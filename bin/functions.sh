#!/bin/sh

# Convert JSON schemas to YAML format
# Required: VERSION environment variable
# Input: JSON files from __output__/artifacts/
# Output: YAML files in __output__/ with version in filename
convert_paas () {
  if [ -z "$VERSION" ]; then
    echo "ERROR: VERSION is not set. Exiting."
    exit 1
  fi

  _convert_schema() {
    ruby -ryaml -rjson - "$1" > "$2" <<'RUBY'
begin
  puts JSON.parse(File.read(ARGV[0])).to_yaml
rescue JSON::ParserError => e
  abort "ERROR: Failed to parse JSON: #{e.message}"
end
RUBY
  }

  _convert_schema __output__/artifacts/admin-schema-edited.json    "__output__/admin-schema-$VERSION.yaml"
  _convert_schema __output__/artifacts/customer-schema-edited.json "__output__/customer-schema-$VERSION.yaml"
  _convert_schema __output__/artifacts/guest-schema-edited.json    "__output__/guest-schema-$VERSION.yaml"
}

# Compare YAML schema outputs and report to console
# Required: VERSION environment variable (same as set by edit_paas/convert_paas)
# Prints checksums, line/byte counts, and pairwise diff results
compare_yaml_schemas () {
  if [ -z "$VERSION" ]; then
    echo "ERROR: VERSION is not set. Cannot compare YAML schemas."
    return 1
  fi

  local out_dir="${1:-__output__}"
  local admin="$out_dir/admin-schema-$VERSION.yaml"
  local customer="$out_dir/customer-schema-$VERSION.yaml"
  local guest="$out_dir/guest-schema-$VERSION.yaml"

  for f in "$admin" "$customer" "$guest"; do
    if [ ! -f "$f" ]; then
      echo "ERROR: YAML file not found: $f"
      return 1
    fi
  done

  _sha_cmd () {
    if command -v sha256sum >/dev/null 2>&1; then
      sha256sum "$1" | awk '{print $1}'
    else
      shasum -a 256 "$1" | awk '{print $1}'
    fi
  }

  echo ""
  echo "=== YAML schema comparison (version $VERSION) ==="
  echo ""
  echo "Checksums (SHA-256):"
  printf "  admin:    %s  %s\n" "$(_sha_cmd "$admin")" "$admin"
  printf "  customer: %s  %s\n" "$(_sha_cmd "$customer")" "$customer"
  printf "  guest:    %s  %s\n" "$(_sha_cmd "$guest")" "$guest"
  echo ""
  echo "Lines and bytes:"
  wc -lc "$admin" "$customer" "$guest" | head -3
  echo ""
  echo "Pairwise diff (files must differ):"
  diff -q "$admin" "$customer" >/dev/null 2>&1 && echo "  admin vs customer: IDENTICAL (unexpected)" || echo "  admin vs customer: differ"
  diff -q "$admin" "$guest"    >/dev/null 2>&1 && echo "  admin vs guest:    IDENTICAL (unexpected)" || echo "  admin vs guest:    differ"
  diff -q "$customer" "$guest"  >/dev/null 2>&1 && echo "  customer vs guest: IDENTICAL (unexpected)" || echo "  customer vs guest: differ"
  echo "=== end YAML comparison ==="
  echo ""
}

# Edit PaaS schema metadata including version, title, intro, and host
# Prompts for Magento version
# Input: Transformed JSON files from __output__/artifacts/
# Output: Edited JSON files in __output__/artifacts/
edit_paas () {
  echo -e "Editing: version, title, intro, host\n"

  read -p 'Enter your Magento version (e.g, 2.4.6): ' VERSION

  _edit_schema() {
    title="$1" version=$VERSION ruby -rjson - "$2" > "$3" <<'RUBY'
begin
  s = JSON.load(File.read(ARGV[0]))
rescue JSON::ParserError => e
  abort "ERROR: Failed to parse JSON: #{e.message}"
end
abort "ERROR: Input JSON is missing required 'info' key" unless s.is_a?(Hash) && s['info'].is_a?(Hash)
s['info']['version'] = ENV['version']
s['info']['title'] = ENV['title']
s['info'].merge!('description' => { '$ref' => '../_includes/redocly-intro.md' })
s['host'] = 'example.com'
s['basePath'] = '/' + (s['basePath'] || '/').to_s.sub(/\A\/+/, '')
puts JSON.pretty_generate(s)
RUBY
  }

  _edit_schema "Commerce Admin REST endpoints - All inclusive" \
    __output__/artifacts/admin-schema-transformed.json \
    __output__/artifacts/admin-schema-edited.json

  _edit_schema "Commerce Customer REST endpoints - All inclusive" \
    __output__/artifacts/customer-schema-transformed.json \
    __output__/artifacts/customer-schema-edited.json

  _edit_schema "Commerce Guest REST endpoints - All inclusive" \
    __output__/artifacts/guest-schema-transformed.json \
    __output__/artifacts/guest-schema-edited.json

  echo 'Done'
}

