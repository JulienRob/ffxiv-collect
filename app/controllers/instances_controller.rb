class InstancesController < ApplicationController
  def index
    @instances = Instance.queueable.with_sources.includes(:sources).order(:order)
    @categories = { 'Dungeons' => 1, 'Trials' => 2, 'Raids' => 3 }
    @category = params[:category].to_i

    @instance_orchestrions = Instance.queueable.with_orchestrion_sources
      .select('instances.id AS id, orchestrions.id AS orchestrion_id')
      .each_with_object(Hash.new { |h, k| h[k] = [] }) { |instance, h| h[instance.id] << instance.orchestrion_id }

    @names = { 'Mount' => {}, 'Minion' => {}, 'Orchestrion' => {} }
    @ids = { 'Mount' => @character&.mount_ids || [], 'Minion' => @character&.minion_ids || [],
             'Orchestrion' => @character&.orchestrion_ids || [] }

    [Mount, Minion].each do |model|
      model.joins(:sources).where('sources.related_type = "Instance"').each do |collectable|
        @names[model.to_s][collectable.id] = collectable.name
      end
    end

    Orchestrion.where(id: @instance_orchestrions.values.flatten).each do |orchestrion|
      @names['Orchestrion'][orchestrion.id] = orchestrion.name
    end
  end
end
