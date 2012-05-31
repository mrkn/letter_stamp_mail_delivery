# LetterStampMailDelivery

[![Build Status](https://secure.travis-ci.org/mrkn/letter_stamp_mail_delivery.png?branch=master)](http://travis-ci.org/mrkn/letter_stamp_mail_delivery)

Mail delivery method to save delivered mails with filenames that allows us to easily recognize the location at which mails are delivered.

## Installation

Add this line to your application's Gemfile:

    gem 'letter_stamp_mail_delivery'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install letter_stamp_mail_delivery

## Usage

### for RSpec

```ruby
require 'letter_stamp_mail_delivery'
require 'letter_stamp_mail_delivery/rspec_support'

RSpec.configure do |config|
  LetterStampMailDelivery::RSpecSupport.install(config)
end
```

### for test-unit

Not supported yet.

### with ActionMailer

```ruby
require 'letter_stamp_mail_delivery'
require 'letter_stamp_mail_delivery/action_mailer_support'

LetterStampMailDelivery::ActionMailerSupport.install

ActionMailer::Base.delivery_method :letter_stamp
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
