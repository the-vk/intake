# frozen_string_literal: true

require_relative '../lib/intake'
require_relative '../lib/intake/ruby_logger_adapter'

log = Intake[:root]
Intake.add_sink Intake::IOSink.new($stdout)
log.level = :debug
log = log.as_ruby_logger

log.add(Logger::Severity::FATAL, 'msg', 'sample')

log.debug 'debug'
log.info 'info'
log.warn 'warn'
log.error 'error'
log.fatal 'fatal'
log.unknown 'unknown'

log.warn { 'warn proc message' }

log = Intake[:root].as_ruby_logger(progname: 'sample')

log.debug 'debug'
log.info 'info'
log.warn 'warn'
log.error 'error'
log.fatal 'fatal'
log.unknown 'unknown'

log.warn { 'warn proc message' }
