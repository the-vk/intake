# frozen_string_literal: true

require 'benchmark'

require_relative '../lib/log_sinks'

log = LogSinks::Logger[:root]
log.level = :error

ITERATIONS = 1_000_000
Benchmark.benchmark(Benchmark::CAPTION, 25, Benchmark::FORMAT, '>same thread avg:', '>dedicated thread avg:') do |x|
  LogSinks::EventDrain.instance.clear_sinks
  LogSinks::EventDrain.instance.add_sink(LogSinks::IOSink.new(File.new('/dev/null', 'a')))
  r1 = x.item(:dev_null_same_thread) do
    ITERATIONS.times do
      log.error 'message'
    end
  end
  LogSinks::EventDrain.instance.clear_sinks
  LogSinks::EventDrain.instance.add_sink(LogSinks::IOSink.new(File.new('/dev/null', 'a'), thread_model: :dedicated_thread))
  r2 = x.item(:dev_null_dedicated_thread) do
    ITERATIONS.times do
      log.error 'message'
    end
  end
  [r1 / ITERATIONS, r2 / ITERATIONS]
end
