# ecg
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
