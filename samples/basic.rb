# frozen_string_literal: true

require_relative '../lib/log_sinks'

log = LogSinks::Logger[:root]
log.level = :info
log.add_sink LogSinks::IOSink.new($stdout)

log.debug 'debug message'
log.debug { 'proc debug message' }
log.debug do
  print("you don't see me!")
  'expensive proc debug message'
end
log.info 'info message'
log.info { 'proc info message' }
log.warn 'warn message'
log.warn { 'proc warn message' }
log.error 'error message'
log.error { 'proc error message' }
log.fatal 'fatal message'
log.fatal { 'proc fatal message' }
