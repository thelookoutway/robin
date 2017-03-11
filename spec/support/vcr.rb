RSpec.configure do |config|
  config.when_first_matching_example_defined(:vcr) do
    require "webmock"
    require "vcr"

    VCR.configure do |config|
      config.cassette_library_dir = "spec/fixtures/cassettes"
      config.hook_into :webmock
      config.ignore_localhost = true
      config.allow_http_connections_when_no_cassette = false
    end
  end

  config.around(:each, :vcr) do |example|
    cassette = example.metadata[:vcr]
    if cassette
      VCR.use_cassette(cassette) do
        example.run
      end
    else
      example.run
    end
  end
end
