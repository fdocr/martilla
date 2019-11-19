## Contributing

First off, thank you for considering contributing to Martilla.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Where do I go from here?

If you've noticed a bug or have a question [search the issue tracker](https://github.com/activeadmin/activeadmin/issues?q=) to see if someone else has already created a ticket. If not, go ahead and create a one[new
issue](https://github.com/fdoxyz/martilla/issues/new/choose)!

### Fork & create a branch

If this is something you think you can fix, then [fork Martilla](https://help.github.com/articles/fork-a-repo) and create
a branch with a descriptive name.

A good branch name would be (where issue #325 is the ticket you're working on):

```sh
git checkout -b 325-add-japanese-translations
```

### Get the test suite running

Make sure you're using a recent ruby and have the `bundler` gem installed, at
least version `2.0.2`.

Now install the development dependencies:

```sh
bundle install
```

Now you should be able to run the entire suite using:

```sh
bundle exec rspec
```

### Implement your fix or feature

At this point, you're ready to make your changes! Feel free to ask for help;
everyone is a beginner at first :)

### Get the style right

Your patch should follow the same conventions & pass the same code quality
checks as the rest of the project. No linter is set in place at the moment but we're hoping to have one in place.

### Make a Pull Request

At this point, you should switch back to your master branch and make sure it's
up to date with Martilla's master branch:

```sh
git remote add upstream git@github.com:fdoxyz/martilla.git
git checkout master
git pull upstream master
```

Then update your feature branch from your local copy of master, and push it!

```sh
git checkout 325-add-japanese-translations
git rebase master
git push --set-upstream origin 325-add-japanese-translations
```

Finally, go to GitHub and [make a Pull Request](https://help.github.com/articles/creating-a-pull-request) :D

[Travis CI](https://travis-ci.org/) will run our test suite against all supported Ruby versions. We care
about quality, so your PR won't be merged until all tests pass. It's unlikely,
but it's possible that your changes pass tests in one Ruby version but fail in
another.

### Keeping your Pull Request updated

If a maintainer asks you to "rebase" your PR, they're saying that a lot of code
has changed, and that you need to update your branch so it's easier to merge.

To learn more about rebasing in Git, there are a lot of good [git rebasing](http://git-scm.com/book/en/Git-Branching-Rebasing)
& [interactive rebase](https://help.github.com/articles/interactive-rebase) resources but here's the suggested workflow:

```sh
git checkout 325-add-japanese-translations
git pull --rebase upstream master
git push --force-with-lease 325-add-japanese-translations
```

### Merging a PR (maintainers only)

A PR can only be merged into master by a maintainer if:

* It is passing CI.
* It has no requested changes.
* It is up to date with current master.

Any maintainer is allowed to merge a PR if all of these conditions are
met.

### Shipping a release (maintainers only)

Maintainers need to do the following to push out a release:

* Make sure all pull requests are in and that [changelog](https://github.com/fdoxyz/martilla/blob/master/CHANGELOG.md) is current
* Update `version.rb` file and changelog with new version number
* If it's not a patch level release, create a stable branch for that release,
  otherwise switch to the stable branch corresponding to the patch release you
  want to ship:

  ```sh
  bundle install
  git add .
  git commit -m "v[X.Y.Z] release"
  git push origin master
  rake release
  ```
