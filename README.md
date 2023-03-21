# Magento REST schema transformer

A toolkit that gets, cleans up, updates, and converts a Magento REST schema for the use by Redoc.

## Install dependencies

```sh
yarn install
```

## Get the schemas, transform, and process

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

Find the generated, transformed, and processed schemas in the `__output__` directory.

__Use the `redocly` schemas on Redocly.__

## Running tests

This project uses [Jest][] for tests.

Use the following to run tests:

```sh
yarn test
```

[jest]: https://jestjs.io/docs/en/getting-started
