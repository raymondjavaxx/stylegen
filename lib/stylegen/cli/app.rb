# frozen_string_literal: true

require 'yaml'
require 'thor'

require 'stylegen/validator'
require 'stylegen/generator'

module Stylegen
  module CLI
    class App < Thor
      default_command :build
      stop_on_unknown_option!

      def self.exit_on_failure?
        true
      end

      desc 'version', 'Prints Stylegen version'
      def version
        say "stylegen version #{Stylegen::VERSION}"
      end

      desc 'init', 'Generates a sample theme.yaml file in the current directory'
      option :output, aliases: '-o', type: :string, default: 'theme.yaml', desc: 'Path to the output file'
      def init
        raise Error, "'#{options['output']}' already exists." if File.exist?(options['output'])

        template = File.read(File.join(__dir__, 'template.yaml'))
        File.write(options['output'], template)

        say "Generated '#{options['output']}'."
      end

      desc 'build', 'Generates the Swift colors file'
      option :input, aliases: '-i', type: :string, default: 'theme.yaml', desc: 'Path to the theme.yaml file'
      def build
        unless File.exist?(options['input'])
          raise Error, "'#{options['input']}' not found. Create one with 'stylegen init'."
        end

        data = File.open(options['input']) { |file| YAML.safe_load(file) }

        validator = Validator.new
        unless validator.valid?(data)
          message = []
          message << "#{options['input']} contains one or more errors:"

          validator.validate(data).each do |e|
            message << "  #{e}"
          end

          exit_now!(message.join("\n"))
        end

        generator = Generator.new(data)
        generator.generate

        say "Generated '#{generator.stats[:output_path]}' with #{generator.stats[:color_count]} colors."
      end
    end
  end
end
