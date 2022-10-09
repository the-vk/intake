# frozen_string_literal: true

require 'benchmark'

require_relative '../lib/intake'
require_relative '../lib/intake/ruby_logger_adapter'

log = Intake::Logger[:root]
log.level = :error
Intake::EventDrain.instance.add_sink(Intake::IOSink.new($stdout))
ruby_logger = log.as_ruby_logger

ITERATIONS = 1000
Benchmark.bm(25) do |x|
  x.item(:log_sink_logger_stdout) do
    ITERATIONS.times do
      log.error 'message'
    end
  end

  x.item(:ruby_logger_adapter_stdout) do
    ITERATIONS.times do
      ruby_logger.error 'message'
    end
  end
end
