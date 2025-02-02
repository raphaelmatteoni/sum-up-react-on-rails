class BillsController < ApplicationController
  def create
    bill = Bill.create_with_items(bill_params[:text])
    render json: bill.as_json(include: :items), status: :created
  end

  def show
    bill = Bill.includes(:items).find(params[:id])
    render json: bill.as_json(include: :items), status: :ok
  end

  private

  def bill_params
    params.permit(:text)
  end
end