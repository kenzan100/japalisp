require 'byebug'
require 'pp'
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
      return env.find(code) if env.find(code)
      raise "#{code}って聞いたことないなー..。打ち間違いだったりしない？"
    elsif code.is_a?(Numeric)
      return code
    end

    case code[0]
    when :STR
      return code[1]
    end

    case code[0][0]
    when :DEFINE
      keys = code[1]
      body = code[2..-1]
      env[code[0][1]] = lambda do |*args|
        sentence_eval(body, Env.new(keys, args, env))
      end
    when :IF
      line_index = 0
      while code[line_index][0] == :IF
        predicate = code[line_index][1]
        if sentence_eval(predicate, env)
          return sentence_eval(code[line_index][2], env)
        end
        line_index += 1
      end
      if code[line_index][0] == :ELSE
        return sentence_eval(code[line_index+1], env)
      end
    when :STR
      code[0][1]
    else
      expressions = code.map{ |exp| sentence_eval(exp, env) }
      rambda = expressions.shift
      if rambda.is_a?(Proc)
        rambda.call(*expressions)
      else
        rambda
      end
    end
  end

  def default_env
    Env[{
      "*"  => lambda{|a,b| a * b},
      "==" => lambda{|a,b| a == b},
      "-"  => lambda{|a,b| a - b},
      "+"  => lambda{|a,b| a + b}
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
