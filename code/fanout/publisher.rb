#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "54.169.56.245",
                 :vhost       => "movies",
                 :user        => "jerry",
                 :password    => "jerry")

conn.start
ch   = conn.create_channel
x    = ch.fanout("top_reviews_exchange", :durable => true)

x.publish("This is a top reviews message")
puts " [x] Sent 'This is a top reviews message'"

conn.close
