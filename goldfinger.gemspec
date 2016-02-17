Gem::Specification.new do |s|
  s.name                  = 'goldfinger'
  s.version               = '0.1.0'
  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.0.0'
  s.date                  = '2016-02-17'
  s.summary               = "A Webfinger utility for Ruby"
  s.description           = "A Webfinger utility for Ruby"
  s.authors               = ["Eugen Rochko"]
  s.email                 = 'eugen@zeonfederated.com'
  s.files                 = `git ls-files lib LICENSE README.md`.split($RS)
  s.homepage              = 'https://github.com/Gargron/goldfinger'
  s.licenses              = ['MIT']

  s.add_dependency('http', '~> 1.0')
  s.add_dependency('addressable', '~> 2.4')
  s.add_dependency('nokogiri', '~> 1.6')

  s.add_development_dependency('bundler', '~> 1.3')
end
