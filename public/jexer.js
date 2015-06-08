var Jexer = {};

Jexer.tokenizeWhole = function(code){
  var tokens;
  tokens = code.split(/。|！/).reduce(function(acc,sentence){
    return acc.concat(Jexer.tokenizeSentence(sentence));
  },[]);
  return tokens
}

Jexer.tokenizeSentence = function(sentence){
  var tokens;
  tokens = sentence.split('\n').reduce(function(acc,line){
    return acc.concat(Jexer.tokenize(line));
  },[]);
  return tokens;
}

Jexer.tokenize = function(line){
  if(line === undefined) return [];
  if(line === []) return [];

  var rest;
  if( line.match(/っていうのは/) ){
    rest = line.replace(/っていうのは.*$/,'');
    return ["DEFINE"].concat(Jexer.tokenize(rest));
  }else if( line.match(/^もし/) ){
    rest = line.replace(/^もし/,'');
    var exp = rest.split(/だったら|なら/);
    var predicate = exp[0],
        body = exp[1];
    return ["IF",
      Jexer.tokenize(predicate),
      Jexer.tokenize(body)
    ]
  }else if( line.match(/それ以外(だったら|なら)、?$/) ){
    return ["ELSE"]
  }else if( line.match(/を使って/) ){
    rest = line.replace(/を使って.*$/,'');
    return Jexer.tokenize(rest);
  }else if( line.match(/を(返す|返して)/) ){
    rest = line.replace(/を(返す|返して).*$/,'');
    return Jexer.tokenize(rest);
  }else if( line.match(/を(計算)?した(結果|もの)$/)){
    rest = line.replace(/を(計算)?した(結果|もの)$/,'');
    var exp = rest.split(/(で)/);
    var id = exp.slice(-1).join(''),
        args = exp.slice(0,-2).join('');
    var splitter = (args.split(/と、/).length > 1) ?  "と、" :  "と";
    var argTokens = args.split(splitter).map(function(arg){
      return Jexer.tokenize(arg);
    });
    return [id].concat(argTokens);
  }else if( line.match(/してみて/) ){
    rest = line.replace(/してみて.*$/,'');
    return Jexer.tokenize(rest);
  }else if( line.match(/を(かけた結果|かけたもの)$/) ){
    rest = line.replace(/を(かけた結果|かけたもの).*$/, '');
    var argTokens = rest.split(/と、?/).map(function(arg){
      return Jexer.tokenize(arg);
    });
    return ["*"].concat(argTokens);
  }else if( line.match(/を足した(もの|数)$/) ){
    rest = line.replace(/を足した(もの|数)$/,'');
    var argTokens = rest.split(/に/).map(function(arg){
      return Jexer.tokenize(arg);
    });
    return ["+"].concat(argTokens);
  }else if( line.match(/を引いた(もの|数)$/) ){
    rest = line.replace(/を引いた(もの|数)$/,'');
    var exp = rest.split(/(から)/);
    var args = [exp.slice(0,-2).join('')].concat(exp.slice(-1));
    var argTokens = args.map(function(arg){
      return Jexer.tokenize(arg);
    });
    return ["-"].concat(argTokens);
  }else if( line.match(/その/) ){
    var rest = line.replace(/その/g,'');
    return Jexer.tokenize(rest);
  }else if( strMatch = line.match(/^「(.*)」$/)){
    return ["STR", str[1]]
  }else if( line.match(/が/) ){
    var args = line.split(/が/);
    return ["==", Jexer.tokenize(args[0]), Jexer.tokenize(args[1])]
  }else if( line.match(/で/) ){
    var exp = line.split(/で/);
    var identifier = exp.slice(-1).join('');
    var rest = exp.slice(0,-1).join('');
    var argTokens = rest.split(/と、?/).map(function(arg){
      return Jexer.tokenize(arg);
    });
    return Jexer.tokenize(identifier).concat(argTokens);
  }else if( line.match(/と、?/) ){
    return line.split(/と、?/).reduce(function(accu,partial_line){
      return accu.concat(Jexer.tokenize(partial_line));
    },[]);
  }else if( line.match(/[0-9]+/) ){
    return [parseInt(line.match(/[0-9]+/))]
  }else{
    return [line];
  }

};
