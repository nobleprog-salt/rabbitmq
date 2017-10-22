#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "34.215.45.93",
                 :vhost       => "mov",
                 :user        => "jerry",
                 :password    => "jerry")

conn.start
ch   = conn.create_channel
x    = ch.topic("for_mov_exchange", :durable => true)
q    = ch.queue("", :exclusive => true)
q.bind(x, :routing_key => "*.jp.*")

begin
  puts " [*] Waiting for messages from for_mov_exchange. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
