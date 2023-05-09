# Wren:DS System Test Resources

Resources for performing Wren:DS system tests.

## Test Categories

* access - ACI configuration and enforcement
* audit - Tracking sensitive operations and generating audit logs
* authentication - LDAP authentication
* backup - Back up and restore functionality
* basic - Basic server operation (starting, stopping, status, ...)
* CLI - Command line tools
* documentation - Generated documentation
* LDAP - LDAP operation, including custom controls (VLV, sort, ...)
* LDIF - LDIF processing
* monitoring - Server monitoring
* package - Distribution packages
* ppolicy - Password policy
* plugin - Plugin operation
* replication - Server replication
* limits - _TODO resource limits_
* REST - REST API feature
* schema - Schema management and enforcement


## Running Tests

Tests can be run manually by executing shell scripts in alphabetical order in their
respective test category folder.

Use `run.sh` shell script to run the whole test suite:

```console
$ ./run.sh
```

Tests are based on docker image of Wren:DS named `wrends`. This image name can be overriden
with `WRENDS_IMAGE` environment variable:

```console
$ WRENDS_IMAGE=wrends-local ./run.sh
```

Failed tests can be resumed from a specific category with `RESUME_FROM` environment variable
(be sure to cleanup leftover docker containers before resuming):

```console
$ RESUME_FROM=replication ./run.sh
```
