/*
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
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
/*
If Exists
(
	Select * 
	    From INFORMATION_SCHEMA.ROUTINES As RoutineInfo
	    Where   RoutineInfo.ROUTINE_NAME = 'TrimVarChar' And 
	    	    RoutineInfo.ROUTINE_TYPE = 'Function'	    	            
)
Begin
    Drop function dbo.TrimVarChar
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 02/14/2017
-- Description:	Trim Leading and Trailing Spaces.
-- ================================================================================================
Create Function [dbo].[TrimVarChar]
(
	@Value Varchar (Max)
)
Returns Varchar (Max)
As
Begin
	Return Ltrim(Rtrim(Replace(@Value, Char(160), ' '))) 
End
Go
*/

/*
If Exists
(
	Select * 
	    From INFORMATION_SCHEMA.ROUTINES As RoutineInfo
	    Where   RoutineInfo.ROUTINE_NAME = 'TrimNVarChar' And 
	    	    RoutineInfo.ROUTINE_TYPE = 'Function'	    	            
)
Begin
    Drop function dbo.TrimNVarChar
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 02/14/2017
-- Description:	Trim Leading and Trailing Spaces.
-- ================================================================================================
Create Function [dbo].[TrimNVarChar]
(
	@Value NVarChar (Max)
)
Returns NVarChar (Max)
As
Begin
	Return Ltrim(Rtrim(Replace(@Value, Char(160), ' '))) 
End
Go
*/

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixData')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_MixData
		Create table Data_Import_RJ.dbo.TestImport0000_MixData
		(
            MixCode NVarChar (100), 
            MixDescription NVarChar (100), 
            metric NVarChar (100), 
            Slump NVarChar (100), 
            yield NVarChar (100), 
            AirContent NVarChar (100), 
            time NVarChar (100), 
            MaxLoadSize NVarChar (100), 
            price NVarChar (100), 
            w_name1 NVarChar (100), 
            w_tar1 NVarChar (100), 
            w_name2 NVarChar (100), 
            w_tar2 NVarChar (100), 
            w_name3 NVarChar (100), 
            w_tar3 NVarChar (100), 
            w_name4 NVarChar (100), 
            w_tar4 NVarChar (100), 
            a_name1 NVarChar (100), 
            a_tar1 NVarChar (100), 
            a_name2 NVarChar (100), 
            a_tar2 NVarChar (100), 
            a_name3 NVarChar (100), 
            a_tar3 NVarChar (100), 
            a_name4 NVarChar (100), 
            a_tar4 NVarChar (100), 
            a_name5 NVarChar (100), 
            a_tar5 NVarChar (100), 
            a_name6 NVarChar (100), 
            a_tar6 NVarChar (100), 
            a_name7 NVarChar (100), 
            a_tar7 NVarChar (100), 
            a_name8 NVarChar (100), 
            a_tar8 NVarChar (100), 
            c_name1 NVarChar (100), 
            c_tar1 NVarChar (100), 
            c_name2 NVarChar (100), 
            c_tar2 NVarChar (100), 
            c_name3 NVarChar (100), 
            c_tar3 NVarChar (100), 
            c_name4 NVarChar (100), 
            c_tar4 NVarChar (100), 
            c_name5 NVarChar (100), 
            c_tar5 NVarChar (100), 
            c_name6 NVarChar (100), 
            c_tar6 NVarChar (100), 
            x_name1 NVarChar (100), 
            x_tar1 NVarChar (100), 
            x_name2 NVarChar (100), 
            x_tar2 NVarChar (100), 
            x_name3 NVarChar (100), 
            x_tar3 NVarChar (100), 
            x_name4 NVarChar (100), 
            x_tar4 NVarChar (100), 
            x_name5 NVarChar (100), 
            x_tar5 NVarChar (100), 
            x_name6 NVarChar (100), 
            x_tar6 NVarChar (100), 
            x_name7 NVarChar (100), 
            x_tar7 NVarChar (100), 
            x_name8 NVarChar (100), 
            x_tar8 NVarChar (100), 
            x_name9 NVarChar (100), 
            x_tar9 NVarChar (100), 
            x_name10 NVarChar (100), 
            x_tar10 NVarChar (100), 
            x_name11 NVarChar (100), 
            x_tar11 NVarChar (100), 
            x_name12 NVarChar (100), 
            x_tar12 NVarChar (100), 
			AutoID Bigint Identity (1, 1)
		)
    End    
End
Go

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
			SpecificGravity Float
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
			IsLiquidAdmix Nvarchar (100)
		)
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
			BatchPanelCode Nvarchar (100)
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
			Padding1 Nvarchar (1),
			MaterialItemCode Nvarchar (100),
			MaterialItemDescription Nvarchar (300),
			Quantity Float,
			QuantityUnitName Nvarchar (100)
		) On [Primary]

		Create Index IX_TestImport0000_MixInfo_AutoID On [Data_Import_RJ].[dbo].[TestImport0000_MixInfo] (AutoID)
		Create Index IX_TestImport0000_MixInfo_PlantCode On [Data_Import_RJ].[dbo].[TestImport0000_MixInfo] (PlantCode)
		Create Index IX_TestImport0000_MixInfo_MixCode On [Data_Import_RJ].[dbo].[TestImport0000_MixInfo] (MixCode)
		Create Index IX_TestImport0000_MixInfo_ItemCategory On [Data_Import_RJ].[dbo].[TestImport0000_MixInfo] (ItemCategory)
		Create Index IX_TestImport0000_MixInfo_MaterialItemCode On [Data_Import_RJ].[dbo].[TestImport0000_MixInfo] (MaterialItemCode)
	End
End
Go

If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
Begin
	--Drop Table [Data_Import_RJ].[dbo].[TestImport0000_MixInfoNotDeleted]
	If Object_ID(N'[Data_Import_RJ].[dbo].[TestImport0000_MixInfoNotDeleted]') Is Null
	Begin
		Create Table [Data_Import_RJ].[dbo].[TestImport0000_MixInfoNotDeleted]
		(
			AutoID Int Identity (1, 1),
			PlantCode Nvarchar (100),
			MixCode Nvarchar (100),
			MixID Int
		) On [Primary]

		Create Index IX_TestImport0000_MixInfo_AutoID On [Data_Import_RJ].[dbo].[TestImport0000_MixInfoNotDeleted] (AutoID)
		Create Index IX_TestImport0000_MixInfo_PlantCode On [Data_Import_RJ].[dbo].[TestImport0000_MixInfoNotDeleted] (PlantCode)
		Create Index IX_TestImport0000_MixInfo_MixCode On [Data_Import_RJ].[dbo].[TestImport0000_MixInfoNotDeleted] (MixCode)
		Create Index IX_TestImport0000_MixInfo_MixID On [Data_Import_RJ].[dbo].[TestImport0000_MixInfoNotDeleted] (MixID)
	End
End
Go
