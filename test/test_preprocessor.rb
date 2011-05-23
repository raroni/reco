require 'reco_test'

class PreprocessorTest < Reco::TestCase
  def test_preprocessing_hello_eco_fixture
    assert_equal fixture('hello.coffee'), Reco::Preprocessor.preprocess(fixture('hello.eco'))
  end
  
  def test_preprocessing_projects_eco_fixture
    assert_equal fixture('projects.coffee'), Reco::Preprocessor.preprocess(fixture('projects.eco'))
  end
  
end
