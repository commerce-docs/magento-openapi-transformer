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

## Get all, transform, and process

You can get all three original schemas and transform them in one run.
Just make sure the Magento app is running.
If your host is not `https://127.0.0.1`, add it as an argument.

For Magento 2.4 running on 'https://127.0.0.1':

```bash
bin/get-rest-schemas-from-2_4
```

For Magento 2.4 running on a different host 'https://magento2.docker.remote.host.com':

```bash
bin/get-rest-schemas-from-2_4 https://magento2.docker.remote.host.com
```

For Magento 2.3:

```bash
bin/get-rest-schemas-from-2_4 [host]
```

Find the generated, transformed, and processed schemas in the `__output__` directory.

__Use the `processed` schemas on Redocly.__

## Running tests

This project uses [Jest][] for tests.

Use the following to run tests:

```sh
yarn test
```

[jest]: https://jestjs.io/docs/en/getting-started
