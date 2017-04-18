# HasPrerequisite

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/has_prerequisite`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'has_prerequisite'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_prerequisite

## Usage

This gem adds features to your Rails controllers. 

First, in your `ApplicationController` or any controller or method that you want to protect, use `perform_checks` method.

```Ruby
class ApplicationController < ActionController::Base

before_filter :perform_checks # This will execute on every method of your controller

def index
  preform_checks # you can call it directly here, especially if you need an instance variable instanciated for a prerequisite
end
```

Once you made sure the checks will be performed on the parts of your application you want to protect, define your prerequisites where you want to protect. The `redirection_path` is where you want your user to be redirected to fulfill the prerequisite. Current location will be stored for future redirection, when the prerequisite is fulfilled.

``` Ruby
class ProfilesController < ApplicationController
  has_prerequisite :accepted_terms_and_conditions, redirection_path :terms_and_conditions_path
  
  private
  
  def accepted_terms_and_conditions
    current_user.accepted_terms_and_conditions_at.present?
  end
end
```

If the path to fulfill the prerequisite is protected by `has_prerequisite` and `perform_checks` (if you're using them in the `ApplicationController` for instance), you can mark it as `fulfilling_prerequisite`

``` Ruby
class TermsAndConditionsController < ApplicationController
  fulfilling_prerequisite
end
```

Once action was taken by the user and can now access the page they wanted to see at the first place, you can use `step_fulfilled!` to redirect them back to it

``` Ruby
 class TermsAndConditionsController < ApplicationController
    fulfilling_prerequisite

    def edit; end

    def update
      if current_user.update(accepted_terms_and_conditions_at: Datetime.now)
        step_fulfilled!
      else
        render :edit
      end
    end
  end
```

### Options

You can use a conditionnal to the prerequisite

``` Ruby
prerequisite :valid_subscription, redirection_path: :new_subscription_path, if: :should_be_charged?
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sophiedeziel/has_prerequisite. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

