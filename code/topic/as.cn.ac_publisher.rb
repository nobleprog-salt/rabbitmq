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

x.publish("This is a CN message", :routing_key => "as.cn.ac")
puts " [x] Sent 'This is a cn message'"

conn.close
