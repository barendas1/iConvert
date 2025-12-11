Declare @XMLFilePath Nvarchar (600) = '''' + '\\ThePhantom\E$\Documents\Projects\Year 2024\20240417_1728 Import RMCCO Materials And Mixes\'

Declare @PlantXMLDocFilePathAndName Nvarchar (600) = @XMLFilePath + 'Plants.xml' + ''''
Declare @MaterialXMLDocFilePathAndName Nvarchar (600) = @XMLFilePath + 'Materials.xml' + ''''
Declare @MixXMLDocFilePathAndName Nvarchar (600) = @XMLFilePath + 'Mixes.xml' + ''''

Declare @SQLQuery Nvarchar (Max)

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

Declare @PlantXMLDocument Xml
Declare @MaterialXMLDocument Xml
Declare @MixXMLDocument Xml

--=================================================================================================
Set @SQLQuery = 
	'Select Convert(Xml, BulkColumn) As BulkColumn ' +
	'From Openrowset(Bulk ' + @PlantXMLDocFilePathAndName + ', Single_blob) As XMLInfo '

Insert into @PlantXML (XMLInfo)
    Exec (@SQLQuery)

Set @PlantXMLDocument = (Select XMLInfo From @PlantXML)

Raiserror('Retrieving Plants', 0, 0) With Nowait

