# frozen_string_literal: true

require_relative '../lib/intake'

log = Intake[:root]
log.level = :info
Intake.add_sink Intake::IOSink.new(File.new('/dev/null', 'a'))

log.info 'debug message'
