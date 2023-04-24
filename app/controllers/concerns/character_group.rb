module CharacterGroup
  extend ActiveSupport::Concern

  included do
    before_action :set_members, only: [:show, :mounts, :spells]
    before_action :set_owned_ids, only: [:mounts, :spells]
    before_action :verify_group_membership!, only: [:show, :mounts, :spells, :refresh]
  end

  def show
    render 'groups/show'
  end

  def mounts
    @collection = 'mounts'
    @sprite_key = 'mounts-small'
    @collectables = Mount.joins(sources: :type)
      .where('source_types.name_en in (?)', %w(Trial Raid))
      .order('source_types.name_en DESC, mounts.patch ASC')
      .distinct.group_by(&:expansion)

    render 'groups/collection'
  end

  def spells
    @collection = 'spells'
    @sprite_key = 'spell'
    @collectables = Spell.ordered.group_by(&:expansion)
    render 'groups/collection'
  end

  def refresh
    if @group.in_queue?
      flash[:alert] = t('alerts.groups.syncing')
    elsif !@group.syncable?
      flash[:alert] = t('alerts.groups.already_refreshed')
    else
      begin
        @group.refresh
        flash[:success] = t('alerts.groups.refreshed')
      rescue ActiveJob::Uniqueness::JobNotUnique
        flash[:alert] = t('alerts.groups.syncing')
      end
    end

    redirect_to polymorphic_path(@group)
  end

  private
  def set_members
    @members = @group.members.visible.order(:name)
  end

  def set_owned_ids
    model = "Character#{action_name.classify}".constantize
    id_column = "#{action_name.singularize}_id"

    @owned_ids = model.where(character_id: @members).each_with_object(Hash.new { |k, v| k[v] = [] }) do |char, h|
      h[char.character_id] << char[id_column]
    end

    # Trim the list of members to only include those who own at least one collectable
    # @members = @members.reject { |character| @owned_ids[character.id].empty? }
  end
end
