--/**********************************************************************************************************************/
--/*	Apply To:		  DB2																															                                  	*/
--/*	Function:		  The following code is granting DB2 @quest_replace_user Cartridge required privileges 								*/
--/*  Usage:        Activate using: db2 connect to <dbname>; db2 -tvf <DB2_grant_Permissions_v98.sql>                   */
--/*	Date Created:	16/01/2014.																													                              	*/
--/*	Last Modified:																																	                                  */
--/**********************************************************************************************************************/
  -- grant related to purescale from version 9.8 and above
  grant execute on function SYSPROC.MON_GET_CF			                                 TO USER @quest_replace_user;
  grant execute on function SYSPROC.MON_GET_GROUP_BUFFERPOOL                             TO USER @quest_replace_user;
  grant select on SYSIBMADM.ENV_CF_SYS_RESOURCES                                   		 TO USER @quest_replace_user;
  grant select on SYSIBMADM.DB2_MEMBER                                           		 TO USER @quest_replace_user;  
 