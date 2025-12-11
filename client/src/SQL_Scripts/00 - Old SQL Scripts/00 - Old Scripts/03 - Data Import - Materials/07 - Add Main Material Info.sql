If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo')
    Begin
    	Insert into Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo
    	(
    		Name, Description, ShortDescription, ItemCategory,
    		ItemCategoryDescription, FamilyMaterialTypeName, MaterialTypeName,
    		SpecificGravity, IsLiquidAdmix
    	)
    	Select  MaterialInfo.ItemCode, MaterialInfo.ItemDescription,
    	        MaterialInfo.ItemShortDescription, MaterialInfo.ItemCategoryName,
    	        MaterialInfo.ItemCategoryDescription,
    	        MaterialInfo.FamilyMaterialTypeName, MaterialInfo.MaterialTypeName,
    	        MaterialInfo.SpecificGravity, MaterialInfo.IsLiquidAdmix
    	From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
    	Left Join Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MainInfo
    	On MaterialInfo.ItemCode = MainInfo.Name
    	Where   MainInfo.AutoID Is Null And
    	        --Isnull(MaterialInfo.MaterialTypeName, '') = '' And
    	        MaterialInfo.AutoID In
    	        (
    	            Select Min(MaterialInfo.AutoID)
    	            From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
    	            Group By MaterialInfo.ItemCode
    	        )
    End
End
Go
