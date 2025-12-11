/*
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
	If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
	Begin
		Drop Table Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo
	End
End
Go
*/

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo
		Create table Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo
		(
			AutoID Bigint Identity (1, 1),
			PlantName Nvarchar (100),
			TradeName Nvarchar (200),
			MaterialDate Nvarchar (30),
			FamilyMaterialTypeName Nvarchar (100),
			MaterialTypeName Nvarchar (100),
			SpecificGravity Float,
			IsLiquidAdmix Nvarchar (100),
			MoisturePct Float,
			Cost Float,
			CostUnitName Nvarchar (30),
			ManufacturerName Nvarchar (100),
			ManufacturerSourceName Nvarchar (100),
			BatchingOrderNumber Nvarchar (100),
			ItemCode Nvarchar (100),
			ItemDescription Nvarchar (300),
			ItemShortDescription Nvarchar (100),
			ItemCategoryName Nvarchar (100),
			ItemCategoryDescription Nvarchar (300),
			ItemCategoryShortDescription Nvarchar (100),
			ComponentCategoryName Nvarchar (100),
			ComponentCategoryDescription Nvarchar (300),
			ComponentCategoryShortDescription Nvarchar (100),
			BatchPanelCode Nvarchar (100),
			UpdatedFromDatabase Bit Default (0)
		)
    End    
End
Go
