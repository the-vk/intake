# frozen_string_literal: true

require_relative '../lib/log_sinks'

log = LogSinks::Logger[:root]
log.level = :info
log.add_sink LogSinks::IOSink.new($stdout)

log.debug 'debug message'
log.info 'info message'
log.warn 'warn message'
log.error 'error message'
log.fatal 'fatal message'
