If Exists (Select * From sys.views Where Object_id = Object_id(N'[dbo].[RptMixSpecSpread]'))
Begin
    Drop View [dbo].[RptMixSpecSpread]
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
Create View [dbo].[RptMixSpecSpread] As
Select  MixSpec.MixSpecID              As MixSpecID,
        MixSpec.Name                   As Name,
        MixSpec.[Description]          As Description,
        MixSpec.UserDefGradingID       As UserDefinedGradingID,
        MixSpec.SharedGradingID        As StandardGradingID,
        SpecDataPoint.SpecDataPointID  As SpecDataPointID,
        SpecMeas.SpecMeasID            As SpecMeasID,
        SpecMeas.MeasTypeID            As MeasTypeID,
        SpecMeas.MinValue              As MinSpread,
        SpecMeas.MaxValue              As MaxSpread,
        SpecMeas.UnitsLink             As SpreadUnitsID
    From dbo.MixSpec                   As MixSpec
    Inner Join dbo.SpecDataPoint       As SpecDataPoint
    On  SpecDataPoint.MixSpecID = MixSpec.MixSpecID
    Inner Join dbo.SpecMeas            As SpecMeas
    On  SpecMeas.SpecDataPointID = SpecDataPoint.SpecDataPointID
    Where   Isnull(SpecMeas.MeasTypeID, -1) = 32
Go

Select	Plants.Name,
		MixNameInfo.Name,
		MixInfo.StrengthAge, 
		MixInfo.Strength,
		StrengthSpec.AgeMaxValue, 
		StrengthSpec.StrengthMaxValue
From dbo.Plants As Plants
Inner Join dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join dbo.Name As MixNameInfo
On MixNameInfo.NameID = Mix.NameID
Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
On	Plants.Name = MixInfo.PlantCode And
	MixNameInfo.Name = MixInfo.MixCode
Inner Join
(
	Select Min(MixInfo.AutoID) As AutoID
	From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
	Group By MixInfo.PlantCode, MixInfo.MixCode
) As FirstMix
On FirstMix.AutoID = MixInfo.AutoID
Left Join dbo.RptMixSpecAgeComprStrengths As StrengthSpec
On Mix.MixSpecID = StrengthSpec.MixSpecID
Where	Isnull(MixInfo.StrengthAge, -1.0) <> Isnull(StrengthSpec.AgeMaxValue, -1.0) Or
		Isnull(MixInfo.Strength, -1.0) <> Isnull(StrengthSpec.StrengthMaxValue, -1.0) 

Select	Plants.Name,
		MixNameInfo.Name,
		ItemName.Name,
		Mix.BatchPanelCode,
		MixInfo.MixCode,
		MixDescription.[Description],
		ItemDescription.[Description],
		Mix.BatchPanelDescription,
		MixInfo.MixDescription,
		ItemMaster.ItemShortDescription,
		MixInfo.MixShortDescription,
		ItemCategoryInfo.ItemCategory,
		MixInfo.ItemCategory,
		MixInfo.AirContent,
		MixInfo.MinAirContent, 
		MixInfo.MaxAirContent,
		Mix.AIR,
		AirContentSpec.MinAirContent, 
		AirContentSpec.MaxAirContent,
		MixInfo.Slump, 
		MixInfo.MinSlump, 
		MixInfo.MaxSlump,
		Round(Mix.SLUMP, 6),
		SlumpSpec.MinSlump, 
		SlumpSpec.MaxSlump,
		Mix.MixTargetSpread,
		SpreadSpec.MinSpread, 
		SpreadSpec.MaxSpread
From dbo.Plants As Plants
Inner Join dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join dbo.Name As MixNameInfo
On MixNameInfo.NameID = Mix.NameID
Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
On	Plants.Name = MixInfo.PlantCode And
	MixNameInfo.Name = MixInfo.MixCode
Inner Join
(
	Select Min(MixInfo.AutoID) As AutoID
	From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
	Group By MixInfo.PlantCode, MixInfo.MixCode
) As FirstMix
On FirstMix.AutoID = MixInfo.AutoID
Left Join dbo.[Description] As MixDescription
On MixDescription.DescriptionID = Mix.DescriptionID
Left Join dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Mix.ItemMasterID
Left Join dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Left Join dbo.[Description] As ItemDescription
On ItemDescription.DescriptionID = ItemMaster.DescriptionID
Left Join dbo.ProductionItemCategory As ItemCategoryInfo
On	MixInfo.ItemCategory = ItemCategoryInfo.ItemCategory And
	ItemCategoryInfo.ProdItemCatType = 'Mix'
