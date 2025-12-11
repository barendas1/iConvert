Declare @CanUseMaterialDescriptionAsTradeName Bit = 1

Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo
(
	PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName,
	SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName,
	ManufacturerName, ManufacturerSourceName, BatchingOrderNumber, ItemCode,
	ItemDescription, ItemShortDescription, ItemCategoryName,
	ItemCategoryDescription, ItemCategoryShortDescription, BatchPanelCode
)

Select  BatchInfo.PlantName,
        Case 
            When Isnull(SourceMaterial.TradeName, '') <> '' 
            Then SourceMaterial.TradeName
            When Isnull(BatchInfo.MaterialItemDescription, '') <> '' And Isnull(@CanUseMaterialDescriptionAsTradeName, 1) = 1
            Then BatchInfo.MaterialItemDescription 
            Else BatchInfo.MaterialItemCode 
        End As TradeName,
        Case when Isdate(SourceMaterial.MaterialDate) = 1 Then SourceMaterial.MaterialDate Else Null End,
        SourceMaterial.FamilyMaterialTypeName,
        SourceMaterial.MaterialTypeName,
        SourceMaterial.SpecificGravity,
        SourceMaterial.IsLiquidAdmix,
        Case when Isnull(SourceMaterial.FamilyMaterialTypeName, '') In ('Admixture & Fiber') Then SourceMaterial.MoisturePct Else Null End,
        Case when Isnull(SourceMaterial.FamilyMaterialTypeName, '') In ('Admixture & Fiber', 'Cement', 'Mineral', 'Water') Then SourceMaterial.Cost Else Null End,
        Case when Isnull(SourceMaterial.FamilyMaterialTypeName, '') In ('Admixture & Fiber', 'Cement', 'Mineral', 'Water') Then SourceMaterial.CostUnitName Else Null End,
        Case when Isnull(SourceMaterial.FamilyMaterialTypeName, '') In ('Admixture & Fiber', 'Cement', 'Mineral') Then SourceMaterial.ManufacturerName Else Null End,
        Case when Isnull(SourceMaterial.FamilyMaterialTypeName, '') In ('Admixture & Fiber', 'Cement', 'Mineral') Then SourceMaterial.ManufacturerSourceName Else Null End,
        SourceMaterial.BatchingOrderNumber,
        BatchInfo.MaterialItemCode,
        Case when Isnull(SourceMaterial.ItemDescription, '') <> '' Then SourceMaterial.ItemDescription Else BatchInfo.MaterialItemDescription End,
        Case when Isnull(SourceMaterial.ItemShortDescription, '') <> '' Then SourceMaterial.ItemShortDescription Else BatchInfo.MaterialItemDescription End,
        Case when Isnull(SourceMaterial.ItemCategoryName, '') <> '' Then SourceMaterial.ItemCategoryName Else BatchInfo.MaterialItemCategoryName End,
        Case when Isnull(SourceMaterial.ItemCategoryDescription, '') <> '' Then SourceMaterial.ItemCategoryDescription Else BatchInfo.MaterialItemCategoryName End,
        Case when Isnull(SourceMaterial.ItemCategoryShortDescription, '') <> '' Then SourceMaterial.ItemCategoryShortDescription Else BatchInfo.MaterialItemCategoryName End,
        SourceMaterial.BatchPanelCode
From Data_Import_RJ.dbo.TestImport0000_BatchRecipeInfo As BatchInfo
Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
On  BatchInfo.PlantName = MaterialInfo.PlantName And
    BatchInfo.MaterialItemCode = MaterialInfo.ItemCode
Left Join 
(
	Select  SourceMaterial1.PlantName, SourceMaterial1.TradeName,
            SourceMaterial1.MaterialDate, SourceMaterial1.FamilyMaterialTypeName,
            SourceMaterial1.MaterialTypeName, SourceMaterial1.SpecificGravity,
            SourceMaterial1.IsLiquidAdmix, SourceMaterial1.MoisturePct,
            SourceMaterial1.Cost, SourceMaterial1.CostUnitName,
            SourceMaterial1.ManufacturerName,
            SourceMaterial1.ManufacturerSourceName,
            SourceMaterial1.BatchingOrderNumber, SourceMaterial1.ItemCode,
            SourceMaterial1.ItemDescription, SourceMaterial1.ItemShortDescription,
            SourceMaterial1.ItemCategoryName,
            SourceMaterial1.ItemCategoryDescription,
            SourceMaterial1.ItemCategoryShortDescription,
            SourceMaterial1.BatchPanelCode
	From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As SourceMaterial1
	Where   SourceMaterial1.AutoID In
	        (
	        	Select Min(FirstMaterial.AutoID)
	        	From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As FirstMaterial
	        	Group By FirstMaterial.ItemCode
	        )
) As SourceMaterial
On BatchInfo.MaterialItemCode = SourceMaterial.ItemCode
Left Join 
(
	Select -1 As ID, Plants.Name As PlantCode, ItemName.Name As ItemCode
	From dbo.Plants As Plants
	Inner Join dbo.Material As Material
	On Material.PlantID = Plants.PlantId
	Inner Join dbo.ItemMaster As ItemMaster
	On ItemMaster.ItemMasterID = Material.ItemMasterID
	Inner Join dbo.Name As ItemName
	On ItemName.NameID = ItemMaster.NameID
	Group By Plants.Name, ItemName.Name
) As ExistingMaterial
On  BatchInfo.PlantName = ExistingMaterial.PlantCode And
    BatchInfo.MaterialItemCode = ExistingMaterial.ItemCode
Where   MaterialInfo.AutoID Is Null And
        ExistingMaterial.ID Is Null And
        BatchInfo.AutoID In
        (
        	Select Min(BatchInfo2.AutoID)
        	From Data_Import_RJ.dbo.TestImport0000_BatchRecipeInfo As BatchInfo2
        	Where Isnull(BatchInfo2.PlantName, '') <> '' And Isnull(BatchInfo2.MaterialItemCode, '') <> ''
        	Group By BatchInfo2.PlantName, BatchInfo2.MaterialItemCode
        )
Order By BatchInfo.MaterialItemCode, BatchInfo.PlantName
