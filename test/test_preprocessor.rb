require 'reco_test'

class PreprocessorTest < Reco::TestCase
  def test_preprocessing_hello_eco_fixture
    assert_equal fixture('hello.coffee'), preprocess_fixture('hello.eco')
  end
  
  def test_preprocessing_projects_eco_fixture
    assert_equal fixture('projects.coffee'), preprocess_fixture('projects.eco')
  end
  
  def test_preprocessing_helpers_eco_fixture
    assert_equal fixture('helpers.coffee'), preprocess_fixture('helpers.eco')
  end
  
  def test_unexpected_dedent
    assert_raise Reco::Preprocessor::Error do
      preprocess_fixture 'invalid_dedentation.eco'
    end
  end
  
  def test_expected_newline_in_code_block
    assert_raise Reco::Preprocessor::Error do
      preprocess_fixture 'unexpected_newline_in_code_block.eco'
    end
  end
  
  def test_unexpected_end_of_template
    assert_raise Reco::Preprocessor::Error do
      preprocess "<%= item.price"
    end
  end
  
  def test_automatic_captures_use_the_same_arrow_as_the_function_definition
    output = preprocess "<% @foo -> %><br><% end %>"
    assert output.match 'capture ->'

    output = preprocess "<% @foo => %><br><% end %>"
    assert output.match 'capture =>'
  end
  
  def test_end_dedents_properly_after_an_automatic_capture
    output = preprocess_fixture 'automatic_capture.eco'
    
    lines = output.split "\n"
    assert lines.pop.match /^\S/
  end
  
  private
  def preprocess(source)
    Reco::Preprocessor.preprocess source
  end
  
  def preprocess_fixture(path)
    preprocess fixture(path)
  end
end
