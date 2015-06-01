require "minitest/autorun"
require_relative "../parser"

class ParserTest < MiniTest::Test
  def test_def
    code = <<-CODE
掛け算っていうのは、
数字Aと数字Bを使って、
数字Aと数字Bをかけた結果を返すんだよ。
CODE

    nodes = Nodes.new([
      DefNode.new("掛け算", ["数字A", "数字B"],
        Nodes.new([
          CallNode.new(
            "*",
            [GetLocalNode.new("数字A"),
             GetLocalNode.new("数字B")]
          )
        ])
      )
    ])
    asser_equal nodes, Parser.new.parse(code)
  end

  def test_call
    code = <<-CODE
5と6で掛け算してみて！
CODE

    nodes = Nodes.new([
      CallNode.new(
        "掛け算",
        [NumberNode.new(5),
         NumberNode.new(6)]
      )
    ])
    asser_equal nodes, Parser.new.parse(code)
  end
end

