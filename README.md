# Property Evaluator

My first flutter project, is about rating the property

Currently only develop for IOS

## Install
Connect iphone and then
`flutter run --release`

## logo generation 
put image under `assets/icon.png` then run
`flutter pub run flutter_launcher_icons`
or specify the path
`flutter pub run flutter_launcher_icons -f <your config file name here>`
## Features to add
- Sorting logic, and secondary sort
- Real estate link to property
- Support different currency
- Polish info message and warning message
- export json and share it
- Animation:
  - Bottom sheet appearing
  - Removing item
  - Radio button on the home page annotation

## Refactoring & Tech debt
- Better way to manage state
- Add tests to the entire project
- Refactor using closure to avoid arguments used multiple time
- Linting
- Fix Theming using flex_color_scheme

## Run linting
`dart fix --dry-run`
`dart fix --apply`

