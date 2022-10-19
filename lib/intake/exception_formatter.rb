# frozen_string_literal: true

module Intake
  # Base class that formats exception object to string
  class ExceptionFormatter
    attr_accessor :backtrace, :cause

    def initialize
      @backtrace = true
      @cause = true
    end

    # Formats error to string
    def call(err)
      format(err, []).join("\n")
    end

    protected

    def format(err, lines)
      lines << format_title(err)
      lines.concat(err.backtrace) if backtrace
      format(err.cause, lines) if cause && !err.cause.nil?
      lines
    end

    def format_title(err)
      "Caused by: <#{err.class.name}> #{err.message}"
    end

    def format_backtrace(err, lines)
      lines + err.backtrace
    end
  end
end
