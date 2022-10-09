# frozen_string_literal: true

module Intake
  # Log event level.
  class Level
    class << self
      def []=(name, level)
        (@s ||= {})[name] = level
      end

      def [](name)
        (@s ||= {})[name]
      end
    end

    attr_reader :name, :val

    def initialize(name, val)
      @val = val
      @name = name
    end

    def to_s
      @name.to_s.upcase
    end

    def <(other)
      @val < other.val
    end

    def <=(other)
      @val <= other.val
    end

    def >(other)
      @val > other.val
    end

    def >=(other)
      @val >= other.val
    end

    def ==(other)
      @val == other.val
    end

    # Define Intake levels
    [[:debug, 1000], [:info, 2000], [:warn, 3000], [:error, 4000], [:fatal, 5000]].each do |(n, v)|
      ::Intake::Level[n] = ::Intake::Level.new(n, v).freeze
    end
  end
end
