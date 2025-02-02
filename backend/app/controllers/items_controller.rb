class ItemsController < ApplicationController
  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: item, status: :created
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:group_id)
  end
end
