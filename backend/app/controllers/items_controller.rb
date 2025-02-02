class ItemsController < ApplicationController
  def index
    items = Item.where(bill_id: params[:bill_id])
    render json: items, status: :ok
  end

  def update_batch
    if Item.where(id: params[:item_ids]).update_all(group_id: params[:group_id])
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Failed to update items' }, status: :unprocessable_entity
    end
  end

  private

  def batch_params
    params.permit(:group_id, item_ids: [])
  end
end
