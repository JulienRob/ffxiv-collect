module InstancesHelper
  def source_collectable_reward(source)
    name = @names[source.collectable_type][source.collectable_id]

    link_to(instance_collectable_path(source), class: "mr-1#{ ' owned' if instance_collectable_owned?(source) }",
            title: name, data: { toggle: 'tooltip' }) do
      instance_collectable_image(source)
    end
  end

  def instance_orchestrion_reward(id)
    link_to(orchestrion_path(id), class: "mr-1#{ ' owned' if @ids['Orchestrion'].include?(id) }",
            title: @names['Orchestrion'][id], data: { toggle: 'tooltip' }) do
      image_tag('orchestrion.png')
    end
  end

  private
  def instance_collectable_owned?(source)
    @ids[source.collectable_type].include?(source.collectable_id)
  end

  def instance_collectable_path(source)
    model = source.collectable_type.downcase.pluralize
    "#{model}/#{source.collectable_id}"
  end

  def instance_collectable_image(source)
    if source.collectable_type == 'Hairstyle'
      hairstyle_sample_image(source.collectable)
    elsif source.collectable_type == 'Mount' || source.collectable_type == 'Minion'
      source_collectable_sprite(source)
    else
      source_collectable_sprite(source)
    end
  end
end
