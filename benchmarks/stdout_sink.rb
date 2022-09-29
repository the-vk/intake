# frozen_string_literal: true

require 'benchmark'

require_relative '../lib/log_sinks'
require_relative '../lib/log_sinks/ruby_logger_adapter'

log = LogSinks::Logger[:root]
log.level = :error
log.add_sink(LogSinks::IOSink.new($stdout))
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
