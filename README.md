# Robin [![Build Status](https://travis-ci.org/fivegoodfriends/robin.svg?branch=master)](https://travis-ci.org/fivegoodfriends/robin)

A Slack bot that assigns tasks round-robin.

![](https://cloud.githubusercontent.com/assets/19860/24195853/16c57b46-0f47-11e7-833a-d2167680a467.png)

You could use Robin to:

* Assign someone to update a library when a new release happens.
* Assign someone to do an ad-hoc task.
* Assign someone to review a pull request.
* Determine who is going first in standup today.

Robin works by:

* Exposing a webhook for creating tasks.
* Tasks are created against lists. Each time a task is created it gets assigned
  round-robin to users on that list.
* The assigned user can accept, reassign, or archive the task.
* There can be many lists. Each list has a name, users, and posts messages to a
  channel.

We recommend using [Zapier](https://zapier.com) as an intermediary for services
which don't expose webhooks as first class citizens.

## HTTP API

Create a new task via the webhook:

    $ curl -X POST \
           -d 'description=You should do this thing!' \
           'https://example.com/lists/:webhook_token/tasks'

## Developers

### System Dependencies

* Ruby 2.5.1
* Postgres 9.6
* [direnv](http://direnv.net/) _(optional, recommended)_

### Configuration

See .envrc.example for the expected environment variables. The example values
have been used for testing.

### Development

    $ bin/setup
    $ bin/rails server -p 3000

### Testing

    $ bin/rspec

## Copyright

Copyright (c) 2017-18 Five.Good.Friends. Pty Ltd. All rights reserved. Licensed under the MIT license.
