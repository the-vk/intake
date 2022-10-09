# frozen_string_literal: true

require 'benchmark'

require_relative '../lib/intake'
require_relative '../lib/intake/ruby_logger_adapter'

log = Intake::Logger[:root]
log.level = :error
ruby_logger = log.as_ruby_logger

ITERATIONS = 67_108_864
Benchmark.bm(25) do |x|
  x.item(:log_sink_logger_skip) do
    ITERATIONS.times do
      log.info 'message'
    end
  end

  x.item(:ruby_logger_adapter_skip) do
    ITERATIONS.times do
      ruby_logger.info 'message'
    end
  end

  log.level = :debug

  x.item(:log_sink_logger_log) do
    ITERATIONS.times do
      log.info 'message'
    end
  end

  x.item(:ruby_logger_adapter_log) do
    ITERATIONS.times do
      ruby_logger.info 'message'
    end
  end
end
