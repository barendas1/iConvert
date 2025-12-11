--Overwrites Current Database

Declare @Index Int
Declare @MaxIndex Int
Declare @DatabaseName Nvarchar (300)
Declare @NewLine Nvarchar (10)
Declare @SQL Nvarchar (Max)

Declare @DatabaseNameInfo Table (AutoID Int Identity (1, 1), DatabaseName Nvarchar (300))

Insert into @DatabaseNameInfo (DatabaseName)
Select Ltrim(Rtrim(DatabaseInfo.DatabaseName))
From 
(
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
	Union All
	Select '' As DatabaseName
) As DatabaseInfo
Inner Join Sys.databases As CurDatabase
On	LTrim(RTrim(DatabaseInfo.DatabaseName)) = CurDatabase.name And
	CurDatabase.state_desc = 'Online'
Where LTrim(RTrim(Isnull(DatabaseInfo.DatabaseName, ''))) <> ''
Group By LTrim(RTrim(DatabaseInfo.DatabaseName))
Order By LTrim(RTrim(DatabaseInfo.DatabaseName))

Set @MaxIndex = 0

If Exists (Select * From @DatabaseNameInfo)
Begin
    Set @MaxIndex = (Select Max(AutoID) From @DatabaseNameInfo)
End

Set @Index = 1

While (@Index <= @MaxIndex)
Begin
	Set @DatabaseName = (Select DatabaseInfo.DatabaseName From @DatabaseNameInfo As DatabaseInfo Where DatabaseInfo.AutoID = @Index) 

	Set @NewLine = Char(13) + Char(10)

	Set @SQL =
		'Backup Database [' + @DatabaseName + '] ' + @NewLine +
		'To  Disk = ''E:\Backup_RJ\' + @DatabaseName + '.bak'' ' + @NewLine +
		'With Noformat, Init, Name = N''' + @DatabaseName + '-Full Database Backup'', ' + @NewLine +
		'Skip, Norewind, Nounload, Compression, Stats = 10 ' + @NewLine

	Print ''	
	Print @SQL	
	Print ''

	Exec (@SQL)
	
	Set @Index = @Index + 1
End
