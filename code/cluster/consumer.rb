#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:hosts        => ["54.169.201.143","54.254.232.74","52.77.212.59"],
                 :vhost       => "movies",
                 :user        => "jerry",
                 :password    => "jerry")

conn.start
ch   = conn.create_channel
q    = ch.queue("new_games_que", :durable => true)
begin
  puts " [*] Waiting for messages. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
