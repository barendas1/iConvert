/*
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
	If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MixItemCategory')
	Begin
		Drop Table Data_Import_RJ.dbo.TestImport0000_XML_MixItemCategory
	End

	If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialItemCategory')
	Begin
		Drop Table Data_Import_RJ.dbo.TestImport0000_XML_MaterialItemCategory
	End

	If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MainMaterialInfo')
	Begin
		Drop Table Data_Import_RJ.dbo.TestImport0000_XML_MainMaterialInfo
	End

	If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
	Begin
		Drop Table Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo
	End

	If Object_ID(N'[Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo]') Is Not Null
	Begin
		Drop Table [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo]
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
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MixItemCategory')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_XML_MixItemCategory
		Create table Data_Import_RJ.dbo.TestImport0000_XML_MixItemCategory
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
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialItemCategory')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_XML_MaterialItemCategory
		Create table Data_Import_RJ.dbo.TestImport0000_XML_MaterialItemCategory
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
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MainMaterialInfo')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_XML_MainMaterialInfo
		Create table Data_Import_RJ.dbo.TestImport0000_XML_MainMaterialInfo
		(
			AutoID Bigint Identity (1, 1),
			Name Nvarchar (100),
			Description Nvarchar (300),
			ShortDescription Nvarchar (100),
			ItemCategory Nvarchar (100),
			ItemCategoryDescription Nvarchar (300),
			FamilyMaterialTypeName Nvarchar (100),
			MaterialTypeName Nvarchar (100),
			SpecificGravity Float
		)
    End    
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Not Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
    	--Drop Table Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo
		Create table Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo
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
			Padding1 Nvarchar (1),
			MaterialItemCode Nvarchar (100),
			MaterialItemDescription Nvarchar (300),
			Quantity Float,
			QuantityUnitName Nvarchar (100)
		) On [Primary]

		Create Index IX_TestImport0000_XML_MixInfo_AutoID On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo] (AutoID)
		Create Index IX_TestImport0000_XML_MixInfo_PlantCode On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo] (PlantCode)
		Create Index IX_TestImport0000_XML_MixInfo_MixCode On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo] (MixCode)
		Create Index IX_TestImport0000_XML_MixInfo_ItemCategory On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo] (ItemCategory)
		Create Index IX_TestImport0000_XML_MixInfo_MaterialItemCode On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfo] (MaterialItemCode)
	End
End
Go

If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
Begin
	--Drop Table [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfoNotDeleted]
	If Object_ID(N'[Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfoNotDeleted]') Is Null
	Begin
		Create Table [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfoNotDeleted]
		(
			AutoID Int Identity (1, 1),
			PlantCode Nvarchar (100),
			MixCode Nvarchar (100),
			MixID Int
		) On [Primary]

		Create Index IX_TestImport0000_XML_MixInfo_AutoID On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfoNotDeleted] (AutoID)
		Create Index IX_TestImport0000_XML_MixInfo_PlantCode On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfoNotDeleted] (PlantCode)
		Create Index IX_TestImport0000_XML_MixInfo_MixCode On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfoNotDeleted] (MixCode)
		Create Index IX_TestImport0000_XML_MixInfo_MixID On [Data_Import_RJ].[dbo].[TestImport0000_XML_MixInfoNotDeleted] (MixID)
	End
End
Go
