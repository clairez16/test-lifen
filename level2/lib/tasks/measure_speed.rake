require 'net/http'
require 'uri'
require 'json'

task measure_create_speed: :environment do
  number_of_iterations = 10000
  start_time = Time.now

  number_of_iterations.times do
    uri = URI.parse("http://localhost:3000/api/communications")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = JSON.dump({
      "communication" => {
        "first_name" => "Fritz",
        "last_name" => "Kertzmann",
        "sent_at" => "2019-01-01"
      }
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

  p Time.now - start_time

  Communication.last(number_of_iterations).each(&:destroy)
end

task measure_index_speed: :environment do
  number_of_iterations = 10
  start_time = Time.now

  number_of_iterations.times do
    uri = URI.parse("http://localhost:3000/api/communications")
    request = Net::HTTP::Get.new(uri)
    request.content_type = "application/json"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

  p Time.now - start_time
end
