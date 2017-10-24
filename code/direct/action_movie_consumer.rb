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
begin
  puts " [*] Waiting for messages from action_movies_que. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
