module FileFixtures
  FIXTURES_FILES_PATH = 'spec/fixtures/files'.freeze

  def file_fixture(fixture_name)
    path = Pathname.new(File.join(FIXTURES_FILES_PATH, fixture_name))
    return path if path.exist?

    msg = "the directory '%s' does not contain a file named '%s'"
    raise ArgumentError, msg % [FIXTURES_FILES_PATH, fixture_name]
  end
end

RSpec.configure do |config|
  config.include FileFixtures
end
