# frozen_string_literal: true

require_relative '../lib/intake'

log = Intake[:root]
log.level = :info
sink = Intake::IOSink.new($stdout)
sink.formatter = ->(e) { "#{e.timestamp} [#{e[:user_id]}] - #{e.logger_name}: - #{e.message}\n" }
Intake.add_sink sink

log.info 'a message', meta: { user_id: 'username' }
