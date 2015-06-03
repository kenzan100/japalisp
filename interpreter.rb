require 'byebug'
require_relative 'lexer'

class Interpreter
  def initialize
    @lexer = Lexer.new
    @default_env = default_env
  end

  def eval(code)
    return_val = nil
    @lexer.tokenize(code).each do |sentence|
      return_val = sentence_eval(sentence, @default_env)
    end
    return_val
  end

  private

  def sentence_eval(code,env)
    if code.is_a?(String)
      return env.find(code)
    elsif code.is_a?(Numeric)
      return code
    end

    case code[0][0]
    when :DEFINE
      env[code[0][1]] = lambda do |*args|
        sentence_eval(code[2], Env.new(code[1], args, env))
      end
    else
      expressions = code.flatten.map{ |exp| sentence_eval(exp, env) }
      rambda = expressions.shift
      rambda.call(*expressions)
    end
  end

  def default_env
    Env[{
      "*" => lambda{|a,b| a * b}
    }]
  end
end

class Env < Hash
  attr_accessor :outer

  def initialize(keys=[], vals=[], outer=nil)
    self.merge!(Hash[keys.zip(vals)])
    self.outer = outer
  end

  def find(key)
    return self[key] if self[key]
    outer.find(key) if outer
  end
end
