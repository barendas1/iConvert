--> This script imports all Materials in all Plants.

Declare @MaterialDate Nvarchar (40) = Format(Getdate(), 'MM/dd/yyyy') 
--> Declare @MaterialDate Nvarchar (40) = Format(Getdate(), 'dd/MM/yyyy') ==> Use this line for mostly International Customers

Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo 
(
	PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName,
	SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName,
	ManufacturerName, ManufacturerSourceName, BatchingOrderNumber, ItemCode,
	ItemDescription, ItemShortDescription, ItemCategoryName,
	ItemCategoryDescription, ItemCategoryShortDescription, ComponentCategoryName,
	ComponentCategoryDescription, ComponentCategoryShortDescription,
	BatchPanelCode, Batchable, UpdatedFromDatabase
)
Select  MaterialInfo.PlantCode, 
        Case when Isnull(MaterialInfo.Description, '') <> '' Then MaterialInfo.[Description] Else MaterialInfo.ProductCode End As TradeName,
        @MaterialDate As MaterialDate,
        Null As FamilyMaterialTypeName,
        Null As MaterialTypeName,
        MaterialInfo.SpecificGravity As SpecificGravity, --Case when Isnull(MaterialInfo.SpecificGravity, -1.0) >= 0.4 Then MaterialInfo.SpecificGravity Else CategoryInfo.SpecificGravity End
        Null As IsLiquidAdmix,
        Isnull(MaterialInfo.MoisturePercent, 0.0) As MoisturePercent,
        MaterialInfo.Cost,
        MaterialInfo.CostUnitName,
        Null As ManufacturerName,
        Null As ManufacturerSourceName,
        Null As BatchingOrderNumber,
        MaterialInfo.ProductCode,
        MaterialInfo.[Description],
        MaterialInfo.ShortDescription,
        MaterialInfo.ItemCategoryCode,
        Null As ItemCategoryDescription,
        Null As ItemCategoryShortDescription,
        MaterialInfo.ComponentCategoryCode As ComponentCategoryName,
        Null As ComponentCategoryDescription,
        Null As ComponentCategoryShortDescription,
        MaterialInfo.BatchPanelCode As BatchPanelCode,
        Isnull(MaterialInfo.Batchable, 1),
        0 As UpdatedFromDatabase
From Data_Import_RJ.dbo.TestImport0000_XML_Material As MaterialInfo
--Left Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
--On MaterialInfo.ItemCategoryCode = CategoryInfo.Name
Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As ExistingInfo
On  MaterialInfo.PlantCode = ExistingInfo.PlantName And
    MaterialInfo.ProductCode = ExistingInfo.ItemCode
Where ExistingInfo.AutoID Is Null
Order By MaterialInfo.PlantCode, MaterialInfo.ProductCode

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
