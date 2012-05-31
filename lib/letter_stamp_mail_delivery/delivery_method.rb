require 'mail/network/delivery_methods/test_mailer'

require 'fileutils'

module LetterStampMailDelivery
  class DeliveryMethod < ::Mail::TestMailer
    class << self
      attr_accessor :posting_location
    end

    def self.start
    end

    def initialize(settings)
      super
      self.settings = {
        :delivery_location => "#{tmpdir}/letter_stamp_mails",
      }.update(settings)
    end

    def deliver!(mail)
      super
      save_raw_mail(mail.encoded)
    end

    private

    def tmpdir
      defined?(::Rails) ? "#{::Rails.root}/tmp" : Dir.tmpdir
    end

    def posting_location
      self.class.posting_location
    end

    def delivery_location
      settings[:delivery_location]
    end

    def generate_filename
      if posting_location && delivery_location
        stem = posting_location.join('_')
        "#{delivery_location}/#{stem}.eml"
      end
    end

    def save_raw_mail(raw_mail)
      filename = generate_filename
      return unless filename

      FileUtils.mkdir_p(File.dirname(filename))
      open(filename, 'wb') {|io| io.write(raw_mail) }
    end
  end
end
