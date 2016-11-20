#!/usr/bin/env ruby

require 'rubygems'
require 'ruby-osc'
require 'open3'
require 'json'

include OSC

def render(points)
	IO.write('out.html', '<!DOCTYPE html><html><head>
<title>FocusTrackkkr</title>
  <!-- Plotly.js -->
  <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>

</head>

<body>

  <div id="myDiv" style="width: 480px; height: 400px;"><!-- Plotly chart will be drawn inside this DIV --></div>
<script>
var data = [
  {
    x: ' + JSON.generate(points.map { |p| p[:time] }) + ',
    y: ' + JSON.generate(points.map { |p| p[:val] }) + ',
    type: \'scatter\'
  }
];

Plotly.newPlot(\'myDiv\', data);
</script>
</body>
</html>')
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
	`./classify.py "#{fft_set.join(", ")}"`.to_i
end

class Frame
	def initialize
		reset
	end

	def reset
		@data = []
	end

	def push(idx, data)
		@data[idx] = data
	end

	def complete
		@data.compact.size == 4
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