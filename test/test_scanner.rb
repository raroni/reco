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
  
  def test_coffee_print_tag_begins_a_print_block
    tokens = scan '<%='
    assert_equal ['printString', ''], tokens.shift
    assert_equal ['beginCode', print: true, safe: false], tokens.shift
  end
  
  def test_coffee_minus_tag_begins_a_safe_print_block
    tokens = scan '<%-'
    assert_equal ['printString', ''], tokens.shift
    assert_equal ['beginCode', print: true, safe: true], tokens.shift
  end
  
  def test_coffee_end_tag_ends_a_code_block
    tokens = scan '<% code goes here %>'
    assert_equal ['printString', ''], tokens.shift
    assert_equal ["beginCode", print: false, safe: false], tokens.shift
    assert_equal ["recordCode", "code goes here"], tokens.shift
    assert_equal ["printString", ""], tokens.shift
  end
  
end
