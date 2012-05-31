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
        ::LetterStampMailDelivery::DeliveryMethod.posting_location = posting_location(example)
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

      def posting_location(example)
        spec_file, lineno = example.location.split(':')
        [spec_file, lineno.to_i]
      end

      def example_finished
        ::LetterStampMailDelivery::DeliveryMethod.posting_location = nil
      end
    end

    def self.install(rspec_configuration)
      rspec_configuration.add_formatter(ExampleLocationNotifier)
    end
  end
end
