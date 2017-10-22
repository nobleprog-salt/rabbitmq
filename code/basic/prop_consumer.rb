#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "34.215.45.93",
                 :user        => "admin",
                 :password    => "admin")

conn.start
ch   = conn.create_channel
q    = ch.queue("first_que")
begin
  puts " [*] Waiting for messages. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
    puts properties
    # puts properties.content_type # => "application/octet-stream"
    # puts properties.priority     # => 8
    #
    # puts properties.headers["time"] # => a Time instance
    #
    # puts properties.headers["coordinates"]["latitude"] # => 59.35
    # puts properties.headers["participants"]            # => 11
    # puts properties.headers["venue"]                   # => "Stockholm"
    # puts properties.headers["true_field"]              # => true
    # puts properties.headers["false_field"]             # => false
    # puts properties.headers["nil_field"]               # => nil
    # puts properties.headers["ary_field"].inspect       # => ["one", 2.0, 3, [{ "abc" => 123}]]
    #
    # puts properties.timestamp      # => a Time instance
    # puts properties.type           # => "kinda.checkin"
    # puts properties.reply_to       # => "a.sender"
    # puts properties.correlation_id # => "r-1"
    # puts properties.message_id     # => "m-1"
    # puts properties.app_id         # => "bunny.example"
    #
    # puts delivery_info.consumer_tag # => a string
    # puts delivery_info.redelivered? # => false
    # puts delivery_info.delivery_tag # => 1
    # puts delivery_info.routing_key  # => server generated queue name prefixed with "amq.gen-"
    # puts delivery_info.exchange     # => ""
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