Left Join dbo.RptMixSpecAirContent As AirContentSpec
On Mix.MixSpecID = AirContentSpec.MixSpecID
Left Join dbo.RptMixSpecSlump As SlumpSpec
On Mix.MixSpecID = SlumpSpec.MixSpecID
Left Join dbo.RptMixSpecSpread As SpreadSpec
On Mix.MixSpecID = SpreadSpec.MixSpecID
Where	Ltrim(Rtrim(Isnull(MixInfo.MixCode, ''))) <> Ltrim(Rtrim(Isnull(ItemName.Name, ''))) Or
		Ltrim(Rtrim(Isnull(MixInfo.MixCode, ''))) <> Ltrim(Rtrim(Isnull(Mix.BatchPanelCode, ''))) Or
		Ltrim(Rtrim(Isnull(MixInfo.MixDescription, ''))) <> Ltrim(Rtrim(Isnull(MixDescription.[Description], ''))) Or
		Ltrim(Rtrim(Isnull(MixInfo.MixDescription, ''))) <> Ltrim(Rtrim(Isnull(ItemDescription.[Description], ''))) Or
		Ltrim(Rtrim(Isnull(MixInfo.MixDescription, ''))) <> Ltrim(Rtrim(Isnull(Mix.BatchPanelDescription, ''))) Or
		Ltrim(Rtrim(Isnull(MixInfo.ItemCategory, ''))) <> Ltrim(Rtrim(Isnull(ItemCategoryInfo.ItemCategory, ''))) Or
		Case When Ltrim(Rtrim(Isnull(MixInfo.MixShortDescription, ''))) <> '' Then RTrim(Left(Ltrim(Rtrim(Isnull(MixInfo.MixShortDescription, ''))), 16)) Else RTrim(Left(Ltrim(Rtrim(Isnull(MixInfo.MixDescription, ''))), 16)) End <> Ltrim(Rtrim(Isnull(ItemMaster.ItemShortDescription, ''))) Or
		Round(Isnull(MixInfo.AirContent, 1.5), 8) <> Round(Isnull(Mix.AIR, -1.0), 8) Or
		Round(Isnull(MixInfo.MinAirContent, -1.0), 8) <> Round(Isnull(AirContentSpec.MinAirContent, -1.0), 8) Or
		Round(Isnull(MixInfo.MaxAirContent, -1.0), 8) <> Round(Isnull(AirContentSpec.MaxAirContent, -1.0), 8) Or
		(Round(Isnull(MixInfo.Slump, -1.0), 6) <= 12.0 * 25.4 And Round(Isnull(MixInfo.Slump, -1.0), 6) <= 12.0 * 25.4 And Round(Isnull(MixInfo.Slump, -1.0), 6) <= 12.0 * 25.4) And
		(
			Round(Isnull(MixInfo.Slump, -1.0), 6) <> Round(Isnull(Mix.SLUMP, -1.0), 6) Or
			Isnull(MixInfo.MinSlump, -1.0) <> Isnull(SlumpSpec.MinSlump, -1.0) Or
			Isnull(MixInfo.MaxSlump, -1.0) <> Isnull(SlumpSpec.MaxSlump, -1.0)
		) Or
		(Round(Isnull(MixInfo.Slump, -1.0), 6) > 12.0 * 25.4 Or Round(Isnull(MixInfo.Slump, -1.0), 6) > 12.0 * 25.4 Or Round(Isnull(MixInfo.Slump, -1.0), 6) > 12.0 * 25.4) And
		(
			Round(Isnull(MixInfo.Slump, -1.0), 6) <> Round(Isnull(Mix.MixTargetSpread, -1.0), 6) Or
			Isnull(MixInfo.MinSlump, -1.0) <> Isnull(SpreadSpec.MinSpread, -1.0) Or
			Isnull(MixInfo.MaxSlump, -1.0) <> Isnull(SpreadSpec.MaxSpread, -1.0)
		) 
		
