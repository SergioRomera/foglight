/****************************************************************************************************************************************************/
/*																										*/
/*	Function:		The following code is automatically granting appropriate privileges to a given user (NT\SQL authenticated), thus, enabling		*/
/*					Foglight for SQL Server to monitor instance analysis. The sysadmin server role is required for granting the access and running	*/
/*					this script.																													*/
/*					There are 1 parameters to use:																									*/
/*					1. The Login name to use.																								 		*/
/*	Date Created:	10/02/2010.																														*/
/****************************************************************************************************************************************************/
use master;
Declare	@LoginName				NVARCHAR(256) ,
		@DBName					NVARCHAR(256) ,
		@SQLStatement			NVARCHAR(4000);

Select	@LoginName = ?			--	Please type the login name to be used for logging-in to SQL Server by the cartridge.

If ( REPLACE ( CONVERT ( VARCHAR(2) , ServerProperty ( 'ProductVersion' ) ) , '.' , '' ) < 9 )
Begin
		--	Adding the sysadmin permissions

		If Not Exists (	Select	*
						From	[master].dbo.spt_values As spv, [master].dbo.sysxlogins As lgn
						Where	spv.name = 'sysadmin'
						And		lgn.[name] = @LoginName
						And		spv.low = 0
						And		spv.[type] = 'SRV'
						And		lgn.srvid Is Null
						And		spv.number & lgn.xstatus = spv.number )
		Begin
				Execute	[master].dbo.sp_addsrvrolemember	@LoginName , N'sysadmin';
		End
End
Else
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

				--	Granting EXECUTE Permissions on master
				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN [master].sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN [master].sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN [master].sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'xp_enumerrorlogs'
								And		C.[type] = 'EX'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[master]
												GRANT EXECUTE ON [master].dbo.xp_enumerrorlogs TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN [master].sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN [master].sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN [master].sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'xp_readerrorlog'
								And		C.[type] = 'EX'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[master]
												GRANT EXECUTE ON [master].dbo.xp_readerrorlog TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

         --	Granting EXECUTE Permissions on msdb

          If Not Exists (	Select	*
                  From	[master].sys.server_principals As A INNER JOIN msdb.sys.database_principals As B
                      ON		A.[sid] = B.[sid]
                      INNER JOIN msdb.sys.database_permissions As C
                      ON		B.[principal_id] = C.[grantee_principal_id]
                      INNER JOIN msdb.sys.all_objects As D
                      ON		C.[major_id] = D.[object_id]
                  Where	A.[name] = @LoginName
                  And		D.[name] = N'agent_datetime'
                  And		C.[type] = 'EX'
                  And		C.[state] In ( 'G' , 'W' ) )
          Begin
              Select	@SQLStatement = N'USE	[msdb]
                          GRANT EXECUTE ON msdb.dbo.agent_datetime TO [' + @LoginName + N'];';

              Execute	( @SQLStatement );
          End

				--	Granting SELECT Permissions on msdb

				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN msdb.sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN msdb.sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN msdb.sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'log_shipping_monitor_primary'
								And		C.[type] = 'SL'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.log_shipping_monitor_primary TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN msdb.sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN msdb.sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN msdb.sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'log_shipping_monitor_secondary'
								And		C.[type] = 'SL'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.log_shipping_monitor_secondary TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN msdb.sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN msdb.sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN msdb.sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'log_shipping_primaries'
								And		C.[type] = 'SL'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.log_shipping_primaries TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN msdb.sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN msdb.sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN msdb.sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'log_shipping_secondaries'
								And		C.[type] = 'SL'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.log_shipping_secondaries TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN msdb.sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN msdb.sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN msdb.sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'log_shipping_primary_secondaries'
								And		C.[type] = 'SL'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.log_shipping_primary_secondaries TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End
				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN msdb.sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN msdb.sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN msdb.sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'sysalerts'
								And		C.[type] = 'SL'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.sysalerts TO [' + @LoginName + N'];';
						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN msdb.sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN msdb.sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN msdb.sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'syscategories'
								And		C.[type] = 'SL'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.syscategories TO [' + @LoginName + N'];';

						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN msdb.sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN msdb.sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN msdb.sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'sysjobactivity'
								And		C.[type] = 'SL'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.sysjobactivity TO [' + @LoginName + N'];';

						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN msdb.sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN msdb.sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN msdb.sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'sysjobs'
								And		C.[type] = 'SL'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.sysjobs TO [' + @LoginName + N'];';

						--print @SQLStatement;
						Execute	( @SQLStatement );
				End

				If Not Exists (	Select	*
								From	[master].sys.server_principals As A INNER JOIN msdb.sys.database_principals As B
										ON		A.[sid] = B.[sid]
										INNER JOIN msdb.sys.database_permissions As C
										ON		B.[principal_id] = C.[grantee_principal_id]
										INNER JOIN msdb.sys.all_objects As D
										ON		C.[major_id] = D.[object_id]
								Where	A.[name] = @LoginName
								And		D.[name] = N'sysjobhistory'
								And		C.[type] = 'SL'
								And		C.[state] In ( 'G' , 'W' ) )
				Begin
						Select	@SQLStatement = N'USE	[msdb]
												GRANT SELECT ON msdb.dbo.sysjobhistory TO [' + @LoginName + N'];';

						--print @SQLStatement;
						Execute	( @SQLStatement );
				End



				--	Adding the db_datareader permissions

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
																		INNER JOIN sys.database_role_members As C
																		ON		B.principal_id = C.member_principal_id
																		INNER JOIN sys.database_principals As D
																		ON		C.role_principal_id = D.principal_id
																Where	A.[name] = N''' + @LoginName + N'''
																And		D.[name] = N''db_datareader'' )
												Begin
														Execute	sp_addrolemember N''db_datareader'' , N''' + @LoginName + N''';
												End';

						--print @SQLStatement;
						Execute	( @SQLStatement );
				End


				--	Adding the replmonitor permissions on all distribution databases
				Select	@DBName = N'';
				While (	Exists (	Select	name
									From	[master].sys.databases
									Where	[name] > @DBName
									And		is_distributor = 1
									and has_dbaccess(name) = 1))
				Begin

						Select	@DBName = MIN ( [name] )
						From	[master].sys.databases
						Where	[name] > @DBName
						And		is_distributor = 1
						And		has_dbaccess(name) = 1;

						Select	@SQLStatement = N'USE	[' + @DBName + N']
												Begin
														Execute	sp_addrolemember N''replmonitor'' , N''' + @LoginName + N''';
											End';
						--print @SQLStatement;
						Execute	( @SQLStatement );

				End

				--	Adding the db_ddladmin permissions

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
																		INNER JOIN sys.database_role_members As C
																		ON		B.principal_id = C.member_principal_id
																		INNER JOIN sys.database_principals As D
																		ON		C.role_principal_id = D.principal_id
																Where	A.[name] = N''' + @LoginName + N'''
																And		D.[name] = N''db_ddladmin'' )
												Begin
														Execute	sp_addrolemember N''db_ddladmin'' , N''' + @LoginName + N''';
												End';
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
		End
End
