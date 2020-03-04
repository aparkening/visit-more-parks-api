# Visit More Parks API

Visit More Parks is an app that suggests nearby U.S. National Parks to events in your Google Calendar. The app also makes it easy to add a park visit to your calendar.

This repository houses the Rails API, supplying data to the [React frontend interface](https://github.com/aparkening/visit-more-parks-frontend). 

## Installation

1. Clone this repo.
2. Install dependences:
```
    $ bundle install
```
3. Create database structure:
```
    $ rails db:create
    $ rails db:migrate
```
4. Run seed file to populate all National Park Service parks:
```
    $ rails db:seed
```
5. Run web server:
```
    $ rails s
```
5. Navigate to `localhost:3000` in your browser.

## Usage

- Add your own data via command line by using `rails c`.

- Interact via [React frontend interface](https://github.com/aparkening/visit-more-parks-frontend).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aparkening/visit-more-parks-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tea Tastes project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aparkening/visit-more-parks-api/blob/master/CODE_OF_CONDUCT.md).
