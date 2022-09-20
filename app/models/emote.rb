# == Schema Information
#
# Table name: emotes
#
#  id          :bigint(8)        not null, primary key
#  name_en     :string(255)      not null
#  name_de     :string(255)      not null
#  name_fr     :string(255)      not null
#  name_ja     :string(255)      not null
#  patch       :string(255)
#  category_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  item_id     :integer
#  command_en  :string(255)
#  command_de  :string(255)
#  command_fr  :string(255)
#  command_ja  :string(255)
#  order       :integer
#

class Emote < ApplicationRecord
  include Collectable
  include Screenshottable

  translates :name, :command
  belongs_to :category, class_name: 'EmoteCategory'

  scope :include_related, -> { include_sources.includes(:category) }
  scope :ordered, -> { order(patch: :desc, order: :desc) }
end
