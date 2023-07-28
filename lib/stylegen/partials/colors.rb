# frozen_string_literal: true

module Stylegen
  module Partials
    class Colors
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def to_s
        result = []
        result << '// MARK: Colors'
        result << ''
        result << "#{data.effective_access_level} extension #{data.struct_name} {".lstrip

        data.color_entries.each do |entry|
          unless entry[:description].nil?
            entry[:description].strip.lines.each do |line|
              result << "    /// #{line.strip}"
            end
          end

          result << "    static let #{entry[:property]} = #{entry[:color].to_s(data.struct_name, 4).lstrip}"
          result << '' unless entry == data.color_entries.last
        end

        result << '}'
        result << ''
        result.join("\n")
      end
    end
  end
end
