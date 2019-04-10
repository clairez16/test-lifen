require 'rails_helper'

RSpec.describe Api::CommunicationsController, type: :controller do
  let(:practitioner) { Practitioner.create(first_name: "Fritz", last_name: "Kertzmann") }
  let(:communication) { Communication.create(practitioner: practitioner, sent_at: "2019-01-01") }
  let(:comm_params) { { first_name: "Fritz", last_name: "Kertzmann", sent_at: "2019-01-01"} }
  let(:test_comm_params) { { first_name: "Test", last_name: "Kertzmann", sent_at: "2019-01-01"} }

  before(:each) do
    practitioner
  end

  describe "#create" do
    it "response status equal to 201 when practitioner found" do

      post :create, params: { communication: comm_params }
      expect(response.status).to eq 201
    end

    it "response status equal to 400 when practitioner not found" do
      post :create, params: { communication: test_comm_params }
      expect(response.status).to eq 400
    end

    it "renders json with expected communication attributes when practitioner found" do
      post :create, params: { communication: comm_params }
      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_response).to eq({
        first_name: comm_params[:first_name],
        last_name: comm_params[:last_name],
        sent_at: comm_params[:sent_at] + "T00:00:00.000Z"
      })
    end
  end

  describe "#index" do
    it "response status equal to 200" do
      get :index
      expect(response.status).to eq 200
    end

    it "response status equal to 200" do
      communication
      get :index
      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_response).to include({
        first_name: communication.practitioner.first_name,
        last_name: communication.practitioner.last_name,
        sent_at: communication.sent_at
      })
    end
  end
end
