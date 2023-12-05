# frozen_string_literal: true

# hll-err.rb - Copyright (C) 2014 Salvatore Sanfilippo
# BSD license, See the COPYING file for more information.
#
# Check error of HyperLogLog Redis implementation for different set sizes.

require 'rubygems'
require 'redis'
require 'digest/sha1'

r = Redis.new
r.del('hll')
i = 0
loop do
  100.times do
    elements = []
    1000.times do
      ele = Digest::SHA1.hexdigest(i.to_s)
      elements << ele
      i += 1
    end
    r.pfadd('hll', elements)
  end
  approx = r.pfcount('hll')
  abs_err = (approx - i).abs
  rel_err = 100.to_f * abs_err / i
  puts "#{i} vs #{approx}: #{rel_err}%"
end
