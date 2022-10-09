# frozen_string_literal: true

require_relative 'intake/async_sink'
require_relative 'intake/io_sink'
require_relative 'intake/logger'
require_relative 'intake/version'
require_relative 'intake/filters/level_filter'
require_relative 'intake/filters/logger_name_prefix_filter'

# Public API module of intake logger
module Intake
  def self.[](logger_name)
    Intake::Logger[logger_name]
  end

  def self.add_sink(sink)
    Intake::EventDrain.instance.add_sink sink
  end

  def self.clear_sinks
    Intake::EventDrain.instance.clear_sinks
  end
end
