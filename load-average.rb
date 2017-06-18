#!/usr/bin/env ruby

require 'optparse'
require 'json'

allowedTypes = ["1m", "5m", "15m"]

options = {
    :type => "1m",
    :expect => true,
    :threshold => 1.0
}

OptionParser.new do |opts|
  opts.banner = "Usage: load-average.rb [options]"
    opts.on("-t", "--type, [:1m, :5m, :15m]", "average load type (default: 1m)") do |type|
        puts type
		options[:type] = type;
	end
    opts.on("-e", "--expect, [true, false]", "expect result") do |expect|
        if expect == "true"
            options[:expect] = true
        else
            options[:expect] = false
        end
	end
    opts.on("-d", "--threshold N", Float, "expect result") do |threshold|
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
    description: "load must be #{options[:expect] ? "below" : "above"} #{options[:threshold]}",
    threshold: options[:threshold],
    result: loadAverage,
    status: loadAverage.to_f < options[:threshold],
    expect: options[:expect]
}


puts JSON.dump result


