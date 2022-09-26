# frozen_string_literal: true

require_relative '../lib/log_sinks'
require_relative '../lib/log_sinks/ruby_logger_adapter'

log = LogSinks::Logger[:root]
log.add_sink LogSinks::IOSink.new($stdout)
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

log = LogSinks::Logger[:root].as_ruby_logger(progname: 'sample')

log.debug 'debug'
log.info 'info'
log.warn 'warn'
log.error 'error'
log.fatal 'fatal'
log.unknown 'unknown'

log.warn { 'warn proc message' }
