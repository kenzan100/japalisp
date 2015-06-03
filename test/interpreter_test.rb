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

#   def test_simple_arith
#     code = <<-CODE
# 5と6をかけた結果を返すんだよ。
# CODE
#     assert_equal 30, Interpreter.new.eval(code)
#   end
end

