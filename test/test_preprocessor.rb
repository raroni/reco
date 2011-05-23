require 'reco_test'

class PreprocessorTest < Reco::TestCase
  def test_respond_to_preprocess_class_method
    assert_equal fixture('hello.coffee'), Reco::Preprocessor.preprocess(fixture('hello.eco'))
  end
end
