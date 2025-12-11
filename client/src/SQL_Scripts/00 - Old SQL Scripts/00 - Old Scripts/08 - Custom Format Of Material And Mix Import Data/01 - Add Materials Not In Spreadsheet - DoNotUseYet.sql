Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo
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
	ItemCode,
	ItemDescription,
	ItemShortDescription,
	ItemCategoryName,
	ItemCategoryDescription,
	ItemCategoryShortDescription,
	BatchPanelCode
)
Select	Case when OtherPlants.PlantId Is Not null Then OtherPlants.Name Else Plants.Name End As [Plant Name],
		TradeName.Name As [Trade Name],
		Material.DATE As [Material Date],
		FamilyMaterialType.MaterialType As [Family Material Type],
		MaterialType.MaterialType As [Material Type],
		Material.SPECGR As [Specific Gravity],
		Case
			When IsNull(Material.FamilyMaterialTypeID, -1) = 3 And Isnull(Material.MOISTURE, -1.0) > 0.0
			Then 'Yes'
			Else 'No'
		End As [IsLiquidAdmix],
		Round(Material.MOISTURE, 4) * 100.0 As [Moisture],
		Material.COST As [Cost],
		'TM' As [CostUnit],
		Manufacturer.Name As [Manufacturer],
		ManufacturerSource.Name As [Manufacturer Source],
		ItemName.Name As [Item Code],
		Case
			When ItemMaster.ItemMasterID Is Null
			Then Description.[Description] 
			Else ItemDescription.[Description] 
		End As [Item Description],		
		ItemMaster.ItemShortDescription As [Item Short Description],
		ItemCategory.ItemCategory As [Item Category],
		ItemCategory.[Description], 
		ItemCategory.ShortDescription,
		BatchPanelName.Name As [Batch Panel Code]
From dbo.Plants As Plants
Inner Join dbo.MATERIAL As Material
On Material.PlantID = Plants.PlantId
Left Join dbo.Plants As OtherPlants
On Plants.PlantId = OtherPlants.PlantIdForYard
Inner Join dbo.Name As TradeName
On TradeName.NameID = Material.NameID
Left Join dbo.[Description] As Description
On Description.DescriptionID = Material.DescriptionID
Left Join dbo.Manufacturer As Manufacturer
On Manufacturer.ManufacturerID = Material.ManufacturerID
Left Join dbo.ManufacturerSource As ManufacturerSource
On ManufacturerSource.ManufacturerSourceID = Material.ManufacturerSourceID  
Left Join iServiceDataExchange.dbo.MaterialType As FamilyMaterialType
On Material.FamilyMaterialTypeID = FamilyMaterialType.MaterialTypeID
Left Join iServiceDataExchange.dbo.MaterialType As MaterialType
On Material.MaterialTypeLink = MaterialType.MaterialTypeID
Inner Join dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Inner Join dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Left Join dbo.[Description] As ItemDescription
On ItemDescription.DescriptionID = ItemMaster.DescriptionID
Left Join dbo.ProductionItemCategory As ItemCategory
On ItemCategory.ProdItemCatID = ItemMaster.ProdItemCatID
Left Join dbo.ProductionItemCategory As ComponentCategory
On ComponentCategory.ProdItemCatID = ItemMaster.ProdItemCompTypeID
Left Join dbo.Name As BatchPanelName
On BatchPanelName.NameID = Material.BatchPanelNameID
Inner Join 
(
	Select MixInfo.PlantCode, MixInfo.MaterialItemCode
	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo 
	Group By MixInfo.PlantCode, MixInfo.MaterialItemCode
) As MixMaterial
On	Case When OtherPlants.PlantId Is Not null Then OtherPlants.Name Else Plants.Name End = MixMaterial.PlantCode And
	ItemName.Name = MixMaterial.MaterialItemCode
Left Join
(
	Select	-1 As ID, MaterialInfo.PlantName, MaterialInfo.ItemCode
	From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
	Group By MaterialInfo.PlantName, MaterialInfo.ItemCode
) As ExistingMaterial
On	Case When OtherPlants.PlantId Is Not null Then OtherPlants.Name Else Plants.Name End = ExistingMaterial.PlantName And
	ItemName.Name = ExistingMaterial.ItemCode
Where ExistingMaterial.ID Is Null
Order By Plants.Name, TradeName.Name
