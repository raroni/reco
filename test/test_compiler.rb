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
  
  def test_identifier_can_be_changed
    output = Reco.compile fixture("hello.eco"), :identifier => 'scoobydoo'
    assert output.match /^var scoobydoo =/
  end
  
  def test_identifiers_with_dot_omit_var_keyword
    output = Reco.compile fixture("hello.eco"), :identifier => "window.cowabunga"
    assert output.match /^window\.cowabunga =/
  end

end
