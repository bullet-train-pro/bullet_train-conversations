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

Then install `tailwindcss-stimulus-components`

```bash
yarn add tailwindcss-stimulus-components
```

And add this to the bottom of `app/javascripts/controllers/index.js`

```javascript
// Slideover is used by the conversations gem for the inbox on small screens
import { Slideover } from "tailwindcss-stimulus-components"
application.register('slideover', Slideover)
```

## Example Usage

For this example, we'll start by creating a project model:

```bash
$ rails g super_scaffold Project Team name:text_field
$ rake db:migrate
```

Once that is in place, we can add a conversation thread to the project like so:

```bash
$ rails g super_scaffold:conversations Project Team
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
