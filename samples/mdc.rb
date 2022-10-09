# frozen_string_literal: true

require_relative '../lib/intake'

log = Intake[:root]
log.level = :info
sink = Intake::IOSink.new($stdout)
sink.formatter = ->(e) { "#{e.timestamp} [#{e[:correlation_id]}] - #{e.logger_name}: - #{e.message}\n" }
Intake.add_sink sink

log.info 'a message'

Intake::MDC[:correlation_id] = :abc

log.info 'message with MDC'

Intake::MDC.clear(:correlation_id)

log.info 'a message with no MDC'
