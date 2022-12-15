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

# Test Environment

Scripts in this repo are using environment variables loaded from `.env` file.
The following variables are being used:

* `WRENDS_HOME` - home directory of uninitialized Wren:DS instalation that is being tested
* `WRENDS_TEST` - directory for test files and utilities for Wren:DS
