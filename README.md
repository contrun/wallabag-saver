<!-- ABOUT THE PROJECT -->
## About The Project

This package grow from my own need to continuously move saved articles from pocket to wallabag.
There are a few wallabag command line utilites to save url to wallabag,
e.g. [Nepochal/wallabag-cli](https://github.com/Nepochal/wallabag-cli),
[artur-shaik/wallabag-client](https://github.com/artur-shaik/wallabag-client),
[gmolveau/pocket_to_wallabag](https://github.com/gmolveau/pocket_to_wallabag),
[wsteitz/wallabag2pocket](https://github.com/wsteitz/wallabag2pocket).
I tried most of them. Those are not suitable for my usage. Because, they have the following undesirable things
* the need for human interaction (have to manually open browser)
* not itempotent (running the script a second time will adding the same article)
* too slow when there are too many articles (sequentially running)
I decide to build a client with async rust.


### Built With

* [wallabag-api](https://crates.io/crates/wallabag-api)
* [async-std](https://crates.io/crates/async-std)


<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

You need the [rust toolchain](https://rustup.rs/) or [nix](https://nixos.org/download.html#download-nix) to build this project.

### Installation

You can download the binaries from [Releases](https://github.com/contrun/wallabag-saver/releases).
Or build it manually with cargo `cargo install --git https://github.com/contrun/wallabag-saver`
or with nix `nix profile install github:contrun/wallabag-saver`.

<!-- USAGE -->
## Usage
This program expects the following environment variables to be set correctly.

```
export WALLABAG_URL=https://wallabag.example.com
export WALLABAG_CLIENT_ID=1_31vhkox6b02skcksg8xxx
export WALLABAG_CLIENT_SECRET=5zmsrnjpu1wk4s8gkyyy
export WALLABAG_USERNAME=user
export WALLABAG_PASSWORD=password
```

After that, run `wallabag-saver -a -- https://archived.article.url/slug` to save
articles to the archived entries. Run `wallabag-saver --help` for more usage instructions.

<!-- ROADMAP -->
## Roadmap

- [x] Parallel saving
- [x] Idempotent saving
- [x] Deleting articles
- [ ] Saving articles from stdin
- [ ] Caching wallabag articles locally for incremental saving
