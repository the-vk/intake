# frozen_string_literal: true

require_relative '../lib/intake'

log = Intake[:root]
log.level = :info
Intake.add_sink Intake::IOSink.new($stdout, pump_class: Intake::Pumps::DedicatedThreadPump)

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

sleep 1
