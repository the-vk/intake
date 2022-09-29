# frozen_string_literal: true

require_relative '../lib/log_sinks'

log = LogSinks::Logger[:root]
log.level = :info
sink = LogSinks::IOSink.new($stdout)
sink.formatter = ->(e) { "#{e.timestamp} [#{e[:correlation_id]}] - #{e.logger_name}: - #{e.message}\n" }
LogSinks::EventDrain.instance.add_sink sink

log.info 'a message'

LogSinks::MDC[:correlation_id] = :abc

log.info 'message with MDC'

LogSinks::MDC.clear(:correlation_id)

log.info 'a message with no MDC'
