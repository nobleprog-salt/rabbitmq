#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

# Load balancer endpoint
conn = Bunny.new(:host        => "34.211.178.113",
                 :vhost       => "mov",
                 :user        => "jerry",
                 :password    => "jerry")


# conn = Bunny.new(:hosts        => ["52.35.207.90","34.215.45.93","34.208.46.140"],
#                  :vhost       => "mov",
#                  :user        => "jerry",
#                  :password    => "jerry")

conn.start
ch   = conn.create_channel
q    = ch.queue("ga_que", :durable => true)
begin
  puts " [*] Waiting for messages. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
