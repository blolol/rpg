### Blolol RPG

Blolol's own roleplaying game for lazy people!

### How to run the game locally

In order to run Blolol RPG on your local machine, you'll need some software installed:

* Ruby >= 2.3.0
* PostgreSQL >= 9.4
* Redis >= 3.0

Install Ruby gem dependencies using [Bundler](http://bundler.io).

```
$ gem install bundler
$ bundle install
```

Create the PostgreSQL database and load the schema.

```
$ bin/rails db:create
$ psql -l # Check for "blolol_rpg_development"
$ bin/rails db:schema:load
```

Configure required environment variables in `.env`. [Foreman](https://github.com/ddollar/foreman) reads this file when the server boots.

```
$ cp .env.example .env
```

There are several optional environment variables you can use to tweak gameplay:

| Variable | Description | Default |
|----------|-------------|---------|
| `BASE_XP_PER_TICK` | XP earned by active characters every game tick. | 4 |
| `BATTLE_PROBABILITY` | The probability, from 0.0 to 1.0, that a random battle will occur on any given game tick. | 0.016 |
| `FIND_ITEM_PROBABILITY` | The probability, per game tick, that some active character will find an item. | 0.016 |
| `PREMIUM_XP_RATE_MODIFIER` | The rate of bonus XP earned by Blolol Premium subscribers' active characters every game tick. | 0.25 |
| `SECONDS_BETWEEN_TICKS` | The number of seconds between game ticks. | 60 |

Start the game loop, background workers, IRC bot and web server using Foreman.

```
$ gem install foreman
$ foreman start
```

### License (MIT)

Copyright (c) 2016 Blolol

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
