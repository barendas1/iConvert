/*
If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
Begin
	If Object_ID(N'[Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo]') Is Not Null
	Begin
		Drop Table [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo]
	End
End
Go
*/

If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
Begin
	--Drop Table [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo]
	If Object_ID(N'[Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo]') Is Null
	Begin
		Create Table [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo]
		(
			AutoID Int Identity (1, 1),
			PlantCode Nvarchar (100),
			MixCode Nvarchar (100),
			MixDescription Nvarchar (300),
			MixShortDescription Nvarchar (100),
			ItemCategory Nvarchar (100),
			StrengthAge Float,
			Strength Float,
			AirContent Float,
			MinAirContent Float,
			MaxAirContent Float,
			Slump Float,
			MinSlump Float,
			MaxSlump Float,
			DispatchSlumpRange Nvarchar (100),
			AggregateSize Float,
			MinAggregateSize Float,
			MaxAggregateSize Float,
			UnitWeight Float,
			MinUnitWeight Float,
			MaxUnitWeight Float,
			MaxLoadSize	Float,
			SackContent	Float, 
			Price Float,
			PriceUnitName Nvarchar (100),
			MixInactive Nvarchar (30),
			MinWCMRatio Float,
			MaxWCMRatio Float,
			MixClassNames Nvarchar (Max),
			MixUsage Nvarchar (Max),
			AttachmentFileNames Nvarchar (Max),
			Padding1 Nvarchar (1),
			MaterialItemCode Nvarchar (100),
			MaterialItemDescription Nvarchar (300),
			Quantity Float,
			QuantityUnitName Nvarchar (100),
			DosageQuantity Float,
			SortNumber Int
		) On [Primary]
		
		Create Index IX_TestImport0000_XML_MixInfo_AutoID On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo] (AutoID)
		Create Index IX_TestImport0000_XML_MixInfo_PlantCode On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo] (PlantCode)
		Create Index IX_TestImport0000_XML_MixInfo_MixCode On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo] (MixCode)
		Create Index IX_TestImport0000_XML_MixInfo_ItemCategory On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo] (ItemCategory)
		Create Index IX_TestImport0000_XML_MixInfo_MaterialItemCode On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo] (MaterialItemCode)
	End
End
Go
