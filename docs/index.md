---
title: Index
permalink: /
---

## Table of contents
{:.no_toc}
* Table of contents
{:toc}

## Quick start
1. Install ecg from [rubygems.org](https://rubygems.org/gems/ecg)
    ```sh
    $ gem install ecg
    ```
2. Create template.erb
    ```sh
    $ cat << EOF > template.json.erb
    {
      "user": {
        "name": "<%= name %>",
        "email": "<%= email %>"
      }
    }
    EOF
    ```
3. Run ecg CLI
    ```sh
    $ ecg --values name=epaew --values email="epaew@example.com" < template.json.erb
    {
      "user": {
        "name": "epaew",
        "email": "epaew@example.com"
      }
    }
    ```
