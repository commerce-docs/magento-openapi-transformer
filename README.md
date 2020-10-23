# Magento REST schema transformer

A tool that cleans up and updates a Magento REST schema to improve readability when used by ReDoc.

## Install dependencies

```sh
yarn install
```

## Run the script

```sh
yarn start -i /path/to/schema/file -o /path/to/output/file
```

## CLI options

| Name        | Alias | Description                  |
| ----------- | ----- | ---------------------------- |
| `--infile`  | `-i`  | Filepath to the schema file  |
| `--outfile` | `-o`  | Filepath to write the output |

**NOTE:** *If the outfile is not specified, the script will emit a warning and write to the console.*

## Running tests

This project uses [Jest][] for tests.

Use the following to run tests:

```sh
yarn test
```

[jest]: https://jestjs.io/docs/en/getting-started