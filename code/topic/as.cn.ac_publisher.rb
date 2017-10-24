#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "54.169.201.143",
                 :vhost       => "movies",
                 :user        => "jerry",
                 :password    => "jerry")

conn.start
ch   = conn.create_channel
x    = ch.topic("foreign_movies_exchange", :durable => true)

x.publish("This is a CN message", :routing_key => "asia.chinese.action")
puts " [x] Sent 'This is a cn message'"

conn.close
