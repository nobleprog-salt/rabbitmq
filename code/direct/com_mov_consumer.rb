#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "34.215.45.93",
                 :vhost       => "mov",
                 :user        => "jerry",
                 :password    => "jerry")

conn.start
ch   = conn.create_channel
q    = ch.queue("com_mov_que", :durable => true)
begin
  puts " [*] Waiting for messages from com_mov_que. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
