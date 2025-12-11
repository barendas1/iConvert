If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
Begin
	If Object_ID(N'[Data_Import_RJ].[dbo].[TestImport0000_XML_PlantInfo]') Is Not Null
	Begin
		Update PlantInfo
			Set PlantInfo.Name = Ltrim(Rtrim(Replace(PlantInfo.Name, Char(160), ' '))),
				PlantInfo.[Description] = Ltrim(Rtrim(Replace(PlantInfo.[Description], Char(160), ' ')))
		From Data_Import_RJ.dbo.TestImport0000_XML_PlantInfo As PlantInfo
	End
End
Go
