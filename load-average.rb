#!/usr/bin/env ruby

require 'optparse'
require 'json'

allowedTypes = ["1m", "5m", "15m"]

options = {
    :type => "1m",
    :inverse => false,
    :threshold => 1.0
}

OptionParser.new do |opts|
  opts.banner = "Usage: load-average.rb [options]"
    opts.on("-t", "--type, [:1m, :5m, :15m]", "average load type (default: 1m)") do |type|
        puts type
		options[:type] = type;
	end
  opts.on("-i", "--[no-]inverse", "run in inverse mode") do |inverse|
        opts[:inverse] = inverse
  end
  opts.on("-n", "--threshold N", Float, "load average threshold") do |threshold|
        options[:threshold] = threshold
  end
end.parse!

if  ! allowedTypes.include? options[:type]
	print 'Invalid load average type. Allows values are 1m, 5m, 15m'
end

out = `uptime`

vals = out.split("load averages:")[1].split(" ")

loadAverage = 0

case options[:type]
when "1m"
  loadAverage = vals[0]
when "5m"
  loadAverage = vals[1]
when "15m"
  loadAverage = vals[2]
end

result = {
    description: "#{options[:type]} average load must be #{options[:inverse] ? "below" : "above"} #{options[:threshold]}",
    data: loadAverage,
    result: loadAverage.to_f < options[:threshold]
}


puts JSON.dump result