Declare @CementitiousInfo Table
(
	MixID Int Primary Key,
	TotalQuantity Float
)

Insert into @CementitiousInfo (MixID, TotalQuantity)
	Select MaterialRecipe.EntityID, Sum(Isnull(MaterialRecipe.Quantity, 0.0))
	From dbo.MaterialRecipe As MaterialRecipe
	Inner Join dbo.MATERIAL As Material
	On Material.MATERIALIDENTIFIER = MaterialRecipe.MaterialID
	Where	Material.FamilyMaterialTypeID In (2, 4) And
			MaterialRecipe.EntityType = 'Mix'
	Group By MaterialRecipe.EntityID
		
Select	Plants.Name,
		MixNameInfo.Name,
		MixRecipe.MaterialItemCode, 
		MixRecipe.MaterialItemDescription,
		MixRecipe.Quantity, 
		MixRecipe.QuantityUnitName
From dbo.Plants As Plants
Inner Join dbo.Batch As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join dbo.Name As MixNameInfo
On MixNameInfo.NameID = Mix.NameID
Left Join @CementitiousInfo As CementitiousInfo
On Mix.BATCHIDENTIFIER = CementitiousInfo.MixID
Inner Join dbo.MaterialRecipe As MaterialRecipe
On MaterialRecipe.EntityID = Mix.BATCHIDENTIFIER
Inner Join dbo.MATERIAL As Material
On Material.MATERIALIDENTIFIER = MaterialRecipe.MaterialID
Inner Join dbo.ItemMaster As MtrlProdItem
On MtrlProdItem.ItemMasterID = Material.ItemMasterID
Inner Join dbo.Name As MtrlItemCode
On MtrlItemCode.NameID = MtrlProdItem.NameID
Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo AS MixRecipe
On	Plants.Name = MixRecipe.PlantCode And
	MixNameInfo.Name = MixRecipe.MixCode And
	MtrlItemCode.Name = MixRecipe.MaterialItemCode
Where	Round(IsNull(MixRecipe.Quantity, -1.0), 6) <>
		Case
			When Isnull(MaterialRecipe.QUANTITY, -1.0) < 0.0
			Then -1.0
			When MixRecipe.QuantityUnitName In ('CW', 'oz/cwt CM')
			Then Round(MaterialRecipe.QUANTITY * 100.0 / (Material.SPECGR * 0.0651984837440621 * CementitiousInfo.TotalQuantity), 6)
			When MixRecipe.QuantityUnitName In ('GA', 'GL', 'GAL', 'GALLONS')
			Then Round(MaterialRecipe.QUANTITY * 0.26417205 / (Material.SPECGR * 1.0), 6)
			When MixRecipe.QuantityUnitName In ('LB', 'Pounds')
			Then Round(MaterialRecipe.QUANTITY * 2.204622476, 6)
			When MixRecipe.QuantityUnitName In ('OZ', 'LQ OZ', 'Ounces')
			Then Round(MaterialRecipe.QUANTITY / (Material.SPECGR * 0.0651984837440621 * 0.45359240000781), 6)
			When MixRecipe.QuantityUnitName = 'KG'
			Then Round(MaterialRecipe.QUANTITY, 6)
			When MixRecipe.QuantityUnitName = 'GR'
			Then Round(MaterialRecipe.QUANTITY, 6) * 1000.0
			When MixRecipe.QuantityUnitName In ('L', 'LT')
			Then Round(MaterialRecipe.QUANTITY / Material.SPECGR / 1.0, 6)
			When MixRecipe.QuantityUnitName In ('ML', 'CC')
			Then Round(MaterialRecipe.QUANTITY / Material.SPECGR / 1.0 * 1000.0, 6)
			When MixRecipe.QuantityUnitName In ('Each', 'Bag')
			Then Round(MaterialRecipe.QUANTITY, 6)
			When MixRecipe.QuantityUnitName In ('Cubic Yards')
			Then Round(MaterialRecipe.QUANTITY / (201.974026 * Material.SPECGR * 1.0) * 0.26417205, 6)
			Else -1.0
		End
Go

If Exists (Select * From sys.views Where Object_id = Object_id(N'[dbo].[RptMixSpecSpread]'))
Begin
    Drop View [dbo].[RptMixSpecSpread]
End
Go
