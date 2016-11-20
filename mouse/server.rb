#!/usr/bin/env ruby

require 'rubygems'
require 'ruby-osc'
require 'open3'

include OSC

XWIDTH = 2560
YWIDTH = 1600

x_pos = XWIDTH / 2
y_pos = YWIDTH / 2

x_velocity = 0
y_velocity = 0

# Open3.popen3('./move_mouse 1 1') do |stdin, out, err|
	OSC.run do
		server = Server.new 9090

		server.add_pattern '/muse/elements/blink' do |*_, blinked|
		end
		#
		server.add_pattern '/muse/elements/experimental/concentration' do |*_, concentration|
			puts "Concentration: #{concentration}"
		end


		# server.add_pattern '/muse/elements/experimental/mellow' do |*_, mellow|
		# 	puts mellow
		# end

		server.add_pattern '/muse/elements/horseshoe' do |*args|
			# p "Sensors:       #{ args.join(', ') }"
		end

		mousedown = false
		server.add_pattern '/muse/elements/jaw_clench' do |*_, clenched|
			# puts "Clenching: #{clenched}"
			if clenched == 1 && !mousedown
				puts "#{mousedown}, clench"
				`./move_mouse #{x_pos} #{y_pos} r`
				mousedown = true
			else
				mousedown = false if not (clenched == 1)
			end
		end

		# i = 0
		server.add_pattern '/muse/acc' do |_, *acc|       # this will match any address
			x, y, z = *acc
			dx = -(Math.atan2(y, z) / Math::PI * 180 - 90)
			dy = -(Math.atan2(y, x) / Math::PI * 180 - 90)

			# x_velocity += dx / 10
			x_pos += dx/10
			x_pos = [[0, x_pos].max, 1280].min
			# x_velocity *= 0.8

			# y_velocity += dy / 10
			y_pos += dy/10
			y_pos = [[0, y_pos].max, 800].min
			# y_velocity *= 0.8

			puts "#{x_pos} #{y_pos}"

			`./move_mouse #{x_pos} #{y_pos}`
		end
	end
# en