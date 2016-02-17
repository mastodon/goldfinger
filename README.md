Goldfinger, a Webfinger client for Ruby
=======================================

[![Gem Version](http://img.shields.io/gem/v/goldfinger.svg)][gem]

[gem]: https://rubygems.org/gems/goldfinger

A Webfinger client for Ruby. Supports `application/xrd+xml` and `application/jrd+json` responses. Raises `Goldfinger::Error::NotFound` on failure to fetch the Webfinger or XRD data.

## Installation

    gem install goldfinger

## Usage

    data = Goldfinger.finger('acct:gargron@quitter.no')
    data.link('http://schemas.google.com/g/2010#updates-from')[:href]
    # => "https://quitter.no/api/statuses/user_timeline/7477.atom"

## RFC support

The gem only parses link data. It does not currently parse aliases, properties, or more complex structures.
