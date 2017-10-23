#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "54.169.56.245",
                 :vhost       => "movies",
                 :user        => "jerry",
                 :password    => "jerry")

conn.start
ch   = conn.create_channel
q    = ch.queue("desktop_top_reviews", :durable => true)
begin
  puts " [*] Waiting for messages from desktop_top_reviews. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
