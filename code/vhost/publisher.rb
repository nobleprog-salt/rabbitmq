#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "34.215.45.93",
                 :vhost       => "mov",
                 :user        => "jerry",
                 :password    => "jerry")

conn.start
ch   = conn.create_channel
#q    = ch.queue("mov_logs", :durable => true)
q    = ch.queue("mov_logs")

ch.default_exchange.publish("This is an mov message", :routing_key => q.name)
puts " [x] Sent 'This is an mov message'"

conn.close
