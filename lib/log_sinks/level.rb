# frozen_string_literal: true

module LogSinks
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
  end

  # Define LogSinks levels
  [[:debug, 1000], [:info, 2000], [:warn, 3000], [:error, 4000], [:fatal, 5000]].each do |(n, v)|
    ::LogSinks::Level[n] = ::LogSinks::Level.new(n, v).freeze
  end

  begin
    # Define Logger levels
    [
      [::Logger::DEBUG, ::LogSinks::Level[:debug]],
      [::Logger::INFO, ::LogSinks::Level[:info]],
      [::Logger::WARN, ::LogSinks::Level[:warn]],
      [::Logger::ERROR, ::LogSinks::Level[:error]],
      [::Logger::FATAL, ::LogSinks::Level[:fatal]],
      [::Logger::UNKNOWN, ::LogSinks::Level[:fatal]]
    ].each do |(n, v)|
      ::LogSinks::Level[n] = v
    end
  rescue NameError
    # logger module is not loaded. ignore
  end
end