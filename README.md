# ecg
[![Gem Version](https://badge.fury.io/rb/ecg.svg)](https://badge.fury.io/rb/ecg)
[![Build Status](https://github.com/epaew/ecg/workflows/Run%20TestUnit/badge.svg)](https://github.com/epaew/ecg/actions?query=workflow%3A%22Run+TestUnit%22+branch%3A%22master%22)
[![Maintainability](https://api.codeclimate.com/v1/badges/a043130a95580dc41610/maintainability)](https://codeclimate.com/github/epaew/ecg/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a043130a95580dc41610/test_coverage)](https://codeclimate.com/github/epaew/ecg/test_coverage)

ecg is an ERB(eRuby) based, simple and powerful configration file generator for general purpose.

## Requirements
Ruby: 2.5 or higher

## Install
```sh
gem install ecg
```

## Usage
See also `ecg --help`

### Simple example
```sh
ecg --values name=epaew --values email="epaew.333@gmail.com" < template.json.erb
{
  "type": "user",
  "name": "epaew",
  "email": "epaew.333@gmail.com"
}
```
or
```sh
ecg config.yml < template.json.erb
{
  "type": "user",
  "name": "epaew",
  "email": "epaew.333@gmail.com"
}
```
with
* template.json.erb
    ```json
    {
      "type": "user",
      "name": "<%= name %>",
      "email": "<%= email %>"
    }
    ```
* config.yml
    ```yaml
    name: epaew
    email: epaew.333@gmail.com
    ```

### Using nested keys
```sh
ecg --values user.name=epaew --values user.email="epaew.333@gmail.com" < template.json.erb
{
  "user": {
    "name": "epaew",
    "email": "epaew.333@gmail.com"
  }
}
```
or
```sh
ecg config.yml < template.json.erb
{
  "user": {
    "name": "epaew",
    "email": "epaew.333@gmail.com"
  }
}
```
with
* template.json.erb
    ```json
    {
      "user": {
        "name": "<%= user.name %>",
        "email": "<%= user.email %>"
      }
    }
    ```
* config.yml
    ```yaml
    user:
      name: epaew
      email: epaew.333@gmail.com
    ```

### Using array (JSON and YAML only)
```sh
ecg config.yml < template.json.erb
{
  "user": [
    {
      "name": "Kurimu"
    },
    {
      "name": "Chizuru"
    },
    {
      "name": "Minatsu"
    },
    {
      "name": "Mahuyu"
    }
  ]
}
```
with
* template.json.erb
    ```json
    {
      "user": [
    <% users.each_with_index do |user, i| %>
        {
          "name": "<%= user.name %>"
    <% unless i == users.count - 1 %>
        },
    <% else %>
        }
    <% end %>
    <% end %>
      ]
    }
    ```
* config.yml
    ```yaml
    users:
      - name: Kurimu
      - name: Chizuru
      - name: Minatsu
      - name: Mahuyu
    ```

## License
[MIT](LICENSE)
