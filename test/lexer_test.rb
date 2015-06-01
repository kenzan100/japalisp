require 'minitest/autorun'
require_relative "../lexer"

# 階乗っていうのは、
# 数字を一つ使って、
# もしその数字が0だったら1を返して、
# それ以外だったら
# 同じ事を一つ少ない数字でやった結果とその数字をかけたものを返すんだよ。
#
# define 階乗
#
# 5が欲しいっていうのは、
# 5を返すんだよ。
#
# define 5が欲しい
# 5
#
# [[:DEF, "def"], [:IDENTIFIER, "5が欲しい"],
#


class LexerTest < MiniTest::Test
  def test_define
    assert_equal [[:DEF, "def"], [:IDENTIFIER, "名前"]], Lexer.new.tokenize("名前っていうのは")
  end

  def test_call
    code = <<-CODE
5と6で掛け算してみて！
CODE
    tokens = [
      [:CALL, "してみて"], [:IDENTIFIER, "掛け算"],
      [:NUMBER, 5], [:NUMBER, 6]
    ]
    assert_equal tokens, Lexer.new.tokenize(code)
  end

  def test_define2
    code = <<-CODE
掛け算っていうのは、
数字Aと数字Bを使って、
数字Aと数字Bをかけた結果を返すんだよ。
CODE
    tokens = [
      [:DEF, "def"], [:IDENTIFIER, "掛け算"],
      [:ARGS, "arg"], [:IDENTIFIER, "数字A"], [:IDENTIFIER, "数字B"],
      [:RETURN, "返す"], [:*, "かけた結果"], [:IDENTIFIER, "数字A"], [:IDENTIFIER, "数字B"]
    ]
    assert_equal tokens, Lexer.new.tokenize(code)
  end

  # def test_
  #   code = <<-CODE
  #     階乗っていうのは、
  #     数字を使って、
  #     もしその数字が0だったら1を返して、
  #     それ以外だったら
  #     同じ事を一つ少ない数字でやった結果とその数字をかけたものを返すんだよ。
  #   CODE
  #   assert_equal [],
  #     Lexer.new.tokenize(code)
  # end
end
