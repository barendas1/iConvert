--> This SQL Query retrieves the Mixes that are in the specified Plants and that are not already in the Quadrel Database.

Declare @PlantInfo Table (PlantName Nvarchar (100))

If Exists (Select * From INFORMATION_SCHEMA.TABLES As TableInfo Where TableInfo.TABLE_NAME = 'ACIBatchViewDetails')
Begin
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
		Insert into Data_Import_RJ.dbo.TestImport0000_MixInfo 
		(
			PlantCode, MixCode, MixDescription, MixShortDescription, ItemCategory,
			StrengthAge, Strength, AirContent, MinAirContent, MaxAirContent, Slump,
			MinSlump, MaxSlump, AggregateSize, MaxLoadSize, MaximumWater, SackContent,
			MaxWCRatio, MaterialItemCode, MaterialItemDescription, Quantity,
			QuantityUnitName, DosageQuantity, SortNumber
		)
		Select  MixData.PlantCode,
				MixData.ItemCode,
				MixData.[Description],
				MixData.ShortDescription,
				MixData.ItemCategoryCode,
				Case
					When Isnull(MixData.Strength, -1.0) <= 0.1
					Then Null
					When Isnull(MixData.StrengthAge, -1.0) <= 0.01 Or Isnull(MixData.StrengthAge, -1.0) >= 100.0
					Then 28.0
					Else MixData.StrengthAge
				End As StrengthAge,
				Case
					When Isnull(MixData.Strength, -1.0) <= 0.1
					Then Null
					Else MixData.Strength
				End As Strength,
				Case 
					When Isnull(MixData.PercentAirVolume, -1.0) < 0.0 Or Isnull(MixData.PercentAirVolume, -1.0) > 90.0
					Then Null
					Else MixData.PercentAirVolume
				End As AirContent,
				Null As MinAirContent,
				Null As MaxAirContent,
				Case
					When dbo.Validation_ValueIsNumeric(MixData.Slump) = 0
					Then Null
					When Isnull(Cast(MixData.Slump As Float), -1.0) <= 0.1
					Then Null
					Else Cast(MixData.Slump As Float)
				End As Slump,
				Null As MinSlump,
				Null As MaxSlump,
				Null As AggregateSize,
				Case
					When Isnull(MixData.MaximumBatchSize, -1.0) <= 0.1
					Then Null
					Else MixData.MaximumBatchSize
				End As MaximumBatchSize,
				Case
					When Isnull(MixData.MaximumWater, -1.0) <= 0.1
					Then Null
					Else MixData.MaximumWater
				End As MaximumWater,
				Null As SackContent,
				Case
					When Isnull(MixData.WaterCementRatio, -1.0) <= 0.0
					Then Null
					Else MixData.WaterCementRatio
				End As WaterCementRatio,
				MixData.MaterialItemCode,
				MixData.MaterialItemDescription,
				Case
					When Isnull(MixData.Quantity, -1.0) < 0.0
					Then 0.0
					Else MixData.Quantity
				End As Quantity,
				MixData.QuantityUnitName,
				MixData.DosageQuantity,
				MixData.MaterialSortNumber
		From Data_Import_RJ.dbo.TestImport0000_XML_Mix As MixData
		Left Join
		(
    		Select Mix.BATCHIDENTIFIER As MixID, Plant.Name As PlantName, MixName.Name As MixName
    		From dbo.Plants As Plant
    		Inner Join dbo.BATCH As Mix
    		On Mix.Plant_Link = Plant.PlantId
    		Inner Join dbo.Name As MixName
    		On MixName.NameID = Mix.NameID
		) As ExistingMixInfo
		On  MixData.PlantCode = ExistingMixInfo.PlantName And MixData.ItemCode = ExistingMixInfo.MixName
		Inner Join @PlantInfo As PlantInfo
		On MixData.PlantCode = PlantInfo.PlantName
		Left Join Data_Import_RJ.dbo.TestImport0000_MixInfo As ExistingMix
		On  MixData.PlantCode = ExistingMix.PlantCode And
			MixData.ItemCode = ExistingMix.MixCode And
			MixData.MaterialItemCode = ExistingMix.MaterialItemCode
		Where ExistingMix.AutoID Is Null And ExistingMixInfo.MixID Is Null
		Order By MixData.PlantCode, MixData.ItemCode, MixData.MaterialSortNumber, MixData.MaterialItemCode
	End
	Else
	Begin
		Insert into Data_Import_RJ.dbo.TestImport0000_MixInfo 
		(
			PlantCode, MixCode, MixDescription, MixShortDescription, ItemCategory,
			StrengthAge, Strength, AirContent, MinAirContent, MaxAirContent, Slump,
			MinSlump, MaxSlump, AggregateSize, MaxLoadSize, MaximumWater, SackContent,
			MaxWCRatio, MaterialItemCode, MaterialItemDescription, Quantity,
			QuantityUnitName, DosageQuantity, SortNumber
		)
		Select  MixData.PlantCode,
				MixData.ItemCode,
				MixData.[Description],
				MixData.ShortDescription,
				MixData.ItemCategoryCode,
				Case
					When Isnull(MixData.Strength, -1.0) <= 0.1
					Then Null
					When Isnull(MixData.StrengthAge, -1.0) <= 0.01 Or Isnull(MixData.StrengthAge, -1.0) >= 100.0
					Then 28.0
					Else MixData.StrengthAge
				End As StrengthAge,
				Case
					When Isnull(MixData.Strength, -1.0) <= 0.1
					Then Null
					Else MixData.Strength
				End As Strength,
				Case 
					When Isnull(MixData.PercentAirVolume, -1.0) < 0.0 Or Isnull(MixData.PercentAirVolume, -1.0) > 90.0
					Then Null
					Else MixData.PercentAirVolume
				End As AirContent,
				Null As MinAirContent,
				Null As MaxAirContent,
				Case
					When dbo.Validation_ValueIsNumeric(MixData.Slump) = 0
					Then Null
					When Isnull(Cast(MixData.Slump As Float), -1.0) <= 0.1
					Then Null
					Else Cast(MixData.Slump As Float)
				End As Slump,
				Null As MinSlump,
				Null As MaxSlump,
				Null As AggregateSize,
				Case
					When Isnull(MixData.MaximumBatchSize, -1.0) <= 0.1
					Then Null
					Else MixData.MaximumBatchSize
				End As MaximumBatchSize,
				Case
					When Isnull(MixData.MaximumWater, -1.0) <= 0.1
					Then Null
					Else MixData.MaximumWater
				End As MaximumWater,
				Null As SackContent,
				Case
					When Isnull(MixData.WaterCementRatio, -1.0) <= 0.0
					Then Null
					Else MixData.WaterCementRatio
				End As WaterCementRatio,
				MixData.MaterialItemCode,
				MixData.MaterialItemDescription,
				Case
					When Isnull(MixData.Quantity, -1.0) < 0.0
					Then 0.0
					Else MixData.Quantity
				End As Quantity,
				MixData.QuantityUnitName,
				MixData.DosageQuantity,
				MixData.MaterialSortNumber
		From Data_Import_RJ.dbo.TestImport0000_XML_Mix As MixData
		Left Join
		(
    		Select Mix.BATCHIDENTIFIER As MixID, Plant.Name As PlantName, MixName.Name As MixName
    		From dbo.Plants As Plant
    		Inner Join dbo.BATCH As Mix
    		On Mix.Plant_Link = Plant.PlantId
    		Inner Join dbo.Name As MixName
    		On MixName.NameID = Mix.NameID
		) As ExistingMixInfo
		On  MixData.PlantCode = ExistingMixInfo.PlantName And MixData.ItemCode = ExistingMixInfo.MixName
		Left Join Data_Import_RJ.dbo.TestImport0000_MixInfo As ExistingMix
		On  MixData.PlantCode = ExistingMix.PlantCode And
			MixData.ItemCode = ExistingMix.MixCode And
			MixData.MaterialItemCode = ExistingMix.MaterialItemCode
		Where ExistingMix.AutoID Is Null And ExistingMixInfo.MixID Is Null
		Order By MixData.PlantCode, MixData.ItemCode, MixData.MaterialSortNumber, MixData.MaterialItemCode
	End

	--> For some Customers, SysDyne has two of the same Material in the Mix.  This SQL Query removes the extra Materials.
	Delete MixInfo
	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
	Inner Join
	(
		Select MixInfo2.PlantCode, MixInfo2.MixCode, MixInfo2.MaterialItemCode, Min(MixInfo2.AutoID) As AutoID
		From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo2
		Where MixInfo2.Quantity = 0.0
		Group By MixInfo2.PlantCode, MixInfo2.MixCode, MixInfo2.MaterialItemCode
		Having Count(*) > 1
	) As MixInfo3
	On  MixInfo.PlantCode = MixInfo3.PlantCode And
		MixInfo.MixCode = MixInfo3.MixCode And
		MixInfo.MaterialItemCode = MixInfo3.MaterialItemCode
	Where MixInfo.Quantity = 0.0 And MixInfo.AutoID <> MixInfo3.AutoID
End
Go
