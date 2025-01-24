class GroupsController < ApplicationController
  def create
    group = Group.create!(group_params)
    render json: group, status: :created
  end

  def index
    groups = Group.includes(:items).where(bill_id: params[:bill_id])
    render json: groups.as_json(include: :items)
  end

  private

  def group_params
    params.require(:group).permit(:name, :bill_id)
  end
end
