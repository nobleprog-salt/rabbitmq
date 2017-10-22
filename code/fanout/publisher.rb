#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "34.215.45.93",
                 :vhost       => "mov",
                 :user        => "jerry",
                 :password    => "jerry")

conn.start
ch   = conn.create_channel
x    = ch.fanout("top_rev_exchange", :durable => true)

x.publish("This is a top rev message")
puts " [x] Sent 'This is a top rev message'"

conn.close
