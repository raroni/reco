require 'test/unit'
require 'reco'

class Reco::TestCase < Test::Unit::TestCase
  FIXTURE_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "fixtures"))
  
  def fixture(path)
    File.read File.join(FIXTURE_ROOT, path)
  end
end
