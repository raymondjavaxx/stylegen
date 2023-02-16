# frozen_string_literal: true

require 'yaml'
require 'dry/cli'

require 'stylegen/validator'
require 'stylegen/generator'
require 'stylegen/version'
require 'stylegen/cli/error'

module Stylegen
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Error < StandardError
      end

      class Version < Dry::CLI::Command
        desc 'Prints stylegen version'

        def call(*)
          puts "stylegen version #{Stylegen::VERSION}"
        end
      end

      class Init < Dry::CLI::Command
        desc 'Generates a sample theme.yaml file in the current directory'

        option :output, aliases: ['-o'], type: :string, default: 'theme.yaml', desc: 'Path to the output file'

        def call(output: 'theme.yaml', **)
          raise Error, "'#{output}' already exists." if File.exist?(output)

          template = File.read(File.join(__dir__, 'template.yaml'))
          File.write(output, template)

          puts "Generated '#{output}'."
        end
      end

      class Build < Dry::CLI::Command
        desc 'Generates the Swift colors file'

        option :input, aliases: ['-i'], type: :string, default: 'theme.yaml', desc: 'Path to the theme.yaml file'

        def call(input: 'theme.yaml', **)
          raise Error, "'#{input}' not found. Create one with 'stylegen init'." unless File.exist?(input)

          data = File.open(input) { |file| YAML.safe_load(file) }

          validator = Validator.new
          unless validator.valid?(data)
            message = []
            message << "#{input} contains one or more errors:"

            validator.validate(data).each do |e|
              message << "  #{e}"
            end

            raise Error, message.join("\n")
          end

          generator = Generator.new(data)
          generator.generate

          puts "Generated '#{generator.stats[:output_path]}' with #{generator.stats[:color_count]} colors."
        end
      end

      register 'init', Init
      register 'build', Build
      register 'version', Version, aliases: ['-v', '--version']
    end
  end
end
