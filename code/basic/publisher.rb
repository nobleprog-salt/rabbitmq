#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "54.169.201.143",
                 :vhost       => "movies",
                 :user        => "movieconsumer",
                 :password    => "movieconsumer")

conn.start
ch   = conn.create_channel
q    = ch.queue("action_movies_que", :durable => true)

ch.default_exchange.publish("Hello World!", :routing_key => q.name)
puts " [x] Sent 'Hello World!'"

conn.close
