require 'reco_test'

class CompilerTest < Reco::TestCase
  def test_compiling_hello_eco_fixture
    assert Reco.compile fixture("hello.eco")
  end
  
  def test_compiling_hello_eco_fixture
    assert Reco.compile fixture("projects.eco")
  end
  
  def test_compiling_hello_eco_fixture
    assert Reco.compile fixture("helpers.eco")
  end
  
  def test_parse_error_throws_exception
    assert_raise Reco::Preprocessor::Error do
      Reco.compile '<% unclosed tag'
    end
  end
  
  def test_identifier_defaults_to_module_exports
    output = Reco.compile fixture("hello.eco")
    assert output.match /^module\.exports =/
  end

end
