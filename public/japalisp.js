var Japalisp = {};

Japalisp.Environment = function(table, outer) {
  this.table = table
  this.outer = outer
  this.find = function(sym){
    if(this.table[sym] === undefined){
      return this.outer ? this.outer.find(sym) : undefined
    }else{
      return this.table[sym]
    }
  }
  this.merge = function(keys, vals){
    keys.forEach(function(key,i){
      this.table.key = vals[i]
    })
    return this.table
  }
}

Japalisp.globalEnvironment = new Japalisp.Environment({
  "*":  function(a,b){ return a * b },
  "==": function(a,b){ return a === b},
  "-":  function(a,b){ return a - b},
  "+":  function(a,b){ return a + b}
});

Japalisp.eval = function(exp, env){
  console.log(exp);
  if(typeof exp === "string") {
    var sym = env.find(exp);
    if(sym === undefined){
      throw exp + "って聞いたことないなー..。打ち間違いだったりしない？"
    }else{
      return sym
    };
  }
  if(!(exp instanceof Array)){
    return exp;
  }

  if(exp[0] === "STR"){
    return exp[1]
  }

  var id = exp[0][0] //checking first element within nested array, since our lexer returns nested array.
  if(id === "DEFINE"){
    var keys = code[1],
      body = code.slice(2)
    env.table[exp[0][1]] = function(args){
      var newEnv = new Japalisp.Environment({})
      newEnv.merge(keys, args)
      return Japalisp.eval(body, newEnv)
    }
  }else if(id === "IF"){
    var lineIndex = 0
    while(exp[lineIndex][0] === "IF"){
      var predicate = exp[lineIndex][1];
      if(Japalisp.eval(predicate, env)){
        return Japalisp.eval(exp[lineIndex][2], env)
      }
      lineIndex += 1;
    }
    if(exp[lineIndex][0] === "ELSE"){
      return Japalisp.eval(code[lineIndex+1],env)
    }
  }else if(id === "STR"){
    return exp[0][1]
  }else{
    var expressions = exp.map(function(each_exp){
      return Japalisp.eval(each_exp, env)
    });
    var rambda = expressions.shift();
    if(typeof rambda === "function"){
      return rambda.apply(this, expressions);
    }else{
      return rambda
    }
  }
}
