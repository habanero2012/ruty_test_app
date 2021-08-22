require 'net/http'
require 'newrelic_rpm'

NewRelic::Agent.manual_start

puts 'start'

duration = rand(1..3)
puts "duration is #{duration}"
$stdout.flush

sleep duration
raise 'unlucky error' if duration == 1

puts 'start network access'
puts Net::HTTP.get('www.example.com', '/index.html')

puts 'end'
