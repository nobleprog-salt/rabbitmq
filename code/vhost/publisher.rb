#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "54.169.201.143",
                 :vhost       => "movies",
                 :user        => "jerry",
                 :password    => "jerry")

conn.start
ch   = conn.create_channel
q    = ch.queue("movie_logs", :durable => true)
#q    = ch.queue("movie_logs")

ch.default_exchange.publish("This is a movie message", :routing_key => q.name)
puts " [x] Sent 'This is a movie message'"

conn.close
