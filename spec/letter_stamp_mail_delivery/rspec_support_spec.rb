require 'spec_helper'
require 'letter_stamp_mail_delivery/rspec_support'

module LetterStampMailDelivery
  describe RSpecSupport do
    describe ".install" do
      let(:rspec_configuration) { ::RSpec::Core::Configuration.new }

      it "should add_formatter ExampleLocationNotifier" do
        rspec_configuration.should_receive(:add_formatter).with(described_class::ExampleLocationNotifier)
        described_class.install(rspec_configuration)
      end
    end
  end
end

module LetterStampMailDelivery::RSpecSupport
  describe ExampleLocationNotifier do
    let(:dummy_output) { double("dummy output") }

    subject { described_class.new(dummy_output) }

    describe "#start" do
      it "should call LetterStampMailerDelivery::DeliveryMethod.start" do
        ::LetterStampMailDelivery::DeliveryMethod.should_receive(:start).once
        subject.start(0)
      end
    end

    describe "#example_started" do
      context "with an example located at foo_spec.rb:42" do
        let(:example) { double("example", :location => "foo_spec.rb:42") }

        it "should set LetterStampMailerDelivery::DeliveryMethod.filename 'foo_spec.rb_42.eml'" do
          subject.example_started(example)
          ::LetterStampMailDelivery::DeliveryMethod.filename.should eq("foo_spec.rb_42.eml")
        end
      end

      context "with an example located at bar_spec.rb:17" do
        let(:example) { double("example", :location => "bar_spec.rb:17") }

        it "should do LetterStampMailerDelivery::DeliveryMethod.filename = 'bar_spec.rb_16.eml'" do
          subject.example_started(example)
          ::LetterStampMailDelivery::DeliveryMethod.filename.should eq("bar_spec.rb_17.eml")
        end
      end
    end

    shared_examples_for "LetterStampMailDelivery::DeliveryMethod.filename should be nil" do |method_name|
      context "LetterStampMailDelivery::DeliveryMethod.filename is 'foo_spec.rb_42.eml'" do
        before :each do
          ::LetterStampMailDelivery::DeliveryMethod.filename = 'foo_spec.rb_42.eml'
        end

        it "should do LetterStampMailDelivery::DeliveryMethod.filename = nil" do
          subject.send(method_name, example)
          ::LetterStampMailDelivery::DeliveryMethod.filename.should be_nil
        end
      end
    end

    describe "#example_passed" do
      it_should_behave_like "LetterStampMailDelivery::DeliveryMethod.filename should be nil", :example_passed
    end

    describe "#example_pending" do
      it_should_behave_like "LetterStampMailDelivery::DeliveryMethod.filename should be nil", :example_pending
    end

    describe "#example_failed" do
      it_should_behave_like "LetterStampMailDelivery::DeliveryMethod.filename should be nil", :example_failed
    end
  end
end
