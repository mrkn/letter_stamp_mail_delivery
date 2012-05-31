require 'mail/network/delivery_methods/test_mailer'

require 'fileutils'

module LetterStampMailDelivery
  class DeliveryMethod < ::Mail::TestMailer
    class << self
      attr_accessor :posting_location
    end

    def self.start
      @mail_counts = Hash.new(0)
    end

    def self.mail_count
      @mail_counts[posting_location]
    end

    class << self
      def increment_mail_count
        @mail_counts[posting_location] += 1
      end
      private :increment_mail_count
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
      stem = [posting_location, self.class.mail_count].flatten.join('_')
      "#{delivery_location}/#{stem}.eml"
    end

    def save_raw_mail(raw_mail)
      if posting_location && delivery_location
        increment_mail_count
        filename = generate_filename
        FileUtils.mkdir_p(File.dirname(filename))
        open(filename, 'wb') {|io| io.write(raw_mail) }
      end
    end

    def increment_mail_count
      self.class.send :increment_mail_count
    end
  end
end
