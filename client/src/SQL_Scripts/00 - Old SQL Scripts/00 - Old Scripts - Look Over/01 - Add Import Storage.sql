/*
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
	If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_PlantInfo')
	Begin
		Drop Table Data_Import_RJ.dbo.TestImport0000_PlantInfo
	End

	If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixItemCategory')
	Begin
		Drop Table Data_Import_RJ.dbo.TestImport0000_MixItemCategory
	End

	If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialItemCategory')
	Begin
		Drop Table Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory
	End

	If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MainMaterialInfo')
	Begin
		Drop Table Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo
	End

	If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo')
	Begin
		Drop Table Data_Import_RJ.dbo.TestImport0000_MaterialInfo
	End

	If Object_ID(N'[Data_Import_RJ].[dbo].[TestImport0000_MixInfo]') Is Not Null
	Begin
		Drop Table [Data_Import_RJ].[dbo].[TestImport0000_MixInfo]
	End
End
Go
*/

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_Location')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_Location
		Create table Data_Import_RJ.dbo.TestImport0000_Location
		(
			AutoID Bigint Identity (1, 1),
			LocationID Int,
			Code Nvarchar (100),
			Name Nvarchar (100),
			ShortName Nvarchar (100),
			DivisionName Nvarchar (100)
		)
    End    
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_Plant')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_Plant
		Create table Data_Import_RJ.dbo.TestImport0000_Plant
		(
			AutoID Bigint Identity (1, 1),
			PlantID Int,
			Code Nvarchar (100),
			Description Nvarchar (100),
			ShortDescription Nvarchar (100),
			LocationID Int,
			LocationCode Nvarchar (100),
			MaxBatchSize Float,
			MaxBatchSizeUnitName Nvarchar (100)			
		)
    End    
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_ItemCategory')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_ItemCategory
		Create table Data_Import_RJ.dbo.TestImport0000_ItemCategory
		(
			AutoID Bigint Identity (1, 1),
			ItemCategoryID Int,
			Code Nvarchar (100),
			Description Nvarchar (100),
			ShortDescription Nvarchar (100),
			ItemTypeID Int,
			ItemTypeName Nvarchar (100)
		)
    End    
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_ItemType')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_ItemType
		Create table Data_Import_RJ.dbo.TestImport0000_ItemType
		(
			AutoID Bigint Identity (1, 1),
			ItemTypeID Int,
			Name Nvarchar (100),
			Description Nvarchar (100)
		)
    End    
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_Material')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_Material
		Create table Data_Import_RJ.dbo.TestImport0000_Material
		(
			AutoID Bigint Identity (1, 1),
			PlantID Int,
			PlantCode Nvarchar (100),
			MaterialID Int,
			ItemCode Nvarchar (100),
			ItemCategoryCode Nvarchar (100),
	        Description Nvarchar (100),
	        ShortDescription Nvarchar (100),
			ItemTypeID Int,
			ItemTypeName Nvarchar (100),
	        DoNotAllowTicketing Bit,
	        OrderedQuantityUnitCode Nvarchar (100),
	        OrderedQuantityUnit Nvarchar (100),
	        DeliveredQuantityUnitCode Nvarchar (100),
	        DeliveredQuantityUnit Nvarchar (100),
	        PriceQuantityUnitCode Nvarchar (100),
	        PriceQuantityUnit Nvarchar (100),
	        BatchUnitCode Nvarchar (100),
	        BatchUnit Nvarchar (100),
	        InventoryUnitCode Nvarchar (100),
	        InventoryUnit Nvarchar (100),
	        PurchaseUnitCode Nvarchar (100),
	        PurchaseUnit Nvarchar (100),
	        ReportingUnitCode Nvarchar (100),
	        ReportingUnit Nvarchar (100),
	        Cost Float,
	        CostExtensionCode Nvarchar (100),
	        SpecificGravity Float,
	        MoisturePercent Float,
	        Price Float,
	        PriceCategoryCode Nvarchar (100),
	        PriceCategoryName Nvarchar (100),
	        PriceExtensionCode Nvarchar (100),
	        Price2 Float,
	        PriceCategoryCode2 Nvarchar (100),
	        PriceCategoryName2 Nvarchar (100),
	        PriceExtensionCode2 Nvarchar (100),
	        Price3 Float,
	        PriceCategoryCode3 Nvarchar (100),
	        PriceCategoryName3 Nvarchar (100),
	        PriceExtensionCode3 Nvarchar (100)	        
		)
    End    
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_Mix')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_Mix
		Create table Data_Import_RJ.dbo.TestImport0000_Mix
		(
			AutoID Bigint Identity (1, 1),
			PlantID Int,
			PlantCode Nvarchar (100),
			MixID Int,
			ItemCode Nvarchar (100),
			ItemCategoryCode Nvarchar (100),
	        Description Nvarchar (100),
	        ShortDescription Nvarchar (100),
			ItemTypeID Int,
			ItemTypeName Nvarchar (100),
	        DoNotAllowTicketing Bit,
	        OrderedQuantityUnitCode Nvarchar (100),
	        OrderedQuantityUnit Nvarchar (100),
	        DeliveredQuantityUnitCode Nvarchar (100),
	        DeliveredQuantityUnit Nvarchar (100),
	        PriceQuantityUnitCode Nvarchar (100),
	        PriceQuantityUnit Nvarchar (100),
	        BatchUnitCode Nvarchar (100),
	        BatchUnit Nvarchar (100),
	        InventoryUnitCode Nvarchar (100),
	        InventoryUnit Nvarchar (100),
	        PurchaseUnitCode Nvarchar (100),
	        PurchaseUnit Nvarchar (100),
	        ReportingUnitCode Nvarchar (100),
	        ReportingUnit Nvarchar (100),
	        StrengthAge Float,
	        Strength Float,
	        StrengthUnitName Nvarchar (100),
	        PercentAirVolume Float,
	        Slump Nvarchar (100),
	        WaterCementRatio Float,
	        AggregateSize Nvarchar (100),
	        CementType Nvarchar (100),
	        MaximumWater Float,
	        MinCementContent Float,
	        WaterHoldback Float,
	        LightweightCubicFeet Float,
	        MaximumBatchSize Float,
	        MaterialSortNumber Int,
	        MaterialItemID Int,
	        MaterialItemCode Nvarchar (100),
	        MaterialItemDescription Nvarchar (100),
	        Quantity Float,
	        DosageQuantity Float,
	        QuantityUnitName Nvarchar (100)
		)
    End    
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixProps')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_MixProps
		Create table Data_Import_RJ.dbo.TestImport0000_MixProps
		(
			AutoID Bigint Identity (1, 1),
            PlantCode Nvarchar (100),	
            PlantDescription Nvarchar (100),
            MixCode Nvarchar (100),
            MixDescription Nvarchar (100),
            StrengthAge Float,
            Strength Float,
            AirContent Float,
            Slump Float,
            ItemCategoryCode Nvarchar (100),	
            ItemCategoryDescription Nvarchar (100)
		)
    End    
