require 'reco_test'

class ScannerTest < Test::Unit::TestCase
  def scan(source)
    Reco::Scanner.scan(source)
  end
  
  def test_coffee_tag_begin_a_code_block
    tokens = scan '<%'
    assert_equal ['printString', ''], tokens.shift
    assert_equal ['beginCode', print: false, safe: false], tokens.shift
  end
end
