class BillsController < ApplicationController
  def create
    bill = Bill.create_with_items(bill_params[:text])
    render json: bill.as_json(include: :items), status: :created
  end

  def show
    bill = Bill.includes(:items).find(params[:id])
    render json: bill.as_json(include: :items), status: :ok
  end

  def create_from_image
    unless params[:image].present?
      return render json: { error: 'Imagem não fornecida' }, status: :unprocessable_entity
    end

    begin
      image_data = params[:image].tempfile.read
      
      recognized_text = OpenaiService.extract_text_from_image(image_data)
      
      bill = Bill.create_with_items(recognized_text)
      
      render json: bill.as_json(include: :items), status: :created
    rescue => e
      Rails.logger.error("Erro ao processar imagem: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      render json: { error: 'Erro ao processar imagem', details: e.message }, status: :unprocessable_entity
    end
  end

  private

  def bill_params
    params.permit(:text, :image)
  end
end