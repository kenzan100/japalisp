require 'minitest/autorun'
require_relative "../lexer"

class LexerTest < MiniTest::Test

  # 7 primitives according to PG
  #
  # 1. quote
  # 2. atom
  # 3. eq
  # 4. car
  # 5. cdr
  # 6. cons
  # 7. cond
  #
  # a. lambda
  # b. label
  # c. defun

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

  def test_subst
    code = <<-CODE
置き換えっていうのは、
AとBとCを使って、
もしCがアトムでBだったら、Aを返して、
それ以外だったら
Cの先っちょで置き換えをした結果と
Cの残りで置き換えをした結果をつなげたものを返すんだよ。
CODE
  end

end
