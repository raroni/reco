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
  
  def test_colon_and_coffee_end_tag_ends_a_code_block_and_indents
    tokens = scan "<% for project in @projects: %>"
    assert_equal ["printString", ""], tokens.shift
    assert_equal ["beginCode", print: false, safe: false], tokens.shift
    assert_equal ["recordCode", "for project in @projects"], tokens.shift
    assert_equal ["indent", nil], tokens.shift
  end
  
  def test_arrow_and_coffee_end_tag_ends_a_code_block_and_indents
    tokens = scan "<%= @render 'layout', -> %>"
    assert_equal ["printString", ""], tokens.shift
    assert_equal ["beginCode", print: true, safe: false], tokens.shift
    assert_equal ["recordCode", "@render 'layout', ->"], tokens.shift
    assert_equal ["indent", "->"], tokens.shift
  end
  
  def test_fat_arrow_and_coffee_end_tag_ends_a_code_clock_and_indents
    tokens = scan "<%= @render 'layout', => %>"
    assert_equal ["printString", ""], tokens.shift
    assert_equal ["beginCode", print: true, safe: false], tokens.shift
    assert_equal ["recordCode", "@render 'layout', =>"], tokens.shift
    assert_equal ["indent", "=>"], tokens.shift
  end
  
  def test_coffee_tag_and_else_and_colon_and_coffee_end_tag_dedents_and_begins_a_code_block_and_indents
    tokens = scan "<% else: %>"
    assert_equal ["printString", ""], tokens.shift
    assert_equal ["beginCode", print: false, safe: false], tokens.shift
    assert_equal ["dedent"], tokens.shift
    assert_equal ["recordCode", "else"], tokens.shift
    assert_equal ["indent", nil], tokens.shift
  end
  
  def test_coffee_tag_and_else_and_if_and_colon_dedents_and_begins_a_code_block_and_indents
    tokens = scan "<% else if @projects: %>"
    assert_equal ["printString", ""], tokens.shift
    assert_equal ["beginCode", print: false, safe: false], tokens.shift
    assert_equal ["dedent"], tokens.shift
    assert_equal ["recordCode", "else if @projects"], tokens.shift
    assert_equal ["indent", nil], tokens.shift
  end
  
  def test_coffee_tag_with_double_percent_signs_prints_an_escaped_coffee_tag_in_data_mode
    tokens = scan "a <%% b <%= '<%%' %>"
    assert_equal ["printString", "a <% b "], tokens.shift
    assert_equal ["beginCode", print: true, safe: false], tokens.shift
    assert_equal ["recordCode", "'<%%'"], tokens.shift  
  end
  
  def test_unexpected_new_in_clock
    tokens = scan "foo\nhello <% do 'thing'\n %>"
    assert_equal ["printString", "foo\nhello "], tokens.shift
    assert_equal ["beginCode", print: false, safe: false], tokens.shift
    assert_equal ["fail", "unexpected newline in code block"], tokens.shift
  end
  
  def test_unexpected_end_of_template
    tokens = scan "foo\nhello <% do 'thing'"
    assert_equal ["printString", "foo\nhello "], tokens.shift
    assert_equal ["beginCode", print: false, safe: false], tokens.shift
    assert_equal ["fail", "unexpected end of template"], tokens.shift
  end
end
