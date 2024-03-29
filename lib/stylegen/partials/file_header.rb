# frozen_string_literal: true

module Stylegen
  module Partials
    class FileHeader
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def to_s
        replacements = {
          'STYLEGEN_FILENAME' => data.basename,
          'STYLEGEN_VERSION' => data.version,
          'STYLEGEN_YEAR' => Date.today.year
        }

        "#{header_template}\n".gsub(/{{(\w+)}}/) { replacements[Regexp.last_match(1)] || '' }
      end

      private

      def header_template
        data.custom_header&.strip || <<~HEADER.chomp
          //
          //  {{STYLEGEN_FILENAME}}
          //
          //  Autogenerated by stylegen ({{STYLEGEN_VERSION}})
          //  DO NOT EDIT
          //
        HEADER
      end
    end
  end
end
