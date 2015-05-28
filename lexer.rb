class Lexer
  def tokenize(code)
    code.chomp!
    tokens = []
    if matched = code[/\A(.+)っていうのは/, 1]
      tokens << [:DEF, "def"] << [:IDENTIFIER, matched]
    end
    tokens
  end
end
