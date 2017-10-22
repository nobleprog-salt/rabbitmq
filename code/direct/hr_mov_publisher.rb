#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "34.215.45.93",
                 :vhost       => "mov",
                 :user        => "jerry",
                 :password    => "jerry")

conn.start
ch   = conn.create_channel
x    = ch.direct("new_mov_exchange", :durable => true)

x.publish("This is an hor mov message", :routing_key => "hor")
puts " [x] Sent 'This is an hor mov message'"

conn.close
