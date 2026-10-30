# honeyconf.sh

System configuration management, as simple as can be.

honeyconf.sh is a tool enabling remote machine configuration as code as simply as possible.
It is based on simple principles and requires very little dependencies.

**[Read the full documentation](https://bee-software.github.io/honeyconf.sh/)**: configuration reference, examples, recipes and exit codes.

## Design goals
- Easy to modify
- Simple mapping to regular shell commands

## Requirements

honeyconf.sh requires [yq](https://github.com/mikefarah/yq) (ideally version 4+) and [jq](https://github.com/stedolan/jq) during "compilation" for `machines.yaml` parsing.

Running tests requires [bats-core](https://github.com/bats-core/bats-core/).

## Usage

Compiling for a specific machine:

    ./compile.sh machines.yaml machine.example.com
        
Deploying:

    ./deploy.sh machines.yaml machine.example.com

See the [documentation](https://bee-software.github.io/honeyconf.sh/) for all commands and configuration options.
