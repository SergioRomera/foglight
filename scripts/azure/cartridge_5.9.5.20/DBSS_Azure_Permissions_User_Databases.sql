/****************************************************************************************************************************************************/
/*    Apply To:       SQL Azure DB.                                                                                                                 */
/*    Function:       The following code is automatically granting appropriate privileges to a given user, thus giving the                          */
/*                    SQL Server Foglight Cartridge product the ability to monitor instance analysis. The permissions for                           */
/*                    granting the access and running this script should be of the sysadmin server role. There is one                               */
/*                    parameter to use:                                                                                                             */
/*                    1. The Login name to be checked / granted.                                                                                    */
/*                                                                                                                                                  */
/*    Return values:  1. Error code                                                                                                                 */
/*                                  1 - permission granted / exists                                                                                 */
/*                                  0 - permission not granted - error                                                                              */
/*                    2. Reason                                                                                                                     */
/*                                  Error description (valid when Error code is 0)                                                                  */
/****************************************************************************************************************************************************/
SET nocount ON;
SET TRANSACTION isolation level READ uncommitted;
  
DECLARE @LoginName      NVARCHAR(256),
        @SQLStatement   NVARCHAR(1024),
        @ErrorMessage   NVARCHAR(4000),
        @FullPermission BIT,
        @PermissionGap  INT;
  
SELECT @LoginName = ?; --    Please type the login name to which you would like the cartridge to work with. 
SELECT @FullPermission = 1;
SELECT @ErrorMessage = N'';
  
IF ( NOT EXISTS (SELECT *
                 FROM   sys.database_principals AS DP1
                        INNER JOIN sys.database_role_members AS DRM
                                ON DP1.principal_id = DRM.member_principal_id
                        INNER JOIN sys.database_principals AS DP2
                                ON DRM.role_principal_id = DP2.principal_id
                 WHERE  DP1.NAME = @LoginName
                    AND DP2.NAME = 'db_owner') )
	BEGIN
  /****************************************************************************************************************************************************/
  /* Checking general permissions                                                                                                                     */
  /****************************************************************************************************************************************************/  
		WITH permissions2check (securable_class, permission_name)
           AS (SELECT 'DATABASE', 'VIEW DATABASE STATE'
           ),
           missingpermissions
           AS (SELECT *
               FROM   permissions2check P2C
               WHERE  NOT EXISTS (SELECT p.class_desc,
                                         p.permission_name
                                  FROM   sys.database_permissions AS p
                                         JOIN sys.database_principals AS r
                                           ON p.grantee_principal_id =
                                              r.principal_id
                                  WHERE  r.NAME = @LoginName
                                         AND class_desc = P2C.securable_class
                                         AND permission_name = P2C.permission_name))
		SELECT @PermissionGap = Count(*)
		FROM   missingpermissions;
   
		IF @PermissionGap > 0
			SET @FullPermission = 0;
   
		--  Granting the VIEW DATABASE STATE permission
		IF @FullPermission = 0
			BEGIN
				IF NOT EXISTS (SELECT *
                        FROM   sys.database_principals AS A
								INNER JOIN sys.database_permissions AS B
                                          ON A.principal_id = B.grantee_principal_id
                        WHERE  B.permission_name = N'VIEW DATABASE STATE'
                              AND [name] = @LoginName)
				BEGIN
					SELECT @SQLStatement = N'GRANT VIEW DATABASE STATE TO ['
                                        + @LoginName + ']';
					BEGIN try
						EXECUTE ( @SQLStatement );
							SET @FullPermission = 1;
					END try
						
				BEGIN catch
					SELECT @FullPermission = 0;
					SELECT @ErrorMessage = isnull(@ErrorMessage,'') + 'Failed granting VIEW DATABASE STATE: ' +
                                            'Error at line ' + cast(ERROR_LINE() as varchar) + ' - ' + ERROR_MESSAGE();
				END catch
			END

            --    Adding the db_datareader permissions 
			IF NOT EXISTS (SELECT *
					FROM   sys.database_principals AS B
							INNER JOIN sys.database_role_members AS C
											ON B.principal_id = C.member_principal_id
							INNER JOIN sys.database_principals AS D
											ON C.role_principal_id = D.principal_id
							WHERE  B.[name] = @LoginName
									AND D.[name] = N'db_datareader')
			BEGIN
				BEGIN try
					EXECUTE Sp_addrolemember
						N'db_datareader',
                        @LoginName;
						SET @FullPermission = 1;
				END try
                BEGIN catch
					SELECT @FullPermission = 0;
					SELECT @ErrorMessage = isnull(@ErrorMessage,'') + CASE WHEN @ErrorMessage IS NULL THEN '' ELSE ', ' END + 'Failed granting db_datareader: ' + 
                                               'Error at line ' + cast(ERROR_LINE() as varchar) + ' - ' + ERROR_MESSAGE();
				END catch
			END
		END
	END
	
--1 = permit 
--0 = No Permit 
SELECT @FullPermission AS permit, @ErrorMessage As ErrorMessage