#!/bin/sh

convert () {
  ruby -ryaml -rjson -e 'puts JSON.parse(ARGF.read).to_yaml' < __output__/admin-schema-processed-$VERSION.json > __output__/admin-schema-redocly-$VERSION.yaml
  ruby -ryaml -rjson -e 'puts JSON.parse(ARGF.read).to_yaml' < __output__/customer-schema-processed-$VERSION.json > __output__/customer-schema-redocly-$VERSION.yaml
  ruby -ryaml -rjson -e 'puts JSON.parse(ARGF.read).to_yaml' < __output__/guest-schema-processed-$VERSION.json > __output__/guest-schema-redocly-$VERSION.yaml
}

edit () {
  echo -e "Final editing\n"

  echo 'Changing version'

  read -p 'Enter your Magento version (ex, 2.4.3): ' VERSION

  cat __output__/admin-schema-transformed.json | version=$VERSION ruby -rjson -e 's = JSON.load($stdin); s["info"]["version"]=ENV["version"]; s["info"]["title"]="Commerce Admin REST endpoints - All inclusive"; s["host"]="example.com"; puts JSON.generate s' > __output__/admin-schema-processed-$VERSION.json
  cat __output__/customer-schema-transformed.json | version=$VERSION ruby -rjson -e 's = JSON.load($stdin); s["info"]["version"]=ENV["version"]; s["info"]["title"]="Commerce Customer REST endpoints - All inclusive"; s["host"]="example.com"; puts JSON.generate s' > __output__/customer-schema-processed-$VERSION.json
  cat __output__/guest-schema-transformed.json | version=$VERSION ruby -rjson -e 's = JSON.load($stdin); s["info"]["version"]=ENV["version"]; s["info"]["title"]="Commerce Guest REST endpoints - All inclusive"; s["host"]="example.com"; puts JSON.generate s' > __output__/guest-schema-processed-$VERSION.json

  echo 'Done'
}

transform () {
  echo "Transfoming the schemas for Redocly"

  yarn install

  yarn start -i __output__/guest-schema-original.json -o __output__/guest-schema-transformed.json

  yarn start -i __output__/admin-schema-original.json -o __output__/admin-schema-transformed.json

  yarn start -i __output__/customer-schema-original.json -o __output__/customer-schema-transformed.json
}
