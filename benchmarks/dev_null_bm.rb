# frozen_string_literal: true

require 'benchmark'

require_relative '../lib/log_sinks'

log = LogSinks::Logger[:root]
log.level = :error
LogSinks::EventDrain.instance.add_sink(LogSinks::IOSink.new(File.new('/dev/null', 'a')))

ITERATIONS = 1_000_000
Benchmark.benchmark(Benchmark::CAPTION, 25, Benchmark::FORMAT, '>avg:') do |x|
  r = x.item(:dev_null) do
    ITERATIONS.times do
      log.error 'message'
    end
  end
  [r, r / ITERATIONS]
end
