# Argo

Turn a JSON Schema into Ruby objects that describe properties and validations.

Work in progress.

## Usage

```ruby
require 'argo/parser'
require 'json'

json_schema = File.read('spec/fixtures/entry-schema.json')
schema = Argo::Parser.new(JSON.parse(json_schema)).root

schema.description # => "schema for an fstab entry"
schema.properties.map(&:name) # => ["storage", "fstype", "options", "readonly"]
schema.properties[1].constraints # => {:enum=>["ext3", "ext4", "btrfs"]}
```
