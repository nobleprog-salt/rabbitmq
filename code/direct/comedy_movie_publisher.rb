#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "54.169.56.245",
                 :vhost       => "movies",
                 :user        => "jerry",
                 :password    => "jerry")

conn.start
ch   = conn.create_channel
x    = ch.direct("new_movies_exchange", :durable => true)

x.publish("This is a comedy message", :routing_key => "comedy")
puts " [x] Sent 'This is a comedy movie message'"

conn.close
