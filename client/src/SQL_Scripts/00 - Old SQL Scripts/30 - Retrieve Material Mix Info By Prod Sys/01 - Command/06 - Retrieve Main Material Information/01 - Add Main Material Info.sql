If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MainMaterialInfo')
    Begin
    	Insert into Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo
    	(
    		Name,
    		[Description],
    		ShortDescription,
    		ItemCategory,
    		ItemCategoryDescription,
    		FamilyMaterialTypeName,
    		MaterialTypeName,
    		SpecificGravity
    	)
		Select	dbo.TrimNVarChar(MainInfo.item_code), 
				dbo.TrimNVarChar(MainInfo.descr), 
				dbo.TrimNVarChar(MainInfo.short_descr),
				dbo.TrimNVarChar(MainInfo.item_cat),
				dbo.TrimNVarChar(CategoryInfo.[Description]),
				dbo.TrimNVarChar(CategoryInfo.FamilyMaterialTypeName),
				dbo.TrimNVarChar(CategoryInfo.MaterialTypeName),
				CategoryInfo.SpecificGravity
		From CmdTest_RJ.dbo.imst As MainInfo
		Inner Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
		On dbo.TrimNVarChar(MainInfo.item_cat) = dbo.TrimNVarChar(CategoryInfo.Name)
		Left Join Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MaterialInfo
		On dbo.TrimNVarChar(MainInfo.item_code) = dbo.TrimNVarChar(MaterialInfo.Name)
		Where   MaterialInfo.AutoID Is Null And
		        dbo.TrimNVarChar(CategoryInfo.Name) Not In
		        (
		        	'Color'
		        )
		Order By dbo.TrimNVarChar(MainInfo.item_code)
    End
End
Go
