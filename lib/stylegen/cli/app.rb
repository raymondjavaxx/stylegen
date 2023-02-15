# frozen_string_literal: true

require 'yaml'
require 'gli'

require 'stylegen/validator'
require 'stylegen/generator'

module Stylegen
  module CLI
    class App
      extend GLI::App

      program_desc 'CLI tool for managing colors in iOS apps'

      version Stylegen::VERSION

      default_command :build

      # Commands

      desc 'Generates a sample theme.yaml file in the current directory'
      command :init do |c|
        c.desc 'Output file path'
        c.flag %i[output o], type: String, default_value: 'theme.yaml'

        c.action do |_global_options, options, _args|
          exit_now!("'#{options['output']}' already exists!") if File.exist?(options['output'])

          template = File.read(File.join(__dir__, 'template.yaml'))
          File.write(options['output'], template)

          puts "Generated '#{options['output']}'."
        end
      end

      desc 'Generates the Swift colors file'
      command :build do |c|
        c.desc 'Path to the theme.yaml file'
        c.flag %i[input i], type: String, default_value: 'theme.yaml'

        c.action do |_global_options, options, _args|
          unless File.exist?(options['input'])
            exit_now!("'#{options['input']}' not found. Create one with 'stylegen init'.")
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

          puts "Generated '#{generator.stats[:output_path]}' with #{generator.stats[:color_count]} colors."
        end
      end
    end
  end
end
