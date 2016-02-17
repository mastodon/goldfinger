Goldfinger, a Webfinger client for Ruby
=======================================

A Webfinger client for Ruby. Supports `application/xrd+xml` and `application/jrd+json` responses. Raises `Goldfinger::Error::NotFound` on failure to fetch the Webfinger or XRD data.

## Installation

    gem install goldfinger

## Usage

    data = Goldfinger.finger('acct:gargron@quitter.no')
    data.link('http://schemas.google.com/g/2010#updates-from')[:href]
    # => "https://quitter.no/api/statuses/user_timeline/7477.atom"
