Select Distinct Info.PlantName 
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As Info

Select *
From iServiceDataExchange.dbo.MaterialType As Info
Order By Info.RecipeOrder

Select MaterialInfo.CostUnitName
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Group By MaterialInfo.CostUnitName

Select MaterialInfo.CostUnitName
From Data_Import_RJ.dbo.Import01_MaterialInfo_WCAN As MaterialInfo
Group By MaterialInfo.CostUnitName

Select *
From Data_Import_RJ.dbo.Import01_MaterialInfo_WCAN As MaterialInfo
Where MaterialInfo.CostUnitName = 'TM' Or MaterialInfo.CostUnitName = 'yes'

Select *
From Data_Import_RJ.dbo.Import01_MaterialInfo_WCAN As MaterialInfo
Where MaterialInfo.CostUnitName = 'yes'

Select *
From Data_Import_RJ.dbo.Import01_MaterialInfo_WCAN As MaterialInfo
Where MaterialInfo.MaterialTypeName In ('Integrel Hardener', 'Integral Hardener')

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Where MaterialInfo.MaterialTypeName = 'NA'

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Where Len(MaterialInfo.ManufacturerName) > 50

Select *
From Data_Import_RJ.dbo.Import01_MaterialInfo_WCAN As MaterialInfo
Where Len(MaterialInfo.ManufacturerName) > 50

Select *
From ARGOS_USA_RJ.dbo.MATERIAL
Where [TYPE] Like '%Coarse%'

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Order By MaterialInfo.AutoID

Select *
From dbo.Plants As Plants
--Where Right(Plants.Name, 1) = 'x'
Order By Plants.Name

Select Distinct MaterialInfo.PlantName
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Order By MaterialInfo.PlantName

Select Distinct MixInfo.PlantCode
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
Order By MixInfo.PlantCode


Insert into Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo
(
	-- AutoID -- this column value is auto-generated
	PlantName,
	TradeName,
	MaterialDate,
	FamilyMaterialTypeName,
	MaterialTypeName,
	SpecificGravity,
	IsLiquidAdmix,
	MoisturePct,
	Cost,
	CostUnitName,
	ManufacturerName,
	ManufacturerSourceName,
	BatchingOrderNumber,
	ItemCode,
	ItemDescription,
	ItemShortDescription,
	ItemCategoryName,
	ItemCategoryDescription,
	ItemCategoryShortDescription,
	ComponentCategoryName,
	ComponentCategoryDescription,
	ComponentCategoryShortDescription,
	BatchPanelCode
)
Select  Plants.Name,
        MaterialInfo.TradeName,
        MaterialInfo.MaterialDate,
        MaterialInfo.FamilyMaterialTypeName,
        MaterialInfo.MaterialTypeName,
        MaterialInfo.SpecificGravity,
        MaterialInfo.IsLiquidAdmix,
        MaterialInfo.MoisturePct,
        MaterialInfo.Cost,
        MaterialInfo.CostUnitName,
        MaterialInfo.ManufacturerName,
        MaterialInfo.ManufacturerSourceName,
        MaterialInfo.BatchingOrderNumber,
        MaterialInfo.ItemCode,
        MaterialInfo.ItemDescription,
        MaterialInfo.ItemShortDescription,
        MaterialInfo.ItemCategoryName,
        MaterialInfo.ItemCategoryDescription,
        MaterialInfo.ItemCategoryShortDescription,
        MaterialInfo.ComponentCategoryName,
        MaterialInfo.ComponentCategoryDescription,
        MaterialInfo.ComponentCategoryShortDescription,
        MaterialInfo.BatchPanelCode
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Cross Join dbo.Plants As Plants
Left Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As ExistingInfo
On	Plants.Name = ExistingInfo.PlantName And
	MaterialInfo.TradeName = ExistingInfo.TradeName And
	MaterialInfo.FamilyMaterialTypeName = ExistingInfo.FamilyMaterialTypeName And
	Cast(MaterialInfo.MaterialDate As Datetime) = Cast(ExistingInfo.MaterialDate As DateTime)
Where	Plants.PlantKind = 'BatchPlant' And
		ExistingInfo.AutoID Is Null
Order By MaterialInfo.FamilyMaterialTypeName, MaterialInfo.TradeName, Plants.Name, Cast(MaterialInfo.MaterialDate As Datetime)
