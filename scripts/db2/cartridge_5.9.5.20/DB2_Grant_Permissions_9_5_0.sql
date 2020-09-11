--/********************************************************************************************************/
--/*	Apply To:		  DB2																																                    */
--/*	Function:		  The following code is granting DB2 @quest_replace_user Cartridge required privileges 	*/
--/*  Usage:        Activate using: db2 connect to <dbname>; db2 -tvf <DB2_grant_Permissions_v95.sql>     */
--/*	Date Created:	16/01/2014.																														                */
--/*	Last Modified:																																	                    */
--/********************************************************************************************************/
-- grant version 9.5 specific permissions
  grant execute on function SYSPROC.SNAP_GET_DB_V91(VARCHAR(128),INTEGER)              TO USER @quest_replace_user;
  grant select on SYSIBMADM.REG_VARIABLES	                                             TO USER @quest_replace_user;
  grant execute on function SYSPROC.SNAP_GET_TAB_V91  (VARCHAR(128),INTEGER)           TO USER @quest_replace_user;
  grant execute on function SYSPROC.SNAP_GET_TBSP_V91 (VARCHAR(128),INTEGER)               TO USER @quest_replace_user;
  grant execute on function SYSPROC.SNAP_GET_TBSP_PART_V91 (VARCHAR(128),INTEGER)      TO USER @quest_replace_user;
  grant execute on function SYSPROC.SNAP_GET_DYN_SQL_V91(VARCHAR(128),INTEGER) 		 TO USER @quest_replace_user;
  grant execute on function SYSPROC.AUTH_LIST_AUTHORITIES_FOR_AUTHID(VARCHAR(128),VARCHAR(1) )		 TO USER @quest_replace_user;
  grant execute on function SYSPROC.SNAP_GET_CONTAINER_V91(VARCHAR(128),INTEGER) 		 TO USER @quest_replace_user;


  

  