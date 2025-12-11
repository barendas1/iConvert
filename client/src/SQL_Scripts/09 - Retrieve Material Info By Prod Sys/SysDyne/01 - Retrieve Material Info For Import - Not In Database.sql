--> This script only Adds Materials that are not already in the Quadrel Database.  
--> The script must be associated with the Database the Plants, Materials, Mixes, etc. are being imported into.

Declare @MaterialDate Nvarchar (40) = Format(Getdate(), 'MM/dd/yyyy')-- '10/23/2023'
--> Declare @MaterialDate Nvarchar (40) = Format(Getdate(), 'dd/MM/yyyy') ==> Use this line for mostly International Customers

Declare @PlantInfo Table (PlantName Nvarchar (100))

If Exists (Select * From INFORMATION_SCHEMA.TABLES As TableInfo Where TableInfo.TABLE_NAME = 'ACIBatchViewDetails')
Begin
	--> If the Customer wants only Data from certain Plants, put the Plant Names in the Plant Info List.
	Insert into @PlantInfo
	(
		PlantName
	)
	Select Trim(Replace(Isnull(PlantInfo.PlantName, ''), Char(160), ' ')) As PlantName
	From
	(
		Select '' As PlantName
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
		Left Join
		(
    		Select Min(Material.MATERIALIDENTIFIER) As MaterialID, Plant.Name As PlantName, ItemName.Name As ItemCode
    		From dbo.Plants As Plant
    		Inner Join dbo.MATERIAL As Material
    		On Material.PlantID = Plant.PlantId
    		Inner Join dbo.ItemMaster As ItemMaster
    		On ItemMaster.ItemMasterID = Material.ItemMasterID
    		Inner Join dbo.Name As ItemName
    		On ItemName.NameID = ItemMaster.NameID
    		Group By Plant.Name, ItemName.Name
		) As ExistingMaterial
		On MaterialInfo.PlantCode = ExistingMaterial.PlantName And MaterialInfo.ItemCode = ExistingMaterial.ItemCode
		Inner Join @PlantInfo As PlantInfo
		On MaterialInfo.PlantCode = PlantInfo.PlantName
		Left Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
		On MaterialInfo.ItemCategoryCode = CategoryInfo.Name
		Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As ExistingInfo
		On  MaterialInfo.PlantCode = ExistingInfo.PlantName And
			MaterialInfo.ItemCode = ExistingInfo.ItemCode
		Where ExistingInfo.AutoID Is Null And ExistingMaterial.MaterialID Is Null
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
		Left Join
		(
    		Select Min(Material.MATERIALIDENTIFIER) As MaterialID, Plant.Name As PlantName, ItemName.Name As ItemCode
    		From dbo.Plants As Plant
    		Inner Join dbo.MATERIAL As Material
    		On Material.PlantID = Plant.PlantId
    		Inner Join dbo.ItemMaster As ItemMaster
    		On ItemMaster.ItemMasterID = Material.ItemMasterID
    		Inner Join dbo.Name As ItemName
    		On ItemName.NameID = ItemMaster.NameID
    		Group By Plant.Name, ItemName.Name
		) As ExistingMaterial
		On MaterialInfo.PlantCode = ExistingMaterial.PlantName And MaterialInfo.ItemCode = ExistingMaterial.ItemCode
		Left Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
		On MaterialInfo.ItemCategoryCode = CategoryInfo.Name
		Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As ExistingInfo
		On  MaterialInfo.PlantCode = ExistingInfo.PlantName And
			MaterialInfo.ItemCode = ExistingInfo.ItemCode
		Where ExistingInfo.AutoID Is Null And ExistingMaterial.MaterialID Is Null
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
End
Go
