#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "34.215.45.93",
                 :user        => "admin",
                 :password    => "admin")

conn.start
ch   = conn.create_channel
q    = ch.queue("first_que", :durable => true)
ch.prefetch(1)

begin
  puts " [*] Waiting for messages. To exit press CTRL+C"
  q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
    sleep 15
    puts " [x] Received #{body}"
    ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
