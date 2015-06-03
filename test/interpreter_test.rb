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

end

