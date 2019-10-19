# ecg
[![Gem Version](https://badge.fury.io/rb/ecg.svg)](https://badge.fury.io/rb/ecg)
[![Build Status](https://github.com/epaew/ecg/workflows/TestUnit/badge.svg)](https://github.com/epaew/ecg/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/a043130a95580dc41610/maintainability)](https://codeclimate.com/github/epaew/ecg/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a043130a95580dc41610/test_coverage)](https://codeclimate.com/github/epaew/ecg/test_coverage)

ecg is an ERB(eRuby) based, simple and powerful configration file generator for general purpose.

## Requirements
Ruby: 2.4 or higher

## Install
```sh
gem install ecg
```

## Simple Usage
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

## License
[MIT](LICENSE)
