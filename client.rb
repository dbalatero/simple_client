#!/usr/bin/env ruby

require 'digest'
require 'socket'

SERVER_HOSTNAME = 'localhost'
SERVER_PORT = 34567

if ARGV.size != 2
  abort "usage: ruby client.rb [username] [password]"
end

# CLI args
username, password = ARGV

# open socket to server
socket = TCPSocket.open(SERVER_HOSTNAME, SERVER_PORT)

# send username
socket.puts(username)

puts "[client debug] sent username: #{username}"

# get hash
sha1_hash = socket.gets
sha1_hash.strip!

puts "[client debug] got hash: #{sha1_hash}"

# salt it!
salted_pw = Digest::SHA1.hexdigest(password + sha1_hash)

# send the salted pw!
socket.puts(salted_pw)

# get the word
result = socket.gets
puts '-----------------------------'
puts result

# close socket
socket.close
