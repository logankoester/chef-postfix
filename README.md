# postfix cookbook

A simple Chef recipe to configure Postfix as an SMTP relay.

## Installation

Using [Berkshelf](http://berkshelf.com/), add the nginx cookbook to your Berksfile.

```ruby
cookbook 'postfix', git: 'git@github.com:logankoester/chef-postfix.git', branch: 'master'
```

Then run `berks` to install it.

## Default

Installs and starts postfix service.

### Usage

Add `recipe[postfix::default]` to your run list.

## Attributes

Refer to `attributes/default.rb` for details.

## Author

Author:: Logan Koester (<logan@logankoester.com>)
