class Api::CommunicationsController < ApplicationController

  def create
    practitioner = Practitioner.find_by(first_name: communication_params[:first_name], last_name: communication_params[:last_name])
    return head(:bad_request) unless practitioner

    communication = Communication.new(practitioner: practitioner, sent_at: communication_params[:sent_at])

    if communication.save
      render json: communication.to_json, status: :created
    else
      return head(:bad_request)
    end
  end

  def index
    render json: Communication.includes(:practitioner).to_json, status: :ok
  end

  def communication_params
    params.require(:communication).permit(:first_name, :last_name, :sent_at)
  end

end

