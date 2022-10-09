# frozen_string_literal: true

require_relative '../filter'

module Intake
  module Filters
    # Filter event by logger name. Pass if logger name starts with logger prefix.
    class LoggerNamePrefixFilter < Intake::Filter
      def initialize(prefix, include_root: true)
        super()
        @prefix = prefix
        @include_root = include_root
      end

      def call(event)
        name = event.logger_name
        (@include_root && name == :root) || name.start_with?(@prefix)
      end
    end
  end
end
