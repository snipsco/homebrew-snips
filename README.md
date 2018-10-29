# Snips Homebrew Tap

A centralized repository for [Snips][]-related brews.

## Installation

Run the following in your command-line:

```sh
brew tap snipsco/homebrew-snips
```

## Contributing 

Please file bug reports and feature requests on [Snips Official Forum][], not this repository - however, we do accept pull requests here.

To do development on these formulae, first fork the repository on GitHub. Add your fork as a remote to your local clone:

```sh
cd $(brew --prefix)/Library/Taps/snipsco/homebrew-snips
git remote add me git@github.com:YOUR_GITHUB_USERNAME/homebrew-snips.git
git fetch me
```

To propose changes, push to your fork (e.g. with `git push me +master`) and
submit pull request on GitHub.

We follow Homebrew's [standard coding style][].

## Troubleshooting

**IMPORTANT** First read the [Troubleshooting Checklist][].

Use `brew gist-logs <formula>` to create a [Gist][] and post the link in your issue.

Search [open][] and [closed][] issues. See also Homebrew's [Common Issues][] and [FAQ][].

## Documentation
`brew help`, `man brew` or check [Homebrew's documentation][].

[Snips]: https://snips.ai
[Snips Official Forum]: https://forum.snips.ai
[Homebrew]: http://brew.sh
[Troubleshooting Checklist]: https://docs.brew.sh/Troubleshooting.html
[Gist]: https://gist.github.com
[open]: https://github.com/Homebrew/homebrew-science/issues?state=open
[closed]: https://github.com/Homebrew/homebrew-science/issues?state=closed
[standard coding style]: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
[Common Issues]: https://docs.brew.sh/Common-Issues.html
[FAQ]: https://docs.brew.sh/FAQ.html
[Homebrew's documentation]: https://github.com/Homebrew/brew/blob/master/docs/README.md
