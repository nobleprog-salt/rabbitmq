#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new(:tls                   => true,
                 :tls_cert              => "/home/ubuntu/ssl/client/cert.pem",
                 :tls_key               => "/home/ubuntu/ssl/client/key.pem",
                 :tls_ca_certificates   => ["/home/ubuntu/ssl/cacert.pem"],
                 :hosts                 => ["ip-172-31-44-154.us-west-2.compute.internal",
                                            "ip-172-31-44-223.us-west-2.compute.internal"],
                 :port                  => 5671,
                 :vhost                 => "/",
                 :user                  => "admin",
                 :password              => "admin")

conn.start
ch   = conn.create_channel
q    = ch.queue("first_que", :durable => true)
begin
  puts " [*] Waiting for messages. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
