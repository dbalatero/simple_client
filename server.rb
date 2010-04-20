#!/usr/bin/env ruby

require 'digest'
require 'socket'

SERVER_PORT = 34567
server = TCPServer.open(SERVER_PORT)

puts "Starting server on localhost:#{SERVER_PORT}"

# username => password
USERS = { 'dbalatero' => 'test' }

loop do
  Thread.start(server.accept) do |client|
    username = client.gets
    username.strip!
    puts "[debug] got username: #{username}"

    puts "[debug] calculating sha1"
    hash_string = Time.now.to_s + username + rand(10000000000).to_s
    puts "[debug] hashing: #{hash_string}"
    sha1_hash = Digest::SHA1.hexdigest(hash_string)

    puts "[debug] sending sha1 hash: #{sha1_hash}"
    client.puts(sha1_hash)

    puts "[debug] waiting for salted password..."
    salted_pw = client.gets
    salted_pw.strip!

    puts "[debug] got salted pw: #{salted_pw}"

    authenticated = (salted_pw == Digest::SHA1.hexdigest(USERS[username] + sha1_hash))

    puts "[debug] authenticated: #{authenticated}"

    if authenticated
      client.puts("AUTHENTICATED")
    else
      client.puts("NOT AUTHENTICATED")
    end

    # Close connection to client.
    client.close
  end
end
