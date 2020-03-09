var setParser = require("./set.js");
var s = setParser.parse("declare S1={1,2,3,4};(S1 / {3,4})");
console.log(s);