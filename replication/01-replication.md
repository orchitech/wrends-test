## Replication testing

Replication being more advanced operation in Wren:DS did not allow me to write a simple bash script. Here is the test scenario i used described step by step.


- Set up two server instances on localhost
- For this test i used the following:
    - Server 1 - localhost, 389, port 4444
    - Server 2 - localhost, 1389, port 5444
- After configuration, start up both server instances
- Create replication
    - Here is the command i used:
    ```
    dsreplication enable -I admin -w password -X -n -b dc=example,dc=com \
        --host1 localhost --port1 4444 --bindDN1 "cn=Directory Manager" \
        --bindPassword1 password --replicationPort1 8989 \
        --host2 localhost --port2 5444 --bindDN2 "cn=Directory Manager" \
        --bindPassword2 password --replicationPort2 8997
    ```
- Initialize replication
    - Here is the command i used:
    ```
    dsreplication initialize-all -I admin -w password -X -n -b dc=example,dc=com \
        -h localhost -p 4444
    ```
- Testing the replication:
    - Stop Server 1 via *stop-ds* command
    - Import ldif data into Server 1 - I used file from *./data/replication.ldif*
    ```
    import-ldif --includeBranch dc=example,dc=com --backendId userRoot --ldifFile $EXAMPLE_PATH/wrends-test/replication/data/replication.ldif --offline

    ```
    - Start Server 1 via *start-ds* command
    - Search for the imported data on Server 2
    ```
    ldapsearch -p 1389 -h localhost -D "cn=Directory Manager" -w password -b dc=example,dc=com "(sn=Atp)" sn
    ```
    - Delete one entry from Server 2
    ```
    ldapdelete -p 1389 -h localhost -D "cn=Directory Manager" -w password \
        uid=user.0,ou=Org-0,ou=People,dc=example,dc=com
    ```
    - Search for the deleted entry on Server 1
    ```
    ldapsearch -p 1389 -h localhost -D "cn=Directory Manager" -w password -b ou=Org-0,ou=People,dc=example,dc=com "(uid=user.0)" uid
    ```
- Testing successfuly completed!