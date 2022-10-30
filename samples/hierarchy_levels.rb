# frozen_string_literal: true

require_relative '../lib/intake'

Intake.add_sink Intake::IOSink.new($stdout)

root_log = Intake[:root]
module_log = Intake['Module']
module_child_log = Intake['Module::SubModule']
another_module_log = Intake['AnotherModule']

module_child_log.info 'default logger level is :info'

module_log.level = :warn

module_child_log.info 'this message is not logged'
module_child_log.warn 'logger looks up to root to determine level if not explicitly defined'

root_log.level = :error

module_child_log.warn 'logger ignores root level because parent logger explicitly set level to :warn'
another_module_log.warn 'but this is not logged as level is not set explicitly'

# set logger#level= to nil to clear level
module_log.level = nil

module_child_log.warn 'this is message is not logged too'
