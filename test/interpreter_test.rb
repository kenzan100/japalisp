require "minitest/autorun"
require_relative "../interpreter"

class InterpreterTest < MiniTest::Test
  def test_method
    # (define (掛け算 数字A 数字B)
    #   (* 数字A 数字B))
    code = <<-CODE
掛け算っていうのは、
数字Aと数字Bを使って、
数字Aと数字Bをかけた結果を返すんだよ。

5と6で掛け算してみて！
CODE
    assert_equal 30, Interpreter.new.eval(code)
  end

  def test_factorial
    code = <<-CODE
階乗っていうのは、
数字を使って、
もしその数字が0だったら1を返して、
それ以外だったら
その数字と、その数字から1を引いた数で階乗をした結果をかけたものを返すんだよ。

4で階乗してみて！
CODE
    assert_equal 24, Interpreter.new.eval(code)
  end

  def test_my_adder
    code = <<-CODE
俺の足し算っていうのは、
数字Aと数字Bを使って、
もし数字Bが0なら数字Aを返して、
それ以外だったら
数字Aと、数字Bから1を引いた数で俺の足し算をした結果に1を足したものを返すんだよ。

34と66で俺の足し算してみて！
CODE
    assert_equal 100, Interpreter.new.eval(code)
  end

  def test_my_multiplier
    code = <<-CODE
俺の足し算っていうのは、
数字Aと数字Bを使って、
もし数字Bが0なら数字Aを返して、
それ以外だったら
数字Aと、数字Bから1を引いた数で俺の足し算をした結果に1を足したものを返すんだよ。

俺の掛け算っていうのは、
数字Aと数字Bを使って、
もし数字Bが0なら0を返して、
それ以外なら
数字Aと、数字Aと数字Bから1を引いた数で俺の掛け算をした結果で俺の足し算をしたものを返すんだよ。

5と6で俺の掛け算してみて！
CODE
    assert_equal 30, Interpreter.new.eval(code)
  end

  def test_my_comparator
    code = <<-CODE
左大っていうのは、
数字Aと数字Bを使って、
もし数字Aが0なら「違うよ」を返して、
もし数字Bが0なら「そうだよ」を返して、
それ以外だったら
数字Aから1を引いた数と、数字Bから1を引いた数で左大を計算した結果を返すんだよ。

10と9で左大してみて！
CODE
    assert_equal "そうだよ", Interpreter.new.eval(code)
  end

  def test_my_equal
    code = <<-CODE
左大っていうのは、
数字Aと数字Bを使って、
もし数字Aが0なら「違うよ」を返して、
もし数字Bが0なら「そうだよ」を返して、
それ以外だったら
数字Aから1を引いた数と、数字Bから1を引いた数で左大を計算した結果を返すんだよ。

右大っていうのは、
数字Aと数字Bを使って、
もし数字Bが0なら「違うよ」を返して、
もし数字Aが0なら「そうだよ」を返して、
それ以外だったら
数字Aから1を引いた数と、数字Bから1を引いた数で右大を計算した結果を返すんだよ。

俺のイコールっていうのは、
数字Aと数字Bを使って、
もし数字Aと数字Bで左大をした結果が「そうだよ」なら「違うよ」を返して、
もし数字Aと数字Bで右大をした結果が「そうだよ」なら「違うよ」を返して、
それ以外だったら
「そうだよ」を返すんだよ。

10と10で俺のイコールしてみて！
CODE
    assert_equal "そうだよ", Interpreter.new.eval(code)
  end
end

