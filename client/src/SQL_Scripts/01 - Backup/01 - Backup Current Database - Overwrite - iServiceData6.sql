--Overwrites Current Database

Declare @DatabaseName Nvarchar (300)
Declare @NewLine Nvarchar (10)
Declare @SQL Nvarchar (Max)

Set @DatabaseName = Db_name()

Set @NewLine = Char(13) + Char(10)

Set @SQL =
	'Backup Database [' + @DatabaseName + '] ' + @NewLine +
	'To  Disk = ''E:\Backup_RJ\' + @DatabaseName + '_' + Format(GetDate(), 'yyyyMMdd_HHmmss') + '.bak'' ' + @NewLine +
	'With Noformat, Init, Name = N''' + @DatabaseName + '-Full Database Backup'', ' + @NewLine +
	'Skip, Norewind, Nounload, Compression, Stats = 10 ' + @NewLine

Print ''	
Print @SQL	
Print ''

Exec (@SQL)