Insert into Data_Import_RJ.dbo.TestImport0000_XML_Plant (Code, [Description], ShortDescription, MaxBatchSize)
Select	LTrim(RTrim(Replace(Data.Col.value('PlantCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PlantCode,
		LTrim(RTrim(Replace(Data.Col.value('PlantName[1]', 'NVarChar(255)'), Char(160), ' '))) As PlantName,
		LTrim(RTrim(Replace(Data.Col.value('PlantShortName[1]', 'NVarChar(255)'), Char(160), ' '))) As PlantShortName,
		Data.Col.value('MaximumBatchSize[1]', 'Float') As MaximumBatchSize
From @PlantXMLDocument.nodes('/Container/Location/Plants') As Data(Col)
Order By Data.Col.value('PlantCode[1]', 'NVarChar(255)')
Option (Optimize For (@PlantXMLDocument = Null))

Raiserror('Plants Retrieved', 0, 0) With Nowait
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
	Batchable, ItemCategoryCode, ComponentCategoryCode, Cost, CostUnitName,
	BatchPanelCode, DesignUnitName, ItemCode, PlantCode, PriceControl,
	PriceQuantityUnitCode, ProductNumber, ProductCode,
    Description, ProductType, QuantityUnitName, SalesUnitName,
    SpecificGravity, SupplierCode
)
Select	Data.Col.value('Batchable[1]', 'Bit') As Batchable,
		--LTrim(RTrim(Replace(Data.Col.value('Cartagecode[1]', 'NVarChar(255)'), Char(160), ' '))) As Cartagecode,
		LTrim(RTrim(Replace(Data.Col.value('Categorycode[1]', 'NVarChar(255)'), Char(160), ' '))) As Categorycode,
		LTrim(RTrim(Replace(Data.Col.value('ComponentType[1]', 'NVarChar(255)'), Char(160), ' '))) As ComponentType,
		Data.Col.value('Cost[1]', 'Float') As Cost,
		LTrim(RTrim(Replace(Data.Col.value('CostUnitofMeasure[1]', 'NVarChar(255)'), Char(160), ' '))) As CostUnitofMeasure,
		LTrim(RTrim(Replace(Data.Col.value('Crossreference[1]', 'NVarChar(255)'), Char(160), ' '))) As Crossreference,
		LTrim(RTrim(Replace(Data.Col.value('DesignUnitofMeasure[1]', 'NVarChar(255)'), Char(160), ' '))) As DesignUnitofMeasure,
		LTrim(RTrim(Replace(Data.Col.value('Itemcode[1]', 'NVarChar(255)'), Char(160), ' '))) As Itemcode,
		LTrim(RTrim(Replace(Data.Col.value('PlantCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PlantCode,
		LTrim(RTrim(Replace(Data.Col.value('Pricecontrol[1]', 'NVarChar(255)'), Char(160), ' '))) As Pricecontrol,
		LTrim(RTrim(Replace(Data.Col.value('PriceUnitofMeasure[1]', 'NVarChar(255)'), Char(160), ' '))) As PriceUnitofMeasure,
		LTrim(RTrim(Replace(Data.Col.value('ProdNbr[1]', 'NVarChar(255)'), Char(160), ' '))) As ProdNbr,
		LTrim(RTrim(Replace(Data.Col.value('ProductCode[1]', 'NVarChar(255)'), Char(160), ' '))) As ProductCode,
		LTrim(RTrim(Replace(Data.Col.value('ProductDescription[1]', 'NVarChar(255)'), Char(160), ' '))) As ProductDescription,
		LTrim(RTrim(Replace(Data.Col.value('ProductType[1]', 'NVarChar(255)'), Char(160), ' '))) As ProductType,
		LTrim(RTrim(Replace(Data.Col.value('QuantityUnitofMeasure[1]', 'NVarChar(255)'), Char(160), ' '))) As QuantityUnitofMeasure,
		LTrim(RTrim(Replace(Data.Col.value('SalesUnitofMeasure[1]', 'NVarChar(255)'), Char(160), ' '))) As SalesUnitofMeasure,
		Data.Col.value('SpecificGravity[1]', 'Float') As SpecificGravity,
		LTrim(RTrim(Replace(Data.Col.value('SupplierCode[1]', 'NVarChar(255)'), Char(160), ' '))) As SupplierCode
From @MaterialXMLDocument.nodes('/Container/Location/Component') As Data(Col)
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
	BatchPanelCode, AirContent, DesignSlump, DesignType,
	MaximumBatchSize, MixClassCode, Description, MixFormula,
	MixGroup, MixMixingTime, ItemCode, MixTypeCode, MixTypeDescription,
	MixUsageCode, MixUsageDescription, PlantCode, MaxSlump, MinSlump, Strength,
    MaterialSortNumber, MaterialItemCode, MaterialItemDescription,
    Quantity, QuantityUnitName, SpecificGravity
)
Select	--Data.Col.value('../CanModifyPreBatch[1]', 'Bit') As CanModifyPreBatch,
		LTrim(RTrim(Replace(Data.Col.value('../CrossReferenceDefault[1]', 'NVarChar(255)'), Char(160), ' '))) As CrossReferenceDefault,
		Data.Col.value('../DesignAir[1]', 'Float') As DesignAir,
		Data.Col.value('../DesignSlump[1]', 'Float') As DesignSlump,
		LTrim(RTrim(Replace(Data.Col.value('../DesignType[1]', 'NVarChar(255)'), Char(160), ' '))) As DesignType,
		Data.Col.value('../MaximumBatchSize[1]', 'Float') As MaximumBatchSize,
		LTrim(RTrim(Replace(Data.Col.value('../MixClassCode[1]', 'NVarChar(255)'), Char(160), ' '))) As MixClassCode,
		LTrim(RTrim(Replace(Data.Col.value('../MixDescription[1]', 'NVarChar(255)'), Char(160), ' '))) As MixDescription,
		LTrim(RTrim(Replace(Data.Col.value('../MixFormula[1]', 'NVarChar(255)'), Char(160), ' '))) As MixFormula,
		LTrim(RTrim(Replace(Data.Col.value('../MixGroup[1]', 'NVarChar(255)'), Char(160), ' '))) As MixGroup,
		LTrim(RTrim(Replace(Data.Col.value('../MixMixingTime[1]', 'NVarChar(255)'), Char(160), ' '))) As MixMixingTime,
		LTrim(RTrim(Replace(Data.Col.value('../MixNumber[1]', 'NVarChar(255)'), Char(160), ' '))) As MixNumber,
		LTrim(RTrim(Replace(Data.Col.value('../MixTypeCode[1]', 'NVarChar(255)'), Char(160), ' '))) As MixTypeCode,
		LTrim(RTrim(Replace(Data.Col.value('../MixTypeDescription[1]', 'NVarChar(255)'), Char(160), ' '))) As MixTypeDescription,
		LTrim(RTrim(Replace(Data.Col.value('../MixUsageCode[1]', 'NVarChar(255)'), Char(160), ' '))) As MixUsageCode,
		LTrim(RTrim(Replace(Data.Col.value('../MixUsageDescription[1]', 'NVarChar(255)'), Char(160), ' '))) As MixUsageDescription,
		LTrim(RTrim(Replace(Data.Col.value('../PlantCode[1]', 'NVarChar(255)'), Char(160), ' '))) As PlantCode,
		Data.Col.value('../SlumpMaximum[1]', 'Float') As SlumpMaximum,
		Data.Col.value('../SlumpMinimum[1]', 'Float') As SlumpMinimum,
		Data.Col.value('../Strength[1]', 'Float') As Strength,
		LTrim(RTrim(Replace(Data.Col.value('BatchingSequence[1]', 'NVarChar(255)'), Char(160), ' '))) As BatchingSequence,
		LTrim(RTrim(Replace(Data.Col.value('ConstituentCode[1]', 'NVarChar(255)'), Char(160), ' '))) As ConstituentCode,
		LTrim(RTrim(Replace(Data.Col.value('ConstituentDescription[1]', 'NVarChar(255)'), Char(160), ' '))) As ConstituentDescription,
		Data.Col.value('Dosage[1]', 'Float') As Dosage,
		LTrim(RTrim(Replace(Data.Col.value('DosageUnitofmeasure[1]', 'NVarChar(255)'), Char(160), ' '))) As DosageUnitofmeasure,
		--LTrim(RTrim(Replace(Data.Col.value('MixNumber[1]', 'NVarChar(255)'), Char(160), ' '))) As ComponentMixNumber,
		--LTrim(RTrim(Replace(Data.Col.value('PlantCode[1]', 'NVarChar(255)'), Char(160), ' '))) As ComponentPlantCode,
		Data.Col.value('SpecificGravity[1]', 'Float') As SpecificGravity
From @MixXMLDocument.nodes('/Container/Location/MixHeader/Constituents') As Data(Col)
Order By    LTrim(RTrim(Replace(Data.Col.value('../PlantCode[1]', 'NVarChar(255)'), Char(160), ' '))),
            LTrim(RTrim(Replace(Data.Col.value('../MixNumber[1]', 'NVarChar(255)'), Char(160), ' '))),
            LTrim(RTrim(Replace(Data.Col.value('ConstituentCode[1]', 'NVarChar(255)'), Char(160), ' ')))
Option (Optimize For (@MixXMLDocument = Null))

Raiserror('Mixes Retrieved', 0, 0) With Nowait
--=================================================================================================
