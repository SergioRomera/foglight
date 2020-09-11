--/****************************************************************************************************************************************************/
--/*	Apply To:		DB2																																*/
--/*	Function:		The following code is granting DB2 @quest_replace_user Cartridge required privileges 						*/
--/*    Usage:          replace @quest_replace_user with the name of the user
--/*                    activate using: db2 connect to <dbname>; db2 -tvf <DB2_grant_Permissions_v10.sql>
--/*	Date Created:	16/01/2014.																														*/
--/*	Last Modified:																																	*/
--/****************************************************************************************************************************************************/
-- grant version 10.5 specific permissions
   grant execute on function SYSPROC.PD_GET_DIAG_HIST                                  TO USER @quest_replace_user;
   grant execute on function SYSPROC.SNAP_GET_DB (VARCHAR(255),INTEGER)                TO USER @quest_replace_user; 
   grant execute on function SYSPROC.SNAP_GET_TAB(VARCHAR(128),INTEGER)                TO USER @quest_replace_user;
   grant execute on function SYSPROC.SNAP_GET_TBSP (VARCHAR(255),INTEGER)              TO USER @quest_replace_user;
   grant execute on function SYSPROC.SNAP_GET_TBSP_PART(VARCHAR(255),INTEGER)          TO USER @quest_replace_user;
   grant execute on function SYSPROC.SNAP_GET_TBSP_PART_V97(VARCHAR(128),INTEGER)      TO USER @quest_replace_user;
   grant execute on function SYSPROC.ENV_GET_REG_VARIABLES							            	 TO USER @quest_replace_user;   
   grant execute on function SYSPROC.DB2_GET_INSTANCE_INFO							            	 TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_GET_SERVICE_SUBCLASS		                       TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_GET_PKG_CACHE_STMT                            TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_GET_SERVICE_SUBCLASS_DETAILS                  TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_FORMAT_XML_TIMES_BY_ROW						      		 TO USER @quest_replace_user;
   grant execute on function SYSPROC.AUTH_LIST_AUTHORITIES_FOR_AUTHID(VARCHAR(128),VARCHAR(1) )		 TO USER @quest_replace_user;
   grant select on SYSIBMADM.MON_LOCKWAITS	                                                       TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_FORMAT_LOCK_NAME(VARCHAR(32) )		                         TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_GET_DATABASE(INTEGER )		                         TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_GET_INSTANCE(INTEGER )		                         TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_GET_TRANSACTION_LOG(INTEGER )		                 TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_GET_CONNECTION(BIGINT,INTEGER,SMALLINT)           TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_GET_UNIT_OF_WORK(BIGINT,INTEGER,SMALLINT)         TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_GET_AGENT(VARCHAR(128),VARCHAR(128), BIGINT,INTEGER) TO USER @quest_replace_user;
   grant execute on function SYSPROC.ADMIN_GET_STORAGE_PATHS(VARCHAR(128),INTEGER)            TO USER @quest_replace_user; 
   grant execute on function SYSPROC.MON_GET_WORKLOAD(VARCHAR(128), INTEGER )		              TO USER @quest_replace_user;   
   grant execute on function SYSPROC.MON_GET_BUFFERPOOL(VARCHAR(128), INTEGER )		            TO USER @quest_replace_user; 
   grant execute on function SYSPROC.MON_GET_FCM_CONNECTION_LIST( INTEGER )		                TO USER @quest_replace_user; 
   grant execute on function SYSPROC.MON_GET_TABLESPACE(VARCHAR(128), INTEGER )		            TO USER @quest_replace_user; 
   grant execute on function SYSPROC.MON_GET_TABLE(VARCHAR(128),VARCHAR(128), INTEGER )	      TO USER @quest_replace_user; 
   grant execute on function SYSPROC.ENV_GET_DB2_SYSTEM_RESOURCES                             TO USER @quest_replace_user; 
   grant execute on function SYSPROC.MON_GET_CONTAINER(VARCHAR(128),INTEGER )	                TO USER @quest_replace_user; 
   grant execute on function SYSPROC.ENV_GET_SYSTEM_RESOURCES                                 TO USER @quest_replace_user;     
   grant execute on function SYSPROC.ENV_GET_DB2_SYSTEM_RESOURCES( INTEGER )	                TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_GET_MEMORY_POOL(VARCHAR(32),VARCHAR(128), INTEGER)	TO USER @quest_replace_user;
   grant execute on function SYSPROC.MON_GET_MEMORY_SET(VARCHAR(32),VARCHAR(128), INTEGER)    TO USER @quest_replace_user;