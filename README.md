# Robin

A Slack bot that assigns tasks round-robin.

* There can be many lists. Each list posts to one channel.
* There can be many users. Users are assigned to one or many lists.
* Tasks are created against lists and assigned round robin to users on that
  list.
* The assigned user can accept, reassign, or archive the task.

## HTTP API

**Note** Only `POST /lists/:id/tasks` is supported at this stage.

Create the first list:

    $ curl -X POST \
           -d 'name=outofdate&slack_channel_id=C1' \
           'https://example.com/lists'

Then add a user:

    $ curl -X POST \
           -d 'slack_name=tatey&slack_id=U1' \
           'https://example.com/users'

Then add the user to the list:

    $ curl -X POST \
           -d 'slack_id=U1' \
           'https://example.com/lists/1/users'

Then create a new task via the webhook:

    $ curl -X POST \
           -d 'description=You should do this thing!' \
           'https://example.com/lists/1/tasks'

## Developers

### System Dependencies

* Ruby 2.4.0
* Postgres 9.5
* [direnv](http://direnv.net/) _(optional, recommended)_

### Configuration

See .envrc.example for the expected environment variables.

### Development

    $ bin/setup
    $ bin/rails server -p 3000

### Testing

    $ bin/rspec
