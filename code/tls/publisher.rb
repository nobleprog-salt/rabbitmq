#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:tls                   => true,
                 :tls_cert              => "/home/ubuntu/client/cert.pem",
                 :tls_key               => "/home/ubuntu/client/key.pem",
                 :tls_ca_certificates   => ["/home/ubuntu/testca/cacert.pem"],
                 :hosts                 => ["ip-172-31-1-22.ap-southeast-1.compute.internal"],
                 :port                  => 5671,
                 :vhost                 => "/",
                 :user                  => "admin",
                 :password              => "admin")

conn.start
ch   = conn.create_channel
q    = ch.queue("first_que", :durable => true)

ch.default_exchange.publish("Hello World!", :routing_key => q.name)
puts " [x] Sent 'Hello World!'"

conn.close
