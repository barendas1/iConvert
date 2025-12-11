SELECT        AutoID, PlantName, TradeName, ItemDescription, FamilyMaterialTypeName, MaterialTypeName, SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName, ManufacturerName, ManufacturerSourceName, 
                         BatchingOrderNumber, ItemCode, MaterialDate, ItemShortDescription, ItemCategoryName, ItemCategoryDescription, ItemCategoryShortDescription, ComponentCategoryName, ComponentCategoryDescription, 
                         ComponentCategoryShortDescription, BatchPanelCode, UpdatedFromDatabase
FROM            TestImport0000_MaterialInfo
WHERE        (UpdatedFromDatabase = 0)
ORDER BY FamilyMaterialTypeName, TradeName