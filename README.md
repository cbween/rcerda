# EdrAgentTester

Welcome to the EDR Agent Tester, it's purpose is to generate vairous telemetry and enabling the testing of an edr agent.


## Installation

**Requires ruby >= 3.1.0**

Checkout the gem, then install it locally like: 

```bash
gem build edr_agent_tester.gemspec
gem install ./edr_agent_tester-0.1.0.gem
bundle install

edr_agent_tester -h
```

To uninstall the gem run
```bash
gem uninstall edr_agent_tester
```

## Using the different Agent Testers

The EDR Tester has various testing "agents" in /lib/edr_agent_tester/agents/ than can be used to generate logs. Current testing agents are `file`, `process`, and `http`. 

### Using the Process Agent

The Process Agent will call out to an external process and execute a passed command.

To get a list of command options for the process agent run:
```bash
$ edr_agent_tester process -h
Usage: edr_agent_tester process [OPTIONS]    
    -n, --name=NAME                  The name of a process to run
    -a, --args=ARGS                  The arguments to pass on to the process
```

The script can then be used to run a process e.g.
```bash
edr_agent_tester process -n ls -a "-alh"
edr_agent_tester process -n ping -a "-c 3 google.com"
```
If your arguments contain no spaces.
```bash
edr_agent_tester process -n ls -a -alh
```

### Using the File Agent

The file agent will attempt to create a file of a given mine-type at the asked for path on the local machine. If a path is not passed, the file will be written to a temporary directory.

To get a list of command options for the file agent run:
```bash
$ edr_agent_tester file -h                             
Usage: edr_agent_tester file [OPTIONS]
    -a, --action=ACTION              The action to take on a file.
    -n, --name=NAME                  The name of a existing or new file.
    -p, --path=PATH                  The path of a existing or new file.
    -t, --type=TYPE                  The type of a new file to create. e.g. [txt|csv|jpg]
```

You may use the script with various actions on files like the line below to create the /tmp/foo.txt file
```bash
edr_agent_tester file -a [create|modify|delete] -n foo -p /tmp -t txt
```

### Use the Http Agent

```bash
$ edr_agent_tester http -h
Usage: edr_agent_tester http [OPTIONS]
    -m, --method=METHOD              The method to take on a file.
    -d, --domain=DOMAIN              The domain/host to preform the http method on.
    -p, --port=PORT                  The port to make a request to.
    -s, --subpath=SUBPATH            The path of a request.
```

You may use the script to set GET requests via HTTP to various domains. e.g.
```bash
edr_agent_tester http -m get -d https://google.com -p 443 -s "?search=foobar"
```

# Testing linux with Docker

Build a container with the gem installed with docker:
```bash
docker build -t erdtestagent .    
```

exec into the docker container's shell like:
```bash
docker run -ti erdtestagent "/bin/bash"
```

Try out some commands:
```bash
edr_agent_tester process -n ls -a "-alh"
```

View the log
```bash
less output.log
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
