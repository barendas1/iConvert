--Use this if needed.
/*
If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
Begin
	If Object_ID(N'[Data_Import_RJ].[dbo].[TestImport0000_MixInfo]') Is Not Null
	Begin
		Drop Table [Data_Import_RJ].[dbo].[TestImport0000_MixInfo]
	End
End
Go
*/
