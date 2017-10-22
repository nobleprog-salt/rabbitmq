#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "34.215.45.93",
                 :user        => "admin",
                 :password    => "admin")

conn.start
ch   = conn.create_channel
q    = ch.queue("first_que", :durable => true)

ch.default_exchange.publish("Hello World!", :routing_key => q.name)
puts " [x] Sent 'Hello World!'"

conn.close
