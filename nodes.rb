class Nodes < Struct.new(:nodes)
  def <<(node)
    nodes << node
    self
  end
end

class LiteralNode < Struct.new(:value); end
class NumberNode < LiteralNode; end
class StringNode < LiteralNode; end
class TrueNode < LiteralNode
  def initialize
    super(true)
  end
end
class FalseNode < LiteralNode
  def initialize
    super(false)
  end
end
class NilNode < LiteralNode
  def initialize
    super(nil)
  end
end

class CallNode < Struct.new(:method, :arguments); end
class GetLocalNode < Struct.new(:name); end
class SetLocalNode < Struct.new(:name, :value); end

class DefNode < Struct.new(:name, :params, :body); end
class IfNode < Struct.new(:condition, :body); end
