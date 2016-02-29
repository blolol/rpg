### Blolol RPG

Blolol's own roleplaying game for lazy people!

### How to run the game locally

In order to run Blolol RPG on your local machine, you'll need some software installed:

* Ruby >= 2.3.0
* PostgreSQL >= 9.4

1. Install Ruby gem dependencies using [Bundler](http://bundler.io).

   ```
   $ gem install bundler
   $ cd ~/Projects/blolol-rpg
   $ bundle install
   ```

2. Configure required environment variables in `.env`. [Foreman](https://github.com/ddollar/foreman) reads this file when the application server boots.

   ```
   $ cp .env.example .env
   ```

3. Create the PostgreSQL database.

   ```
   $ bin/rails db:create
   $ psql -l # Check for "blolol_rpg_development"
   ```

4. Start the web server and IRC bot using Foreman.

   ```
   $ gem install foreman
   $ foreman start
   ```
