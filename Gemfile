source "https://rubygems.org"

ruby "2.4.0"

gem "jbuilder"
gem "pg"
gem "puma"
gem "rails", "~> 5.1.0"

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "vcr", require: false
  gem "webmock", require: false
end

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
end
