# Martilla Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).


## 0.4.0
2019-11-27
- Fixes a couple of important bugs for S3 storage component ([PR](https://github.com/fdoxyz/martilla/pull/19))
  - Retention enforcement deletes other files in bucket
  - Root path in bucket wasn't working as a valid location to store backups
- Fixes a metadata formatting issue ([PR](https://github.com/fdoxyz/martilla/pull/22))

## 0.3.1
2019-11-14

- Fixes a bug that caused absolute paths sent to the CLI for the `backup` command to fail

## 0.3.0
2019-11-10

- Lots of bug fixes (by trial & error released as versions 0.2.X)
- `send_success` & `send_failure` now valid options for Notifiers ([PR](https://github.com/fdoxyz/martilla/pull/13))
- Now Storage options can configure retention of your backups for S3 & local storages ([PR](https://github.com/fdoxyz/martilla/pull/11))
- Travis CI in place for the repo ([PR](https://github.com/fdoxyz/martilla/pull/10))

## 0.2.2
2019-10-20

- Fixes CLI executable not being setup properly ([PR](https://github.com/fdoxyz/martilla/pull/6))

## 0.2.1
2019-10-20

- Adds Slack Notifier support (thanks [anoopmadhav](https://github.com/fdoxyz/martilla/pull/2))
- `pipefail` config when using the pipe operator in Mysql & Postgres database adapters ([PR](https://github.com/fdoxyz/martilla/pull/3))
