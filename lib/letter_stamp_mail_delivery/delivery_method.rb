require 'mail/network/delivery_methods/test_mailer'

require 'fileutils'

module LetterStampMailDelivery
  class DeliveryMethod < ::Mail::TestMailer
    class << self
      attr_accessor :filename
    end

    def self.start
    end

    def initialize(settings)
      super
      self.settings = {
        :location => "#{tmpdir}/letter_stamp_mails",
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

    def generate_filename
      if self.class.filename && settings[:location]
        "#{settings[:location]}/#{self.class.filename}"
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
