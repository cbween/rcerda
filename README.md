# CbweenEdrAgent

Welcome to the EDR Agent Tester, it's purpose is to generate vairous telemetry and enabling the testing of an edr agent.


## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bin/setup
chmod +x bin/cbween_edr_agent
```

Or run
```bash
bundle install
chmod +x bin/cbween_edr_agent
```

### Use the process agent
To get a list of commands for the process agent run:
```bash
bin/cbween_edr_agent process -h
```
  - -n NAME, name of the process to run
  - -a ARGUMENTS, arguments to pass onto the process

e.g.
```bash
bin/cbween_edr_agent process -n ls -a "-alh"
```

### Use the file agent
```bash
bin/cbween_edr_agent file -a [create|modify|delete] -n foo -p tmp -t txt
```

To get a list of commands for the file agent run:
```bash
bin/cbween_edr_agent file -h
```

  - -a ACTION, the action to preform with a file.
  - -n NAME, the name of a file
  - -p PATH, the path to a file
  - -t TYPE, the mime-type of a file

TODO: Write usage instructions here for network agent

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).
