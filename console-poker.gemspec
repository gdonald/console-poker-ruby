# frozen_string_literal: true

require 'rake'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.2'
  spec.name = 'console-poker'
  spec.version = '1.0.2'
  spec.summary = 'Console Poker'
  spec.description = 'Poker for your console, full version.'
  spec.author = 'Greg Donald'
  spec.email = 'gdonald@gmail.com'
  spec.bindir = 'bin'
  spec.executables << 'console-poker'
  spec.files = FileList['lib/**/*.rb',
                        'bin/*',
                        '[A-Z]*',
                        'spec/**/*.rb'].to_a
  spec.homepage = 'https://github.com/gdonald/console-poker-ruby'
  spec.metadata = {
    'source_code_uri' => 'https://github.com/gdonald/console-poker-ruby',
    'rubygems_mfa_required' => 'true'
  }
  spec.license = 'MIT'
  spec.post_install_message = "\nType `console-poker` to run!\n\n"
end
