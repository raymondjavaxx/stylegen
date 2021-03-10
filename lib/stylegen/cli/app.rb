# frozen_string_literal: true

require "yaml"
require "gli"

require "stylegen/validator"
require "stylegen/generator"

module Stylegen
  module CLI

    class App
      extend GLI::App

      program_desc "CLI tool for managing colors in iOS apps"

      version Stylegen::VERSION

      default_command :build

      # Commands

      desc "Generates a sample theme.yaml file in the current directory"
      command :init do |c|
        c.action do
          if File.exist?('theme.yaml')
            exit_now!("theme.yaml already exists!")
          end

          template = File.read(File.join(__dir__, "template.yaml"))
          File.write("theme.yaml", template)
        end
      end

      desc "Generates the Swift colors file"
      command :build do |c|
        c.action do
          data = File.open("theme.yaml") { |file| YAML.safe_load(file) }

          validator = Validator.new

          unless validator.valid?(data)
            message = []
            message << "theme.yaml contains one or more errors:"

            validator.validate(data).each do |e|
              message << "  #{e}"
            end

            exit_now!(message.join("\n"))
          end

          generator = Generator.new(data)
          generator.generate
        end
      end

    end
  end
end
