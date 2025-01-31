#!/bin/sh

convert () {
  if [ -z "$VERSION" ]; then
    echo "ERROR: VERSION is not set. Exiting."
    exit 1
  fi

  ruby -ryaml -rjson -e 'puts JSON.parse(ARGF.read).to_yaml' < __output__/artifacts/admin-schema-edited.json > __output__/admin-schema-$VERSION.yaml
  ruby -ryaml -rjson -e 'puts JSON.parse(ARGF.read).to_yaml' < __output__/artifacts/customer-schema-edited.json > __output__/customer-schema-$VERSION.yaml
  ruby -ryaml -rjson -e 'puts JSON.parse(ARGF.read).to_yaml' < __output__/artifacts/guest-schema-edited.json > __output__/guest-schema-$VERSION.yaml
}

edit () {
  echo -e "Editing: version, title, intro, host\n"

  read -p 'Enter your Magento version (e.g, 2.4.6): ' VERSION

  version=$VERSION ruby -rjson -e 's = JSON.load($stdin); s["info"]["version"]=ENV["version"]; s["info"]["title"]="Commerce Admin REST endpoints - All inclusive"; s["info"].merge!({"description" => {"$ref" => "../_includes/redocly-intro.md"}}); s["host"]="example.com"; puts JSON.pretty_generate s' < __output__/artifacts/admin-schema-transformed.json > __output__/artifacts/admin-schema-edited.json
  version=$VERSION ruby -rjson -e 's = JSON.load($stdin); s["info"]["version"]=ENV["version"]; s["info"]["title"]="Commerce Customer REST endpoints - All inclusive"; s["host"]="example.com"; s["info"].merge!({"description" => {"$ref" => "../_includes/redocly-intro.md"}}); puts JSON.pretty_generate s' < __output__/artifacts/customer-schema-transformed.json > __output__/artifacts/customer-schema-edited.json
  version=$VERSION ruby -rjson -e 's = JSON.load($stdin); s["info"]["version"]=ENV["version"]; s["info"]["title"]="Commerce Guest REST endpoints - All inclusive"; s["info"].merge!({"description" => {"$ref" => "../_includes/redocly-intro.md"}}); s["host"]="example.com"; puts JSON.pretty_generate s' < __output__/artifacts/guest-schema-transformed.json > __output__/artifacts/guest-schema-edited.json

  echo 'Done'
}

get_customer_creds () {
  CUSTOMER_PASSWORD="$(jq -r '.password' 'bin/customer.json')"
  CUSTOMER_USERNAME="$(jq -r '.customer.email' "bin/customer.json")"
  export CUSTOMER_PASSWORD
  export CUSTOMER_USERNAME
}

transform () {
  echo "Transfoming the schemas for Redocly"

  yarn install

  yarn start -i __output__/artifacts/guest-schema-original.json -o __output__/artifacts/guest-schema-transformed.json

  yarn start -i __output__/artifacts/admin-schema-original.json -o __output__/artifacts/admin-schema-transformed.json

  yarn start -i __output__/artifacts/customer-schema-original.json -o __output__/artifacts/customer-schema-transformed.json
}
