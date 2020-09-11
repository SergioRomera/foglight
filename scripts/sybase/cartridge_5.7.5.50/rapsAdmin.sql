use master
go
print "Creating procedure sp_fgl_addgrant 1 in master"
go
if exists (select 1
	from master..sysobjects
		where sysstat & 7 = 4
			and name = 'sp_fgl_addgrant')
begin
	print "Dropping procedure sp_fgl_addgrant 1 in master"
	drop procedure sp_fgl_addgrant
end
go
create procedure sp_fgl_addgrant  
	@fogUser varchar(120)
as
declare @textmsg varchar(255)
            select @textmsg = "grant select on  syslisteners to " + @fogUser  
            exec(@textmsg) 	 
			
go
print "Finished creating procedure sp_fgl_addgrant 1 in master"
go

use sybsystemprocs
go
print "Creating procedure sp_fgl_addgrant 2 in sybsystemprocs"
go
if exists (select 1
	from sybsystemprocs..sysobjects
		where sysstat & 7 = 4
			and name = 'sp_fgl_addgrant')
begin
	print "Dropping procedure sp_fgl_addgrant 2 in sybsystemprocs"
	drop procedure sp_fgl_addgrant
end
go
create procedure sp_fgl_addgrant  
	@fogUser varchar(120)
as
declare @textmsg varchar(255)
            select @textmsg = "grant create procedure to " + @fogUser  
            exec(@textmsg) 	 
          
go
print "Finished creating procedure sp_fgl_addgrant 2 in sybsystemprocs"
go

print "Creating procedure sp_fgl_adduser"
go
if exists (select 1
	from sybsystemprocs..sysobjects
		where sysstat & 7 = 4
			and name = 'sp_fgl_adduser')
begin
	print "Dropping procedure sp_fgl_adduser"
	drop procedure sp_fgl_adduser
end
go
if exists (select 1 from tempdb..sysobjects where name = "foguserCreate"   ) 
begin
        drop table tempdb..foguserCreate
end
go
if exists (select 1 from tempdb..sysobjects where name = "foguserdbNames"   ) 
begin
        drop table tempdb..foguserdbNames
end
go
create procedure sp_fgl_adduser  
	@fogUser varchar(120) , @fogGroup varchar(120)
as 
-- exec  sp_fgl_adduser 'fog' , 'foglightGroup'
 set nocount on
declare @dbName	varchar(120), 
        @textmsg varchar(1024),
        @groupExists tinyint,	 
        @userExists tinyint
		
if exists (select 1 from tempdb..sysobjects where name = "foguserCreate"   ) 
begin
        drop table tempdb..foguserCreate
end
select 1 as ugExists into tempdb..foguserCreate 

if exists (select 1 from tempdb..sysobjects where name = "foguserdbNames"   ) 
begin
        drop table tempdb..foguserdbNames
end

select name into tempdb..foguserdbNames from master..sysdatabases where 1 = 2

if( charindex("Cluster Edition" ,@@version  ) = 0 ) 
	begin
	exec ( "insert tempdb..foguserdbNames select name 
	from master..sysdatabases 
    where  status & 256 != 256 and status & 1024 != 1024 and status & 4096 != 4096
	  and  status2 & 16 != 16  and status2 & 32 != 32    and status2 & 64 != 64 
	  and status3 & 128 != 128 and status & 32 != 32" )
	end
if( charindex("Cluster Edition" ,@@version  ) != 0 ) 
	begin
	exec("insert  tempdb..foguserdbNames select name 
	from master..sysdatabases 
    where  status & 256 != 256 and status & 1024 != 1024 and status & 4096 != 4096
	  and  status2 & 16 != 16  and status2 & 32 != 32    and status2 & 64 != 64 
	  and status3 & 128 != 128 and status & 32 != 32
	  and instanceid is null or instanceid = @@instanceid ")
	end

declare DBs_cursor cursor for 
	select name 
	from tempdb..foguserdbNames
open DBs_cursor 
 
fetch DBs_cursor into @dbName 

while (@@sqlstatus = 0) 
 
 
begin 
	truncate table tempdb..foguserCreate 
        select @textmsg = "insert tempdb..foguserCreate  select  count(*) from "+ @dbName + "..sysusers where name = '"+  @fogUser + "'"

        exec(@textmsg) 	 
				if(@@error != 0) begin 
					print "Continue After Error"
					raiserror 99999  "Continue After Error"
					fetch DBs_cursor into @dbName
					continue 
					end

	select @userExists = ugExists from tempdb..foguserCreate  

        if ( @userExists = 0 ) 
		begin
			truncate table tempdb..foguserCreate 
			select @textmsg = "insert tempdb..foguserCreate  select  count(*) from "+ @dbName + "..sysusers where name = '"+  @fogGroup + "'"
			exec(@textmsg) 	 
				if(@@error != 0) print "Error"
			select @groupExists = ugExists from tempdb..foguserCreate  
		--- add group if not exists
			if ( @groupExists = 0 ) 
				begin
				select @textmsg = @dbName + "..sp_addgroup " + @fogGroup 
				exec(@textmsg) 	 
				if(@@error != 0) print "Error"
				end
		--- add user 
            select @textmsg = @dbName + "..sp_adduser " + @fogUser + "," + @fogUser + " , '"+ @fogGroup  +"' " 
            exec(@textmsg) 	 
				if(@@error != 0) print "Error"
			if(@dbName = 'sybsystemprocs') 
			begin
				exec sybsystemprocs..sp_fgl_addgrant @fogUser

			end
		end
        fetch DBs_cursor into @dbName 
end 
 
close DBs_cursor 
 
deallocate cursor DBs_cursor 
--   grant to syslistener in order to use islocal proc
				exec master..sp_fgl_addgrant @fogUser
-- clean temporary table
if exists (select 1 from tempdb..sysobjects where name = "foguserCreate"   ) 
begin
	drop table tempdb..foguserCreate 
end
if exists (select 1 from tempdb..sysobjects where name = "foguserdbNames"   ) 
begin
        drop table tempdb..foguserdbNames
end
go
if exists (select 1 from tempdb..sysobjects where name = "foguserdbNames"   ) 
begin
        drop table tempdb..foguserdbNames
end
go
print "Finished creating procedure sp_fgl_adduser"
go

