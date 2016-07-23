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
