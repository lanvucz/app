
    The code should pass the Linter validation with default 
    rubocop settings (https://github.com/rubocop-hq/rubocop)

    There should be a simple test using Rspec that will succeed o
    n the code with testing/mocked data

Put the code to a public repository on GitHub (https://github.com/) 
and provide us with a link to it.

Install gem

    bundle install

Run script

    jruby -S run.rb

Robocop - Linter validation
    
    rubocop

Rspec - unit testing
    
    rspec test/export_breeds_spec.rb