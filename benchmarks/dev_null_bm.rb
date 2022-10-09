# frozen_string_literal: true

require 'benchmark'

require_relative '../lib/intake'

log = Intake::Logger[:root]
log.level = :error
Intake::EventDrain.instance.add_sink(Intake::IOSink.new(File.new('/dev/null', 'a')))

ITERATIONS = 1_000_000
Benchmark.benchmark(Benchmark::CAPTION, 25, Benchmark::FORMAT, '>avg:') do |x|
  r = x.item(:dev_null) do
    ITERATIONS.times do
      log.error 'message'
    end
  end
  [r, r / ITERATIONS]
end
