# frozen_string_literal: true

require 'benchmark'

require_relative '../lib/intake'

log = Intake::Logger[:root]
log.level = :error

ITERATIONS = 1_000_000
Benchmark.benchmark(Benchmark::CAPTION, 25, Benchmark::FORMAT, '>same thread avg:', '>dedicated thread avg:') do |x|
  Intake::EventDrain.instance.clear_sinks
  Intake::EventDrain.instance.add_sink(Intake::IOSink.new(File.new('/dev/null', 'a')))
  r1 = x.item(:dev_null_same_thread) do
    ITERATIONS.times do
      log.error 'message'
    end
  end
  Intake::EventDrain.instance.clear_sinks
  output_stream = File.new('/dev/null', 'a')
  dedicated_thread_sink = Intake::IOSink.new(output_stream, pump_class: Intake::Pumps::DedicatedThreadPump)
  Intake::EventDrain.instance.add_sink dedicated_thread_sink
  r2 = x.item(:dev_null_dedicated_thread) do
    ITERATIONS.times do
      log.error 'message'
    end
  end
  [r1 / ITERATIONS, r2 / ITERATIONS]
end
