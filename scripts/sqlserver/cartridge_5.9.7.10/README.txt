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
- The "MSSQLPermissionsGrant.sql" script is used for granting the correlated permissions that monitoring the SQL Server instance.
- The "RDSPermissionsGrant.sql" script is used for granting the correlated permissions that monitoring the SQL Server instance on AWS RDS.
- The "AzurePermissionsGrant.sql" script is used for granting the correlated permissions that monitoring the SQL Server instance on Azure.


Requirements
---------------
A DB User who obtain the "sysadmin" server role.


Grant Permissions
---------------

1. Login the SQL Server instance with the "sysadmin" role DB user.

2. For general SQL Server, open the "MSSQLPermissionsGrant.sql" with the doc editor, then located the keywords : "@LoginName = ?" & "@GrantSSISPermissions".
   For SQL Server on AWS RDS, open the "RDSPermissionsGrant.sql" with the doc editor, then located the keywords : "@LoginName = ?".
   For SQL Server on Azure, open the "AzurePermissionsGrant.sql" with the doc editor, then located the keywords : "@LoginName = ?".

3. Fill in the actual value regarding the introduction in below "Configuration parameters".

4. After fill in the keyword parameters, execute the modified SQL script in Microsoft SQL Server Management Studio (or another way that could execute the sql statement).

   
Configuration parameters
================
 The Configuration parameters are used for fill in the specified "LoginName" & "GrantSSISPermissions" variables in the "MSSQLPermissionsGrant.sql"
 in order to let the "sysadmin" user to grant the correlated permissions to the specified DB user for the SQL Server instance monitoring make sense.
   
 @LoginName 
   - the login name to be used for logging-in to SQL Server by the cartridge.
 
 @GrantSSISPermissions
   - The input value for @GrantSSISPermissions should be 1 or 0.
      1 : need grant SSIS permissions to the user.
      0 : no need to grant SSIS permissions to the user.