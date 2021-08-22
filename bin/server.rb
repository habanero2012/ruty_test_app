require 'socket'
require 'logger'
require 'newrelic_rpm'

server = TCPServer.new 2000
logger = Logger.new($stdout)

NewRelic::Agent.manual_start

6.times do |i|
  Thread.start(server.accept) do |client|
    p [Thread.current]
    headers = []
    while header = client.gets
      break if header.chomp.empty?

      headers << header.chomp
    end
    p [Thread.current, headers]

    client.puts 'HTTP/1.0 200 OK'
    client.puts 'Content-Type: text/plain'
    client.puts
    client.puts "message body #{i}"
    client.close

    # 無駄にスレッドを生成してみる
    threads = []
    threads.push(Thread.new { logger.info("info #{i}") })
    threads.push(Thread.new { logger.warn("warn #{i}") })
    threads.push(Thread.new { logger.error("error #{i}") })
    threads.each { |t| t.join }
  end
end
