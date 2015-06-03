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

class LexerTest < MiniTest::Test

  def test_define
    # (define (掛け算 数字A 数字B)
    #   (* 数字A 数字B))
    code = <<-CODE
掛け算っていうのは、
数字Aと数字Bを使って、
数字Aと数字Bをかけた結果を返すんだよ。
5と6で掛け算してみて！
CODE
    tokens = [[
      [:DEFINE, "掛け算"],
      ["数字A", "数字B"],
      ["*", ["数字A"], ["数字B"]]
    ],[
      ["掛け算", [5], [6]],
    ]]
    assert_equal tokens, Lexer.new.tokenize(code)
  end

  def test_factorial
    code = <<-CODE
階乗っていうのは、
数字を使って、
もしその数字が0だったら1を返して、
それ以外だったら
その数字と、その数字から1を引いた数で階乗をした結果をかけたものを返すんだよ。
CODE
    assert_equal [[
      [:DEFINE, "階乗"],
      ["数字"],
      [:IF, ["==", "数字", 0], [1]],
      [:ELSE],
      ["*", ["数字"], ["階乗", ["-", ["数字"], [1]]]]
    ]],
      Lexer.new.tokenize(code)
  end

  def test_body
    code = "その数字と、その数字から1を引いた数で階乗をした結果をかけたものを返すんだよ。"
    tokens = [[
      ["*", ["数字"], ["階乗", ["-", ["数字"], [1]]]]
    ]]
    assert_equal tokens, Lexer.new.tokenize(code)
  end
end
