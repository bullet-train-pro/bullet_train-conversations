# Bullet Train Conversations

## Installation

Add the following to your `Gemfile`:

```ruby
source "https://YOUR_LICENSE_KEY@gem.fury.io/bullettrain" do
  gem "bullet_train-conversations"
end
```

Add this to your `config/environment.rb` right after `Rails.application.initialize!`:
```ruby
require 'bullet_train/conversations'
```

And run the following on your shell:

```bash
$ bundle install
$ rake bt:link
$ rake bullet_train:conversations:install
$ rake db:migrate
$ rails restart
```

## Example Usage

For this example, we'll start by creating a project model:

```bash
$ rails g model Project team:references name:string
$ bin/super-scaffold crud Project Team name:text_field
```

Once that is in place, we can add a conversation thread to the project like so:

```bash
$ bin/super-scaffold conversations Project Team
$ rake db:migrate
```

Also, because of the way CableReady reflects on certain relationships, you'll need to restart your Rails server as well:

```bash
$ rails restart
```

Now you should be good to add a new project on your team and then drill down on it to have a conversation!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
