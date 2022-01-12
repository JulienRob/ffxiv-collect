# == Schema Information
#
# Table name: instances
#
#  id           :bigint(8)        not null, primary key
#  name_en      :string(255)      not null
#  name_de      :string(255)      not null
#  name_fr      :string(255)      not null
#  name_ja      :string(255)      not null
#  content_type :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order        :integer          not null
#

class Instance < ApplicationRecord
  translates :name

  has_many :sources, as: :related

  scope :queueable, -> { where(content_type: Instance.queueable_types) }
  scope :with_sources, -> { joins(:sources).where('sources.related_type = "Instance"') }
  scope :with_orchestrion_sources, -> do
    joins('INNER JOIN orchestrions ON orchestrions.description_en LIKE CONCAT("%", instances.name_en, "%")' \
          'OR orchestrions.details LIKE CONCAT("%", instances.name_en, "%")' )
  end

  def self.queueable_types
    %w(Dungeons Trials Raids).freeze
  end

  def self.valid_types
    ['Dungeon', 'Trial', 'Raid', 'Treasure Hunt'].freeze
  end
end
