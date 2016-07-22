# Coursemology Code Evaluator [![Build Status](https://travis-ci.org/Coursemology/evaluator-slave.svg?branch=master)](https://travis-ci.org/Coursemology/evaluator-slave)
[![Code Climate](https://codeclimate.com/github/Coursemology/evaluator-slave/badges/gpa.svg)](https://codeclimate.com/github/Coursemology/evaluator-slave) [![Coverage Status](https://coveralls.io/repos/Coursemology/evaluator-slave/badge.svg?branch=master&service=github)](https://coveralls.io/github/Coursemology/evaluator-slave?branch=master) [![Security](https://hakiri.io/github/Coursemology/evaluator-slave/master.svg)](https://hakiri.io/github/Coursemology/evaluator-slave/master) [![Inline docs](http://inch-ci.org/github/coursemology/evaluator-slave.svg?branch=master)](http://inch-ci.org/github/coursemology/evaluator-slave) [![Gem Version](https://badge.fury.io/rb/coursemology-evaluator.svg)](https://badge.fury.io/rb/coursemology-evaluator)

This is the evaluator program which will query Coursemology for pending evaluation jobs.

## Setting up the Evaluator Slave

### System Requirements

1. Ruby (>= 2.1.0)
2. Linux (tested on Ubuntu 14.04)
3. Docker (the user the evaluator runs as must be able to talk to the Docker Remote API endpoint)

### Getting Started

1. Install the gem

   ```sh
   $ gem install coursemology-evaluator
   ```

2. Modify `.env` to suit your environment. Point to the host to your Coursemology instance, and 
   specify the API email and API key.

   1. You might need to configure a new user on your Coursemology instance, enable token 
      authentication, and grant the `auto_grader` system/instance permission.

3. Start the evaluator using the Procfile. You can use [foreman](https://github.com/ddollar/foreman)
   or any similar tool to generate system scripts for boot.

### Command Line Options

#### Compulsory Options

1. `--host`: Coursemology host to connect to
2. `--api-user-email`: User with autograder flag set
3. `--api-token`: Authentication token of the user

#### Optional Options

Time options are expected to be strings in [ISO8601 format](https://en.wikipedia.org/wiki/ISO_8601#Durations).

1. `--interval`: Time interval between checks for programming allocations. As this time is
  expected to be short, specify it with the time components of ISO8601 only. (Hours, minutes, seconds)
  The time designator `T` must be left out.

2. `--lifetime`: Length of time to cache Docker images. This is expected to be in the order of days.
  If more granularity is needed, the time designator is required.

  E.g. `1DT2H5M10S`

3. `--one-shot`: Runs once and terminates. Primarily used for testing.
