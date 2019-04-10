require "json"
require "date"

class TurnoverCalculator
  PRICE_PER_COMMUNICATION = 0.10
  PRICE_COLOR_OPTION = 0.18
  PRICE_ADDITIONAL_PAGE = 0.07
  PRICE_EXPRESS_DELIVERY_OPTION = 0.60

  def initialize(input_filepath)
    @input_filepath = input_filepath
  end

  def run
    parsed_data = parse_input_data
    return unless parsed_data

    grouped_communications = group_communications_by_date(parsed_data["communications"])
    totals = calculate_turnover_by_date(grouped_communications, parsed_data)
    generate_output_data(totals)
  end

  private

  def parse_input_data
    serialized_data = File.read(@input_filepath)
    return if serialized_data.empty?

    JSON.parse(serialized_data)
  end

  def generate_output_data(totals)
    File.open('output.json', 'wb') do |file|
      file.write(JSON.generate({ "totals" => totals }))
    end
  end

  def group_communications_by_date(communications)
    communications.group_by { |communication| Date.strptime(communication["sent_at"], '%Y-%m-%d').to_s }
  end

  def calculate_turnover_by_date(grouped_communications, parsed_data)
    grouped_communications.map do |date, communications|
      total = 0.00

      communications.each do |communication|
        total += PRICE_PER_COMMUNICATION
        total += PRICE_ADDITIONAL_PAGE * (communication["pages_number"] - 1)
        total += PRICE_COLOR_OPTION if communication["color"]
        total += PRICE_EXPRESS_DELIVERY_OPTION if practitioner_has_express_delivery_option?(parsed_data, communication["practitioner_id"])
      end

      {
        "sent_on" => date,
        "total" => total.round(2)
      }
    end
  end

  def practitioner_has_express_delivery_option?(parsed_data, practitioner_id)
    corresponding_practitioner = parsed_data["practitioners"].select { |practitioner| practitioner["id"] == practitioner_id }
    corresponding_practitioner.any? ? corresponding_practitioner.first["express_delivery"] : false
  end
end