# Retrieve customer credentials from bin/customer.json
# Sets CUSTOMER_PASSWORD and CUSTOMER_USERNAME environment variables
get_customer_creds () {
  CUSTOMER_PASSWORD="$(jq -r '.password' 'bin/customer.json')"
  CUSTOMER_USERNAME="$(jq -r '.customer.email' "bin/customer.json")"
  export CUSTOMER_PASSWORD
  export CUSTOMER_USERNAME
}

# Transform PaaS schemas for Redocly
# Required: yarn and Node.js
# Input: Original JSON files from __output__/artifacts/
# Output: Transformed JSON files in __output__/artifacts/
transform_paas () {
  echo "Transforming the PaaS schemas for Redocly"

  yarn install

  yarn start -i __output__/artifacts/guest-schema-original.json -o __output__/artifacts/guest-schema-transformed.json

  yarn start -i __output__/artifacts/admin-schema-original.json -o __output__/artifacts/admin-schema-transformed.json

  yarn start -i __output__/artifacts/customer-schema-original.json -o __output__/artifacts/customer-schema-transformed.json
}

# Transform ACCS schema for Redocly
# Required: yarn and Node.js
# Parameters:
#   $1 - Input schema file path
# Output: Transformed JSON file with _transformed suffix
transform_accs () {
  if [ -z "$1" ]; then
    echo "ERROR: Input schema file not provided. Usage: transform_accs <input_schema_file>"
    exit 1
  fi

  echo "Transforming the ACCS schemas for Redocly"

  yarn install

  yarn start -i "$1" -o "${1%.*}_transformed.json"
}

# Convert ACCS JSON schema to YAML format
# Required: ruby with yaml and json gems
# Parameters:
#   $1 - Input JSON file path
# Output: YAML file with same base name
convert_accs () {
  if [ -z "$1" ]; then
    echo "ERROR: Input JSON file not provided. Usage: convert_accs <input_json_file>"
    exit 1
  fi

  if [ ! -f "$1" ]; then
    echo "ERROR: File not found: $1"
    exit 1
  fi

  echo "Converting the ACCS schemas to YAML"

  ruby -ryaml -rjson - "$1" > "${1%.*}.yaml" <<'RUBY'
begin
  puts JSON.parse(File.read(ARGV[0])).to_yaml
rescue JSON::ParserError => e
  abort "ERROR: Failed to parse JSON: #{e.message}"
end
RUBY

  echo 'Done'

  echo "See the resulting schema in ${1%.*}.yaml"
}

# Edit ACCS schema metadata including version, title, intro, and host
# Prompts for release version (e.g., April 2026)
# Required: ruby with json gem
# Note: injects a $ref to ../_includes/accs-intro.md — this file must exist
#   relative to the schema location in the parent docs repository
# Parameters:
#   $1 - Input JSON file path
# Output: Edited JSON file with _edited suffix
edit_accs () {
  if [ -z "$1" ]; then
    echo "ERROR: Input JSON file not provided. Usage: edit_accs <input_json_file>"
    exit 1
  fi

  if [ ! -f "$1" ]; then
    echo "ERROR: File not found: $1"
    exit 1
  fi

  echo -e "Editing: version, title, intro, host\n"

  read -p 'Enter the release version (e.g., April 2026): ' VERSION

  version=$VERSION ruby -rjson - "$1" > "${1%.*}_edited.json" <<'RUBY'
begin
  s = JSON.load(File.read(ARGV[0]))
rescue JSON::ParserError => e
  abort "ERROR: Failed to parse JSON: #{e.message}"
end
abort "ERROR: Input JSON is missing required 'info' key" unless s.is_a?(Hash) && s['info'].is_a?(Hash)
s['info']['title'] = 'Adobe Commerce as a Cloud Service'
s['info']['version'] = ENV['version']
s['host'] = 'https://<server>.api.commerce.adobe.com/<tenant-id>'
s['basePath'] = '/'
s['info'].merge!('description' => { '$ref' => '../_includes/accs-intro.md' })
puts JSON.pretty_generate(s)
RUBY

  echo 'Done'
}

# Check for required dependencies
# Verifies presence of ruby, yarn, and jq
# Exits with error if any dependency is missing
check_dependencies() {
  local deps=("ruby" "yarn" "jq")
  for dep in "${deps[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      echo "ERROR: Required dependency '$dep' is not installed"
      exit 1
    fi
  done
}