End
Go



--=================================================================================================


If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixItemCategory')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_MixItemCategory
		Create table Data_Import_RJ.dbo.TestImport0000_MixItemCategory
		(
			AutoID Bigint Identity (1, 1),
			Name Nvarchar (100),
			Description Nvarchar (300),
			ShortDescription Nvarchar (100),
			CategoryNumber Nvarchar (10),
			CategoryType Nvarchar (10)
		)
    End    
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialItemCategory')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory
		Create table Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory
		(
			AutoID Bigint Identity (1, 1),
			Name Nvarchar (100),
			Description Nvarchar (300),
			ShortDescription Nvarchar (100),
			CategoryNumber Nvarchar (10),
			CategoryType Nvarchar (10),
			FamilyMaterialTypeName Nvarchar (100),
			MaterialTypeName Nvarchar (100),
			SpecificGravity Float,
			IsLiquidAdmix Bit
		)
    End    
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MainMaterialInfo')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo
		Create table Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo
		(
			AutoID Bigint Identity (1, 1),
			Name Nvarchar (100),
			Description Nvarchar (300),
			ShortDescription Nvarchar (100),
			ItemCategory Nvarchar (100),
			ItemCategoryDescription Nvarchar (300),
			FamilyMaterialTypeName Nvarchar (100),
			MaterialTypeName Nvarchar (100),
			SpecificGravity Float,
			IsLiquidAdmix Bit
		)
    End    
