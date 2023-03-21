#!/bin/sh

convert () {
  ruby -ryaml -rjson -e 'puts JSON.parse(ARGF.read).to_yaml' < __output__/artifacts/admin-schema-processed.json > __output__/admin-schema-$VERSION.yaml
  ruby -ryaml -rjson -e 'puts JSON.parse(ARGF.read).to_yaml' < __output__/artifacts/customer-schema-processed.json > __output__/customer-schema-$VERSION.yaml
  ruby -ryaml -rjson -e 'puts JSON.parse(ARGF.read).to_yaml' < __output__/artifacts/guest-schema-processed.json > __output__/guest-schema-$VERSION.yaml
}

edit () {
  echo -e "Final editing\n"

  echo 'Changing version'

  read -p 'Enter your Magento version (e.g, 2.4.6): ' VERSION

  version=$VERSION ruby -rjson -e 's = JSON.load($stdin); s["info"]["version"]=ENV["version"]; s["info"]["title"]="Commerce Admin REST endpoints - All inclusive"; s["host"]="example.com"; puts JSON.generate s' < __output__/artifacts/admin-schema-transformed.json > __output__/artifacts/admin-schema-processed.json
  version=$VERSION ruby -rjson -e 's = JSON.load($stdin); s["info"]["version"]=ENV["version"]; s["info"]["title"]="Commerce Customer REST endpoints - All inclusive"; s["host"]="example.com"; puts JSON.generate s' < __output__/artifacts/customer-schema-transformed.json > __output__/artifacts/customer-schema-processed.json
  version=$VERSION ruby -rjson -e 's = JSON.load($stdin); s["info"]["version"]=ENV["version"]; s["info"]["title"]="Commerce Guest REST endpoints - All inclusive"; s["host"]="example.com"; puts JSON.generate s' < __output__/artifacts/guest-schema-transformed.json > __output__/artifacts/guest-schema-processed.json

  echo 'Done'
}

transform () {
  echo "Transfoming the schemas for Redocly"

  yarn install

  yarn start -i __output__/artifacts/guest-schema-original.json -o __output__/artifacts/guest-schema-transformed.json

  yarn start -i __output__/artifacts/admin-schema-original.json -o __output__/artifacts/admin-schema-transformed.json

  yarn start -i __output__/artifacts/customer-schema-original.json -o __output__/artifacts/customer-schema-transformed.json
}
