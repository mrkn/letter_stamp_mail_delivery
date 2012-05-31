require 'rspec/core/formatters/base_formatter'

module LetterStampMailDelivery
  module RSpecSupport
    class ExampleLocationNotifier < ::RSpec::Core::Formatters::BaseFormatter
      def initialize(*args)
        # nothing
      end

      def close
        # nothing
      end

      def start(example_count)
        ::LetterStampMailDelivery::DeliveryMethod.start
      end

      def example_group_started(example_group)
        # nothing
      end

      def example_group_finished(example_group)
        # nothing
      end

      def example_started(example)
        ::LetterStampMailDelivery::DeliveryMethod.filename = generate_filename(example)
      end

      def example_passed(example)
        example_finished
      end

      def example_pending(example)
        example_finished
      end

      def example_failed(example)
        example_finished
      end

      private

      def generate_filename(example)
        spec_file, lineno = example.location.split(':')
        "#{spec_file}_#{lineno}.eml"
      end

      def example_finished
        ::LetterStampMailDelivery::DeliveryMethod.filename = nil
      end
    end

    def self.install(rspec_configuration)
      rspec_configuration.add_formatter(ExampleLocationNotifier)
    end
  end
end
