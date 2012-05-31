require 'spec_helper'
require 'mail'
require 'tmpdir'

module LetterStampMailDelivery
  describe DeliveryMethod do
    shared_context "setup and enter temporary directory" do
      around :each do |example|
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir) do
            example.run
          end
        end
      end
    end

    shared_context "initialize without :delivery_location" do
      before :each do
        Mail.defaults do
          delivery_method DeliveryMethod
        end
      end
    end

    shared_context "initialize with :delivery_location" do
      before :each do
        Mail.defaults do
          delivery_method DeliveryMethod,
            :delivery_location => "#{Dir.pwd}/tmp/mails"
        end
      end
    end

    before :each do
      # Reset all defaults back to original state
      Mail.defaults do
        delivery_method :smtp, { :address              => "localhost",
                                 :port                 => 25,
                                 :domain               => 'localhost.localdomain',
                                 :user_name            => nil,
                                 :password             => nil,
                                 :authentication       => nil,
                                 :enable_starttls_auto => true,
                                 :openssl_verify_mode  => nil }
        DeliveryMethod.deliveries.clear
      end
    end

    context "just initialized" do
      include_context "initialize without :delivery_location"

      describe ".deliveries" do
        subject { described_class.deliveries }

        it { should be_empty }
      end
    end

    context "initialize without :delivery_location parameter" do
      include_context "setup and enter temporary directory"

      describe "#settings[:delivery_location]" do
        subject { Mail.delivery_method.settings[:delivery_location] }

        context "Rails isn't defined" do
          include_context "initialize without :delivery_location"

          it "should have the correct temporary directory" do
            subject.should eq("#{Dir.tmpdir}/letter_stamp_mails")
          end
        end

        context "Rails.root is defined" do
          before :each do
            Object.const_set(:Rails, double("Rails")) unless defined?(::Rails)
            ::Rails.stub(:root).and_return(Dir.pwd)
          end

          after :each do
            Object.send(:remove_const, :Rails) if ::Rails.is_a?(::RSpec::Mocks::Mock)
          end

          include_context "initialize without :delivery_location"

          it "should have \"\#{Rails.root}/tmp/letter_stamp_mails\"" do
            subject.should eq("#{::Rails.root}/tmp/letter_stamp_mails")
          end
        end
      end
    end

    context "initialize with :delivery_location parameter" do
      include_context "setup and enter temporary directory"
      include_context "initialize with :delivery_location"

      describe "#settings[:delivery_location]" do
        subject { Mail.delivery_method.settings[:delivery_location] }

        it "should have the value specified at the initialization" do
          subject.should eq("#{Dir.pwd}/tmp/mails")
        end
      end
    end

    it "should deliver an email into the LetterStampMailDelivery.deliveries array" do
      Mail.defaults do
        delivery_method DeliveryMethod
      end
      mail = Mail.new do
        to 'mikel@me.com'
        from 'you@you.com'
        subject 'testing'
        body 'hello'
      end
      mail.deliver
      described_class.deliveries.should have(1).item
      described_class.deliveries.first.should eq(mail)
    end

    context "do not set filename" do
      include_context "setup and enter temporary directory"
      include_context "initialize with :delivery_location"

      it "should not save an email as a file" do
        mail = Mail.new do
          to 'mikel@me.com'
          from 'you@you.com'
          subject 'testing'
          body 'hello'
        end
        mail.deliver
        Dir.glob("#{Dir.pwd}/tmp/mails/*").should have(0).item
      end
    end

    context "filename is given" do
      include_context "setup and enter temporary directory"
      include_context "initialize with :delivery_location"

      before :each do
        DeliveryMethod.filename = "foo.eml"
      end

      it "should save an email as a file" do
        mail = Mail.new do
          to 'mikel@me.com'
          from 'you@you.com'
          subject 'testing'
          body 'hello'
        end
        mail.deliver
        Dir.glob("#{Dir.pwd}/tmp/mails/*").should have(1).item
        File.should be_file("#{Dir.pwd}/tmp/mails/foo.eml")
      end
    end
  end
end
