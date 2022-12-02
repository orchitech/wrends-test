## Access testing

Here is the test scenario for access testing described step by step.

- First we import ldif file on which we will be performing the anonymous search operation.
    - In this scenario i used the file from *../replication/data/replication.ldif*
    ```
    import-ldif --includeBranch dc=example,dc=com --backendId userRoot --ldifFile $PATH/wrends-test/replication/data/replication.ldif --offline
    ```
- Then we proceed with the anonymous search:
    - Command:
    ```
    ldapsearch -b dc=example,dc=com "(sn=Atp)" sn
    ```
- Remove anonymous access in following steps:
    - Command:
    ```
        dsconfig --hostname localhost --port 4444 --bindDN "cn=Directory Manager" --bindPassword <YOUR_PASSWORD> --trustAll
    ```
    - In *Wren:DS configuration console main menu* pick *1) Access Control Handler*
    - In *Access Control Handler management menu* pick *1) View and edit the Access Control Handler*
    - In *Configure the properties of the Dsee Compat Access Control Handler* pick *2) global-aci*
    - For *Configuring the "global-aci" property* pick *3) Remove one or more values*
    - Find the following value and it's number enter as choice
    ```
    (targetattr!="userPassword||authPassword||debugsearchindex||changes||changeNumber||changeType||changeTime||targetDN||newRDN||newSuperior||deleteOldRDN")(version 3.0; acl "Anonymous read access"; allow (read,search,compare) userdn="ldap:///anyone";)
    ```
    - For *Configuring the "global-aci" property (Continued)* pick *1) Use these values*
    - For *Configure the properties of the Dsee Compat Access Control Handler* pick *f) finish - apply any changes to the Dsee Compat Access Control Handler*
    - In *Access Control Handler management menu* pick *q) quit*
- Now we use the same anonymous search, which returns no value
- Finally we use non-anonymous search, that returns searched attributes
    - Command:
    ```
    ldapsearch -p 389 -h localhost -D "cn=Directory Manager" -w password -b dc=example,dc=com "(sn=Atp)" sn
    ```
- Testing successfuly completed




