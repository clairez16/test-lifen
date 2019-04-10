# rspec app_spec.rb

require 'rspec'

require_relative './app.rb'

RSpec.describe "Turnover Calculator", type: :model do
  let(:test_data)     { JSON.parse(File.read('test_data.json')) }
  let(:test_output)   { JSON.parse(File.read('test_output.json')) }
  let(:output)        { JSON.parse(File.read('output.json')) }


  it "JSON generated should be equal to test_output JSON when given test_data JSON" do
    turnover_calculator = TurnoverCalculator.new('test_data.json')
    turnover_calculator.run
    expect(output).to eq(test_output)
  end
end
