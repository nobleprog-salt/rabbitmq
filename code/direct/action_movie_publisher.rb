#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "54.169.201.143",
                 :vhost       => "movies",
                 :user        => "movieconsumer",
                 :password    => "movieconsumer")

conn.start
ch   = conn.create_channel
x    = ch.direct("new_movies_exchange", :durable => true)

x.publish("This is an action movie message", :routing_key => "action")
puts " [x] Sent 'This is an action movie message'"

conn.close
