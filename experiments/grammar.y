class Parser

token DEF
token IDENTIFIER
token NUMBER
token CALL
token ARGS
token TERM
token IF

rule
  # val[0] means 0th matched expression on the left.
  Program:
    /* nothing */ { result = Nodes.new([]) }
  | Expressions   { result = val[0] }
  ;

  Expressions:
    Expression                        { result = Nodes.new(val) }
  | Expressions Terminator Expression { result = val[0] << val[2] }
  | Expressions Terminator            { result = val[0] }
  ;

  Expression:
    Literal
  | Call
  | Operator
  | GetLocal
  | Def
  | If
  ;

  Terminator:
    TERM
  ;

  Literal:
    NUMBER { result = NumberNode.new(val[0]) }
  ;

  Call:
    CALL IDENTIFIER Arguments { result = CallNode.new(val[1], val[2]) }
  ;

  Arguments:
    Arguments Expression { result = val[0] << val[1] }
  | Expression           { result = val }
  ;

  Operator:
    '*' Expression Expression { result = CallNode.new(val[0], [val[1], val[2]]) }
  ;

  GetLocal:
    IDENTIFIER  { result = GetLocalNode.new(val[0]) }
  ;

  Def:
    DEF IDENTIFIER ARGS Arguments Expressions  { result = DefNode.new(val[1], val[3], val[4]) }
  ;

  If:
    IF Expression Expressions { result = IfNode.new(val[1], val[2]) }
  ;
end

---- header
  require_relative "lexer"
  require_relative "nodes"

---- inner
  def parse(code, feed_tokens=false)
    if feed_tokens
      @tokens = code
    else
      @tokens = Lexer.new.tokenize(code)
    end
    # puts @tokens.inspect if show_tokens
    do_parse
  end

  def next_token
    @tokens.shift
  end
