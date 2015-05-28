require 'minitest/autorun'
require_relative "../lexer"

class LexerTest < MiniTest::Test
  def test_define
    assert_equal [[:DEF, "def"], [:IDENTIFIER, "名前"]], Lexer.new.tokenize("名前っていうのは")
  end
end
