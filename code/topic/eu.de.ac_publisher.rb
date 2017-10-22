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

x.publish("This is a topic message", :routing_key => "eu.de.ac")
puts " [x] Sent 'This is a de message'"

conn.close
