# Overview of test files

This folder contains test files for ldiff operations that can be found in Wren:DS.

## Testing

All the test files can be executed directly from this folder.
Execute them in the numerical order as the name of the file suggests.

## Test files and their description

* 01-importldif.sh - This script first generates ldif data based on a template then it stops the server instance if it is running and finally it imports the generated ldif data.
* 02-exportldif.sh - This script first stops the server instance if it is running and it exportes previously imported ldif data into generated.ldif file.
* 03-searchldif.sh - This script searches for a specific user by given attribute.
* 04-modifyldif.sh - This script first shows the changes that are about to be made then modifies the 
  generated.ldif file and transferes the changed data into the new.ldif file
