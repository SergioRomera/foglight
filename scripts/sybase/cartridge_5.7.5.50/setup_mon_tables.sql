--
--

-- the following can be run to set the Mon table parameters
-- that influence the mon tables from which Sybase_MDA collects
-- data.
--
-- Numeric buffer sizes.  Must be greater than zero
--

-- not dynamic
sp_configure 'max SQL text monitored',2048  
go

sp_configure 'sql text pipe max messages',5000
go

sp_configure 'statement pipe max messages',10000
go
sp_configure 'errorlog pipe max messages',1000
go
-- Flags
sp_configure 'enable monitoring', 1
go
sp_configure 'errorlog pipe active',1
go
sp_configure 'per object statistics active',1
go
sp_configure 'statement statistics active',1
go
sp_configure 'statement pipe active',1
go
sp_configure 'sql text pipe active',1
go
sp_configure 'wait event timing',1
go
sp_configure 'process wait events',1
go
sp_configure 'SQL batch capture',1
go
--------  New in 5.5.8 Version ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
sp_configure 'object lockwait timing' , 1 -- for table space collection
go
--- For Top Hash 
sp_configure "enable stmt cache monitoring" , 1
go
sp_configure 'statement cache size'
---  example:    sp_configure 'statement cache size', 0, '50M'
go
sp_configure 'enable literal autoparam' , 1
go
-- Done

