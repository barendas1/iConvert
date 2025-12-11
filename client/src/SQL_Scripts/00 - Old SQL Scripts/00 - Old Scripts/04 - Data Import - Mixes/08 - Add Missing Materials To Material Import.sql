If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo')
    Begin
        Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo
        (
        	PlantName, TradeName, MaterialDate, FamilyMaterialTypeName,
        	MaterialTypeName, SpecificGravity, IsLiquidAdmix, MoisturePct, Cost,
        	CostUnitName, ManufacturerName, ManufacturerSourceName,
        	BatchingOrderNumber, ItemCode, ItemDescription, ItemShortDescription,
        	ItemCategoryName, ItemCategoryDescription,
        	ItemCategoryShortDescription, ComponentCategoryName,
        	ComponentCategoryDescription, ComponentCategoryShortDescription,
        	BatchPanelCode, UpdatedFromDatabase
        )
        Select  MixInfo.PlantCode,
                Coalesce(MaterialInfo.TradeName, MixInfo.MaterialItemDescription, MixInfo.MaterialItemCode) As TradeName,
                Null As Date,
                MaterialInfo.FamilyMaterialTypeName,
                MaterialInfo.MaterialTypeName,
                MaterialInfo.SpecificGravity,
                MaterialInfo.IsLiquidAdmix,
                MaterialInfo.MoisturePct,
                Null As Cost,
                Null As CostUnitName,
                Null As ManufacturerName,
                Null As ManufacturerSourceName,
                MaterialInfo.BatchingOrderNumber,
                MixInfo.MaterialItemCode,
                Coalesce(MaterialInfo.ItemDescription, MixInfo.MaterialItemDescription) As ItemDescription,
                Coalesce(MaterialInfo.ItemShortDescription, MaterialInfo.ItemDescription, MixInfo.MaterialItemDescription) As ItemShortDescription,
                MaterialInfo.ItemCategoryName,
                MaterialInfo.ItemCategoryDescription,
                MaterialInfo.ItemCategoryShortDescription,
                MaterialInfo.ComponentCategoryName,
                MaterialInfo.ComponentCategoryDescription,
                MaterialInfo.ComponentCategoryShortDescription,
                Null As BatchPanelCode, 
                0 As UpdatedFromDatabase
        From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
        Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
        On MixInfo.MaterialItemCode = MaterialInfo.ItemCode
        Where   MixInfo.AutoID In
                (
                	Select Min(MixInfo.AutoID)
                	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
                    Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
                    On MixInfo.PlantCode = MaterialInfo.PlantName And MixInfo.MaterialItemCode = MaterialInfo.ItemCode
                    Where   MaterialInfo.AutoID Is Null And
                            Isnull(MixInfo.PlantCode, '') <> '' And Isnull(MixInfo.MaterialItemCode, '') <> ''
                	Group By MixInfo.PlantCode, MixInfo.MaterialItemCode
                ) And
                (
                    MaterialInfo.AutoID Is Null Or
                    MaterialInfo.AutoID In
                    (
                    	Select Min(MaterialInfo.AutoID)
                    	From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
                    	Where Isnull(MaterialInfo.PlantName, '') <> '' And Isnull(MaterialInfo.ItemCode, '') <> ''
                    	Group By MaterialInfo.ItemCode                    	
                    )
                )
        Order By MixInfo.MaterialItemCode, MixInfo.PlantCode
    End
End
Go
