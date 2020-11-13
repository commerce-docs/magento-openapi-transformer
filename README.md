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

## Get all and transform

You can all three original schemas and transform them in one run.
Make sure the Magento app is running.
If your host is not `https://127.0.0.1`, add it as an argument.

For Magento 2.4 running on 'https://127.0.0.1':

```bash
bin/get-rest-schemas-from-2_4
```

For Magento 2.4 running on a remote host 'https://magento2.docker':

```bash
bin/get-rest-schemas-from-2_4 https://magento2.docker
```

For Magento 2.3:

```bash
bin/get-rest-schemas-from-2_4 [host]
```

Find generated original and transformed schemas in the `__output__` directory.

## Running tests

This project uses [Jest][] for tests.

Use the following to run tests:

```sh
yarn test
```

[jest]: https://jestjs.io/docs/en/getting-started