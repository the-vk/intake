# frozen_string_literal: true

require 'benchmark'

require_relative '../lib/log_sinks'
require_relative '../lib/log_sinks/ruby_logger_adapter'

log = LogSinks::Logger[:root]
log.level = :error
ruby_logger = log.as_ruby_logger

ITERATIONS = 67_108_864
Benchmark.bm(25) do |x|
  x.item(:log_sink_logger) do
    ITERATIONS.times do
      log.info 'message'
    end
  end

  x.item(:ruby_logger_adapter) do
    ITERATIONS.times do
      ruby_logger.info 'message'
    end
  end
end