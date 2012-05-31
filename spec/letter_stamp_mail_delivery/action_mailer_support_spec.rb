require 'spec_helper'
require 'letter_stamp_mail_delivery/action_mailer_support'

module LetterStampMailDelivery
  describe ActionMailerSupport do
    describe '.install' do
      it "should add_delivery_method :letter_stamp" do
        described_class.install
        ActionMailer::Base.delivery_methods.should include(:letter_stamp)
      end
    end
  end
end
