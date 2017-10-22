#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:host        => "54.169.56.245",
                 :user        => "admin",
                 :password    => "admin")

conn.start
ch   = conn.create_channel
q    = ch.queue("second_que", :durable => true)

ch.default_exchange.publish("Hello World !",
          :routing_key => "#{q.name}",
          :app_id      => "properties.example",
          :priority    => 8,
          :subject     => "ddffkksdfs sadfdasf ssdfasdf fsafsad fsdaf sfad fasdfasd fd fads",
          :type        => "kinda.checkin",
          # headers table keys can be anything
          :headers     => {
            :coordinates => {
              :latitude  => 59.35,
              :longitude => 18.066667
            },
            :time         => Time.now,
            :participants => 11,
            :venue        => "Singapore",
            :true_field   => true,
            :false_field  => false,
            :nil_field    => nil,
            :something    => "sdfsfdsdfds",
            :any_field    => ["one", 2.0, 3, [{"abc" => 123}]]
          },
          :timestamp      => Time.now.to_i,
          :reply_to       => "a.sender",
          :correlation_id => "r-1",
          :message_id     => "m-1")



puts " [x] Sent 'Hello World!'"

conn.close
