====
    This software is confidential. Quest Software Inc., or one of its subsidiaries, has supplied this software to you
    under terms of a license agreement, nondisclosure agreement or both.

    You may not copy, disclose, or use this software except in accordance with those terms.

    Copyright 2017 Quest Software Inc. ALL RIGHTS RESERVED.

    QUEST SOFTWARE INC. MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF THE SOFTWARE, EITHER EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
    OR NON-INFRINGEMENT. QUEST SOFTWARE SHALL NOT BE LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING,
    MODIFYING OR DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES.
====

Scripts Description
---------------
The "DB2_Grant_Basic_Permissions_9_1_0.sql" & "DB2_Grant_Permissions_x.sql" are used for granting the correlated permissions that monitoring the DB2 instance.


Requirements 
---------------
Required DB2 LUW User Account Privileges
  - Foglight monitoring agents use DB2 LUW user accounts to access the monitored DB2 instances. Before adding monitored instances, ensure that the user accounts have at least the following privilege and permission set:

    - SYSMON authority (enables monitoring)

    - AUTH_LIST_AUTHORITIES_FOR_AUTHID permission (enables the wizard to verify and set permissions)

    - Select permission on SYSIBMADM.PRIVILEGES, SYSCAT.VIEWS and SYSCAT.ROUTINES (verify the correlated permission)
When you add monitored instances, the Monitor DB2 Instance wizard checks that other required permissions exist and, if not, executes a script to grant any missing permissions. For a list of the required permissions granted by this script, see Permissions .


Grant Permissions
---------------

1. Check the instance privilege groups
   - db2 get dbm cfg | grep GROUP
   E.G : SYSMON group name                        (SYSMON_GROUP) = TESTG
   
2. Add the current login user that prepare to used for monitor the target DB2 instance into the user group that obtain the "SYSMON" authority.
   E.G : For example, now the group name should be : TESTG
   
   - Once there is not any group that obtains the "SYSMON" authority, should execute the command : db2 UPDATE DBM CFG USING SYSMON_GROUP $groupName, in order to obtains the "SYSMON" authority.
   
3. Connect to the target Database, edit the "DB2_Grant_Basic_Permissions_9_1_0.sql" with keywords replacement.

   - Replace all the "@quest_replace_user" keywords in the script with the login user name.
   
4. Execute the modified "DB2_Grant_Basic_Permissions_9_1_0.sql" script firstly.
   
   - Notify the output "The SQL command completed successfully.", it means that the specified permission is grant successfully, the all permissions grant successful logs would output in the console.
   
5. After all the basic permission grant successfully, edit "DB2_Grant_Permissions_x.sql" with keywords replacement.

   - Replace all the "@quest_replace_user" keywords in the script with the login user name.
   - Regarding to the specified DB2 instance version which is being monitored, pay attention to execute the specified "DB2_Grant_Permissions_x.sql".
     - "DB2_Grant_Permissions_10_5_0.sql" is the most highest version in the cartridge which used for grant the permissions for the DB2 instance version higher than 10.5.

6. Execute the modified	"DB2_Grant_Permissions_x.sql" script secondly.
   - Notify the output "The SQL command completed successfully.", it means that the specified permission is grant successfully, the all permissions grant successful logs would output in the console.