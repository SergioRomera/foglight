/****************************************************************************************************************************************************/
/*	Function:		The following code is automatically granting appropriate privileges to a given user (NT\SQL authenticated), thus, enabling		*/
/*					Foglight for SQL Server to monitor instance analysis. The sysadmin server role is required for granting the access and running	*/
/*					this script.																													*/
/*					There is an input parameter: Login name																				 		*/
/*						   																	    */
/*	Date Created:	10/02/2010.																														*/
/****************************************************************************************************************************************************/
use master;
Declare	@LoginName				NVARCHAR(256) ,
		@DBName					NVARCHAR(256) ,
		@SQLStatement			NVARCHAR(4000);

Select	@LoginName = ?		--	Please type the login name to be used for logging-in to SQL Server by the cartridge.
	
Begin
		If Not Exists	(	Select	*
							From	sys.server_principals As A INNER JOIN sys.server_role_members As B
									ON		A.principal_id = B.member_principal_id
									INNER JOIN sys.server_principals As C
									ON		B.role_principal_id = C.principal_id
							Where	A.[name] = @LoginName
							And		C.[name] = N'sysadmin' )
		Begin
				--	Granting Server permissions
				use master;
				If Not Exists (	Select	*
								From	sys.server_principals As A INNER JOIN sys.server_permissions As B
										ON		A.principal_id = B.grantee_principal_id
								Where	A.[type] In ( 'S' , 'U' , 'G' , 'C' , 'K' )
								And		A.[name] = @LoginName
								And		B.permission_name = N'VIEW ANY DEFINITION'
								And		B.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'GRANT VIEW ANY DEFINITION TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (	Select	*
								From	sys.server_principals As A INNER JOIN sys.server_permissions As B
										ON		A.principal_id = B.grantee_principal_id
								Where	A.[type] In ( 'S' , 'U' , 'G' , 'C' , 'K' )
								And		A.[name] = @LoginName
								And		B.permission_name = N'VIEW SERVER STATE'
								And		B.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'GRANT VIEW SERVER STATE TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				--	Creating the user in each DB

				Select	@DBName = N'';

				While Exists (	Select	*
								From	[master].sys.databases
								Where	[name] > @DBName
								And		HAS_DBACCESS ( [name] ) = 1
								And		[state] = 0
								And		is_read_only = 0 )
				Begin
						Select	@DBName = MIN ( [name] )
						From	[master].sys.databases
						Where	[name] > @DBName
						And		HAS_DBACCESS ( [name] ) = 1
						And		[state] = 0
						And		is_read_only = 0;

						Select	@SQLStatement = N'USE	[' + @DBName + N']
												  If Not Exists (	Select	*
																	From	[master].sys.server_principals As A INNER JOIN sys.database_principals As B
																			ON		A.[sid] = B.[sid]
																	Where	A.[name] = N''' + @LoginName + N''' )
												  Begin try
														CREATE USER [' + @LoginName + N'];
												  End try
												  begin catch
												  end catch';

												  --print @SQLStatement;

						Execute	( @SQLStatement );
				End
				
				--	Granting trace permissions

				If Not Exists (	Select	*
								From	sys.server_principals As A INNER JOIN sys.server_permissions As B
										ON		A.principal_id = B.grantee_principal_id
								Where	A.[type] In ( 'S' , 'U' , 'G' , 'C' , 'K' )
								And		A.[name] = @LoginName
								And		B.permission_name = N'ALTER TRACE'
								And		B.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'use master;GRANT ALTER TRACE TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End
			
				-- Granting permissions for monitoring jobs
				
				If Not Exists (SELECT * FROM msdb.sys.database_permissions p
				JOIN msdb.sys.objects o
				on p.major_id=o.object_id
				JOIN msdb.sys.sysusers s
				on p.grantee_principal_id=s.uid 
                Where o.name ='sysjobhistory' and s.name=@LoginName)
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.sysjobhistory TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (SELECT * FROM msdb.sys.database_permissions p
				JOIN msdb.sys.objects o
				on p.major_id=o.object_id
				JOIN msdb.sys.sysusers s
				on p.grantee_principal_id=s.uid 
                Where o.name='sysjobs' and s.name=@LoginName)
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.sysjobs TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (SELECT * FROM msdb.sys.database_permissions p
				JOIN msdb.sys.objects o
				on p.major_id=o.object_id
				JOIN msdb.sys.sysusers s
				on p.grantee_principal_id=s.uid 
                Where o.name='sysjobactivity' and s.name=@LoginName)
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.sysjobactivity TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End
				
				If Not Exists (SELECT r.name
                FROM master.sys.server_principals l
                JOIN msdb.sys.database_principals u
                ON u.sid = l.sid
                JOIN msdb.sys.database_role_members rm
                ON rm.member_principal_id = u.principal_id
                JOIN msdb.sys.database_principals r
                ON r.principal_id = rm.role_principal_id
                WHERE l.name = @LoginName
                AND r.name='SQLAgentUserRole')
				Begin
				Select	@SQLStatement = N'USE[msdb]
												Begin
														Execute	sp_addrolemember N''SQLAgentUserRole'' , N''' + @LoginName + N''';
											End';
				--print @SQLStatement;
				Execute	( @SQLStatement );
				End 

		
		End
End
		