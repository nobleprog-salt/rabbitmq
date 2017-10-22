#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "34.215.45.93",
                 :user        => "admin",
                 :password    => "admin")

conn.start
ch   = conn.create_channel
q    = ch.queue("second_que", :durable => true)
ch.confirm_select

ch.default_exchange.publish("Hello World!", :routing_key => q.name)
puts " [x] Sent 'Hello World!'"

# Block until all messages have been confirmed
success = ch.wait_for_confirms

if !success
  ch.nacked_set.each do |n|
    puts " [x] Message not sent"
  end
end

conn.close
