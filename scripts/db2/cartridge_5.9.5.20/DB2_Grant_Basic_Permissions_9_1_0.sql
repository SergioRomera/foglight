--/****************************************************************************************************************************************************/
--/*	Apply To:		DB2																																*/
--/*	Function:		The following code is granting DB2 @quest_replace_user Cartridge required privileges to a giving user 								*/
--/*    Usage:          replace @quest_replace_user with the name of the user.
--/*                    activate using: db2 connect to <dbname>; db2 -tvf <DB2_grant_Permissions_allversions.sql>
--/*	Date Created:	16/01/2014.																														*/
--/*	Last Modified:																																	*/
--/****************************************************************************************************************************************************/
-- grant general permissions
grant execute on function SYSPROC.DB_PARTITIONS                                      TO USER @quest_replace_user;
grant execute on procedure SYSPROC.ADMIN_CMD                                         TO USER @quest_replace_user;
grant execute on function SYSPROC.ENV_GET_PROD_INFO                                  TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_APPL(VARCHAR(128),INTEGER)                TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_APPL_INFO (VARCHAR(128),INTEGER)          TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_BP (VARCHAR(128),INTEGER)                 TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_BP_PART(VARCHAR(128),INTEGER)             TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_DBM(INTEGER)                              TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_DBM()                                     TO USER @quest_replace_user;
grant execute on SPECIFIC function SYSPROC.SNAP_GET_DBM                              TO USER @quest_replace_user;      
grant execute on function SYSPROC.PD_GET_DIAG_HIST                                   TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_DBM_MEMORY_POOL(INTEGER)                  TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_DB_MEMORY_POOL(VARCHAR(128),INTEGER)      TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_FCM  (INTEGER)                            TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_FCM_PART  (INTEGER)                       TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_HADR (VARCHAR(128),INTEGER)               TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_LOCKWAIT (VARCHAR(128),INTEGER)           TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_STMT (VARCHAR(128),INTEGER)               TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_STORAGE_PATHS (VARCHAR(128),INTEGER)      TO USER @quest_replace_user;
grant execute on function SYSPROC.SNAP_GET_SWITCHES  (INTEGER)                       TO USER @quest_replace_user;
grant execute on function SYSPROC.ENV_GET_SYS_INFO 									                 TO USER @quest_replace_user;
grant select on SYSIBMADM.DBCFG 													                           TO USER @quest_replace_user;
grant select on SYSIBMADM.DBMCFG													                           TO USER @quest_replace_user;
grant select on SYSIBMADM.SNAPDBM                                                    TO USER @quest_replace_user; 
grant select on SYSIBMADM.ENV_INST_INFO												                       TO USER @quest_replace_user;
grant select on SYSIBMADM.DB_HISTORY												                         TO USER @quest_replace_user;
grant select on SYSIBMADM.BP_HITRATIO												                         TO USER @quest_replace_user;
grant select on SYSIBMADM.ENV_PROD_INFO												                       TO USER @quest_replace_user;
grant select on SYSIBMADM.SNAPFCM                                                    TO USER @quest_replace_user;  
grant select on SYSCAT.VIEWS                                                         TO USER @quest_replace_user;  
grant select on SYSCAT.ROUTINES                                                      TO USER @quest_replace_user;  
grant select on SYSIBMADM.PRIVILEGES	                                              TO USER @quest_replace_user; 



  
