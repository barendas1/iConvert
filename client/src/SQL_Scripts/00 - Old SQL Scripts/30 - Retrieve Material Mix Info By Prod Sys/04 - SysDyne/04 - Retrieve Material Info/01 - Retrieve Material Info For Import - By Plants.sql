Declare @MaterialDate Nvarchar (40) = Format(Getdate(), 'MM/dd/yyyy')-- '10/23/2023'

Declare @PlantInfo Table (PlantName Nvarchar (100))

Insert into @PlantInfo
(
	PlantName
)
Select Trim(Replace(Isnull(PlantInfo.PlantName, ''), Char(160), ' ')) As PlantName
From
(
	Select '409' As PlantName
	Union All
	Select '420' As PlantName
	Union All
	Select '453' As PlantName
	Union All
	Select '455' As PlantName
	Union All
	Select '' As PlantName
	Union All
	Select '' As PlantName
	Union All
	Select '' As PlantName
	Union All
	Select '' As PlantName
	Union All
	Select '' As PlantName
) As PlantInfo
Where Trim(Replace(Isnull(PlantInfo.PlantName, ''), Char(160), ' ')) <> ''
Group By Trim(Replace(Isnull(PlantInfo.PlantName, ''), Char(160), ' '))

If Exists (Select * From @PlantInfo)
Begin
    Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo 
    (
	    PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName,
	    SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName,
	    ManufacturerName, ManufacturerSourceName, BatchingOrderNumber, ItemCode,
	    ItemDescription, ItemShortDescription, ItemCategoryName,
	    ItemCategoryDescription, ItemCategoryShortDescription, ComponentCategoryName,
	    ComponentCategoryDescription, ComponentCategoryShortDescription,
	    BatchPanelCode, UpdatedFromDatabase
    )
    Select  MaterialInfo.PlantCode, 
            Case when Isnull(MaterialInfo.Description, '') <> '' Then MaterialInfo.[Description] Else MaterialInfo.ItemCode End As TradeName,
            @MaterialDate As MaterialDate,
            CategoryInfo.FamilyMaterialTypeName As FamilyMaterialTypeName,
            CategoryInfo.MaterialTypeName As MaterialTypeName,
            Case when Isnull(MaterialInfo.SpecificGravity, -1.0) >= 0.4 Then MaterialInfo.SpecificGravity Else CategoryInfo.SpecificGravity End As SpecificGravity,
            CategoryInfo.IsLiquidAdmix As IsLiquidAdmix,
            Isnull(MaterialInfo.MoisturePercent, 0.0) As MoisturePercent,
            MaterialInfo.Cost,
            MaterialInfo.PurchaseUnit,
            Null As ManufacturerName,
            Null As ManufacturerSourceName,
            Null As BatchingOrderNumber,
            MaterialInfo.ItemCode,
            MaterialInfo.[Description],
            MaterialInfo.ShortDescription,
            CategoryInfo.Name,
            CategoryInfo.Description,
            CategoryInfo.ShortDescription,
            Null As ComponentCategoryName,
            Null As ComponentCategoryDescription,
            Null As ComponentCategoryShortDescription,
            Null As BatchPanelCode,
            0 As UpdatedFromDatabase
    From Data_Import_RJ.dbo.TestImport0000_XML_Material As MaterialInfo
    Inner Join @PlantInfo As PlantInfo
    On MaterialInfo.PlantCode = PlantInfo.PlantName
    Left Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
    On MaterialInfo.ItemCategoryCode = CategoryInfo.Name
    Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As ExistingInfo
    On  MaterialInfo.PlantCode = ExistingInfo.PlantName And
        MaterialInfo.ItemCode = ExistingInfo.ItemCode
    Where ExistingInfo.AutoID Is Null
    Order By MaterialInfo.PlantCode, MaterialInfo.ItemCode
End
Else
Begin
    Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo 
    (
	    PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName,
	    SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName,
	    ManufacturerName, ManufacturerSourceName, BatchingOrderNumber, ItemCode,
	    ItemDescription, ItemShortDescription, ItemCategoryName,
	    ItemCategoryDescription, ItemCategoryShortDescription, ComponentCategoryName,
	    ComponentCategoryDescription, ComponentCategoryShortDescription,
	    BatchPanelCode, UpdatedFromDatabase
    )
    Select  MaterialInfo.PlantCode, 
            Case when Isnull(MaterialInfo.Description, '') <> '' Then MaterialInfo.[Description] Else MaterialInfo.ItemCode End As TradeName,
            @MaterialDate As MaterialDate,
            CategoryInfo.FamilyMaterialTypeName As FamilyMaterialTypeName,
            CategoryInfo.MaterialTypeName As MaterialTypeName,
            Case when Isnull(MaterialInfo.SpecificGravity, -1.0) >= 0.4 Then MaterialInfo.SpecificGravity Else CategoryInfo.SpecificGravity End As SpecificGravity,
            CategoryInfo.IsLiquidAdmix As IsLiquidAdmix,
            Isnull(MaterialInfo.MoisturePercent, 0.0) As MoisturePercent,
            MaterialInfo.Cost,
            MaterialInfo.PurchaseUnit,
            Null As ManufacturerName,
            Null As ManufacturerSourceName,
            Null As BatchingOrderNumber,
            MaterialInfo.ItemCode,
            MaterialInfo.[Description],
            MaterialInfo.ShortDescription,
            CategoryInfo.Name,
            CategoryInfo.Description,
            CategoryInfo.ShortDescription,
            Null As ComponentCategoryName,
            Null As ComponentCategoryDescription,
            Null As ComponentCategoryShortDescription,
            Null As BatchPanelCode,
            0 As UpdatedFromDatabase
    From Data_Import_RJ.dbo.TestImport0000_XML_Material As MaterialInfo
    Left Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
    On MaterialInfo.ItemCategoryCode = CategoryInfo.Name
    Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As ExistingInfo
    On  MaterialInfo.PlantCode = ExistingInfo.PlantName And
        MaterialInfo.ItemCode = ExistingInfo.ItemCode
    Where ExistingInfo.AutoID Is Null
    Order By MaterialInfo.PlantCode, MaterialInfo.ItemCode    
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
