const Transformer = require('./src/Transformer');
const fs = require('fs');
const config = require('./_config');


fs.readFile(config.infile, "utf8", (err,data)=>{
    if(err){
        throw err;
    }

    var json = data.toString();

    const result = Transformer.run(config, json);

    console.log(result);
});
