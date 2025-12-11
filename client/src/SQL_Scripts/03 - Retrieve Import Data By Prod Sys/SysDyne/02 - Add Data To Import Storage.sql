Declare @XMLFilePath Nvarchar (600) = '''' + '\\iServiceData5\E$\Documents\RJ\Import_Data\BostonConcrete\'

Declare @LocationXMLDocFilePathAndName Nvarchar (600) = @XMLFilePath + 'Locations.xml' + ''''
Declare @PlantXMLDocFilePathAndName Nvarchar (600) = @XMLFilePath + 'Plants.xml' + ''''
Declare @MaterialXMLDocFilePathAndName Nvarchar (600) = @XMLFilePath + 'Materials.xml' + ''''
Declare @MixXMLDocFilePathAndName Nvarchar (600) = @XMLFilePath + 'Mixes.xml' + ''''
Declare @ItemCategoryXMLDocFilePathAndName Nvarchar (600) = @XMLFilePath + 'ItemCategories.xml' + ''''
Declare @ItemTypeXMLDocFilePathAndName Nvarchar (600) = @XMLFilePath + 'ItemTypes.xml' + ''''

Declare @SQLQuery Nvarchar (Max)

Declare @LocationXML Table
(
	XMLInfo Xml
)

Declare @PlantXML Table
(
	XMLInfo Xml
)

Declare @MaterialXML Table
(
	XMLInfo Xml
)

Declare @MixXML Table
(
	XMLInfo Xml
)

Declare @ItemCategoryXML Table
(
	XMLInfo Xml
)

Declare @ItemTypeXML Table
(
	XMLInfo Xml
)

Declare @LocationXMLDocument Xml
Declare @PlantXMLDocument Xml
Declare @MaterialXMLDocument Xml
Declare @MixXMLDocument Xml
Declare @ItemCategoryXMLDocument Xml
Declare @ItemTypeXMLDocument Xml


--=================================================================================================
Set @SQLQuery = 
	'Select Convert(Xml, BulkColumn) As BulkColumn ' +
	'From Openrowset(Bulk ' + @LocationXMLDocFilePathAndName + ', Single_blob) As XMLInfo '

Insert into @LocationXML (XMLInfo)
    Exec (@SQLQuery)
    
Set @LocationXMLDocument = (Select XMLInfo From @LocationXML)

Raiserror('Retrieving Locations', 0, 0) With Nowait

Insert into Data_Import_RJ.dbo.TestImport0000_XML_Location (LocationID, Code, Name, ShortName, DivisionName)
Select  Data.Col.value('ID[1]', 'Int') As PlantID,
        LTrim(RTrim(Replace(Data.Col.value('Code[1]', 'NVarChar(255)'), Char(160), ' '))) As Code,
		LTrim(RTrim(Replace(Data.Col.value('Name[1]', 'NVarChar(255)'), Char(160), ' '))) As Name,
		LTrim(RTrim(Replace(Data.Col.value('ShortName[1]', 'NVarChar(255)'), Char(160), ' '))) As ShortName,
		LTrim(RTrim(Replace(Data.Col.value('Divisions[1]/Division[1]/Name[1]', 'NVarChar(255)'), Char(160), ' '))) As DivisionName
From @LocationXMLDocument.nodes('/WebcreteXML/WebcreteXMLMsgsRs/LocationQueryRs/LocationRet') As Data(Col)
Left Join Data_Import_RJ.dbo.TestImport0000_XML_Location As ExistingLocation
On Data.Col.value('ID[1]', 'Int') = ExistingLocation.LocationID
Where ExistingLocation.LocationID Is Null
Order By LTrim(RTrim(Replace(Data.Col.value('Code[1]', 'NVarChar(255)'), Char(160), ' ')))
Option (Optimize For (@LocationXMLDocument = Null))

Raiserror('Locations Retrieved', 0, 0) With Nowait
--=================================================================================================
Set @SQLQuery = 
	'Select Convert(Xml, BulkColumn) As BulkColumn ' +
	'From Openrowset(Bulk ' + @PlantXMLDocFilePathAndName + ', Single_blob) As XMLInfo '

Insert into @PlantXML (XMLInfo)
    Exec (@SQLQuery)

Set @PlantXMLDocument = (Select XMLInfo From @PlantXML)

Raiserror('Retrieving Plants', 0, 0) With Nowait

Insert into Data_Import_RJ.dbo.TestImport0000_XML_Plant (PlantID, Code, [Description], ShortDescription, LocationID, LocationCode, MaxBatchSize, MaxBatchSizeUnitName)
Select  Data.Col.value('ID[1]', 'Int') As PlantID,
        LTrim(RTrim(Replace(Data.Col.value('Code[1]', 'NVarChar(255)'), Char(160), ' '))) As Code,
		LTrim(RTrim(Replace(Data.Col.value('Description[1]', 'NVarChar(255)'), Char(160), ' '))) As Description,
		LTrim(RTrim(Replace(Data.Col.value('ShortDescription[1]', 'NVarChar(255)'), Char(160), ' '))) As ShortDescription,
		Data.Col.value('LocationID[1]', 'Int') As LocationID,
		LTrim(RTrim(Replace(Data.Col.value('LocationCode[1]', 'NVarChar(255)'), Char(160), ' '))) As LocationCode,
		Data.Col.value('MaxBatchSize[1]', 'Float') As MaxBatchSize,
		LTrim(RTrim(Replace(Data.Col.value('MaxBatchSizeUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As MaxBatchSizeUnit
From @PlantXMLDocument.nodes('/WebcreteXML/WebcreteXMLMsgsRs/PlantQueryRs/PlantRet') As Data(Col)
Left Join Data_Import_RJ.dbo.TestImport0000_XML_Plant As ExistingPlant
On Data.Col.value('ID[1]', 'Int') = ExistingPlant.PlantID
Where ExistingPlant.PlantID Is Null
Order By LTrim(RTrim(Replace(Data.Col.value('Code[1]', 'NVarChar(255)'), Char(160), ' ')))
Option (Optimize For (@PlantXMLDocument = Null))

Raiserror('Plants Retrieved', 0, 0) With Nowait
--=================================================================================================
Set @SQLQuery = 
	'Select Convert(Xml, BulkColumn) As BulkColumn ' +
	'From Openrowset(Bulk ' + @ItemCategoryXMLDocFilePathAndName + ', Single_blob) As XMLInfo '

Insert into @ItemCategoryXML (XMLInfo)
    Exec (@SQLQuery)

Set @ItemCategoryXMLDocument = (Select XMLInfo From @ItemCategoryXML)

Raiserror('Retrieving Item Categories', 0, 0) With Nowait

Insert into Data_Import_RJ.dbo.TestImport0000_XML_ItemCategory (ItemCategoryID, Code, [Description], ShortDescription, ItemTypeID, ItemTypeName)
Select  Data.Col.value('ID[1]', 'Int') As ItemCategoryID,
        LTrim(RTrim(Replace(Data.Col.value('Code[1]', 'NVarChar(255)'), Char(160), ' '))) As Code,
		LTrim(RTrim(Replace(Data.Col.value('Description[1]', 'NVarChar(255)'), Char(160), ' '))) As Description,
		LTrim(RTrim(Replace(Data.Col.value('ShortDescription[1]', 'NVarChar(255)'), Char(160), ' '))) As ShortDescription,
		Data.Col.value('ItemTypeID[1]', 'Int') As ItemTypeID,
		LTrim(RTrim(Replace(Data.Col.value('ItemType[1]', 'NVarChar(255)'), Char(160), ' '))) As ItemTypeName
From @ItemCategoryXMLDocument.nodes('/WebcreteXML/WebcreteXMLMsgsRs/ItemCategoryQueryRs/ItemCategoryRet') As Data(Col)
Left Join Data_Import_RJ.dbo.TestImport0000_XML_ItemCategory As ExistingCategory
On Data.Col.value('ID[1]', 'Int') = ExistingCategory.ItemCategoryID
Where ExistingCategory.ItemCategoryID Is Null
Order By LTrim(RTrim(Replace(Data.Col.value('Code[1]', 'NVarChar(255)'), Char(160), ' ')))
Option (Optimize For (@ItemCategoryXMLDocument = Null))

Raiserror('Item Categories Retrieved', 0, 0) With Nowait
--=================================================================================================
Set @SQLQuery = 
	'Select Convert(Xml, BulkColumn) As BulkColumn ' +
	'From Openrowset(Bulk ' + @ItemTypeXMLDocFilePathAndName + ', Single_blob) As XMLInfo '

Insert into @ItemTypeXML (XMLInfo)
    Exec (@SQLQuery)

Set @ItemTypeXMLDocument = (Select XMLInfo From @ItemTypeXML)

Raiserror('Retrieving Item Types', 0, 0) With Nowait

Insert into Data_Import_RJ.dbo.TestImport0000_XML_ItemType (ItemTypeID, Name, [Description])
Select  Data.Col.value('ID[1]', 'Int') As ItemTypeID,
        LTrim(RTrim(Replace(Data.Col.value('Name[1]', 'NVarChar(255)'), Char(160), ' '))) As Name,
		LTrim(RTrim(Replace(Data.Col.value('Description[1]', 'NVarChar(255)'), Char(160), ' '))) As Description
From @ItemTypeXMLDocument.nodes('/WebcreteXML/WebcreteXMLMsgsRs/ItemTypeQueryRs/ItemTypeRet') As Data(Col)
Left Join Data_Import_RJ.dbo.TestImport0000_XML_ItemType As ExistingItemType
On Data.Col.value('ID[1]', 'Int') = ExistingItemType.ItemTypeID
Where ExistingItemType.ItemTypeID Is Null
Order By LTrim(RTrim(Replace(Data.Col.value('Name[1]', 'NVarChar(255)'), Char(160), ' ')))
Option (Optimize For (@ItemTypeXMLDocument = Null))

Raiserror('Item Types Retrieved', 0, 0) With Nowait
--=================================================================================================
Set @SQLQuery = 
	'Select Convert(Xml, BulkColumn) As BulkColumn ' +
	'From Openrowset(Bulk ' + @MaterialXMLDocFilePathAndName + ', Single_blob) As XMLInfo '

Insert into @MaterialXML (XMLInfo)
    Exec (@SQLQuery)

Set @MaterialXMLDocument = (Select XMLInfo From @MaterialXML)

Raiserror('Retrieving Materials', 0, 0) With Nowait

Insert into Data_Import_RJ.dbo.TestImport0000_XML_Material
(
	PlantID, PlantCode, MaterialID, ItemCode, ItemCategoryCode, [Description],
	ShortDescription, ItemTypeID, ItemTypeName, DoNotAllowTicketing,
	OrderedQuantityUnitCode, OrderedQuantityUnit, DeliveredQuantityUnitCode,
	DeliveredQuantityUnit, PriceQuantityUnitCode, PriceQuantityUnit, BatchUnitCode,
	BatchUnit, InventoryUnitCode, InventoryUnit, PurchaseUnitCode, PurchaseUnit,
	ReportingUnitCode, ReportingUnit, Cost, CostExtensionCode, SpecificGravity,
	MoisturePercent, 
	Price, PriceCategoryCode, PriceCategoryName, PriceExtensionCode,
	Price2, PriceCategoryCode2, PriceCategoryName2, PriceExtensionCode2,
	Price3, PriceCategoryCode3, PriceCategoryName3, PriceExtensionCode3
)
Select  Data.Col.value('LocationID[1]', 'Int') As PlantID,
		LTrim(RTrim(Replace(Data.Col.value('LocationCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PlantCode,
        Data.Col.value('../../ID[1]', 'Int') As MaterialID,
        LTrim(RTrim(Replace(Data.Col.value('../../Code[1]', 'NVarChar(255)'), Char(160), ' '))) As ItemCode,
        LTrim(RTrim(Replace(Data.Col.value('../../CategoryCode[1]', 'NVarChar(255)'), Char(160), ' '))) As ItemCategoryCode,
		LTrim(RTrim(Replace(Data.Col.value('../../Description[1]', 'NVarChar(255)'), Char(160), ' '))) As Description,
		LTrim(RTrim(Replace(Data.Col.value('../../ShortDescription[1]', 'NVarChar(255)'), Char(160), ' '))) As ShortDescription,
		Data.Col.value('../../ItemTypeID[1]', 'Int') As ItemTypeID,
		LTrim(RTrim(Replace(Data.Col.value('../../ItemType[1]', 'NVarChar(255)'), Char(160), ' '))) As ItemTypeName,
		Data.Col.value('../../DoNotAllowTicketing[1]', 'Bit') As DoNotAllowTicketing,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/OrderedQuantityUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As OrderedQuantityUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/OrderedQuantityUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As OrderedQuantityUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/DeliveredQuantityUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As DeliveredQuantityUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/DeliveredQuantityUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As DeliveredQuantityUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/PriceQuantityUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceQuantityUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/PriceQuantityUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceQuantityUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/BatchUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As BatchUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/BatchUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As BatchUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/InventoryUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As InventoryUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/InventoryUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As InventoryUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/PurchaseUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PurchaseUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/PurchaseUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As PurchaseUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/ReportingUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As ReportingUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../UOM[1]/ReportingUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As ReportingUnit,
		Data.Col.value('Cost[1]/StandardCost[1]', 'Float') As Cost,
		LTrim(RTrim(Replace(Data.Col.value('Cost[1]/CostExtensionCode[1]', 'NVarChar(255)'), Char(160), ' '))) As CostExtensionCode,
		Data.Col.value('Batching[1]/SpecificGravity[1]', 'Float') As SpecificGravity,
		Data.Col.value('Batching[1]/MoisturePercent[1]', 'Float') As MoisturePercent,
		Data.Col.value('Pricings[1]/Pricing[1]/Price[1]', 'Float') As Price,
		LTrim(RTrim(Replace(Data.Col.value('Pricings[1]/Pricing[1]/PriceCategoryCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceCategoryCode,
		LTrim(RTrim(Replace(Data.Col.value('Pricings[1]/Pricing[1]/PriceCategoryName[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceCategoryName,
		LTrim(RTrim(Replace(Data.Col.value('Pricings[1]/Pricing[1]/PriceExtensionCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceExtensionCode,
		Data.Col.value('Pricings[1]/Pricing[2]/Price[1]', 'Float') As Price,
		LTrim(RTrim(Replace(Data.Col.value('Pricings[1]/Pricing[2]/PriceCategoryCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceCategoryCode,
		LTrim(RTrim(Replace(Data.Col.value('Pricings[1]/Pricing[2]/PriceCategoryName[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceCategoryName,
		LTrim(RTrim(Replace(Data.Col.value('Pricings[1]/Pricing[2]/PriceExtensionCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceExtensionCode,
		Data.Col.value('Pricings[1]/Pricing[3]/Price[1]', 'Float') As Price,
		LTrim(RTrim(Replace(Data.Col.value('Pricings[1]/Pricing[3]/PriceCategoryCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceCategoryCode,
		LTrim(RTrim(Replace(Data.Col.value('Pricings[1]/Pricing[3]/PriceCategoryName[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceCategoryName,
		LTrim(RTrim(Replace(Data.Col.value('Pricings[1]/Pricing[3]/PriceExtensionCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceExtensionCode
From @MaterialXMLDocument.nodes('/WebcreteXML/WebcreteXMLMsgsRs/ItemQueryRs/ItemRet/Locations/Location') As Data(Col)
Left Join Data_Import_RJ.dbo.TestImport0000_XML_Material As ExistingMaterial
On  Data.Col.value('LocationID[1]', 'Int') = ExistingMaterial.PlantID And
    Data.Col.value('../../ID[1]', 'Int') = ExistingMaterial.MaterialID
Where ExistingMaterial.AutoID Is Null
Order By LTrim(RTrim(Replace(Data.Col.value('LocationCode[1]', 'NVarChar(255)'), Char(160), ' '))), LTrim(RTrim(Replace(Data.Col.value('../../Description[1]', 'NVarChar(255)'), Char(160), ' ')))
Option (Optimize For (@MaterialXMLDocument = Null))

Raiserror('Materials Retrieved', 0, 0) With Nowait
--=================================================================================================
Set @SQLQuery = 
	'Select Convert(Xml, BulkColumn) As BulkColumn ' +
	'From Openrowset(Bulk ' + @MixXMLDocFilePathAndName + ', Single_blob) As XMLInfo '

Insert into @MixXML (XMLInfo)
    Exec (@SQLQuery)

Set @MixXMLDocument = (Select XMLInfo From @MixXML)

Raiserror('Retrieving Mixes', 0, 0) With Nowait

Insert into Data_Import_RJ.dbo.TestImport0000_XML_Mix
(
	PlantID, PlantCode, MixID, ItemCode, ItemCategoryCode, [Description],
	ShortDescription, ItemTypeID, ItemTypeName, DoNotAllowTicketing,
	OrderedQuantityUnitCode, OrderedQuantityUnit, DeliveredQuantityUnitCode,
	DeliveredQuantityUnit, PriceQuantityUnitCode, PriceQuantityUnit, BatchUnitCode,
	BatchUnit, InventoryUnitCode, InventoryUnit, PurchaseUnitCode, PurchaseUnit,
	ReportingUnitCode, ReportingUnit, StrengthAge, Strength, StrengthUnitName,
	PercentAirVolume, Slump, WaterCementRatio, AggregateSize, CementType,
	MaximumWater, MinCementContent, WaterHoldback, LightweightCubicFeet,
	MaximumBatchSize, MaterialSortNumber, MaterialItemID, MaterialItemCode,
	MaterialItemDescription, Quantity, DosageQuantity, QuantityUnitName
)
Select  Data.Col.value('../../LocationID[1]', 'Int') As PlantID,
		LTrim(RTrim(Replace(Data.Col.value('../../LocationCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PlantCode,
        Data.Col.value('../../../../ID[1]', 'Int') As MixID,
        LTrim(RTrim(Replace(Data.Col.value('../../../../Code[1]', 'NVarChar(255)'), Char(160), ' '))) As ItemCode,
        LTrim(RTrim(Replace(Data.Col.value('../../../../CategoryCode[1]', 'NVarChar(255)'), Char(160), ' '))) As ItemCategoryCode,
		LTrim(RTrim(Replace(Data.Col.value('../../../../Description[1]', 'NVarChar(255)'), Char(160), ' '))) As Description,
		LTrim(RTrim(Replace(Data.Col.value('../../../../ShortDescription[1]', 'NVarChar(255)'), Char(160), ' '))) As ShortDescription,
		Data.Col.value('../../../../ItemTypeID[1]', 'Int') As ItemTypeID,
		LTrim(RTrim(Replace(Data.Col.value('../../../../ItemType[1]', 'NVarChar(255)'), Char(160), ' '))) As ItemTypeName,
		Data.Col.value('../../../../DoNotAllowTicketing[1]', 'Bit') As DoNotAllowTicketing,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/OrderedQuantityUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As OrderedQuantityUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/OrderedQuantityUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As OrderedQuantityUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/DeliveredQuantityUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As DeliveredQuantityUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/DeliveredQuantityUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As DeliveredQuantityUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/PriceQuantityUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceQuantityUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/PriceQuantityUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceQuantityUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/BatchUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As BatchUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/BatchUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As BatchUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/InventoryUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As InventoryUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/InventoryUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As InventoryUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/PurchaseUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PurchaseUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/PurchaseUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As PurchaseUnit,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/ReportingUnitCode[1]', 'NVarChar(255)'), Char(160), ' '))) As ReportingUnitCode,
		LTrim(RTrim(Replace(Data.Col.value('../../../../UOM[1]/ReportingUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As ReportingUnit,

        Data.Col.value('../../../../Mix[1]/DaysToStrength[1]', 'Float') As StrengthAge,
        Data.Col.value('../../../../Mix[1]/Strength[1]', 'Float') As Strength,
        LTrim(RTrim(Replace(Data.Col.value('../../../../Mix[1]/StrengthUnit[1]', 'NVarChar(255)'), Char(160), ' '))) As StrengthUnitName,
        Data.Col.value('../../../../Mix[1]/PercentAirVolume[1]', 'Float') As PercentAirVolume,
        LTrim(RTrim(Replace(Data.Col.value('../../../../Mix[1]/Slump[1]', 'NVarChar(255)'), Char(160), ' '))) As Slump,
        Data.Col.value('../../../../Mix[1]/WaterCementRatio[1]', 'Float') As WaterCementRatio,
        LTrim(RTrim(Replace(Data.Col.value('../../../../Mix[1]/AggregateSize[1]', 'NVarChar(255)'), Char(160), ' '))) As AggregateSize,
        LTrim(RTrim(Replace(Data.Col.value('../../../../Mix[1]/CementType[1]', 'NVarChar(255)'), Char(160), ' '))) As CementType,
        Data.Col.value('../../../../Mix[1]/MaximumWater[1]', 'Float') As MaximumWater,
        Data.Col.value('../../../../Mix[1]/MinCementContent[1]', 'Float') As MinCementContent,
        Data.Col.value('../../../../Mix[1]/WaterHoldback[1]', 'Float') As WaterHoldback,
        Data.Col.value('../../../../Mix[1]/LightweightCubicFeet[1]', 'Float') As LightweightCubicFeet,

		Data.Col.value('../../Batching[1]/MaximumBatchSize[1]', 'Float') As MaximumBatchSize,
		
		Data.Col.value('Sort[1]', 'Int') As MaterialSortNumber,
		Data.Col.value('ItemID[1]', 'Int') As MaterialItemID,
		LTrim(RTrim(Replace(Data.Col.value('Code[1]', 'NVarChar(255)'), Char(160), ' '))) As MaterialItemCode,
		LTrim(RTrim(Replace(Data.Col.value('Description[1]', 'NVarChar(255)'), Char(160), ' '))) As MaterialItemDescription,
		Data.Col.value('Quantity[1]', 'Float') As Quantity,
		Data.Col.value('DosageQuantity[1]', 'Float') As DosageQuantity,
		LTrim(RTrim(Replace(Data.Col.value('Unit[1]', 'NVarChar(255)'), Char(160), ' '))) As QuantityUnitName
From @MixXMLDocument.nodes('/WebcreteXML/WebcreteXMLMsgsRs/ItemQueryRs/ItemRet/Locations/Location/MixDesign/Material') As Data(Col)
Order By    
            LTrim(RTrim(Replace(Data.Col.value('../../../../Code[1]', 'NVarChar(255)'), Char(160), ' '))),
            LTrim(RTrim(Replace(Data.Col.value('../../LocationCode[1]', 'NVarChar(255)'), Char(160), ' '))),
            Data.Col.value('Sort[1]', 'Int'),
            LTrim(RTrim(Replace(Data.Col.value('Code[1]', 'NVarChar(255)'), Char(160), ' ')))
Option (Optimize For (@MixXMLDocument = Null))

Raiserror('Mixes Retrieved', 0, 0) With Nowait
