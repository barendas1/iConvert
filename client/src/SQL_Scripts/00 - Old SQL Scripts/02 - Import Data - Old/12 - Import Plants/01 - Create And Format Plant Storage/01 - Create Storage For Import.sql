If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
Begin
	--Drop Table [Data_Import_RJ].[dbo].[TestImport0000_XML_PlantInfo]
	If Object_ID(N'[Data_Import_RJ].[dbo].[TestImport0000_XML_PlantInfo]') Is Null
	Begin
		Create Table [Data_Import_RJ].[dbo].[TestImport0000_XML_PlantInfo]
		(
			[AutoID] Int Identity (1, 1),
			[Name] Nvarchar (100),
			[Description] Nvarchar (300)
		) On [PRIMARY]
	End
End
Go
