## Features
Auto generate resource path.

## Getting started
Add these lines into pubspec.yaml
"""
gen_res:
    git:
      url: https://github.com/bf-tuyennv/gen_res
      ref: main
"""

## Usage
Config resources should be generate
"""
gen_res:
  generate_R: true

  drawable:
    enabled: true

  fonts:
    enabled: true

  colors:
    enabled: true
"""

Run "dart run gen_res" or using build_runner "flutter pub run build_runner build --delete-conflicting-outputs" to start generate resources