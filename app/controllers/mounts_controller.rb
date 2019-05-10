class MountsController < ApplicationController
  def index
    @mounts = Mount.all.order(patch: :desc, order: :desc)
    @mount_ids = current_user&.character&.mount_ids || []
  end

  def show
    @mount = Mount.find(params[:id])
  end
end
