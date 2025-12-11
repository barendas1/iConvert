Select Distinct MixInfo.QuantityUnitName
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo

Select * From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo Where MixInfo.MaterialItemCode = 'Z60'

SELECT        AutoID, PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName, SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName, ManufacturerName, ManufacturerSourceName, 
                         BatchingOrderNumber, ItemCode, ItemDescription, ItemShortDescription, ItemCategoryName, ItemCategoryDescription, ItemCategoryShortDescription, ComponentCategoryName, ComponentCategoryDescription, 
                         ComponentCategoryShortDescription, BatchPanelCode, UpdatedFromDatabase
FROM            Data_Import_RJ.dbo.Import0071_MaterialInfo AS MaterialInfo
Where MaterialTypeName Like '%Sil%'
ORDER BY AutoID

Select * From dbo.Static_MaterialType As Info Order By Info.RecipeOrder
