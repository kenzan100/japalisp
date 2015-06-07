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
      [:IF, ["==", ["数字"], [0]], [1]],
      [:ELSE],
      ["*", ["数字"], ["階乗", ["-", ["数字"], [1]]]]
    ]],
      Lexer.new.tokenize(code)
  end

  def test_my_adder
    code = <<-CODE
俺の足し算っていうのは、
数字Aと数字Bを使って、
もし数字Bが0なら数字Aを返して、
それ以外だったら
数字Aと、数字Bから1を引いた数で俺の足し算をした結果に1を足したものを返すんだよ。
CODE
    tokens = [[
      [:DEFINE, "俺の足し算"],
      ["数字A", "数字B"],
      [:IF, ["==", ["数字B"], [0]], ["数字A"]],
      [:ELSE],
      ["+", ["俺の足し算", ["数字A"], ["-", ["数字B"], [1]]], [1]]
    ]]
    assert_equal tokens, Lexer.new.tokenize(code)
  end

  def test_my_multiplier
    code = <<-CODE
数字Aと、数字Aと数字Bから1を引いた数で俺の掛け算をした結果で俺の足し算をしたものを返すんだよ。
CODE
    tokens = [[
      ["俺の足し算", ["数字A"], ["俺の掛け算", ["数字A"], ["-", ["数字B"], [1]]]]
    ]]
    assert_equal tokens, Lexer.new.tokenize(code)
  end

  def test_my_comparator
    code = <<-CODE
左大っていうのは、
数字Aと数字Bを使って、
もし数字Aが0なら「違うよ」を返して、
もし数字Bが0なら「そうだよ」を返して、
それ以外だったら
数字Aから1を引いた数と、数字Bから1を引いた数で左大を計算した結果を返すんだよ。
CODE
    tokens = [[
      [:DEFINE, "左大"],
      ["数字A", "数字B"],
      [:IF, ["==", ["数字A"], [0]], [:STR, "違うよ"]],
      [:IF, ["==", ["数字B"], [0]], [:STR, "そうだよ"]],
      [:ELSE],
      ["左大", ["-", ["数字A"], [1]], ["-", ["数字B"], [1]]]
    ]]
    assert_equal tokens, Lexer.new.tokenize(code)
  end

  def test_my_equal
    code = <<-CODE
俺のイコールっていうのは、
数字Aと数字Bを使って、
もし数字Aと数字Bで左大をした結果が「そうだよ」なら「違うよ」を返して、
もし数字Aと数字Bで右大をした結果が「そうだよ」なら「違うよ」を返して、
それ以外だったら
「そうだよ」を返すんだよ。
CODE

    tokens = [[
      [:DEFINE, "俺のイコール"],
      ["数字A", "数字B"],
      [:IF, ["==", ["左大", ["数字A"], ["数字B"]], [:STR, "そうだよ"]], [:STR, "違うよ"]],
      [:IF, ["==", ["右大", ["数字A"], ["数字B"]], [:STR, "そうだよ"]], [:STR, "違うよ"]],
      [:ELSE],
      [:STR, "そうだよ"]
    ]]

    assert_equal tokens, Lexer.new.tokenize(code)
  end

  def test_my_division
    code = <<-CODE
俺の割り算っていうのは、
数字Aと数字Bを使って、
もし数字Aと数字Bで右大をした結果が「そうだよ」なら0を返して、
それ以外だったら
数字Bと、数字Aから数字Bを引いた数で俺の割り算をした結果に1を足したものを返すんだよ。
CODE
    tokens = [[
      [:DEFINE, "俺の割り算"],
      ["数字A", "数字B"],
      [:IF, ["==", ["右大", ["数字A"], ["数字B"]], [:STR, "そうだよ"]], [0]],
      [:ELSE],
      ["+", ["俺の割り算", ["数字B"], ["-", ["数字A"], ["数字B"]]], [1]]
    ]]
    assert_equal tokens, Lexer.new.tokenize(code)
  end
end
