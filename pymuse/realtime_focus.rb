#!/usr/bin/env ruby

require 'rubygems'
require 'ruby-osc'
require 'open3'
require 'json'

include OSC

def render(points)
	data = {x: points.map { |p| p[:time] }, y: points.map { |p| p[:val] }}
	IO.write('data.json', JSON.generate(data))
end

class Array
	def mode
		group_by{|i| i}.max{|x,y| x[1].length <=> y[1].length}[0]
	end
end

class CircularBuffer
	Size = 20

	def initialize
		@data = []
	end

	def <<(point)
		@data.push(point)
		@data.shift if data.size > Size
	end

	def data
		@data.dup
	end

	def majority
		@data.mode
	end
end

@last_topics = CircularBuffer.new
@datapoints = CircularBuffer.new

def classify(fft_set)
	`./classify.py "#{fft_set.join(", ")}"`.to_i.tap { |_| puts "class: #{_}" }
end

class Frame
	def initialize
		reset
	end

	def reset
		@data = []
	end

	def push(idx, data)
		if @data[idx].nil?
			@data[idx] = data
		else
			if @data[idx + 4].nil?
				@data[idx + 4] = data
			else
				if @data[idx + 8].nil?
					@data[idx + 8] = data
				else
						@data[idx + 12] = data
				end
			end
		end
	end

	def complete
		@data.compact.size == 16
	end

	def linearize
		@data.flatten
	end
end

render([])
@last_frame = Frame.new

def add_observation(idx, data)
	@last_frame.push(idx, data)
	if @last_frame.complete
		@last_topics << classify(@last_frame.linearize)
		@last_frame.reset
		puts @last_topics.majority
		@datapoints << { val: @last_topics.majority, time: Time.now }
		render(@datapoints.data)
	end
end

OSC.run do
	server = Server.new 9090

	server.add_pattern '/muse/elements/raw_fft0' do |_, *fft|
		add_observation(0, fft)
	end

	server.add_pattern '/muse/elements/raw_fft1' do |_, *fft|
		add_observation(1, fft)
	end

	server.add_pattern '/muse/elements/raw_fft2' do |_, *fft|
		add_observation(2, fft)
	end

	server.add_pattern '/muse/elements/raw_fft3' do |_, *fft|
		add_observation(3, fft)
	end
end
