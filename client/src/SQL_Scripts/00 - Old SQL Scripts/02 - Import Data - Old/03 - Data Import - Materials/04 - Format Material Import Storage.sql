If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.PlantName = LTrim(RTrim(Replace(MaterialInfo.PlantName, Char(160), ' '))),
				MaterialInfo.TradeName = LTrim(RTrim(Replace(MaterialInfo.TradeName, Char(160), ' '))),
				MaterialInfo.MaterialDate = LTrim(RTrim(Replace(MaterialInfo.MaterialDate, Char(160), ' '))),
				MaterialInfo.FamilyMaterialTypeName = LTrim(RTrim(Replace(MaterialInfo.FamilyMaterialTypeName, Char(160), ' '))),
				MaterialInfo.MaterialTypeName = LTrim(RTrim(Replace(MaterialInfo.MaterialTypeName, Char(160), ' '))),
				MaterialInfo.IsLiquidAdmix = LTrim(RTrim(Replace(MaterialInfo.IsLiquidAdmix, Char(160), ' '))),
				MaterialInfo.CostUnitName = LTrim(RTrim(Replace(MaterialInfo.CostUnitName, Char(160), ' '))),
				MaterialInfo.ManufacturerName = LTrim(RTrim(Replace(MaterialInfo.ManufacturerName, Char(160), ' '))),
				MaterialInfo.ManufacturerSourceName = LTrim(RTrim(Replace(MaterialInfo.ManufacturerSourceName, Char(160), ' '))),
				MaterialInfo.BatchingOrderNumber = LTrim(RTrim(Replace(MaterialInfo.BatchingOrderNumber, Char(160), ' '))),
				MaterialInfo.ItemCode = LTrim(RTrim(Replace(MaterialInfo.ItemCode, Char(160), ' '))),
				MaterialInfo.ItemDescription = LTrim(RTrim(Replace(MaterialInfo.ItemDescription, Char(160), ' '))),
				MaterialInfo.ItemShortDescription = LTrim(RTrim(Replace(MaterialInfo.ItemShortDescription, Char(160), ' '))),
				MaterialInfo.ItemCategoryName = LTrim(RTrim(Replace(MaterialInfo.ItemCategoryName, Char(160), ' '))),
				MaterialInfo.ItemCategoryDescription = LTrim(RTrim(Replace(MaterialInfo.ItemCategoryDescription, Char(160), ' '))),
				MaterialInfo.ItemCategoryShortDescription = LTrim(RTrim(Replace(MaterialInfo.ItemCategoryShortDescription, Char(160), ' '))),
				MaterialInfo.ComponentCategoryName = LTrim(RTrim(Replace(MaterialInfo.ComponentCategoryName, Char(160), ' '))),
				MaterialInfo.ComponentCategoryDescription = LTrim(RTrim(Replace(MaterialInfo.ComponentCategoryDescription, Char(160), ' '))),
				MaterialInfo.ComponentCategoryShortDescription = LTrim(RTrim(Replace(MaterialInfo.ComponentCategoryShortDescription, Char(160), ' '))),
				MaterialInfo.BatchPanelCode = LTrim(RTrim(Replace(MaterialInfo.BatchPanelCode, Char(160), ' ')))
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
    End
End
Go
/*
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.ItemCode = Upper(MaterialInfo.ItemCode),
				MaterialInfo.ItemDescription = Upper(MaterialInfo.ItemDescription),
				MaterialInfo.ItemShortDescription = Upper(MaterialInfo.ItemShortDescription),
				MaterialInfo.ItemCategoryName = Upper(MaterialInfo.ItemCategoryName),
				MaterialInfo.ItemCategoryDescription = Upper(MaterialInfo.ItemCategoryDescription),
				MaterialInfo.ItemCategoryShortDescription = Upper(MaterialInfo.ItemCategoryShortDescription),
				MaterialInfo.ComponentCategoryName = Upper(MaterialInfo.ComponentCategoryName),
				MaterialInfo.ComponentCategoryDescription = Upper(MaterialInfo.ComponentCategoryDescription),
				MaterialInfo.ComponentCategoryShortDescription = Upper(MaterialInfo.ComponentCategoryShortDescription),
				MaterialInfo.BatchPanelCode = Upper(MaterialInfo.BatchPanelCode)
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
    End
End
Go
*/
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.FamilyMaterialTypeName = 'Admixture & Fiber'
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where Isnull(MaterialInfo.FamilyMaterialTypeName, '') = 'AdmixtureFiber'
    End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.MaterialTypeName = 'Admixture & Fiber'
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where Isnull(MaterialInfo.MaterialTypeName, '') = 'AdmixtureFiber'
    End
End
Go
/*
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.SpecificGravity = 0.9982,
			    MaterialInfo.IsLiquidAdmix = 'No'
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where Isnull(MaterialInfo.FamilyMaterialTypeName, '') = 'Water'
    End
End
Go
*/