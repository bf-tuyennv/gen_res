## Features
Auto generate resource path.

## Getting started
Add these lines into pubspec.yaml
```yaml
# pubspec.yaml
gen_res:
    git:
      url: https://github.com/bf-tuyennv/gen_res
      ref: master_2
```

## Usage
Config resources should be generate
```yaml
# pubspec.yaml
gen_res:
  generate_R: true

  drawable:
    enabled: true

  fonts:
    enabled: true

  colors:
    enabled: true
```

After added new resources, run
```sh
dart run gen_res
```
or
```sh
dart run build_runner build --delete-conflicting-outputs
```
to update resources