End
Go

If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
Begin
	--Drop Table [Data_Import_RJ].[dbo].[TestImport0000_PlantInfo]
	If Object_ID(N'[Data_Import_RJ].[dbo].[TestImport0000_PlantInfo]') Is Null
	Begin
		Create Table [Data_Import_RJ].[dbo].[TestImport0000_PlantInfo]
		(
			[AutoID] Int Identity (1, 1),
			[Name] Nvarchar (100),
			[Description] Nvarchar (300)
		) On [PRIMARY]
	End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_MaterialInfo
		Create table Data_Import_RJ.dbo.TestImport0000_MaterialInfo
		(
			AutoID Bigint Identity (1, 1),
			PlantName Nvarchar (100),
			TradeName Nvarchar (200),
			MaterialDate Nvarchar (30),
			FamilyMaterialTypeName Nvarchar (100),
			MaterialTypeName Nvarchar (100),
			SpecificGravity Float,
			IsLiquidAdmix Nvarchar (100),
			MoisturePct Float,
			Cost Float,
			CostUnitName Nvarchar (30),
			ManufacturerName Nvarchar (100),
			ManufacturerSourceName Nvarchar (100),
			BatchingOrderNumber Nvarchar (100),
			ItemCode Nvarchar (100),
			ItemDescription Nvarchar (300),
			ItemShortDescription Nvarchar (100),
			ItemCategoryName Nvarchar (100),
			ItemCategoryDescription Nvarchar (300),
			ItemCategoryShortDescription Nvarchar (100),
			ComponentCategoryName Nvarchar (100),
			ComponentCategoryDescription Nvarchar (300),
			ComponentCategoryShortDescription Nvarchar (100),
			BatchPanelCode Nvarchar (100),
			UpdatedFromDatabase Bit Default (0)
		)
    End    
End
Go


If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
Begin
	--Drop Table [Data_Import_RJ].[dbo].[TestImport0000_MixInfo]
	If Object_ID(N'[Data_Import_RJ].[dbo].[TestImport0000_MixInfo]') Is Null
	Begin
		Create Table [Data_Import_RJ].[dbo].[TestImport0000_MixInfo]
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
			MaximumWater Float, 
			SackContent	Float,
			Price Float,
			PriceUnitName Nvarchar (100),
			MixInactive Nvarchar (30),
			MinWCRatio Float,
			MaxWCRatio Float,
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
		
		Create Index IX_TestImport0000_MixInfo_AutoID On [Data_Import_RJ].[dbo].[TestImport0000_MixInfo] (AutoID)
		Create Index IX_TestImport0000_MixInfo_PlantCode On [Data_Import_RJ].[dbo].[TestImport0000_MixInfo] (PlantCode)
		Create Index IX_TestImport0000_MixInfo_MixCode On [Data_Import_RJ].[dbo].[TestImport0000_MixInfo] (MixCode)
		Create Index IX_TestImport0000_MixInfo_ItemCategory On [Data_Import_RJ].[dbo].[TestImport0000_MixInfo] (ItemCategory)
		Create Index IX_TestImport0000_MixInfo_MaterialItemCode On [Data_Import_RJ].[dbo].[TestImport0000_MixInfo] (MaterialItemCode)
	End
End
Go
