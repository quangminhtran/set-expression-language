{
  var idToSetContent = new Map();
  function union(setA, setB) {
      var _union = new Set(setA);
      for (var elem of setB) {
          _union.add(elem);
      }
      return _union;
  }

  function intersection(setA, setB) {
      var _intersection = new Set();
      for (var elem of setB) {
          if (setA.has(elem)) {
              _intersection.add(elem);
          }
      }
      return _intersection;
  }

  function difference(setA, setB) {
    var _difference = new Set(setA);
    for (var elem of setB) {
        _difference.delete(elem);
    }
    return _difference;
  }
}

Start
 = _ expr:SetExpression _ {
      return "{" + Array.from(expr).join(',') + "}";
 }

// Define a set
SetExpression
  = SetConstant
  / SetVariable
  / LetExpression 
  / SetUnion
  / SetIntersection
  / SetDifference

 SetConstant
  = "{" _ head:INTEGER? tail:(_ ',' _ INTEGER)* _ "}" {
   var setResult = new Set();
   if (head) {
    setResult.add(head);
     }

   tail.forEach(function (element) {
    setResult.add(element[3])
     });
   return setResult;
  }

SetVariable
  = _ id:SetSymbol _ {
    if (!idToSetContent.has(id)) {
      throw new Error(`Variable "${id}" is not defined`);
    }
  return idToSetContent.get(id);
}

LetExpression
 = Let _ "in" _ expr:SetExpression {
    return expr;
 }

Let
  = _ 'let' _ id:SetSymbol _ "=" _ expr:SetExpression _ {
   // Store map: set id -> set definition
   idToSetContent.set(id, expr);
  }

 SetUnion
   = '(' _ left:SetExpression _ 'U' _ right:SetExpression _ ')' {
      return union(left, right);
   }

 SetIntersection
   = '(' _ left:SetExpression _ 'I' _ right:SetExpression _ ')' {
      return intersection(left, right);         
   }

 SetDifference
   = '(' _ left:SetExpression _ '/' _ right:SetExpression _ ')' {
      return difference(left, right);           
   }

//INTEGER "integer"
//  = digits:[0-9]+ { return parseInt(digits.join("")); }

INTEGER "integer"
  = _ [0-9]+ { return parseInt(text(), 10); }

SetSymbol "Set symbols"
//  = _ ([a-z]/[A-Z])+ { return text(); }
  = "S"INTEGER { return text(); }

_ "whitespace"
  = [ \t\n\r]*