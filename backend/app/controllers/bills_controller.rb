class BillsController < ApplicationController
  def create
    bill = Bill.create(bill_params)
    render json: bill.as_json(include: :items), status: :created
  end

  def show
    bill = Bill.includes(:items).find(params[:id])
    render json: bill.as_json(include: :items)
  end

  private

  def bill_params
    params.require(:bill).permit(:name)
  end
end