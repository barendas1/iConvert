Declare @CanUseMaterialDescriptionAsTradeName Bit = 1

Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo
(
	PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName,
	SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName,
	ManufacturerName, ManufacturerSourceName, BatchingOrderNumber, ItemCode,
	ItemDescription, ItemShortDescription, ItemCategoryName,
	ItemCategoryDescription, ItemCategoryShortDescription, BatchPanelCode
)

Select  MixInfo.PlantCode,
        Case 
            When Isnull(SourceMaterial.TradeName, '') <> '' 
            Then SourceMaterial.TradeName
            When Isnull(MixInfo.MaterialItemDescription, '') <> '' And Isnull(@CanUseMaterialDescriptionAsTradeName, 1) = 1
            Then MixInfo.MaterialItemDescription 
            Else MixInfo.MaterialItemCode 
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
        MixInfo.MaterialItemCode,
        Case when Isnull(SourceMaterial.ItemDescription, '') <> '' Then SourceMaterial.ItemDescription Else MixInfo.MaterialItemDescription End,
        Case when Isnull(SourceMaterial.ItemShortDescription, '') <> '' Then SourceMaterial.ItemShortDescription Else MixInfo.MaterialItemDescription End,
        SourceMaterial.ItemCategoryName,
        SourceMaterial.ItemCategoryDescription,
        SourceMaterial.ItemCategoryShortDescription,
        SourceMaterial.BatchPanelCode
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
On  MixInfo.PlantCode = MaterialInfo.PlantName And
    MixInfo.MaterialItemCode = MaterialInfo.ItemCode
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
On MixInfo.MaterialItemCode = SourceMaterial.ItemCode
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
On  MixInfo.PlantCode = ExistingMaterial.PlantCode And
    MixInfo.MaterialItemCode = ExistingMaterial.ItemCode
Where   MaterialInfo.AutoID Is Null And
        ExistingMaterial.ID Is Null And
        MixInfo.AutoID In
        (
        	Select Min(MixInfo.AutoID)
        	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
        	Where Isnull(MixInfo.PlantCode, '') <> '' And Isnull(MixInfo.MaterialItemCode, '') <> ''
        	Group By MixInfo.PlantCode, MixInfo.MaterialItemCode
        )
Order By MixInfo.MaterialItemCode, MixInfo.PlantCode
