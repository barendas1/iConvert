Declare @CanUpdateItemCategories Bit = 0
Declare @SetTradeNameToDescription Bit = 0
Declare @SetTradeNameToShortDescription Bit = 0

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo')
    Begin
    	Update MainInfo
    	    Set MainInfo.Name = Ltrim(Rtrim(Replace(MainInfo.Name, Char(160), ' '))),
    	        MainInfo.Description = Ltrim(Rtrim(Replace(MainInfo.Description, Char(160), ' '))),
    	        MainInfo.ShortDescription = Ltrim(Rtrim(Replace(MainInfo.ShortDescription, Char(160), ' '))),
    	        MainInfo.ItemCategory = Ltrim(Rtrim(Replace(MainInfo.ItemCategory, Char(160), ' '))),
    	        MainInfo.ItemCategoryDescription = Ltrim(Rtrim(Replace(MainInfo.ItemCategoryDescription, Char(160), ' '))),
    	        MainInfo.FamilyMaterialTypeName = Ltrim(Rtrim(Replace(MainInfo.FamilyMaterialTypeName, Char(160), ' '))),
    	        MainInfo.MaterialTypeName = Ltrim(Rtrim(Replace(MainInfo.MaterialTypeName, Char(160), ' '))),
    	        MainInfo.IsLiquidAdmix = Ltrim(Rtrim(Replace(MainInfo.IsLiquidAdmix, Char(160), ' ')))
    	From Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MainInfo
    	
    	Update MaterialInfo
    	    Set MaterialInfo.FamilyMaterialTypeName = MainInfo.FamilyMaterialTypeName,
                MaterialInfo.MaterialTypeName = MainInfo.MaterialTypeName,
                MaterialInfo.SpecificGravity = 
                    Case
                        When Isnull(MainInfo.FamilyMaterialTypeName, '') = 'Water' And Isnull(MaterialInfo.SpecificGravity, -1.0) >= 2.0
                        Then MainInfo.SpecificGravity
                        When Isnull(MaterialInfo.SpecificGravity, -1.0) >= 0.4
                        Then MaterialInfo.SpecificGravity
                        Else MainInfo.SpecificGravity                        
                    End,
                MaterialInfo.IsLiquidAdmix = MainInfo.IsLiquidAdmix,
                MaterialInfo.MoisturePct = MainInfo.MoisturePct,
                MaterialInfo.ItemCategoryName = 
                    Case
                        When Isnull(@CanUpdateItemCategories, 0) = 0 Or Isnull(MaterialInfo.ItemCategoryName, '') <> ''
                        Then MaterialInfo.ItemCategoryName
                        Else MainInfo.ItemCategory
                    End,
                MaterialInfo.ItemCategoryDescription = 
                    Case
                        When Isnull(@CanUpdateItemCategories, 0) = 0 Or Isnull(MaterialInfo.ItemCategoryDescription, '') <> ''
                        Then MaterialInfo.ItemCategoryDescription
                        Else MainInfo.ItemCategoryDescription
                    End                
        From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
        Inner Join Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MainInfo
        On MaterialInfo.ItemCode = MainInfo.Name
        
        If Isnull(@SetTradeNameToDescription, 0) = 1
        Begin
		    Update MaterialInfo
		        Set MaterialInfo.TradeName = MaterialInfo.ItemDescription
		    From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
		    Where Isnull(MaterialInfo.ItemDescription, '') <> ''
        End

        If Isnull(@SetTradeNameToShortDescription, 0) = 1
        Begin
		    Update MaterialInfo
		        Set MaterialInfo.TradeName = MaterialInfo.ItemShortDescription
		    From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
		    Where Isnull(MaterialInfo.ItemShortDescription, '') <> ''
        End
        
		Update MaterialInfo
		    Set MaterialInfo.TradeName = MaterialInfo.ItemCode
		From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
		Inner Join
		(
	        Select MaterialInfo.PlantName, MaterialInfo.TradeName, Min(MaterialInfo.AutoID) As MinAutoID
	        From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
	        Group By MaterialInfo.PlantName, MaterialInfo.TradeName
	        Having Count(*) > 1
		) As DuplicateInfo
		On  DuplicateInfo.PlantName = MaterialInfo.PlantName And
		    DuplicateInfo.TradeName = MaterialInfo.TradeName 
		Where MaterialInfo.AutoID <> DuplicateInfo.MinAutoID
    End
End
Go
