# -*- encoding: utf-8 -*-
require File.expand_path('../lib/letter_stamp_mail_delivery/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kenta Murata"]
  gem.email         = ["mrkn@cookpad.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "letter_stamp_mail_delivery"
  gem.require_paths = ["lib"]
  gem.version       = LetterStampMailDelivery::VERSION

  gem.add_dependency('mail', '>= 2.2.0')

  gem.add_development_dependency('rspec', '~> 2.10.0')
end
