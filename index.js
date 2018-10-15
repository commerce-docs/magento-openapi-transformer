const transpiler = require('./src/transpiler');
const fs = require('fs');
const config = require('./_config');


fs.readFile(config.infile, "utf8", (err,data)=>{
    if(err){
        throw err;
    }

    var json = data.toString();

    const result = transpiler.run(config, json);

    console.log(result);
});
