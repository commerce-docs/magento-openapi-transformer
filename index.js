const Transformer = require("./src/Transformer");
const fs = require("fs");
const config = require("./_config");

const commandLineArgs = require("command-line-args");
const { emitWarning } = require("process");

const optionDefinitions = [
  {
    name: "infile",
    alias: "i",
    type: String,
  },
  {
    name: "outfile",
    alias: "o",
    type: String,
  },
];

const options = commandLineArgs(optionDefinitions);

const { infile, outfile } = options;

if (!infile) {
  throw new Error("Input file argument --infile or -i not specified");
}

fs.readFile(infile, "utf8", (err, data) => {
  if (err) {
    throw err;
  }

  var json = data.toString();

  const result = Transformer.run(config, json);

  if (outfile) {
    fs.writeFile(outfile, result, (err) => {
      if (err) {
        throw err;
      }
    });
  } else {
    emitWarning(
      "outfile argument --outfile or -o not specified, writing output to console"
    );
    console.log(result);
  }
});
