If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MainMaterialInfo')
    Begin
    	Insert into Data_Import_RJ.dbo.TestImport0000_XML_MainMaterialInfo
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
		From CmdProd_SONAG_RJ.dbo.imst As MainInfo
		Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialItemCategory As CategoryInfo
		On dbo.TrimNVarChar(MainInfo.item_cat) = dbo.TrimNVarChar(CategoryInfo.Name)
		Left Join Data_Import_RJ.dbo.TestImport0000_XML_MainMaterialInfo As MaterialInfo
		On dbo.TrimNVarChar(MainInfo.item_code) = dbo.TrimNVarChar(MaterialInfo.Name)
		Where MaterialInfo.AutoID Is Null
		Order By dbo.TrimNVarChar(MainInfo.item_code)
    End
End
Go
/*
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If	Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MainMaterialInfo') And
		Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'Import24_MainMaterialInfo')
    Begin
    	Update MainMtrlInfo
    		Set MainMtrlInfo.FamilyMaterialTypeName = PrevMtrlInfo.FamilyMaterialTypeName,
    			MainMtrlInfo.MaterialTypeName = PrevMtrlInfo.MaterialTypeName,
    			MainMtrlInfo.SpecificGravity = PrevMtrlInfo.SpecificGravity
    	From Data_Import_RJ.dbo.TestImport0000_XML_MainMaterialInfo As MainMtrlInfo
    	Inner Join Data_Import_RJ.dbo.Import22_MainMaterialInfo As PrevMtrlInfo
    	On dbo.TrimNVarChar(MainMtrlInfo.Name) = dbo.TrimNVarChar(PrevMtrlInfo.Name)
    End
End
Go
*/
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If	Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MainMaterialInfo') And
		Exists (Select * From sys.databases As DatabaseInfo Where DatabaseInfo.name = 'Sonag_RJ')
    Begin
    	Update MainMtrlInfo
    		Set MainMtrlInfo.FamilyMaterialTypeName = MaterialInfo.FamilyMaterialTypeName,
    			MainMtrlInfo.MaterialTypeName = MaterialInfo.MaterialTypeName,
    			MainMtrlInfo.SpecificGravity = MaterialInfo.SpecificGravity
    	From Data_Import_RJ.dbo.TestImport0000_XML_MainMaterialInfo As MainMtrlInfo
    	Inner Join
    	(
    		Select  ItemName.Name As ItemCode, 
    		        FamilyMtrlTypeInfo.MaterialType As FamilyMaterialTypeName, 
    		        MtrlTypeInfo.MaterialType As MaterialTypeName,
    		        Material.SPECGR As SpecificGravity
    		From Sonag_RJ.dbo.MATERIAL As Material
    		Inner Join iServiceDataExchange.dbo.MaterialType As FamilyMtrlTypeInfo
    		On Material.FamilyMaterialTypeID = FamilyMtrlTypeInfo.MaterialTypeID
    		Inner Join iServiceDataExchange.dbo.MaterialType As MtrlTypeInfo
    		On Material.MaterialTypeLink = MtrlTypeInfo.MaterialTypeID
    		Inner Join Sonag_RJ.dbo.ItemMaster As ItemMaster 
    		On ItemMaster.ItemMasterID = Material.ItemMasterID
    		Inner Join Sonag_RJ.dbo.Name As ItemName
    		On ItemName.NameID = ItemMaster.NameID
    		Where   Material.MATERIALIDENTIFIER In
    		        (
    		            Select Max(Material.MATERIALIDENTIFIER)
    		            From Sonag_RJ.dbo.MATERIAL As Material
    		            Inner Join Sonag_RJ.dbo.ItemMaster As ItemMaster 
    		            On ItemMaster.ItemMasterID = Material.ItemMasterID
    		            Inner Join Sonag_RJ.dbo.Name As ItemName
    		            On ItemName.NameID = ItemMaster.NameID
    		            Group By ItemName.Name
    		        )
    	) As MaterialInfo
    	On MainMtrlInfo.Name = MaterialInfo.ItemCode
    End
End
Go
