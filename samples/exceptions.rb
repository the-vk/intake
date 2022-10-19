# frozen_string_literal: true

require_relative '../lib/intake'

log = Intake[:root]
log.level = :info
Intake.add_sink Intake::IOSink.new($stdout)

def error_func
  raise StandardError, 'sample error'
rescue StandardError
  raise StandardError, 'base exception'
end

begin
  error_func
rescue StandardError => e
  log.error('unhandled exception', error: e)
  log.error(error: e) { 'proc messages work too' }
end

log.error 'it\'s okay, no errors here'
