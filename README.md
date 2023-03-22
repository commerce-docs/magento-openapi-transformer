# Adobe Commerce REST schema transformer

A toolkit that gets, cleans up, updates, and converts a Commerce's REST schema for Redoc.

## Prerequisites

1. [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
1. [Node.js](https://nodejs.org/en)
1. [Yarn](https://www.npmjs.com/package/yarn)
1. [jq](https://stedolan.github.io/jq/download/)

## Install dependencies

```sh
yarn install
```

## Configure variables

Create a `.env` file:

```sh
cp .env.example .env
```

Set values for your running Commerce app in `.env`.

## Get, transform, and process the schema

You can get all three original schemas and transform them in one run.
Just make sure the Magento app is running.

```bash
bin/get-schemas-for-redoc
```

> NOTE: Be ready to enter a 2FA code and a version of the running Adobe Commerce.

Find the redoc-ready schemas at `__output__`. For debugging, use intermediate results in `__output__/artifacts`.

## Running tests

This project uses [Jest][] for tests.

Use the following to run tests:

```sh
yarn test
```

[jest]: https://jestjs.io/docs/en/getting-started
