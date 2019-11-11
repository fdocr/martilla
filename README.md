# Martilla

Martilla is a tool to automate your backups. With simple but flexible configuration options you can have a database backup configured to run (using cron jobs or similar). Receive a notification whenever a backup fails, choose multiple ways of getting notified (i.e. email + slack).

The name Martilla comes from a local name for the [Kinkajou](https://en.wikipedia.org/wiki/Kinkajou). This nocturnal animal goes fairly unnoticed, just like we hope database backups should remain.

## Table of Contents

1. [Installation](https://github.com/fdoxyz/martilla#installation)
2. [Usage](https://github.com/fdoxyz/martilla#usage)
   * [Databases](https://github.com/fdoxyz/martilla#databases)
   * [Storages](https://github.com/fdoxyz/martilla#storages)
   * [Notifiers](https://github.com/fdoxyz/martilla#notifiers)
   * [Perform a backup](https://github.com/fdoxyz/martilla#perform-a-backup)
3. [Contributing](https://github.com/fdoxyz/martilla#contributing)
4. [Development](https://github.com/fdoxyz/martilla#development)
5. [License](https://github.com/fdoxyz/martilla#license)
6. [Code of Conduct](https://github.com/fdoxyz/martilla#code-of-conduct)

## Installation

To use as a CLI tool

    $ gem install martilla

Or add this line to your application's Gemfile:

```ruby
gem 'martilla'
```

## Usage

Martilla uses a YAML configuration file that specifies the backup to be performed. The gem works by making three main concepts work together, they're listed out with details that should generally be specified in the config file:

 - **Database**
   - What database are we going to backup
   - How can we connect to the database
 - **Storage**
   - Where is this backup going to be stored
   - Credentials needed to persist the backup
 - **Notifiers**
   - How will you get notified of the backup result
   - Can be a list of multiple ways to get notified

Execute `martilla setup backup-config.yml` and you'll have your first (default) config file that looks like the following:

```yaml
---
db:
  type: postgres
  options:
    host: localhost
    user: username
    password: password
    db: databasename
storage:
  type: local
  options:
    filename: database-backup.sql
notifiers:
- type: none
```

From here on you pick the building blocks that work for your specific case:

### Databases

Currently available DB types to choose from are **postgres** & **mysql**. They both have the same available options:
 - `host`
   - defaults to localhost
   - can be set in ENV variable `PG_HOST` or `MYSQL_HOST`
 - `user`
   - required
   - can be set in ENV variable `PG_USER` or `MYSQL_USER`
 - `password`
   - required
   - can be set in ENV variable `PG_PASSWORD` or `MYSQL_PASSWORD`
 - `db`
   - required
   - can be set in ENV variable `PG_DATABASE` or `MYSQL_DATABASE`
 - `port`
   - defaults to 5432 or 3306
   - can be set in ENV variable `PG_USER` or `MYSQL_USER`

### Storages

The available Storages types are **local**, **S3** & **SCP**. They each have different available options:
 - options for type: **local**
   - `filename`
     - The location to where the backup will be stored
   - `retention`
     - An integer that defines the max number of backups stored at the defined location
 - options for type: **s3**
   - `filename`
     - The location to where the backup will be stored within the S3 bucket
   - `bucket`
   - `region`
   - `access_key_id`
     - can be specified with the usual ENV variables or IAM roles
   - `secret_access_key`
     - can be specified with the usual ENV variables or IAM roles
   - `retention`
     - An integer that defines the max number of backups stored at the defined location
 - options for type: **scp**
   - `filename`
     - The location to where the backup will be stored within remote server
   - `host`
   - `user`
   - `identity_file`
   - `retention`
     - Not implemented for this storage ([see #12](https://github.com/fdoxyz/martilla/issues/12))

All storage types also accept 'suffix' as a boolean that enables or disables a timestamp to be added as a suffix to the backup 'filename', it defaults as `true`.

### Notifiers

The available Notifiers are **ses**, **sendmail** & **smtp**. They each have different available options:
  - options for type: **ses** (email notifier)
    - `aws_region`
    - `access_key_id`
      - can be specified with the usual ENV variables or IAM role
    - `secret_access_key`
      - can be specified with the usual ENV variables or IAM roles
  - options for type: **sendmail** (email notifier)
    - no custom options
  - options for type: **smtp** (email notifier)
    - `address`
    - `domain`
    - `user_name`
    - `password`
  - options for type: **slack**
    - `slack_webhook_url`
      - required
      - more info [here](https://api.slack.com/messaging/webhooks)
    - `slack_channel`
      - defaults to `#general`
      - the channel to post the backup notifications
    - `slack_username`
      - defaults to `Martilla`
      - the username which backup notifications will be posted with

All of the previous **email notifiers** also have the following options that can be customized:
  - `to`
    - a list of comma separated emails to be notified
  - `from`
    - defaults to 'martilla@no-reply.com'
  - `success_subject`
    - the subject of the success email
  - `failure_subject`
    - the subject of the failure email

Also **ALL** notifiers have the following two options
  - `send_success`
    - `Boolean` value that will disable notifications on success when set to false. Defaults to `true`
  - `send_failure`
    - `Boolean` value that will disable notifications on failure when set to false. Defaults to `true`

It's **HIGHLY RECOMMENDED** to test and make sure emails are being delivered correctly to each target inbox. Emails with standard messages like these automated backup notifications tend to be easily marked as spam.

### Perform a backup

As simple as running the `backup` command on the martilla CLI and passing as argument the configuration file you want to use

    $ martilla backup backup-config.yml

Help the help command help you

    $ martilla help
    
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fdoxyz/martilla. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Martilla project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fdoxyz/martilla/blob/master/CODE_OF_CONDUCT.md).
