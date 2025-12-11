If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo')
    Begin
    	Update MaterialInfo
    	    Set MaterialInfo.Name = LTrim(RTrim(Replace(MaterialInfo.Name, Char(160), ' '))),
    	        MaterialInfo.Description = LTrim(RTrim(Replace(MaterialInfo.Description, Char(160), ' '))),
    	        MaterialInfo.ShortDescription = LTrim(RTrim(Replace(MaterialInfo.ShortDescription, Char(160), ' '))),
    	        MaterialInfo.ItemCategory = LTrim(RTrim(Replace(MaterialInfo.ItemCategory, Char(160), ' '))),
    	        MaterialInfo.ItemCategoryDescription = LTrim(RTrim(Replace(MaterialInfo.ItemCategoryDescription, Char(160), ' '))),
    	        MaterialInfo.FamilyMaterialTypeName = LTrim(RTrim(Replace(MaterialInfo.FamilyMaterialTypeName, Char(160), ' '))),
    	        MaterialInfo.MaterialTypeName = LTrim(RTrim(Replace(MaterialInfo.MaterialTypeName, Char(160), ' '))),
    	        MaterialInfo.IsLiquidAdmix = LTrim(RTrim(Replace(MaterialInfo.IsLiquidAdmix, Char(160), ' ')))
    	From Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MaterialInfo
    	
    	Update MaterialInfo
    	    Set MaterialInfo.FamilyMaterialTypeName = MainInfo.FamilyMaterialTypeName,
    	        MaterialInfo.MaterialTypeName = MainInfo.MaterialTypeName,
    	        MaterialInfo.SpecificGravity = Case when Isnull(MaterialInfo.SpecificGravity, -1.0) >= 0.4 Then MaterialInfo.SpecificGravity Else MainInfo.SpecificGravity End,
    	        MaterialInfo.IsLiquidAdmix = MainInfo.IsLiquidAdmix
    	From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
    	Inner Join Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MainInfo
    	On MaterialInfo.ItemCode = MainInfo.Name        
    	--Where Isnull(MaterialInfo.MaterialTypeName, '') = ''
    End	
End
Go
