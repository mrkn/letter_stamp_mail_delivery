require 'letter_stamp_mail_delivery/delivery_method'

require 'action_mailer'

module LetterStampMailDelivery
  module ActionMailerSupport
    def self.install
      ActionMailer::Base.add_delivery_method :letter_stamp, DeliveryMethod
    end
  end
end
