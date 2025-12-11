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

If dbo.Validation_FunctionExists('Validation_IsValidBase26Number') = 1
Begin
	Drop function [dbo].[Validation_IsValidBase26Number]
End
Go
	
Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 01/20/2014
-- Description:	Return "True" if the Value is a Valid Base 26 Number.
-- ================================================================================================
Create Function [dbo].[Validation_IsValidBase26Number]
(
    @Base26Number Nvarchar (Max)
)
Returns Bit
As
Begin
	Declare @FirstValue Int
	Declare @LastValue Int
	Declare @CharValue Int
	Declare @ValueLength Bigint
	Declare @Index Bigint
	Declare @IsValid Bit
    Declare @Base26Value NVarChar (Max)
        
    Set @IsValid = 0
    
    Set @Base26Value = Upper(Ltrim(Rtrim(Isnull(@Base26Number, ''))))
    
    If @Base26Value <> ''
    Begin
		Set @FirstValue = Ascii('A')
		Set @LastValue = Ascii('Z')
	    
		Set @ValueLength = Len(@Base26Value)
		
        Set @IsValid = 1
        
        Set @Index = 1
        
        While (@Index <= @ValueLength)
        Begin
        	Set @CharValue = Ascii(Substring(@Base26Value, @Index, 1))
        	
        	If @CharValue < @FirstValue Or @CharValue > @LastValue
        	Begin
        	    Set @IsValid = 0
        	    Break
        	End
        	
            Set @Index = @Index + 1
        End
    End
    
	Return @IsValid
End
Go

If dbo.Validation_FunctionExists('GetBase10NumberFromBase26Number') = 1
Begin
	Drop function [dbo].[GetBase10NumberFromBase26Number]
End
Go
	
Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 01/20/2014
-- Description:	Return a Base 10 Number from a Base 26 Number.
-- ================================================================================================
Create Function [dbo].[GetBase10NumberFromBase26Number]
(
    @Base26Number Nvarchar (Max)
)
Returns BigInt
As
Begin
    Declare @Index BigInt
    Declare @NumOfChars BigInt
    Declare @FirstLetter BigInt
    Declare @Base10Number BigInt
    Declare @Base26Num NVarChar (Max)
    
    Set @Base10Number = Null
    
    If dbo.Validation_IsValidBase26Number(@Base26Number) = 1
    Begin        
        Set @Base26Num = Upper(LTrim(RTrim(@Base26Number)))
        
        Set @NumOfChars = Len(@Base26Num)
        
        Set @FirstLetter = Ascii('A')
        
        Set @Base10Number = 0
        
        Set @Index = @NumOfChars
        
        While (@Index > 0)
        Begin
            Set @Base10Number = @Base10Number + Power(26.0, (@NumOfChars - @Index)) * (Ascii(SubString(@Base26Num, @Index, 1)) - @FirstLetter)
            Set @Index = @Index - 1
        End
    End
    
	Return @Base10Number
End
Go

If dbo.Validation_FunctionExists('GetBase26NumberFromBase10Number') = 1
Begin
	Drop function [dbo].[GetBase26NumberFromBase10Number]
End
Go
	
Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 01/20/2014
-- Description:	Return a Base 26 Number from a Base 10 Number.
-- ================================================================================================
Create Function [dbo].[GetBase26NumberFromBase10Number]
(
    @Base10Number BigInt
)
Returns Nvarchar (Max)
As
Begin
    Declare @ABSNum BigInt
    --Declare @IsNegativeNum Bit
    Declare @RemainderNum BigInt
    Declare @Base26Divider BigInt
    Declare @Base26Number NVarChar (Max)
    Declare @FirstLetter BigInt
    Declare @Index BigInt

    Set @Base26Number = Null
    
    If IsNull(@Base10Number, -1) >= 0
    Begin
        Set @Base26Divider = 26
        Set @Base26Number = ''
        Set @FirstLetter = Ascii('A')
        Set @Index = 1
        
        --If @Base10Number < 0 
        --Begin
        --    Set @IsNegativeNum = 1
        --End
        --Else
        --Begin
        --    Set @IsNegativeNum = 0
        --End
        
        Set @ABSNum = Abs(@Base10Number)
        
        While (@ABSNum <> 0 Or @Index = 1)
        Begin
            Set @RemainderNum = @ABSNum % @Base26Divider
            Set @Base26Number = Char(@FirstLetter + @RemainderNum) + @Base26Number
            Set @ABSNum = Floor(@ABSNum / @Base26Divider)
            Set @Index = @Index + 1
        End
        
        --If @IsNegativeNum = 1
        --Begin
        --    Set @Base26Number = '-' + @Base26Number
        --End
    End
    
	Return @Base26Number
End
Go

If dbo.Validation_FunctionExists('GetMixNameCodeList') = 1
Begin
	Drop function [dbo].[GetMixNameCodeList]
End
Go
	
Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 01/20/2014
-- Description:	Return a list of Mix Name Codes starting at the Mix Name Code specified.
-- ================================================================================================
Create Function [dbo].[GetMixNameCodeList]
(
	@NumberOfMixNameCodes Int,
    @StartMixNameCode Nvarchar (20) = 'A',
    @NumberOfCharacters Int = 4    
)
Returns @MixNameCodeList Table
(
	AutoID Int Identity (1, 1),
	MixNameCode Nvarchar (20),
	MixNameCodeValue Bigint,
	Primary Key Clustered 
	(
		MixNameCode
	)
)
As
Begin
	Declare @Index Bigint
	Declare @MixNameCode Nvarchar (20)
	Declare @Base10Number Bigint
	
	If	Isnull(@NumberOfMixNameCodes, -1) > 0 And
		Isnull(@NumberOfCharacters, -1) > 0
	Begin
		If @NumberOfCharacters > 20
		Begin
		    Set @NumberOfCharacters = 20
		End
		
		Set @MixNameCode = Upper(Ltrim(Rtrim(Isnull(@StartMixNameCode, ''))))
		
		If dbo.Validation_IsValidBase26Number(@MixNameCode) = 0
		Begin
		    Set @MixNameCode = 'A'
		End
				
    	Set @Base10Number = dbo.GetBase10NumberFromBase26Number(@MixNameCode)
    	Set @MixNameCode = dbo.GetBase26NumberFromBase10Number(@Base10Number) --Trim off extra A's.    	
    	
		Set @Index = 1
		
		While (@Index <= @NumberOfMixNameCodes)
		Begin
			If Len(@MixNameCode) > @NumberOfCharacters
			Begin
			    Break
			End
			
			Set @MixNameCode = Right(Replicate('A', @NumberOfCharacters) + @MixNameCode, @NumberOfCharacters)
			
			Insert into @MixNameCodeList (MixNameCode, MixNameCodeValue)
				Values (@MixNameCode, @Base10Number)

			Set @Base10Number = @Base10Number + 1
			Set @MixNameCode = dbo.GetBase26NumberFromBase10Number(@Base10Number)
			
			Set @Index = @Index + 1
		End
    End
	
	Return
End
Go

If dbo.Validation_StoredProcedureExists('Utility_Print') = 1
Begin
	Drop Procedure dbo.Utility_Print
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 11/18/2014
-- Description:	Print A Message
-- ================================================================================================
Create Procedure [dbo].[Utility_Print]
(
	@Message Nvarchar (Max)
)
As
Begin
	Declare @Statement Nvarchar (Max)
	
	Set @Statement = Isnull(@Message, '')
	
	Raiserror(@Statement, 0, 1) With Nowait
End
Go

If dbo.Validation_StoredProcedureExists('MixImport_ImportItemCategories') = 1
Begin
	Drop Procedure dbo.MixImport_ImportItemCategories
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 11/17/2014
-- Description:	Import Item Categories
-- ================================================================================================
Create Procedure [dbo].[MixImport_ImportItemCategories]
As
Begin
	Declare @ErrorMessage Nvarchar (Max)
	Declare @ErrorSeverity Int
		
    --Set Nocount On
    
    Begin try
		Begin Transaction
		
		If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
		Begin
		    If Exists(Select * From Data_Import_RJ.sys.objects As Objects Where Objects.name = 'TestImport0000_XML_MixItemCategory')		    
		    Begin
		    	Print ''
		    	Print 'Add New Item Categories'
		    	
		    	Insert into dbo.ProductionItemCategory
		    	(
		    		ItemCategory,
		    		[Description],
		    		ShortDescription,
		    		ProdItemCatType
		    	)
		    	Select	Ltrim(Rtrim(ItemCategoryInfo.Name)), 
		    			Ltrim(Rtrim(ItemCategoryInfo.[Description])),
		    	      	Ltrim(Rtrim(ItemCategoryInfo.ShortDescription)),
		    	      	Ltrim(Rtrim(ItemCategoryInfo.CategoryType))
		    	From Data_Import_RJ.dbo.TestImport0000_XML_MixItemCategory As ItemCategoryInfo		    	
		    	Left Join dbo.ProductionItemCategory As ExistingItemCategory
		    	On	Ltrim(Rtrim(ItemCategoryInfo.Name)) = Ltrim(Rtrim(ExistingItemCategory.ItemCategory)) And
		    		Ltrim(Rtrim(ItemCategoryInfo.CategoryType)) = Ltrim(Rtrim(ExistingItemCategory.ProdItemCatType))
		    	Where	ExistingItemCategory.ProdItemCatID Is Null And
		    			ItemCategoryInfo.AutoID In
		    			(
		    				Select Min(ItemCategoryInfo.AutoID)
		    				From Data_Import_RJ.dbo.TestImport0000_XML_MixItemCategory As ItemCategoryInfo
		    				Where	Ltrim(Rtrim(Isnull(ItemCategoryInfo.Name, ''))) <> '' And
		    						LTrim(RTrim(IsNull(ItemCategoryInfo.CategoryType, ''))) In ('Mix', 'Mtrl', 'MtrlCompType')
		    				Group By Ltrim(Rtrim(ItemCategoryInfo.CategoryType)), Ltrim(Rtrim(ItemCategoryInfo.Name))	    	
		    			)
		    	
		    End		    
		End
		
		Commit Transaction
		
		Print ''
		Print 'The Item Categories May Have Been Imported.'
		
    End Try
    Begin catch
		If @@TRANCOUNT > 0
		Begin
		    Rollback Transaction
		End
		
		Select	@ErrorMessage = Error_message(),
				@ErrorSeverity = Error_severity()

		Print 'The Item Categories could not be imported.  The Import was rolled back.'
		Print 'Error Message - ' + @ErrorMessage
		Print 'Error Severity - ' + Cast(@ErrorSeverity As Nvarchar) + '.'		

		Raiserror(@ErrorMessage, @ErrorSeverity, 1)
    End Catch
End
Go

If dbo.Validation_StoredProcedureExists('MixImport_ImportPlants') = 1
Begin
	Drop Procedure dbo.MixImport_ImportPlants
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 11/06/2014
-- Description:	Import Plants And Yards
-- ================================================================================================
Create Procedure [dbo].[MixImport_ImportPlants]
As
Begin
	Declare @PlantInfo Table
	(
    	AutoID Int Identity (1, 1) Not null,
    	Code Nvarchar (100),
    	Name Nvarchar (100),
        Description NVarChar (255),
        MaxBatchSize Float,
        DistrictID Int,
        DistrictCode Nvarchar (100),
        PlantAutoID Int,
        CodeSuffix Int
	)
	
	Declare @PlantCodeValue Int
	Declare @PlantCodeSuffix Int
	
	Declare @ErrorMessage Nvarchar (Max)
	Declare @ErrorSeverity Int
		
    --Set Nocount On
    
    Begin try
		Begin Transaction
		
		If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
		Begin
		    If Exists(Select * From Data_Import_RJ.sys.objects Where Name = 'Import17_PlantXML')		    
		    Begin
		    	Print ''
		    	Print 'Import Plants'
		    	
		    	Print ''
		    	Print 'Retrieve the Plants that need to be added'
		    	
		    	Insert into @PlantInfo (Name, [Description], MaxBatchSize)
		    		Select Ltrim(Rtrim(PlantInfo.Name)), Ltrim(Rtrim(PlantInfo.[Description])), PlantInfo.MaxBatchSize
		    		From Data_Import_RJ.dbo.Import17_PlantXML As PlantInfo
		    		Left Join dbo.Plants As Plants
		    		On LTrim(RTrim(PlantInfo.Name)) = Plants.Name
		    		Where	Plants.PlantID Is Null And
		    				PlantInfo.AutoID In
		    				(
		    					Select Min(PlantInfo.AutoID)
		    					From Data_Import_RJ.dbo.Import17_PlantXML As PlantInfo
		    					Where Ltrim(Rtrim(Isnull(PlantInfo.Name, ''))) <> ''
		    					Group By Ltrim(Rtrim(Isnull(PlantInfo.Name, '')))
		    				)
		    		Order By Ltrim(Rtrim(PlantInfo.Name))
		    		
		    	Print ''
		    	Print 'Link the Plants that need to be added to Yards'
		    	
		    	Insert into @PlantInfo (Name, [Description], PlantAutoID)
		    		Select 'Yard ' + PlantInfo.Name, PlantInfo.[Description], PlantInfo.AutoID
		    		From @PlantInfo As PlantInfo
		    		Order By PlantInfo.Name
		    		
		    	Print ''
		    	Print 'Set up Code Suffixes that will be used to set up the Plant Codes'
		    	
		    	Update PlantInfo 
		    		Set	PlantInfo.CodeSuffix = RowNumberInfo.CodeSuffix
		    	From @PlantInfo As PlantInfo
		    	Inner Join
		    	(
		    		Select PlantInfo.AutoID, Row_number() Over (Order By PlantInfo.AutoID) As CodeSuffix
		    		From @PlantInfo As PlantInfo
		    		Where PlantInfo.PlantAutoID Is Not Null
		    	) As RowNumberInfo
		    	On PlantInfo.AutoID = RowNumberInfo.AutoID
		    	
		    	Set @PlantCodeSuffix = (Select Max(PlantInfo.CodeSuffix) From @PlantInfo As PlantInfo Where PlantInfo.CodeSuffix Is Not null)

		    	Update PlantInfo 
		    		Set	PlantInfo.CodeSuffix = RowNumberInfo.CodeSuffix + @PlantCodeSuffix
		    	From @PlantInfo As PlantInfo
		    	Inner Join
		    	(
		    		Select PlantInfo.AutoID, Row_number() Over (Order By PlantInfo.AutoID) As CodeSuffix
		    		From @PlantInfo As PlantInfo
		    		Where PlantInfo.PlantAutoID Is Null
		    	) As RowNumberInfo
		    	On PlantInfo.AutoID = RowNumberInfo.AutoID
		    	
		    	Print ''
		    	Print 'Retrieve the Last Plant Code Suffix'
		    	
		    	If Exists (Select * From dbo.Plants As Plants)
		    	Begin 
		    		Set @PlantCodeValue = (Select Max(Cast(LTrim(RTrim(Substring(Plants.PLNTTAGShouldGoAway, Charindex('-', Plants.PLNTTAGShouldGoAway) + 1, Len(Plants.PLNTTAGShouldGoAway)))) As Int)) From dbo.Plants As Plants)
		    	End
		    	Else
		    	Begin
		    	    Set @PlantCodeValue = 0
		    	End
		    	
		    	Update PlantInfo
		    		Set PlantInfo.DistrictID = District.DistrictIdentifier,
		    			PlantInfo.DistrictCode = District.RGCode
		    	From @PlantInfo As PlantInfo
		    	Inner Join dbo.District As District
		    	On District.Name = 'Concrete District'
		    	
		    	Print ''
		    	Print 'Add Yards'
		    	
		    	Insert into dbo.Plants
		    	(
		    		PLNTTAGShouldGoAway,
		    		Name,
		    		[Description],
		    		ParentBusinessUnitId,
		    		PlantKind,
		    		PlantIdForYard,
		    		DistrictCodeShouldGoAway
		    	)
		    	Select	'P-' + Right('0000000' + Cast(@PlantCodeValue + PlantInfo.CodeSuffix As Nvarchar), 7),
		    			PlantInfo.Name,
		    			PlantInfo.[Description],
		    			PlantInfo.DistrictID,
		    			'ConcreteYard',
		    			Null,
		    			PlantInfo.DistrictCode
		    	From @PlantInfo As PlantInfo
		    	Where PlantInfo.PlantAutoID Is Not Null

		    	Print ''
		    	Print 'Add Plants and link them to the Yards'
		    	
		    	Insert into dbo.Plants
		    	(
		    		PLNTTAGShouldGoAway,
		    		Name,
		    		[Description],
		    		MaximumBatchSize,
		    		ParentBusinessUnitId,
		    		PlantKind,
		    		PlantIdForYard,
		    		DistrictCodeShouldGoAway
		    	)
		    	Select	'P-' + Right('0000000' + Cast(@PlantCodeValue + PlantInfo.CodeSuffix As Nvarchar), 7),
		    			PlantInfo.Name,
		    			PlantInfo.[Description],
		    			PlantInfo.MaxBatchSize,
		    			PlantInfo.DistrictID,
		    			'BatchPlant',
		    			ViewYard.PlantID,
		    			PlantInfo.DistrictCode
		    	From @PlantInfo As PlantInfo
		    	Inner Join @PlantInfo As YardInfo
		    	On PlantInfo.AutoID = YardInfo.PlantAutoID
		    	Inner Join dbo.ViewPlant As ViewYard
		    	On YardInfo.Name = ViewYard.Name
		    	Where PlantInfo.PlantAutoID Is Null
		    	
		    End		    
		End
		
		Commit Transaction
		
		Print ''
		Print 'The Plants May Have Been Imported.'
		
    End Try
    Begin catch
		If @@TRANCOUNT > 0
		Begin
		    Rollback Transaction
		End
		
		Select	@ErrorMessage = Error_message(),
				@ErrorSeverity = Error_severity()

		Print 'The Plants could not be imported.  The Import was rolled back.'
		Print 'Error Message - ' + @ErrorMessage
		Print 'Error Severity - ' + Cast(@ErrorSeverity As Nvarchar) + '.'		

		Raiserror(@ErrorMessage, @ErrorSeverity, 1)
    End Catch
End
Go

If dbo.Validation_StoredProcedureExists('MixImport_ImportMaterials') = 1
Begin
	Drop Procedure dbo.MixImport_ImportMaterials
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 11/06/2014
-- Description:	Import Materials into the Yards and Plants
-- ================================================================================================
Create Procedure [dbo].[MixImport_ImportMaterials]
As
Begin
	Declare @MaterialInfo Table
	(
		AutoID int Identity(1,1),
		PlantName Nvarchar (100),
		TradeName Nvarchar (100),
		ItemCode Nvarchar (100),
		Description Nvarchar (300),
		ItemCategory Nvarchar (100),
		ComponentCategory Nvarchar (100),
		BatchPanelCode Nvarchar (100),
		SpecificGravity Float,
		SpecificHeat Float,
		Cost Float,
		CostUnit Nvarchar (100),
		Moisture Float,
		BlaineFineness Float,
		Batchable Bit,
		FamilyMaterialTypeID Int,
		FamilyMaterialTypeName Nvarchar (100),
		MaterialTypeID Int,
		MaterialTypeName Nvarchar (100),
		ReportMaterialTypeID Int,
		ReportMaterialTypeName Nvarchar (100),
		PlantID Int,
		ConvertedDate Nvarchar (20),
		ConvertedCost Float,
		Code Nvarchar (20),
		CodePrefix Nvarchar (10),
		CodeDate Nvarchar (20),
		CodeSuffix Nvarchar (10),
		MaxCodeSuffix Nvarchar (20),
		MinAutoID Int
	)
	
	Declare @ProdItem Table
	(
		AutoID Int Identity (1, 1),
		ItemCode Nvarchar (100),
		Description Nvarchar (300),
		ItemCategory Nvarchar (100),
		ComponentCategory Nvarchar (100)
	)
	
	Declare @AggregatesInYards Bit
	Declare @CurrentTimeStamp Datetime
	Declare @CodeDate Nvarchar (20)
	
	Declare @ErrorMessage Nvarchar (Max)
	Declare @ErrorSeverity Int
		
    --Set Nocount On
    
    Begin try
		Begin Transaction
		
		If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
		Begin
		    If Exists(Select * From Data_Import_RJ.sys.objects Where Name = 'Import17_MaterialInfo')
		    Begin
				Set @AggregatesInYards = IsNull(dbo.GetAggregatesInYards(), 0)
				Set @CurrentTimeStamp = Current_timestamp
				Set @CodeDate =	Right('00' + Cast(Year(@CurrentTimeStamp) As Nvarchar), 2) +
								Right('00' + Cast(Month(@CurrentTimeStamp) As Nvarchar), 2) +
								Right('00' + Cast(Day(@CurrentTimeStamp) As Nvarchar), 2)
								
				Print ''
				Print 'Import Materials'
				
				Print ''
				Print 'Retrieve Material Information'

		        Insert Into @MaterialInfo
		        (
		            PlantName,
		            TradeName,
		            ItemCode,
		            [Description],
		            ItemCategory,
		            ComponentCategory,
		            BatchPanelCode,
		            SpecificGravity,
		            SpecificHeat,
		            Cost,
		            CostUnit,
		            Moisture,
		            BlaineFineness,
		            Batchable,
		            FamilyMaterialTypeID,
		            FamilyMaterialTypeName,
		            MaterialTypeID,
		            MaterialTypeName,
		            ReportMaterialTypeID,
		            ReportMaterialTypeName
		        )		        
		        Select  Ltrim(Rtrim(MaterialInfo.PlantName)),
		                Ltrim(Rtrim(MaterialInfo.TradeName)),
		                Ltrim(Rtrim(MaterialInfo.ItemCode)),
		                Ltrim(Rtrim(MaterialInfo.[Description])),
		                Ltrim(Rtrim(MaterialInfo.ItemCategory)),
		                Ltrim(Rtrim(MaterialInfo.ComponentCategory)),
		                Ltrim(Rtrim(MaterialInfo.BatchPanelCode)),
		                MaterialInfo.SpecificGravity,
		                MaterialInfo.SpecificHeat,
		                MaterialInfo.Cost,
		                Ltrim(Rtrim(MaterialInfo.CostUnit)),
		                MaterialInfo.Moisture,
		                MaterialInfo.BlaineFineness,
		                MaterialInfo.Batchable,
		                MaterialInfo.FamilyMaterialTypeID,
		                Ltrim(Rtrim(MaterialInfo.FamilyMaterialTypeName)),
		                MaterialInfo.MaterialTypeID,
		                Ltrim(Rtrim(MaterialInfo.MaterialTypeName)),
		                MaterialInfo.ReportMaterialTypeID,
		                Ltrim(Rtrim(MaterialInfo.ReportMaterialTypeName))
		            From Data_Import_RJ.dbo.Import17_MaterialInfo As MaterialInfo
		            Inner Join dbo.Plants As Plants
		            On LTrim(RTrim(MaterialInfo.PlantName)) = Plants.Name
					Where	Ltrim(Rtrim(Isnull(MaterialInfo.TradeName, ''))) <> '' And
							Ltrim(Rtrim(Isnull(MaterialInfo.ItemCode, ''))) <> '' And
							IsNull(MaterialInfo.FamilyMaterialTypeID, -1) In (1, 2, 3, 4, 5) And
							Isnull(MaterialInfo.MaterialTypeID, -1) > 0	 And
							Isnull(MaterialInfo.SpecificGravity, -1.0) > 0.0 And
							Isnull(MaterialInfo.SpecificHeat, -1.0) > 0.0 And
							MaterialInfo.AutoID In
							(
								Select Min(MaterialInfo.AutoID)
								From Data_Import_RJ.dbo.Import17_MaterialInfo As MaterialInfo
								Group By LTrim(RTrim(MaterialInfo.PlantName)), LTrim(RTrim(MaterialInfo.ItemCode))
							)					
					Order By	MaterialInfo.FamilyMaterialTypeID, 
								LTrim(RTrim(MaterialInfo.PlantName)),
								LTrim(RTrim(MaterialInfo.ItemCode))
								
				Print ''
				Print 'Set Material Plant, Date, Code, and Cost Information'
				
				Update MaterialInfo
					Set MaterialInfo.PlantID =
							Case
								When @AggregatesInYards = 1 And MaterialInfo.FamilyMaterialTypeID = 1
								Then Yard.PlantId
								Else Plants.PlantId
							End,
						MaterialInfo.ConvertedDate = 
							Right('00' + Cast(Month(@CurrentTimeStamp) As Nvarchar), 2) + '/' +
							Right('00' + Cast(Day(@CurrentTimeStamp) As Nvarchar), 2) + '/' +
							Right('0000' + Cast(Year(@CurrentTimeStamp) As Nvarchar), 4), 
						MaterialInfo.CodePrefix = 
							Case
								When MaterialInfo.FamilyMaterialTypeID = 1
								Then 'A'
								When MaterialInfo.FamilyMaterialTypeID = 2
								Then 'C'
								When MaterialInfo.FamilyMaterialTypeID = 3
								Then 'H'
								When MaterialInfo.FamilyMaterialTypeID = 4
								Then 'M'
								When MaterialInfo.FamilyMaterialTypeID = 5
								Then 'W'
							End,
						CodeDate = @CodeDate,
						ConvertedCost = 
							Case
								When	IsNull(MaterialInfo.CostUnit, '') Not In ('CY', 'GL', 'OZ', 'TN', 'LB') Or 
										Isnull(MaterialInfo.Cost, -1.0) < 0.0 
								Then Null
								When IsNull(MaterialInfo.CostUnit, '') = 'CY'
								Then MaterialInfo.Cost / 201.974026 * 264.17205 / (MaterialInfo.SpecificGravity * 1.0)
								When IsNull(MaterialInfo.CostUnit, '') = 'GL'
								Then MaterialInfo.Cost * 264.17205 / (MaterialInfo.SpecificGravity * 1.0)
								When IsNull(MaterialInfo.CostUnit, '') = 'OZ'
								Then MaterialInfo.Cost * 128.0 * 264.17205 / (MaterialInfo.SpecificGravity * 1.0)
								When IsNull(MaterialInfo.CostUnit, '') = 'TN'
								Then MaterialInfo.Cost * 1.102311359528
								When IsNull(MaterialInfo.CostUnit, '') = 'LB'
								Then MaterialInfo.Cost * 2000.0 / 0.9071847
							End
				From @MaterialInfo As MaterialInfo
				Inner Join dbo.Plants As Plants
				On MaterialInfo.PlantName = Plants.Name
				Left Join dbo.Plants As Yard
				On Plants.PlantIdForYard = Yard.PlantId				
				
				Print ''
				Print 'Set Max Code Suffixes'
				
				Update MaterialInfo
					Set MaterialInfo.MaxCodeSuffix = CodeInfo.MaxCodeSuffix
				From @MaterialInfo As MaterialInfo
				Left Join 
				(
					Select Material.FamilyMaterialTypeID, Max(Right(Material.CODE, 5)) As MaxCodeSuffix
					From dbo.MATERIAL As Material
					Where	Material.FamilyMaterialTypeID In (1, 2, 3, 4, 5) And
							Substring(Material.CODE, 2, 6) = @CodeDate
					Group By Material.FamilyMaterialTypeID 
				) As CodeInfo
				On MaterialInfo.FamilyMaterialTypeID = CodeInfo.FamilyMaterialTypeID
				
				Print ''
				Print 'Set Min Auto-Generated Numbers'
				
				Update MaterialInfo
					Set MaterialInfo.MinAutoID = AutoIDInfo.MinAutoID
				From @MaterialInfo As MaterialInfo
				Inner Join
				(
					Select MaterialInfo.FamilyMaterialTypeID, Min(MaterialInfo.AutoID) As MinAutoID
					From @MaterialInfo As MaterialInfo
					Group By MaterialInfo.FamilyMaterialTypeID
				) As AutoIDInfo
				On MaterialInfo.FamilyMaterialTypeID = AutoIDInfo.FamilyMaterialTypeID
				
				Print ''
				Print 'Set Code Suffixes'
				
				Update MaterialInfo
					Set MaterialInfo.CodeSuffix =
							Right
							(
								'00000' + 
								Cast
								(
									Case 
										when MaterialInfo.MaxCodeSuffix Is Null 
										Then 0 
										Else Cast(MaterialInfo.MaxCodeSuffix As Int) + 1
									End +
									(MaterialInfo.AutoID - MaterialInfo.MinAutoID) As Nvarchar
								),
								5
							)
				From @MaterialInfo As MaterialInfo
				
				Print ''
				Print 'Set Up Codes'
				
				Update MaterialInfo
					Set MaterialInfo.Code = MaterialInfo.CodePrefix + MaterialInfo.CodeDate + MaterialInfo.CodeSuffix
				From @MaterialInfo As MaterialInfo
				
				Print ''
				Print 'Retrieve Production Item Information'
				
				Insert into @ProdItem
				(
					ItemCode, 
					[Description], 
					ItemCategory, 
					ComponentCategory
				)
				Select	MaterialInfo.ItemCode, 
						MaterialInfo.[Description],
				      	MaterialInfo.ItemCategory, 
				      	MaterialInfo.ComponentCategory
				From @MaterialInfo As MaterialInfo
				Where	MaterialInfo.AutoID In
						(
							Select Min(MaterialInfo.AutoID)
							From @MaterialInfo As MaterialInfo
							Where Isnull(MaterialInfo.ItemCode, '') <> ''
							Group By MaterialInfo.ItemCode
						)
								
				Print ''
				Print 'Show Materials that might be imported'
				
				Select * 
				From @MaterialInfo
				Order By AutoID
				
				Print ''
				Print 'Show Production Item Information that might be imported'
				
				Select *
				From @ProdItem
				Order By AutoID
				
				--/*
				
				Print ''
				Print 'Add Material Item Codes'
				
				Insert into dbo.Name
				(
					Name,
					MaterialTypeID,
					NameType
				)
					Select MaterialInfo.ItemCode, Min(MaterialInfo.MaterialTypeID), 'MtrlItem'					
					From @MaterialInfo As MaterialInfo
					Left Join dbo.Name As Name
					On MaterialInfo.ItemCode = Name.Name 
					Where Name.NameID Is Null
					Group By MaterialInfo.ItemCode
					Order By MaterialInfo.ItemCode
					
				Print ''
				Print 'Add Material Batch Panel Codes'

				Insert into dbo.Name
				(
					Name,
					MaterialTypeID,
					NameType
				)
					Select MaterialInfo.BatchPanelCode, Min(MaterialInfo.MaterialTypeID), 'MtrlBatchCode'					
					From @MaterialInfo As MaterialInfo
					Left Join dbo.Name As Name
					On MaterialInfo.BatchPanelCode = Name.Name 
					Where Isnull(MaterialInfo.BatchPanelCode, '') <> '' And Name.NameID Is Null
					Group By MaterialInfo.BatchPanelCode
					Order By MaterialInfo.BatchPanelCode
					
				Print ''
				Print 'Add Trade Names'

				Insert into dbo.Name
				(
					Name,
					MaterialTypeID,
					NameType
				)
					Select MaterialInfo.TradeName, Min(MaterialInfo.MaterialTypeID), 'Mtrl'					
					From @MaterialInfo As MaterialInfo
					Left Join dbo.Name As Name
					On MaterialInfo.TradeName = Name.Name 
					Where Name.NameID Is Null
					Group By MaterialInfo.TradeName
					Order By MaterialInfo.TradeName
				
				Print ''
				Print 'Add Material Descriptions'
				
				Insert into dbo.[Description]
				(
					[Description],
					MaterialTypeID,
					DescriptionType
				)
					Select MaterialInfo.[Description], Min(MaterialInfo.MaterialTypeID), 'MtrlItem'					
					From @MaterialInfo As MaterialInfo
					Left Join dbo.[Description] As ItemDescr
					On MaterialInfo.[Description] = ItemDescr.[Description]
					Where Isnull(MaterialInfo.[Description], '') <> '' And ItemDescr.DescriptionID Is Null
					Group By MaterialInfo.[Description]
					Order By MaterialInfo.[Description]
					
				Print ''
				Print 'Add Item Categories'
				
				Insert into dbo.ProductionItemCategory
				(
					ItemCategory, 
					[Description], 
					ShortDescription, 
					ProdItemCatType
				)
				Select	ProdItem.ItemCategory,
						ProdItem.ItemCategory,
						ProdItem.ItemCategory,
						'Mtrl'
				From @ProdItem As ProdItem
				Left Join dbo.ProductionItemCategory As ItemCategoryInfo
				On	ProdItem.ItemCategory = ItemCategoryInfo.ItemCategory And
					ItemCategoryInfo.ProdItemCatType = 'Mtrl'
				Where	ItemCategoryInfo.ProdItemCatID Is Null And
						Isnull(ProdItem.ItemCategory, '') <> ''
				Group By ProdItem.ItemCategory
				Order By ProdItem.ItemCategory

				Print ''
				Print 'Add Component Categories'
				
				Insert into dbo.ProductionItemCategory
				(
					ItemCategory, 
					[Description], 
					ShortDescription, 
					ProdItemCatType
				)
				Select	ProdItem.ComponentCategory,
						ProdItem.ComponentCategory,
						ProdItem.ComponentCategory,
						'MtrlCompType'
				From @ProdItem As ProdItem
				Left Join dbo.ProductionItemCategory As ComponentCategoryInfo
				On	ProdItem.ComponentCategory = ComponentCategoryInfo.ItemCategory And
					ComponentCategoryInfo.ProdItemCatType = 'MtrlCompType'
				Where	ComponentCategoryInfo.ProdItemCatID Is Null And
						Isnull(ProdItem.ComponentCategory, '') <> ''
				Group By ProdItem.ComponentCategory
				Order By ProdItem.ComponentCategory
				
				Print ''
				Print 'Add Production Item Information'
							
				Insert into dbo.ItemMaster
				(
					NameID,
					DescriptionID,
					ItemShortDescription,
					ProdItemCatID,
					ProdItemCompTypeID,
					ItemType
				)
					Select	Name.NameID,
							Description.DescriptionID,
							Left(Description.[Description], 16),
							ItemCategoryInfo.ProdItemCatID,
							ComponentCategoryInfo.ProdItemCatID,
							'Mtrl'
					From @ProdItem As ProdItem					
					Inner Join dbo.Name As Name
					On ProdItem.ItemCode = Name.Name
					Left Join dbo.ItemMaster As ItemMaster
					On ItemMaster.NameID = Name.NameID
					Left Join dbo.[Description] As Description
					On ProdItem.[Description] = Description.[Description]
					Left Join dbo.ProductionItemCategory As ItemCategoryInfo
					On	ProdItem.ItemCategory = ItemCategoryInfo.ItemCategory And
						ItemCategoryInfo.ProdItemCatType = 'Mtrl'
					Left Join dbo.ProductionItemCategory As ComponentCategoryInfo
					On	ProdItem.ComponentCategory = ComponentCategoryInfo.ItemCategory And
						ComponentCategoryInfo.ProdItemCatType = 'MtrlCompType'
					Where ItemMaster.ItemMasterID Is Null					
				
				Print ''
				Print 'Add Material Information'
				
				Insert into dbo.Material
				(
					PlantID, 
					PLANTCODE, 
					FamilyMaterialTypeID, 
					CODE, 
					NameID, 
					DescriptionID, 
					DATE, 
					MaterialTypeLink,
					ReportMaterialTypeID,
					Type, 
					SpecGr, 
					SpecHt, 
					COST,
					Moisture, 
					Blaine,
					ItemMasterID,
					BatchPanelNameID,
					BatchPanelDescription,
					NonBatchable
				) 
				Select	Plants.PlantId,
						Plants.PLNTTAGShouldGoAway,
						MaterialInfo.FamilyMaterialTypeID,
						MaterialInfo.Code,
						TradeNameInfo.NameID,
						Case when ItemMaster.ItemMasterID Is Null Then DescrInfo.DescriptionID Else ItemDescrInfo.DescriptionID End,
						MaterialInfo.ConvertedDate,
						MaterialInfo.MaterialTypeID,
						MaterialInfo.ReportMaterialTypeID,
						MaterialInfo.ReportMaterialTypeName,
						MaterialInfo.SpecificGravity,
						MaterialInfo.SpecificHeat,
						MaterialInfo.ConvertedCost,
						MaterialInfo.Moisture,
						MaterialInfo.BlaineFineness,
						ItemMaster.ItemMasterID,
						BatchPanelName.NameID,
						ItemDescrInfo.[Description],
						Case when Isnull(MaterialInfo.Batchable, 1) = 1 Then Null Else 1 End
				From @MaterialInfo As MaterialInfo
				Inner Join dbo.Plants As Plants
				On MaterialInfo.PlantID = Plants.PlantId
				Inner Join dbo.Name As TradeNameInfo
				On MaterialInfo.TradeName = TradeNameInfo.Name
				Left Join dbo.[Description] As DescrInfo
				On MaterialInfo.[Description] = DescrInfo.[Description]
				Inner Join dbo.Name As ItemNameInfo
				On MaterialInfo.ItemCode = ItemNameInfo.Name
				Left Join dbo.ItemMaster As ItemMaster
				On	ItemMaster.NameID = ItemNameInfo.NameID And
					ItemMaster.ItemType = 'Mtrl'
				Left Join dbo.[Description] As ItemDescrInfo
				On ItemMaster.DescriptionID = ItemDescrInfo.DescriptionID
				Left Join dbo.Name As BatchPanelName
				On MaterialInfo.BatchPanelCode = BatchPanelName.Name
				Left Join dbo.MATERIAL As ExistingMaterial
				On	Plants.PlantId = ExistingMaterial.PlantID And
					TradeNameInfo.NameID = ExistingMaterial.NameID 
				Where ExistingMaterial.MATERIALIDENTIFIER Is Null
							
				Print ''
				Print 'Add Aggregate Information'
					
				Insert into dbo.Aggregate 
				(
					MaterialID
				)
				Select Material.MATERIALIDENTIFIER
				From dbo.MATERIAL As Material
				Inner Join @MaterialInfo As MaterialInfo
				On Material.CODE = MaterialInfo.Code
				Left Join dbo.[Aggregate] As Aggregate
				On Aggregate.MaterialID = Material.MATERIALIDENTIFIER
				Where	Material.FamilyMaterialTypeID = 1 And
						Aggregate.AggregateID Is Null
				Group By Material.MATERIALIDENTIFIER
				Order By Material.MATERIALIDENTIFIER

		    	Print ''
		    	Print 'Update the Types for Item Codes'
		    	
				Update ItemName
					Set ItemName.NameType = 'MtrlItem'
				From dbo.Name As ItemName
				Inner Join dbo.ItemMaster As ItemMaster
				On ItemMaster.NameID = ItemName.NameID
				Where	ItemMaster.ItemType = 'Mtrl' And
						ItemName.NameType In ('Mtrl', 'MtrlBatchCode')
						
		    	Print ''
		    	Print 'Update the Types for Batch Panel Codes'
		    	
				Update PanelNameInfo
					Set PanelNameInfo.NameType = 'MtrlBatchCode'
				From dbo.Name As PanelNameInfo
				Inner Join dbo.MATERIAL As Material
				On Material.BatchPanelNameID = PanelNameInfo.NameID
				Left Join dbo.ItemMaster As ItemMaster
				On ItemMaster.NameID = PanelNameInfo.NameID
				Where	ItemMaster.ItemMasterID Is Null And
						IsNull(PanelNameInfo.NameType, '') In ('Mtrl', 'MtrlItem')
				
		    	Print ''
		    	Print 'Update the Types for Item Descriptions'
		    	
				Update ItemDescription
					Set ItemDescription.DescriptionType = 'MtrlItem'
				From dbo.[Description] As ItemDescription
				Inner Join dbo.ItemMaster As ItemMaster
				On ItemMaster.DescriptionID = ItemDescription.DescriptionID
				Where	ItemMaster.ItemType = 'Mtrl' And
						ItemDescription.DescriptionType In ('Mtrl')
				--*/
			End
		End
		
		Commit Transaction
		
		Print ''
		Print 'The Materials May Have Been Imported.'
    End Try
    Begin catch
		If @@TRANCOUNT > 0
		Begin
		    Rollback Transaction
		End
		
		Select	@ErrorMessage = Error_message(),
				@ErrorSeverity = Error_severity()

		Print 'The Materials could not be imported.  The Import was rolled back.'
		Print 'Error Message - ' + @ErrorMessage
		Print 'Error Severity - ' + Cast(@ErrorSeverity As Nvarchar) + '.'		

		Raiserror(@ErrorMessage, @ErrorSeverity, 1)
    End Catch
End
Go

If dbo.Validation_StoredProcedureExists('MixImport_ImportMixes') = 1
Begin
	Drop Procedure dbo.MixImport_ImportMixes
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 11/07/2014
-- Description:	Import Mixes into the Plants
-- ================================================================================================
Create Procedure [dbo].[MixImport_ImportMixes]
(
	@AllowedToOverwriteMixes Bit = 1,
	@UpdateExistingProdItems Bit = 1
)
As
Begin
	/*
	Declare @MixInfo Table
	(
		AutoID Int Identity (1, 1),
		MixID Int,
		PlantName Nvarchar (100),
		MixName Nvarchar (100),
		Description Nvarchar (300),
		ShortDescription Nvarchar (100),
		ItemCategory Nvarchar (100),
		StrengthAge Float,
		Strength Float,
		AirContent Float,
		MinAirContent Float,
		MaxAirContent Float,
		Slump Float,
		MinSlump Float,
		MaxSlump Float,
		Spread Float,
		MinSpread Float,
		MaxSpread Float,
		DispatchSlumpRange Nvarchar (100),
		MixCode Nvarchar (20),
		MixNameCode Nvarchar (20),
		MixSpecID Int,
		StrengthDataPointID Int,
		AirDataPointID Int,
		SlumpDataPointID Int,
		SpreadDataPointID Int,
		StrengthAgeMeasID Int,
		StrengthMeasID Int,
		AirMeasID Int,
		SlumpMeasID Int,
		SpreadMeasID Int
		Primary Key Nonclustered
		(
			MixID
		),
		Unique Nonclustered
		(
			PlantName,
			MixName
		)
	)

	Declare @MixRecipeInfo Table
	(
    	AutoID Int Identity (1, 1),
		MixID Int,
		PlantName Nvarchar (100),
		MixName Nvarchar (100),
		MaterialItemCode Nvarchar (100),
		Quantity Float,
		QuantityUnit Nvarchar (100),			
		ConvertedQuantity Float,
		PlantID Int,
		MaterialID Int,
		MaterialCode Nvarchar (20),
		FamilyMaterialTypeID Int,
		SpecificGravity Float,
		Primary Key Nonclustered
		(
			MixID,
			MaterialItemCode			
		),
		Unique Nonclustered
		(
			PlantName,
			MixName,
			MaterialItemCode
		)
	)
    */
    
    Declare @ExistingMix Table (AutoID Int Identity (1, 1), PlantCode Nvarchar (100), MixCode Nvarchar(100), Unique Nonclustered (PlantCode, MixCode))
    Declare @CementitiousMix Table (AutoID Int Identity (1, 1), PlantCode Nvarchar (100), MixCode Nvarchar(100), Unique Nonclustered (PlantCode, MixCode))
    Declare @AdmixtureMix Table (AutoID Int Identity (1, 1), PlantCode Nvarchar (100), MixCode Nvarchar(100), Unique Nonclustered (PlantCode, MixCode))
    Declare @MultiMaterial Table (AutoID Int Identity (1, 1), PlantCode Nvarchar (100), MixCode Nvarchar(100), Unique Nonclustered (PlantCode, MixCode))
    Declare @MissingMaterial Table (AutoID Int Identity (1, 1), PlantCode Nvarchar (100), MixCode Nvarchar(100), Unique Nonclustered (PlantCode, MixCode))
    Declare @MixAutoIDInfo Table (AutoID Int Identity (1, 1), MixAutoID Int, Unique Nonclustered (MixAutoID))
    Declare @MixProdInfo Table (AutoID Int Identity (1, 1), MixID Int, Unique Nonclustered (MixID)) 
    
	Declare @AggregatesInYards Bit
	
	Declare @CodeDate Nvarchar (20)
	Declare @CodeSuffix Int
	Declare @MixNameCode Nvarchar (20)
	Declare @LastID Int
	Declare @MixTimeStamp Datetime
	Declare @MixDate Nvarchar (20)
	Declare @MixTime Nvarchar (20)
		
	Declare @ErrorMessage Nvarchar (Max)
	Declare @ErrorSeverity Int
		
    --Set Nocount On

	If dbo.Validation_DatabaseTemporaryTableExists('#MixInfo') = 1
	Begin
	    Drop table #MixInfo
	End
	
	Create table #MixInfo
	(
		AutoID Int Identity (1, 1),
		MixID Int,
		PlantName Nvarchar (100),
		MixName Nvarchar (100),
		Description Nvarchar (300),
		ShortDescription Nvarchar (100),
		ItemCategory Nvarchar (100),
		StrengthAge Float,
		Strength Float,
		AirContent Float,
		MinAirContent Float,
		MaxAirContent Float,
		Slump Float,
		MinSlump Float,
		MaxSlump Float,
		Spread Float,
		MinSpread Float,
		MaxSpread Float,
		DispatchSlumpRange Nvarchar (100),
		ActualMixID Int,
		MixCode Nvarchar (20),
		MixNameCode Nvarchar (20),
		MixSpecID Int,
		StrengthDataPointID Int,
		AirDataPointID Int,
		SlumpDataPointID Int,
		SpreadDataPointID Int,
		StrengthAgeMeasID Int,
		StrengthMeasID Int,
		AirMeasID Int,
		SlumpMeasID Int,
		SpreadMeasID Int
		Primary Key Nonclustered
		(
			MixID
		),
		Unique Nonclustered
		(
			AutoID
		),
		Unique Nonclustered
		(
			PlantName,
			MixName
		)
	)
	
	Create Index IX_MixInfo_PlantName On #MixInfo (PlantName)
	Create Index IX_MixInfo_MixName On #MixInfo (MixName)
	Create Index IX_MixInfo_Description On #MixInfo (Description)
	Create Index IX_MixInfo_MixCode On #MixInfo (MixCode)
	Create Index IX_MixInfo_MixNameCode On #MixInfo (MixNameCode)
	Create Index IX_MixInfo_MixSpecID On #MixInfo (MixSpecID)
	Create Index IX_MixInfo_StrengthDataPointID On #MixInfo (StrengthDataPointID)
	Create Index IX_MixInfo_AirDataPointID On #MixInfo (AirDataPointID)
	Create Index IX_MixInfo_SlumpDataPointID On #MixInfo (SlumpDataPointID)
	Create Index IX_MixInfo_SpreadDataPointID On #MixInfo (SpreadDataPointID)
	Create Index IX_MixInfo_StrengthAgeMeasID On #MixInfo (StrengthAgeMeasID)
	Create Index IX_MixInfo_StrengthMeasID On #MixInfo (StrengthMeasID)
	Create Index IX_MixInfo_AirMeasID On #MixInfo (AirMeasID)
	Create Index IX_MixInfo_SlumpMeasID On #MixInfo (SlumpMeasID)
	Create Index IX_MixInfo_SpreadMeasID On #MixInfo (SpreadMeasID)
	
	If dbo.Validation_DatabaseTemporaryTableExists('#MixRecipeInfo') = 1
	Begin
	    Drop table #MixRecipeInfo
	End

	Create table #MixRecipeInfo
	(
    	AutoID Int Identity (1, 1),
		MixID Int,
		PlantName Nvarchar (100),
		MixName Nvarchar (100),
		MaterialItemCode Nvarchar (100),
		Quantity Float,
		QuantityUnit Nvarchar (100),			
		ConvertedQuantity Float,
		PlantID Int,
		MaterialID Int,
		MaterialCode Nvarchar (20),
		FamilyMaterialTypeID Int,
		SpecificGravity Float,
		Primary Key Nonclustered
		(
			MixID,
			MaterialItemCode			
		),
		Unique Nonclustered
		(
			AutoID
		),
		Unique Nonclustered
		(
			PlantName,
			MixName,
			MaterialItemCode
		)
	)
    
    Create Index IX_MixRecipeInfo_MixID On #MixRecipeInfo (MixID)
    Create Index IX_MixRecipeInfo_PlantName On #MixRecipeInfo (PlantName)
    Create Index IX_MixRecipeInfo_MixName On #MixRecipeInfo (MixName)
    Create Index IX_MixRecipeInfo_MaterialItemCode On #MixRecipeInfo (MaterialItemCode)
    Create Index IX_MixRecipeInfo_PlantID On #MixRecipeInfo (PlantID)
    Create Index IX_MixRecipeInfo_MaterialID On #MixRecipeInfo (MaterialID)
    Create Index IX_MixRecipeInfo_MaterialCode On #MixRecipeInfo (MaterialCode)
    Create Index IX_MixRecipeInfo_FamilyMaterialTypeID On #MixRecipeInfo (FamilyMaterialTypeID)
    
    If dbo.Validation_DatabaseTemporaryTableExists('#MaterialInfo') = 1
    Begin
		Drop Table #MaterialInfo
    End
    
    Create table #MaterialInfo
    (
    	AutoID Int Identity (1, 1),
    	PlantName Nvarchar (100),
    	ItemCode Nvarchar (100),
    	SpecificGravity Float,
    	Moisture Float,
    	PlantID Int,
    	MaterialID Int,
    	MaterialCode Nvarchar (30),
    	FamilyMaterialTypeID Int,
    )
    
    Create Index IX_MaterialInfo_AutoID On #MaterialInfo (AutoID)
    Create Index IX_MaterialInfo_PlantName On #MaterialInfo (PlantName)
    Create Index IX_MaterialInfo_ItemCode On #MaterialInfo (ItemCode)
    Create Index IX_MaterialInfo_PlantID On #MaterialInfo (PlantID)
    Create Index IX_MaterialInfo_MaterialID On #MaterialInfo (MaterialID)
    Create Index IX_MaterialInfo_MaterialCode On #MaterialInfo (MaterialCode)
    Create Index IX_MaterialInfo_FamilyMaterialTypeID On #MaterialInfo (FamilyMaterialTypeID)
    
    Begin try
		Begin Transaction
		
		If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
		Begin
		    If	Exists(Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MixInfo')
		    Begin
		    	Exec dbo.Utility_Print ''
		    	Exec dbo.Utility_Print 'Import Mixes'
		    	
		    	Exec dbo.Utility_Print ''
		    	Exec dbo.Utility_Print 'Retrieve Batch Plant Materials'
		    	
		    	Insert Into #MaterialInfo
		    	(
		    	    PlantName,
		    	    ItemCode,
		    	    SpecificGravity,
		    	    Moisture,
		    	    PlantID,
		    	    MaterialID,
		    	    MaterialCode,
		    	    FamilyMaterialTypeID
		    	)
		    	Select	Plant.PLNTNAME,
		    			ItemName.Name,
		    			Material.SPECGR,
		    			Material.MOISTURE,
		    			Plant.PLANTIDENTIFIER,
		    			Material.MATERIALIDENTIFIER,
		    			Material.CODE,
		    			Material.FamilyMaterialTypeID
		    	From dbo.PLANT As Plant
		    	Inner Join dbo.MATERIAL As Material
		    	On Material.PlantID = Plant.PLANTIDENTIFIER
		    	Inner Join dbo.ItemMaster As ItemMaster
		    	On ItemMaster.ItemMasterID = Material.ItemMasterID
		    	Inner Join dbo.Name As ItemName
		    	On ItemName.NameID = ItemMaster.NameID
		    	Inner Join
		    	(
		    		Select	Max(Material.MATERIALIDENTIFIER) As MATERIALIDENTIFIER
		    		From dbo.MATERIAL As Material
		    		Where   Isnull(Material.Inactive, 0) = 0 And
		    		        Isnull(Material.NotAllowedInMixAndBatchRecipes, 0) = 0 And
		    		        Isnull(Material.OnlyAllowedInImportedBatchRecipes, 0) = 0
		    		Group By Material.PlantID, Material.ItemMasterID
		    	) As SelMaterial
		    	On Material.MATERIALIDENTIFIER = SelMaterial.MATERIALIDENTIFIER
		    	Where Plant.PlantKind = 'BatchPlant'
		    	Order By	Material.FamilyMaterialTypeID,
		    				Plant.PLANTIDENTIFIER,
		    				ItemName.Name

		    	Exec dbo.Utility_Print ''
		    	Exec dbo.Utility_Print 'Retrieve Concrete Yard Materials'
		    	
		    	Insert Into #MaterialInfo
		    	(
		    	    PlantName,
		    	    ItemCode,
		    	    SpecificGravity,
		    	    Moisture,
		    	    PlantID,
		    	    MaterialID,
		    	    MaterialCode,
		    	    FamilyMaterialTypeID
		    	)
		    	Select	Plant.PLNTNAME,
		    			ItemName.Name,
		    			Material.SPECGR,
		    			Material.MOISTURE,
		    			Plant.PLANTIDENTIFIER,
		    			Material.MATERIALIDENTIFIER,
		    			Material.CODE,
		    			Material.FamilyMaterialTypeID
		    	From dbo.PLANT As Yard		    	 
		    	Inner Join dbo.MATERIAL As Material
		    	On Material.PlantID = Yard.PLANTIDENTIFIER
		    	Inner Join dbo.PLANT As Plant
		    	On Yard.PLANTIDENTIFIER = Plant.PlantIDForYard
		    	Inner Join dbo.ItemMaster As ItemMaster
		    	On ItemMaster.ItemMasterID = Material.ItemMasterID
		    	Inner Join dbo.Name As ItemName
		    	On ItemName.NameID = ItemMaster.NameID
		    	Inner Join
		    	(
		    		Select	Max(Material.MATERIALIDENTIFIER) As MATERIALIDENTIFIER
		    		From dbo.MATERIAL As Material
		    		Where   Isnull(Material.Inactive, 0) = 0 And
		    		        Isnull(Material.NotAllowedInMixAndBatchRecipes, 0) = 0 And
		    		        Isnull(Material.OnlyAllowedInImportedBatchRecipes, 0) = 0
		    		Group By Material.PlantID, Material.ItemMasterID
		    	) As SelMaterial
		    	On Material.MATERIALIDENTIFIER = SelMaterial.MATERIALIDENTIFIER
		    	Where Plant.PlantKind = 'BatchPlant'
		    	Order By	Material.FamilyMaterialTypeID,
		    				Plant.PLANTIDENTIFIER,
		    				ItemName.Name
		    			    	
		    	Exec dbo.Utility_Print ''
		    	Exec dbo.Utility_Print 'Set Up Date, Time, Code, And Mix Name Code Info'
		    	
				Set @MixTimeStamp = GetDate()

                If dbo.GetDBSetting_GlobalDateFormat(Default) = 'DD/MM/YYYY'
                Begin
				    Set @MixDate =  Right('00' + LTrim(RTrim(Cast(Day(@MixTimeStamp) As NVarChar))), 2) + '/' +
								    Right('00' + LTrim(RTrim(Cast(Month(@MixTimeStamp) As NVarChar))), 2) + '/' +
								    Right('0000' + LTrim(RTrim(Cast(Year(@MixTimeStamp) As NVarChar))), 4)
                End
                Else
                Begin

					Set @MixDate =  Right('00' + LTrim(RTrim(Cast(Month(@MixTimeStamp) As NVarChar))), 2) + '/' +
									Right('00' + LTrim(RTrim(Cast(Day(@MixTimeStamp) As NVarChar))), 2) + '/' +
									Right('0000' + LTrim(RTrim(Cast(Year(@MixTimeStamp) As NVarChar))), 4)
                End
		                        
				Set @MixTime =  Right('00' + LTrim(RTrim(Cast(DatePart(hour, @MixTimeStamp) As NVarChar))), 2) + ':' +
								Right('00' + LTrim(RTrim(Cast(DatePart(minute, @MixTimeStamp) As NVarChar))), 2)
                        
				Set @AggregatesInYards = IsNull(dbo.GetAggregatesInYards(), 0)
				
				Set @CodeDate =	Right('00' + Cast(Year(@MixTimeStamp) As Nvarchar), 2) +
								Right('00' + Cast(Month(@MixTimeStamp) As Nvarchar), 2) +
								Right('00' + Cast(Day(@MixTimeStamp) As Nvarchar), 2)
								
				Set @CodeSuffix = Null				
				Set @CodeSuffix = (Select Max(Cast(Right(Batch.Code, 5) + 1 As Int)) From dbo.Batch As Batch Where Substring(Batch.CODE, 2, 6) = @CodeDate)
				
				If @CodeSuffix Is Null
				Begin
				    Set @CodeSuffix = 0
				End				 
								
				Set @MixNameCode = Null
				
				Set @MixNameCode = 
					(
						Select Max(Mix.MixNameCode) 
						From dbo.BATCH As Mix 
						Where	Mix.Mix = 'y' And 
								Len(Mix.MixNameCode) = (Select Max(Len(Mix.MixNameCode)) From dbo.Batch As Mix Where Mix.Mix = 'y')
					)
					
				Set @MixNameCode = Ltrim(Rtrim(Isnull(@MixNameCode, '')))
				
				If @MixNameCode = ''
				Begin
				    Set @MixNameCode = 'AAAA'
				End 
				Else
				Begin
				    Set @MixNameCode = dbo.GetBase26NumberFromBase10Number(dbo.GetBase10NumberFromBase26Number(@MixNameCode) + 1)
				    
				    If Len(@MixNameCode) < 4
				    Begin
				        Set @MixNameCode = Right(Replicate('A', 4) + @MixNameCode, 4)
				    End
				End
				
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Format Mix Information To Be Imported'
				
				Update MixInfo
					Set MixInfo.PlantCode = LTrim(RTrim(Replace(MixInfo.PlantCode, Char(160), ' '))),
						MixInfo.MixCode = LTrim(RTrim(Replace(MixInfo.MixCode, Char(160), ' '))),
						MixInfo.MixDescription = LTrim(RTrim(Replace(MixInfo.MixDescription, Char(160), ' '))),
						MixInfo.MixShortDescription = LTrim(RTrim(Replace(MixInfo.MixShortDescription, Char(160), ' '))),
						MixInfo.ItemCategory = LTrim(RTrim(Replace(MixInfo.ItemCategory, Char(160), ' '))),
						MixInfo.DispatchSlumpRange = LTrim(RTrim(Replace(MixInfo.DispatchSlumpRange, Char(160), ' '))),
						MixInfo.Padding1 = LTrim(RTrim(Replace(MixInfo.Padding1, Char(160), ' '))),
						MixInfo.MaterialItemCode = LTrim(RTrim(Replace(MixInfo.MaterialItemCode, Char(160), ' '))),
						MixInfo.MaterialItemDescription = LTrim(RTrim(Replace(MixInfo.MaterialItemDescription, Char(160), ' '))),
						MixInfo.QuantityUnitName = LTrim(RTrim(Replace(MixInfo.QuantityUnitName, Char(160), ' ')))
				From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo

                If Isnull(@AllowedToOverwriteMixes, 1) = 0
                Begin
				    Exec dbo.Utility_Print ''
				    Exec dbo.Utility_Print 'Retrieve Existing Mix Information'
				
                    Insert into @ExistingMix (PlantCode, MixCode)
					    Select MixRecipe.PlantCode, MixRecipe.MixCode
					    From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixRecipe
					    Inner Join dbo.Plants As Plants
					    On MixRecipe.PlantCode = Plants.Name
					    Inner Join dbo.Name As MixName
					    On MixRecipe.MixCode = MixName.Name
					    Inner Join dbo.BATCH As Mix
					    On  Plants.PlantId = Mix.Plant_Link And
					        MixName.NameID = Mix.NameID
					    Group By MixRecipe.PlantCode, MixRecipe.MixCode
                End
                
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Retrieve Mixes With Cementitious Quantities'
				
                Insert into @CementitiousMix (PlantCode, MixCode)
					Select MixRecipe.PlantCode, MixRecipe.MixCode
					From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixRecipe
					Inner Join #MaterialInfo As MaterialInfo
					On	MixRecipe.PlantCode = MaterialInfo.PlantName And
						MixRecipe.MaterialItemCode = MaterialInfo.ItemCode
					Where MaterialInfo.FamilyMaterialTypeID In (2, 4)
					Group By MixRecipe.PlantCode, MixRecipe.MixCode
					Having Round(Sum(MixRecipe.Quantity), 2) > 0.0

				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Retrieve Mixes With Admixtures'
				
                Insert into @AdmixtureMix (PlantCode, MixCode)
					Select MixRecipe.PlantCode, MixRecipe.MixCode
					From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixRecipe
					Inner Join #MaterialInfo As MaterialInfo
					On	MixRecipe.PlantCode = MaterialInfo.PlantName And
						MixRecipe.MaterialItemCode = MaterialInfo.ItemCode
					Where MaterialInfo.FamilyMaterialTypeID In (3)
					Group By MixRecipe.PlantCode, MixRecipe.MixCode
                
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Retrieve Mixes With Multiple Material With The Same Item Code'
				
                Insert into @MultiMaterial (PlantCode, MixCode)
                    Select MultiMaterial.PlantCode, MultiMaterial.MixCode
                    From 
                    (
					    Select MixInfo.PlantCode, MixInfo.MixCode
					    From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
					    Group By MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode
					    Having Count(*) > 1
                    ) As MultiMaterial
                    Group By MultiMaterial.PlantCode, MultiMaterial.MixCode
                             
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Retrieve Mixes With Missing Materials'
				
                Insert into @MissingMaterial (PlantCode, MixCode)
					Select MixInfo.PlantCode, MixInfo.MixCode
					From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
					Left Join #MaterialInfo As MaterialInfo
					On	MixInfo.PlantCode = MaterialInfo.PlantName And
						MixInfo.MaterialItemCode = MaterialInfo.ItemCode
					Where	MaterialInfo.AutoID Is Null
					Group By MixInfo.PlantCode, MixInfo.MixCode

				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Retrieve Mix Auto ID Information Of Mixes That May Be Imported'
					
				Insert into @MixAutoIDInfo (MixAutoID)
					Select Min(MixInfo.AutoID)
					From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
					Inner Join dbo.Plant As Plant
					On MixInfo.PlantCode = Plant.PLNTNAME
					Left Join @ExistingMix As ExistingMix
					On  MixInfo.PlantCode = ExistingMix.PlantCode And
					    MixInfo.MixCode = ExistingMix.MixCode
					Left Join @CementitiousMix As CementitiousMix
					On	MixInfo.PlantCode = CementitiousMix.PlantCode And
						MixInfo.MixCode = CementitiousMix.MixCode
					Left Join @AdmixtureMix As AdmixtureMix
					On	MixInfo.PlantCode = AdmixtureMix.PlantCode And
						MixInfo.MixCode = AdmixtureMix.MixCode
					Left Join @MultiMaterial As MultiMaterial
					On	MixInfo.PlantCode = MultiMaterial.PlantCode And
						MixInfo.MixCode = MultiMaterial.MixCode
					Left Join @MissingMaterial As MissingMaterial
					On	MixInfo.PlantCode = MissingMaterial.PlantCode And
						MixInfo.MixCode = MissingMaterial.MixCode
					Where	IsNull(MixInfo.MixCode, '') <> '' And		
					        ExistingMix.AutoID Is Null And							
							MultiMaterial.AutoID Is Null And
							MissingMaterial.AutoID Is Null And
							(
								AdmixtureMix.AutoID Is Null Or
								AdmixtureMix.AutoID Is Not null And
								CementitiousMix.AutoID Is Not null
							)			
					Group By	MixInfo.PlantCode,
								MixInfo.MixCode

				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Retrieve Mix Import Information'
				
				Insert Into #MixInfo
				(
				    MixID,
				    ActualMixID,
				    MixCode,
				    MixNameCode,
				    MixSpecID,
				    PlantName,
				    MixName,
				    [Description],
				    ShortDescription,
				    ItemCategory,
				    StrengthAge,
				    Strength,
				    AirContent,
				    MinAirContent,
				    MaxAirContent,
				    Slump,
				    MinSlump,
				    MaxSlump,
				    DispatchSlumpRange
				)
				Select  MixInfo.AutoID,
				        Mix.BATCHIDENTIFIER,
				        Mix.CODE,
				        Mix.MixNameCode,
				        Mix.MixSpecID,
				        MixInfo.PlantCode,
				        MixInfo.MixCode,
				        MixInfo.MixDescription,
				        MixInfo.MixShortDescription,
				        MixInfo.ItemCategory,
				        Case 
							When Round(Isnull(MixInfo.Strength, -1.0), 2) <= 0.0
							Then Null
							When	Round(Isnull(MixInfo.Strength, -1.0), 2) > 0.0 And
									Round(Isnull(MixInfo.StrengthAge, -1.0), 2) <= 0.0
							Then 28.0
							Else MixInfo.StrengthAge
						End,
						Case
							When Round(Isnull(MixInfo.Strength, -1.0), 2) <= 0.0
							Then Null
							Else MixInfo.Strength
						End,
				        MixInfo.AirContent,
				        MixInfo.MinAirContent,
				        MixInfo.MaxAirContent,
				        MixInfo.Slump,
				        MixInfo.MinSlump,
				        MixInfo.MaxSlump,
				        MixInfo.DispatchSlumpRange
				From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
				Inner Join @MixAutoIDInfo As MixAutoIDInfo
				On MixInfo.AutoID = MixAutoIDInfo.MixAutoID
				Inner Join dbo.Plants As Plants
				On MixInfo.PlantCode = Plants.Name
				Left Join dbo.Name As MixName
				On MixInfo.MixCode = MixName.Name
				Left Join dbo.Batch As Mix
				On  Plants.PlantId = Mix.Plant_Link And
				    Mix.NameID = MixName.NameID
				Order By MixInfo.PlantCode, MixInfo.MixCode
						
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Retrieve Mix Recipe Information'
						
		        Insert Into #MixRecipeInfo
		        (
		            MixID,
		            PlantName,
		            MixName,
		            MaterialItemCode,
		            Quantity,
		            QuantityUnit,
		            PlantID,
		            MaterialID,
		            MaterialCode,
		            FamilyMaterialTypeID,
		            SpecificGravity
		        )
		        Select  MixInfo.MixID,
						MixRecipe.PlantCode, 
						MixRecipe.MixCode,
						MixRecipe.MaterialItemCode,
						MixRecipe.Quantity, 
						MixRecipe.QuantityUnitName,
						MaterialInfo.PlantID,
						MaterialInfo.MaterialID, 
						MaterialInfo.MaterialCode,
						MaterialInfo.FamilyMaterialTypeID,
						MaterialInfo.SpecificGravity
				From #MixInfo As MixInfo
				Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixRecipe
				On	MixInfo.PlantName = MixRecipe.PlantCode And
					MixInfo.MixName = MixRecipe.MixCode
				Inner Join #MaterialInfo As MaterialInfo
				On	MixRecipe.PlantCode = MaterialInfo.PlantName And
					MixRecipe.MaterialItemCode = MaterialInfo.ItemCode
		                
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Convert Recipe Quantities From LBs to Kgs'
				
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity * 0.45359240000781
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit In ('LB', 'Pounds')

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Convert Recipe Quantities From Ozs to Kgs'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity * MixRecipeInfo.SpecificGravity * 0.0651984837440621 * 0.45359240000781
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit In ('LQ OZ', 'OZ', 'Ounces')
				
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Convert Recipe Quantities From Yd^3 to Kgs'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity * 201.974026 * MixRecipeInfo.SpecificGravity * 1.0 / 0.26417205
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit In ('CYD', 'Cubic Yards')
				
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Convert Recipe Quantities From Gallons to Kgs'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity * MixRecipeInfo.SpecificGravity * 1.0 / 0.26417205
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit In ('GL', 'GA', 'GAL', 'Gallons')

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Convert Recipe Quantities From Oz/CWt CM to Kgs'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity * MixRecipeInfo.SpecificGravity * 0.0651984837440621 * CementitiousInfo.TotalQuantity / 100.0
		        From #MixRecipeInfo As MixRecipeInfo
		        Inner Join
		        (
		        	Select MixRecipeInfo.MixID, Sum(Isnull(MixRecipeInfo.ConvertedQuantity, 0.0)) As TotalQuantity
		        	From #MixRecipeInfo As MixRecipeInfo
		        	Where MixRecipeInfo.FamilyMaterialTypeID In (2, 4)
		        	Group By MixRecipeInfo.MixID
		        	Having Round(Sum(Isnull(MixRecipeInfo.ConvertedQuantity, 0.0)), 2) > 0.0
		        ) As CementitiousInfo
		        On MixRecipeInfo.MixID = CementitiousInfo.MixID
		        Where MixRecipeInfo.QuantityUnit In ('CW', 'oz/cwt CM')

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Set Recipe Quantities in Kgs'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit = 'KG'

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Convert Recipe Quantities From Grams to Kgs'

		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity / 1000.0
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit = 'GR'

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Convert Recipe Quantities From L to Kgs'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity * MixRecipeInfo.SpecificGravity * 1.0
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit In ('L', 'LT')

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Convert Recipe Quantities From Ml to Kgs'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity * MixRecipeInfo.SpecificGravity * 1.0 / 1000.0
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit = 'ML'

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Convert Recipe Quantities From CM^3 to Kgs'

		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity * MixRecipeInfo.SpecificGravity * 1.0 / 1000.0
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit In ('CC')

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Set Recipe Quantities in Kgs (Units are Each or Bag)'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit In ('Each', 'Bag')

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes To Mix Name Codes'
		        
		        Update MixInfo
					Set MixInfo.MixNameCode = MixNameCodeList.MixNameCode
		        From #MixInfo As MixInfo
		        Inner Join
		        (
		        	Select  MixInfo.AutoID, Row_number() Over (Order By MixInfo.AutoID) As RowNumber
		        	From #MixInfo As MixInfo
		        	Where MixInfo.ActualMixID Is Null
		        ) As RowNumberInfo
		        On MixInfo.AutoID = RowNumberInfo.AutoID
		        Inner Join dbo.GetMixNameCodeList(Isnull((Select Count(*) From #MixInfo As MixInfo Where MixInfo.ActualMixID Is Null), 0), @MixNameCode, 4) As MixNameCodeList
		        On RowNumberInfo.RowNumber = MixNameCodeList.AutoID
		        Where MixInfo.ActualMixID Is Null
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes To Codes'
		        
		        Update MixInfo
					Set MixInfo.MixCode = 'B' + @CodeDate + Right('00000' + Cast(@CodeSuffix + RowNumberInfo.RowNumber - 1 As Nvarchar), 5)										
		        From #MixInfo As MixInfo
		        Inner Join
		        (
		        	Select  MixInfo.AutoID, Row_number() Over (Order By MixInfo.AutoID) As RowNumber
		        	From #MixInfo As MixInfo
		        	Where MixInfo.ActualMixID Is Null
		        ) As RowNumberInfo
		        On MixInfo.AutoID = RowNumberInfo.AutoID
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Set Up Spreads From Slumps'
		        
		        Update MixInfo
					Set MixInfo.Spread = MixInfo.Slump,
						MixInfo.MinSpread = MixInfo.MinSlump,
						MixInfo.MaxSpread = MixInfo.MaxSlump
		        From #MixInfo As MixInfo
		        Where	Isnull(MixInfo.Slump, -1.0) > 12.0 Or
						Isnull(MixInfo.MinSlump, -1.0) > 12.0 Or
						Isnull(MixInfo.MaxSlump, -1.0) > 12.0

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Clear Out Slumps With Spreads'
		        
		        Update MixInfo
					Set MixInfo.Slump = Null,
						MixInfo.MinSlump = Null,
						MixInfo.MaxSlump = Null
		        From #MixInfo As MixInfo
		        Where	Isnull(MixInfo.Spread, -1.0) >= 0.0 Or
						Isnull(MixInfo.MinSpread, -1.0) >= 0.0 Or
						Isnull(MixInfo.MaxSpread, -1.0) >= 0.0
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Show Mixes'
		        
		        Select *
		        From #MixInfo As MixInfo
		        Order By MixInfo.AutoID
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Show Mixes That Might Be Created'
		        
		        Select 'Mixes That Might be Created', *
		        From #MixInfo As MixInfo
		        Where MixInfo.ActualMixID Is Null
		        Order By MixInfo.AutoID
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Show Mix Recipes'
		        
		        Select *
		        From #MixRecipeInfo As MixRecipeInfo
		        Order By MixRecipeInfo.AutoID

				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Show Mix Recipes Without Material Links'
				
		        Select *
		        From #MixRecipeInfo As MixRecipeInfo
		        Where IsNull(MixRecipeInfo.MaterialCode, '') = ''
		        Order By MixRecipeInfo.AutoID

		        --/*
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add New Mix Names'
		        
		        Insert into dbo.Name
		        (
		        	Name,
		        	NameType
		        )
		        Select MixNameInfo.MixName, 'MixItem'
		        From 
		        (
		        	Select MixInfo.MixName
		        	From #MixInfo As MixInfo
		        	Group By MixInfo.MixName
		        ) As MixNameInfo
		        Left Join dbo.Name As ExistingName
		        On MixNameInfo.MixName = ExistingName.Name
		        Where ExistingName.NameID Is Null
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add New Descriptions'
		        
		        Insert into dbo.Description
		        (
		        	[Description], 
		        	DescriptionType
		        )
		        Select MixDescriptionInfo.Description, 'MixItem'
		        From 
		        (
		        	Select MixInfo.[Description] As Description
		        	From #MixInfo As MixInfo
		        	Where Isnull(MixInfo.Description, '') <> '' 
		        	Group By MixInfo.Description
		        ) As MixDescriptionInfo
		        Left Join dbo.[Description] As ExistingDescription
		        On MixDescriptionInfo.Description = ExistingDescription.[Description]
		        Where ExistingDescription.DescriptionID Is Null
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add Production Item Categories'
		        
		        Insert into dbo.ProductionItemCategory
		        (
		        	ItemCategory,
		        	[Description],
		        	ShortDescription,
		        	ProdItemCatType
		        )
		        Select	MixInfo.ItemCategory,
						MixInfo.ItemCategory,
						MixInfo.ItemCategory,
						'Mix'
		        From #MixInfo As MixInfo
		        Left Join dbo.ProductionItemCategory As ItemCategoryInfo
		        On	MixInfo.ItemCategory = ItemCategoryInfo.ItemCategory And
					ItemCategoryInfo.ProdItemCatType = 'Mix'
		        Where	Isnull(MixInfo.ItemCategory, '') <> '' And
						ItemCategoryInfo.ProdItemCatID Is Null
		        Group By MixInfo.ItemCategory
		        
				Raiserror('', 0, 0) With Nowait
				Raiserror('Delete Production Items Not Linked To Materials Or Mixes.', 0, 0) With Nowait

				Delete ItemMaster
				From dbo.ItemMaster As ItemMaster
				Left Join dbo.Batch As Mix
				On Mix.ItemMasterID = ItemMaster.ItemMasterID
				Left Join dbo.MATERIAL As Material
				On Material.ItemMasterID = ItemMaster.ItemMasterID
				Where	Mix.BATCHIDENTIFIER Is Null And
						Material.MATERIALIDENTIFIER Is Null
				
				If Isnull(@UpdateExistingProdItems, 1) = 1
				Begin		
		            Exec dbo.Utility_Print ''
		            Exec dbo.Utility_Print 'Retrieve Mixes With Production Items That Were Modified'
		            
		            Insert into @MixProdInfo (MixID)
		                Select Mix.BATCHIDENTIFIER
		                From dbo.BATCH As Mix
		                Inner Join dbo.ItemMaster As ItemMaster
		                On ItemMaster.ItemMasterID = Mix.ItemMasterID
				        Inner Join dbo.Name As ItemName
				        On ItemName.NameID = ItemMaster.NameID
				        Inner Join #MixInfo As MixInfo
				        On ItemName.Name = MixInfo.MixName
				        Left Join dbo.[Description] As ExistingDescr
				        On ExistingDescr.DescriptionID = ItemMaster.DescriptionID
				        Left Join dbo.ProductionItemCategory As ExistingCategoryInfo
				        On ExistingCategoryInfo.ProdItemCatID = ItemMaster.ProdItemCatID
				        Left Join dbo.[Description] As ItemDescr
				        On  MixInfo.[Description] = ItemDescr.[Description] And
				            ItemDescr.DescriptionType In ('Mix', 'MixItem')
				        Left Join dbo.ProductionItemCategory As CategoryInfo
				        On  MixInfo.ItemCategory = CategoryInfo.ItemCategory And
				            CategoryInfo.ProdItemCatType = 'Mix'
				        Where   MixInfo.AutoID In				    
				                (
				        	        Select Min(MixInfo.AutoID)
				        	        From #MixInfo As MixInfo
				        	        Where Isnull(MixInfo.MixName, '') <> ''
				        	        Group By MixInfo.MixName
				                ) And
				                (
				                    Isnull(MixInfo.[Description], '') <> '' And
				                    Isnull(ItemDescr.[Description], '') <> '' And
				                    Isnull(MixInfo.[Description], '') <> Isnull(ExistingDescr.[Description], '') Or
				                    Isnull(MixInfo.ShortDescription, '') <> '' And
				                    LTrim(RTrim(Left(Isnull(MixInfo.ShortDescription, ''), 16))) <> Isnull(ItemMaster.ItemShortDescription, '') Or
				                    Isnull(MixInfo.ItemCategory, '') <> '' And
				                    Isnull(CategoryInfo.ItemCategory, '') <> '' And
				                    Isnull(MixInfo.ItemCategory, '') <> Isnull(ExistingCategoryInfo.ItemCategory, '')
				                )
		                Group By Mix.BATCHIDENTIFIER

		            Exec dbo.Utility_Print ''
		            Exec dbo.Utility_Print 'Update Existing Production Items That Changed'
		        
				    Update ItemMaster
				        Set ItemMaster.DescriptionID =
				                Case
				                    When ItemDescr.DescriptionID Is Not null
				                    Then ItemDescr.DescriptionID
				                    Else ItemMaster.DescriptionID
				                End,
				            ItemMaster.ItemShortDescription =    
				                Case
				                    When Isnull(MixInfo.ShortDescription, '') <> ''
				                    Then Ltrim(Rtrim(Left(MixInfo.ShortDescription, 16)))
				                    When ItemDescr.DescriptionID Is Not null
				                    Then Ltrim(Rtrim(Left(ItemDescr.[Description], 16)))
				                    Else ItemMaster.ItemShortDescription
				                End,
				            ItemMaster.ProdItemCatID =
				                Case
				                    When CategoryInfo.ProdItemCatID Is Not null
				                    Then CategoryInfo.ProdItemCatID
				                    Else ItemMaster.ProdItemCatID
				                End    
				    From dbo.ItemMaster As ItemMaster
				    Inner Join dbo.Name As ItemName
				    On  ItemName.NameID = ItemMaster.NameID And
				        ItemMaster.ItemType = 'Mix'
				    Inner Join #MixInfo As MixInfo
				    On ItemName.Name = MixInfo.MixName
				    Left Join dbo.[Description] As ExistingDescr
				    On ExistingDescr.DescriptionID = ItemMaster.DescriptionID
				    Left Join dbo.ProductionItemCategory As ExistingCategoryInfo
				    On ExistingCategoryInfo.ProdItemCatID = ItemMaster.ProdItemCatID
				    Left Join dbo.[Description] As ItemDescr
				    On  MixInfo.[Description] = ItemDescr.[Description] And
				        ItemDescr.DescriptionType In ('Mix', 'MixItem')
				    Left Join dbo.ProductionItemCategory As CategoryInfo
				    On  MixInfo.ItemCategory = CategoryInfo.ItemCategory And
				        CategoryInfo.ProdItemCatType = 'Mix'
				    Where   MixInfo.AutoID In				    
				            (
				        	    Select Min(MixInfo.AutoID)
				        	    From #MixInfo As MixInfo
				        	    Where Isnull(MixInfo.MixName, '') <> ''
				        	    Group By MixInfo.MixName
				            ) And
				            (
				                Isnull(MixInfo.[Description], '') <> '' And
				                Isnull(ItemDescr.[Description], '') <> '' And
				                Isnull(MixInfo.[Description], '') <> Isnull(ExistingDescr.[Description], '') Or
				                Isnull(MixInfo.ShortDescription, '') <> '' And
				                LTrim(RTrim(Left(Isnull(MixInfo.ShortDescription, ''), 16))) <> Isnull(ItemMaster.ItemShortDescription, '') Or
				                Isnull(MixInfo.ItemCategory, '') <> '' And
				                Isnull(CategoryInfo.ItemCategory, '') <> '' And
				                Isnull(MixInfo.ItemCategory, '') <> Isnull(ExistingCategoryInfo.ItemCategory, '')
				            )
				            
		            Exec dbo.Utility_Print ''
		            Exec dbo.Utility_Print 'Update Production Statuses Of Mixes With Modified Production Items'
		            
				    Update Mix
				        Set Mix.ProductionStatus = Case when Isnull(Mix.ProductionStatus, '') In ('InSync', 'Sent') Then 'OutOfSync' Else Mix.ProductionStatus End
				    From dbo.BATCH As Mix
				    Inner Join @MixProdInfo As MixProdInfo
				    On Mix.BATCHIDENTIFIER = MixProdInfo.MixID
				End

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add New Production Items'
		        
		        Insert into dbo.ItemMaster
		        (
		        	NameID, 
		        	DescriptionID, 
		        	ItemShortDescription,
		        	ProdItemCatID, 
		        	DispatchSlumpRange,
		        	ItemType
		        )
		        Select	MixNameInfo.NameID,
						MixDescriptionInfo.DescriptionID,
						Case 
							When Isnull(ProdItem.ShortDescription, '') = ''
							Then LTrim(RTrim(Left(MixDescriptionInfo.[Description], 16)))
							Else LTrim(RTrim(Left(ProdItem.ShortDescription, 16)))
						End,
						ItemCategoryInfo.ProdItemCatID,
						Ltrim(Rtrim(Left(ProdItem.DispatchSlumpRange, 30))),
						'Mix'
		        From
		        (
		        	Select	MixInfo.MixName As MixName, 
		        			MixInfo.Description As Description, 
		        			MixInfo.ShortDescription As ShortDescription,
		        			MixInfo.ItemCategory As ItemCategory,
		        			MixInfo.DispatchSlumpRange
		        	From #MixInfo As MixInfo
		        	Where	MixInfo.AutoID In
		        			(
		        				Select Min(MixInfo.AutoID)
		        				From #MixInfo As MixInfo
		        				Group By MixInfo.MixName
		        			)
		        ) As ProdItem
		        Inner Join dbo.Name As MixNameInfo
		        On ProdItem.MixName = MixNameInfo.Name
		        Left Join dbo.[Description] As MixDescriptionInfo
		        On ProdItem.Description = MixDescriptionInfo.[Description]
		        Left Join dbo.ProductionItemCategory As ItemCategoryInfo
		        On  ProdItem.ItemCategory = ItemCategoryInfo.ItemCategory And
		            ItemCategoryInfo.ProdItemCatType = 'Mix'
		        Left Join dbo.ItemMaster As ItemMaster
		        On ItemMaster.NameID = MixNameInfo.NameID
		        Where ItemMaster.ItemMasterID Is Null

			    Exec dbo.Utility_Print ''
			    Exec dbo.Utility_Print 'Retrieve Specified Air Content And Slump And Spread Information.'
		
			    Update MixInfo
				    Set	MixInfo.SlumpDataPointID = SlumpSpec.SpecDataPointID,
					    MixInfo.SlumpMeasID = SlumpSpec.SpecMeasID,
					    MixInfo.AirDataPointID = AirSpec.SpecDataPointID,
					    MixInfo.AirMeasID = AirSpec.SpecMeasID,
					    MixInfo.SpreadDataPointID = SpreadSpec.SpecDataPointID,
					    MixInfo.SpreadMeasID = SpreadSpec.SpecMeasID
			    From #MixInfo As MixInfo
			    Left Join dbo.RptMixSpecAirContent As AirSpec
			    On MixInfo.MixSpecID = AirSpec.MixSpecID
			    Left Join dbo.RptMixSpecSlump As SlumpSpec
			    On MixInfo.MixSpecID = SlumpSpec.MixSpecID
			    Left Join dbo.RptMixSpecSpread As SpreadSpec
			    On MixInfo.MixSpecID = SpreadSpec.MixSpecID
			
			    Exec dbo.Utility_Print ''
			    Exec dbo.Utility_Print 'Retrieve Specified Strength Information.'
		
			    Update MixInfo
				    Set	MixInfo.StrengthDataPointID = StrengthSpec.SpecDataPointID,
					    MixInfo.StrengthAgeMeasID = StrengthSpec.AgeSpecMeasID,
					    MixInfo.StrengthMeasID = StrengthSpec.StrengthSpecMeasID
			    From #MixInfo As MixInfo
			    Inner Join dbo.RptMixSpecAgeComprStrengths As StrengthSpec
			    On	MixInfo.MixSpecID = StrengthSpec.MixSpecID And
				    Round(MixInfo.StrengthAge, 8) = Round(StrengthSpec.AgeMinValue, 8)
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add Mix Specifications'
		        
		        Set @LastID = Null		        
		        Set @LastID = (Select Max(MixSpec.MixSpecID) From dbo.MixSpec As MixSpec)
		        
		        Insert into dbo.MixSpec
		        (
		        	Name,
		        	[Description]
		        )
		        Select '', ''
		        From #MixInfo As MixInfo
		        Where MixInfo.MixSpecID Is Null
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mix Specifications To Mixes'
		        
		        Update MixInfo
					Set MixInfo.MixSpecID = MixSpecInfo.MinMixSpecID + RowNumberInfo.RowNumber - 1						
		        From #MixInfo As MixInfo
		        Inner Join
		        (
		        	Select MixInfo.AutoID, Row_number() Over (Order By MixInfo.AutoID) As RowNumber
		        	From #MixInfo As MixInfo
		        	Where MixInfo.MixSpecID Is Null
		        ) As RowNumberInfo
		        On MixInfo.AutoID = RowNumberInfo.AutoID
		        Cross Join
		        (
		        	Select Min(MixSpec.MixSpecID) As MinMixSpecID
		        	From dbo.MixSpec As MixSpec
		        	Where MixSpec.MixSpecID > Isnull(@LastID, -1)
		        ) As MixSpecInfo
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add Spec Data Points for Strength Ages and Strengths'
		        
		        Set @LastID = Null
		        Set @LastID = (Select Max(SpecDataPoint.SpecDataPointID) From dbo.SpecDataPoint As SpecDataPoint)
		        
		        Insert into dbo.SpecDataPoint
		        (
		        	MixSpecID
		        )
		        Select MixInfo.MixSpecID
		        From #MixInfo As MixInfo
		        Where	MixInfo.StrengthDataPointID Is Null And
						IsNull(MixInfo.StrengthAge, -1.0) >= 0.0 And
						IsNull(MixInfo.Strength, -1.0) >= 0.0
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes to the Strength Spec Data Points'
		        
		        Update MixInfo
					Set MixInfo.StrengthDataPointID = SpecDataPoint.SpecDataPointID
		        From #MixInfo As MixInfo
		        Inner Join dbo.SpecDataPoint As SpecDataPoint
		        On SpecDataPoint.MixSpecID = MixInfo.MixSpecID
		        Where SpecDataPoint.SpecDataPointID > Isnull(@LastID, -1)

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add Specifications for Air Content Ranges'
		        
		        Set @LastID = Null
		        Set @LastID = (Select Max(SpecDataPoint.SpecDataPointID) From dbo.SpecDataPoint As SpecDataPoint)
		        
		        Insert into dbo.SpecDataPoint
		        (
		        	MixSpecID
		        )
		        Select MixInfo.MixSpecID
		        From #MixInfo As MixInfo
		        Where	MixInfo.AirDataPointID Is Null And
						(
							IsNull(MixInfo.MinAirContent, -1.0) >= 0.0 Or
							IsNull(MixInfo.MaxAirContent, -1.0) >= 0.0 
						) 
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes to Air Content Ranges'
		        
		        Update MixInfo
					Set MixInfo.AirDataPointID = SpecDataPoint.SpecDataPointID
		        From #MixInfo As MixInfo
		        Inner Join dbo.SpecDataPoint As SpecDataPoint
		        On SpecDataPoint.MixSpecID = MixInfo.MixSpecID
		        Where SpecDataPoint.SpecDataPointID > Isnull(@LastID, -1)

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add Spec Data Points for Slump Ranges'
		        
		        Set @LastID = Null
		        Set @LastID = (Select Max(SpecDataPoint.SpecDataPointID) From dbo.SpecDataPoint As SpecDataPoint)
		        
		        Insert into dbo.SpecDataPoint
		        (
		        	MixSpecID
		        )
		        Select MixInfo.MixSpecID
		        From #MixInfo As MixInfo
		        Where	MixInfo.SlumpDataPointID Is Null And
						(
							IsNull(MixInfo.MinSlump, -1.0) >= 0.0 Or 
							IsNull(MixInfo.MaxSlump, -1.0) >= 0.0
						)
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes to Slump Ranges'
		        
		        Update MixInfo
					Set MixInfo.SlumpDataPointID = SpecDataPoint.SpecDataPointID
		        From #MixInfo As MixInfo
		        Inner Join dbo.SpecDataPoint As SpecDataPoint
		        On SpecDataPoint.MixSpecID = MixInfo.MixSpecID
		        Where SpecDataPoint.SpecDataPointID > Isnull(@LastID, -1)
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add Spec Data Points for Spread Ranges'
		        
		        Set @LastID = Null
		        Set @LastID = (Select Max(SpecDataPoint.SpecDataPointID) From dbo.SpecDataPoint As SpecDataPoint)
		        
		        Insert into dbo.SpecDataPoint
		        (
		        	MixSpecID
		        )
		        Select MixInfo.MixSpecID
		        From #MixInfo As MixInfo
		        Where	MixInfo.SpreadDataPointID Is null And
						(
							IsNull(MixInfo.MinSpread, -1.0) >= 0.0 Or 
							IsNull(MixInfo.MaxSpread, -1.0) >= 0.0
						)
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes to Spread Ranges'
		        
		        Update MixInfo
					Set MixInfo.SpreadDataPointID = SpecDataPoint.SpecDataPointID
		        From #MixInfo As MixInfo
		        Inner Join dbo.SpecDataPoint As SpecDataPoint
		        On SpecDataPoint.MixSpecID = MixInfo.MixSpecID
		        Where SpecDataPoint.SpecDataPointID > Isnull(@LastID, -1)
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add Spec Meases for Strength Ages'
		        
		        Set @LastID = Null
		        Set @LastID = (Select Max(SpecMeas.SpecMeasID) From dbo.SpecMeas As SpecMeas)
		        
		        Insert into dbo.SpecMeas
		        (
					SpecDataPointID
		        )
		        Select MixInfo.StrengthDataPointID
		        From #MixInfo As MixInfo
		        Where	MixInfo.StrengthAgeMeasID Is Null And
						Isnull(MixInfo.StrengthAge, -1.0) >= 0.0 And
						IsNull(MixInfo.Strength, -1.0) >= 0.0						
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes to Strength Age Spec Meases'
		        
		        Update MixInfo
					Set MixInfo.StrengthAgeMeasID = SpecMeas.SpecMeasID
		        From #MixInfo As MixInfo
		        Inner Join dbo.SpecMeas As SpecMeas
		        On MixInfo.StrengthDataPointID = SpecMeas.SpecDataPointID
		        Where SpecMeas.SpecMeasID > Isnull(@LastID, -1)

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add Spec Meases for Strengths'
		        
		        Set @LastID = Null
		        Set @LastID = (Select Max(SpecMeas.SpecMeasID) From dbo.SpecMeas As SpecMeas)
		        
		        Insert into dbo.SpecMeas
		        (
					SpecDataPointID
		        )
		        Select MixInfo.StrengthDataPointID
		        From #MixInfo As MixInfo
		        Where	MixInfo.StrengthMeasID Is Null And
						Isnull(MixInfo.StrengthAge, -1.0) >= 0.0 And
						IsNull(MixInfo.Strength, -1.0) >= 0.0						
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes to Strength Spec Meases'
		        
		        Update MixInfo
					Set MixInfo.StrengthMeasID = SpecMeas.SpecMeasID
		        From #MixInfo As MixInfo
		        Inner Join dbo.SpecMeas As SpecMeas
		        On MixInfo.StrengthDataPointID = SpecMeas.SpecDataPointID
		        Where SpecMeas.SpecMeasID > Isnull(@LastID, -1)

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add Spec Meases for Air Ranges'
		        
		        Set @LastID = Null
		        Set @LastID = (Select Max(SpecMeas.SpecMeasID) From dbo.SpecMeas As SpecMeas)
		        
		        Insert into dbo.SpecMeas
		        (
					SpecDataPointID
		        )
		        Select MixInfo.AirDataPointID
		        From #MixInfo As MixInfo
		        Where	MixInfo.AirMeasID Is Null And
						(
							IsNull(MixInfo.MinAirContent, -1.0) >= 0.0 Or 
							IsNull(MixInfo.MaxAirContent, -1.0) >= 0.0
						)
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes to Air Range Spec Meases'
		        
		        Update MixInfo
					Set MixInfo.AirMeasID = SpecMeas.SpecMeasID
		        From #MixInfo As MixInfo
		        Inner Join dbo.SpecMeas As SpecMeas
		        On MixInfo.AirDataPointID = SpecMeas.SpecDataPointID
		        Where SpecMeas.SpecMeasID > Isnull(@LastID, -1)

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add Spec Meases for Slump Ranges'
		        
		        Set @LastID = Null
		        Set @LastID = (Select Max(SpecMeas.SpecMeasID) From dbo.SpecMeas As SpecMeas)
		        
		        Insert into dbo.SpecMeas
		        (
					SpecDataPointID
		        )
		        Select MixInfo.SlumpDataPointID
		        From #MixInfo As MixInfo
		        Where	MixInfo.SlumpMeasID Is Null And
						(
							IsNull(MixInfo.MinSlump, -1.0) >= 0.0 Or 
							IsNull(MixInfo.MaxSlump, -1.0) >= 0.0
						)
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes to Slump Range Spec Meases'
		        
		        Update MixInfo
					Set MixInfo.SlumpMeasID = SpecMeas.SpecMeasID
		        From #MixInfo As MixInfo
		        Inner Join dbo.SpecMeas As SpecMeas
		        On MixInfo.SlumpDataPointID = SpecMeas.SpecDataPointID
		        Where SpecMeas.SpecMeasID > Isnull(@LastID, -1)
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Add Spec Meases for Spreads'
		        
		        Set @LastID = Null
		        Set @LastID = (Select Max(SpecMeas.SpecMeasID) From dbo.SpecMeas As SpecMeas)
		        
		        Insert into dbo.SpecMeas
		        (
					SpecDataPointID
		        )
		        Select MixInfo.SpreadDataPointID
		        From #MixInfo As MixInfo
		        Where	MixInfo.SpreadMeasID Is Null And
						(
							IsNull(MixInfo.MinSpread, -1.0) >= 0.0 Or 
							IsNull(MixInfo.MaxSpread, -1.0) >= 0.0
						)		        
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes to Spread Range Spec Meases'
		        
		        Update MixInfo
					Set MixInfo.SpreadMeasID = SpecMeas.SpecMeasID
		        From #MixInfo As MixInfo
		        Inner Join dbo.SpecMeas As SpecMeas
		        On MixInfo.SpreadDataPointID = SpecMeas.SpecDataPointID
		        Where SpecMeas.SpecMeasID > Isnull(@LastID, -1)
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Set Up Strength Age Spec Meases'
		        
		        Update SpecMeas
					Set SpecMeas.MeasTypeID = 2,
						SpecMeas.MinValue = MixInfo.StrengthAge,
						SpecMeas.MaxValue = MixInfo.StrengthAge,
						SpecMeas.UnitsLink = 7
		        From dbo.SpecMeas As SpecMeas
		        Inner Join #MixInfo As MixInfo
		        On SpecMeas.SpecMeasID = MixInfo.StrengthAgeMeasID
		        Where	IsNull(MixInfo.StrengthAge, -1.0) >= 0.0 And
						IsNull(MixInfo.Strength, -1.0) >= 0.0

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Set Up Strength Spec Meases'
		        
		        Update SpecMeas
					Set SpecMeas.MeasTypeID = 22,
						SpecMeas.MinValue = MixInfo.Strength,
						SpecMeas.MaxValue = MixInfo.Strength,
						SpecMeas.UnitsLink = 6
		        From dbo.SpecMeas As SpecMeas
		        Inner Join #MixInfo As MixInfo
		        On SpecMeas.SpecMeasID = MixInfo.StrengthMeasID
		        Where	IsNull(MixInfo.StrengthAge, -1.0) >= 0.0 And
						IsNull(MixInfo.Strength, -1.0) >= 0.0

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Set Up Air Range Spec Meases'
		        
		        Update SpecMeas
					Set SpecMeas.MeasTypeID = 10,
						SpecMeas.MinValue = MixInfo.MinAirContent,
						SpecMeas.MaxValue = MixInfo.MaxAirContent,
						SpecMeas.UnitsLink = 4
		        From dbo.SpecMeas As SpecMeas
		        Inner Join #MixInfo As MixInfo
		        On SpecMeas.SpecMeasID = MixInfo.AirMeasID
		        Where	IsNull(MixInfo.MinAirContent, -1.0) >= 0.0 Or
						IsNull(MixInfo.MaxAirContent, -1.0) >= 0.0 

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Set Up Slump Range Spec Meases'
		        
		        Update SpecMeas
					Set SpecMeas.MeasTypeID = 28,
						SpecMeas.MinValue = MixInfo.MinSlump,
						SpecMeas.MaxValue = MixInfo.MaxSlump,
						SpecMeas.UnitsLink = 9
		        From dbo.SpecMeas As SpecMeas
		        Inner Join #MixInfo As MixInfo
		        On SpecMeas.SpecMeasID = MixInfo.SlumpMeasID
		        Where	IsNull(MixInfo.MinSlump, -1.0) >= 0.0 Or
						IsNull(MixInfo.MaxSlump, -1.0) >= 0.0

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Set Up Spread Range Spec Meases'
		        
		        Update SpecMeas
					Set SpecMeas.MeasTypeID = 32,
						SpecMeas.MinValue = MixInfo.MinSpread,
						SpecMeas.MaxValue = MixInfo.MaxSpread,
						SpecMeas.UnitsLink = 9
		        From dbo.SpecMeas As SpecMeas
		        Inner Join #MixInfo As MixInfo
		        On SpecMeas.SpecMeasID = MixInfo.SpreadMeasID
		        Where	IsNull(MixInfo.MinSpread, -1.0) >= 0.0 Or
						IsNull(MixInfo.MaxSpread, -1.0) >= 0.0 
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Remove Empty Spec Meases'
		        
		        Delete SpecMeas
		        From dbo.SpecMeas As SpecMeas
		        Where MeasTypeID Is Null
				
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Remove Empty Spec Data Points'
		        
				Delete SpecDataPoint
				From dbo.SpecDataPoint As SpecDataPoint
				Left Join dbo.SpecMeas As SpecMeas
				On SpecMeas.SpecDataPointID = SpecDataPoint.SpecDataPointID
				Where SpecMeas.SpecMeasID Is Null

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Remove Existing Recipes'
		        
				Delete Recipe
				From dbo.MaterialRecipe As Recipe
				Inner Join #MixInfo As MixInfo
				On  Recipe.EntityID = MixInfo.ActualMixID And
				    Recipe.EntityType = 'Mix'
				
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Reset the Spec Meas, Spec Data Point, and Material Recipe Auto Numbers'
		        
				Exec dbo.Utilities_ResetAutoNumberInPhysicalTable 'SpecMeas'
				Exec dbo.Utilities_ResetAutoNumberInPhysicalTable 'SpecDataPoint'
				Exec dbo.Utilities_ResetAutoNumberInPhysicalTable 'MaterialRecipe'

				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Update Existing Mixes'
				
				Update Mix
				    Set Mix.AIR = Case when IsNull(MixInfo.AirContent, -1.0) >= 0.0 And Isnull(MixInfo.AirContent, -1.0) <= 90.0 Then MixInfo.AirContent Else Mix.AIR End,
				        Mix.SLUMP = Case when Isnull(MixInfo.Slump, -1.0) >= 0.0 Then MixInfo.Slump * 25.4 Else Mix.SLUMP End,
				        Mix.MixTargetSpread = Case when Isnull(MixInfo.Spread, -1.0) >= 0.0 Then MixInfo.Spread * 25.4 Else Mix.MixTargetSpread End,
				        Mix.MixSpecID = Case when MixInfo.MixSpecID Is Not null Then MixInfo.MixSpecID Else Mix.MixSpecID End,
				        Mix.ItemMasterID = ItemMaster.ItemMasterID,
				        Mix.DescriptionID = Case when ItemMaster.ItemMasterID Is Not Null Then ItemMaster.DescriptionID Else Mix.DescriptionID End,
				        Mix.BatchPanelCode = Case when ItemMaster.ItemMasterID Is not Null Then MixName.Name Else Null End,
				        Mix.BatchPanelDescription = ItemDescr.[Description],
				        Mix.ProductionStatus = Case when Isnull(Mix.ProductionStatus, '') In ('InSync', 'Sent') Then 'OutOfSync' Else Mix.ProductionStatus End
				From dbo.Batch As Mix
				Inner Join #MixInfo As MixInfo
				On Mix.BATCHIDENTIFIER = MixInfo.ActualMixID
				Inner Join dbo.Name As MixName
				On Mix.NameID = MixName.NameID
			    Left Join dbo.ItemMaster As ItemMaster
			    On  MixName.NameID = ItemMaster.NameID And
			        ItemMaster.ItemType = 'Mix'
			    Left Join dbo.[Description] As ItemDescr
			    On ItemMaster.DescriptionID = ItemDescr.DescriptionID
				
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Add New Mixes'
				
				Insert Into [dbo].[Batch]
				(
				    Code,
				    CrushCode,
				    Date,
				    Time,
				    MixNameCode,
				    Air,
				    ThrmCond,
				    Slump,
				    MixTargetSpread,
				    Mix,
				    Plant_Link,
				    MixSpecID,
				    ItemMasterID,
				    NameID,
				    DescriptionID,
				    BatchPanelCode,
				    BatchPanelDescription
				)					
				Select  MixInfo.MixCode,
				        'S97000000000',
				        @MixDate,
				        @MixTime,
				        MixInfo.MixNameCode,
				        Isnull(MixInfo.AirContent, 1.5),
				        8.099819,
				        MixInfo.Slump * 25.4, 
				        MixInfo.Spread * 25.4, 
				        'y',
				        Plants.PlantId,
				        MixInfo.MixSpecID,
				        ItemMaster.ItemMasterID,
				        MixNameInfo.NameID,
				        Case when ItemMaster.ItemMasterID Is Null Then MixDescriptionInfo.DescriptionID Else ItemMaster.DescriptionID End,
				        Case when ItemMaster.ItemMasterID Is Null Then Null Else MixNameInfo.Name End,
				        ItemDescrInfo.[Description]
				    From #MixInfo As MixInfo
				    Inner Join dbo.Plants As Plants
				    On MixInfo.PlantName = Plants.Name
				    Inner Join dbo.Name As MixNameInfo
				    On MixInfo.MixName = MixNameInfo.Name
				    Left Join dbo.[Description] As MixDescriptionInfo
				    On MixInfo.[Description] = MixDescriptionInfo.[Description]
				    Left Join dbo.ItemMaster As ItemMaster
				    On	ItemMaster.NameID = MixNameInfo.NameID And
						ItemMaster.ItemType = 'Mix'
				    Left Join dbo.[Description] As ItemDescrInfo
				    On ItemDescrInfo.DescriptionID = ItemMaster.DescriptionID
				    Where MixInfo.ActualMixID Is Null
				    
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Add New Mix Recipe Ingredients'
				
			    Insert Into dbo.MaterialRecipe
			    (
			        EntityID,
			        EntityType,
			        CODE,
			        MaterialID,
			        MATERIAL,
			        QUANTITY,
			        MOISTURE
			    )				    
			    Select	Mix.BATCHIDENTIFIER,
						'Mix',
						Mix.CODE,
						MixRecipeInfo.MaterialID,
						MixRecipeInfo.MaterialCode,
						MixRecipeInfo.ConvertedQuantity,
						0.0 
			    From #MixInfo As MixInfo
			    Inner Join #MixRecipeInfo As MixRecipeInfo
			    On	MixInfo.PlantName = MixRecipeInfo.PlantName And
					MixInfo.MixName = MixRecipeInfo.MixName
			    Inner Join dbo.BATCH As Mix
			    On MixInfo.MixCode = Mix.CODE
			    
			    Exec dbo.Utility_Print ''
			    Exec dbo.Utility_Print 'Calculate Mix Sack Contents'

				Update Mix
					Set SackContent = Recipe.CementitiousQty / (94.0 * 0.45359240000781)
					From dbo.Batch As Mix
					Inner Join #MixInfo As MixInfo
					On Mix.CODE = MixInfo.MixCode
					Inner Join
					(
						Select MaterialRecipe.EntityID As MixID, Sum(MaterialRecipe.Quantity) As CementitiousQty
							From [dbo].[MaterialRecipe] As MaterialRecipe
							Inner Join #MixInfo As MixInfo
							On	MaterialRecipe.CODE = MixInfo.MixCode And
								MaterialRecipe.EntityType = 'Mix'							 
							Inner Join [dbo].[Material] As Material
							On MaterialRecipe.MaterialID = Material.MaterialIdentifier
							Where Material.FamilyMaterialTypeID In (2, 4)
							Group By MaterialRecipe.EntityID
					) As Recipe
					On Mix.BATCHIDENTIFIER = Recipe.MixID
				
				If dbo.Validation_DatabaseTemporaryTableExists('#MixIDInfo') = 1
				Begin
				    Drop table #MixIDInfo
				End
				
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Create Mix ID Storage'
				
				Create table #MixIDInfo
				(
					MixID Int
				)
				
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Get Mix Information For Calculations'
				
				Insert into #MixIDInfo (MixID)
					Select Mix.BATCHIDENTIFIER
					From dbo.Batch As Mix
					Inner Join #MixInfo As MixInfo
					On Mix.CODE = MixInfo.MixCode
				
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Calculate The Mix Theoretical And Measured Values'
				
				Exec dbo.Mix_CalcTheoAndMeasCalcsByMixIDTempTable '#MixIDInfo', 'MixID', 1.5, 0
				
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Calculate The Mix Material Costs'
				
				Exec dbo.Mix_CalcMaterialCostsByMixIDTempTable '#MixIDInfo', 'MixID', 1.5, 0

				If dbo.Validation_DatabaseTemporaryTableExists('#MixIDInfo') = 1
				Begin
				    Drop table #MixIDInfo
				End
				--*/
			End
		End
		
		Commit Transaction
		
		Exec dbo.Utility_Print ''
		Exec dbo.Utility_Print 'The Mixes May Have Been Imported.'
		
    End Try
    Begin catch
		If @@TRANCOUNT > 0
		Begin
		    Rollback Transaction
		End
		
		Select	@ErrorMessage = Error_message(),
				@ErrorSeverity = Error_severity()
				
		Print 'The Mixes could not be imported.  The Import was rolled back.'
		Print 'Error Message - ' + @ErrorMessage
		Print 'Error Severity - ' + Cast(@ErrorSeverity As Nvarchar) + '.'		

		Raiserror(@ErrorMessage, @ErrorSeverity, 1)
    End Catch

	If dbo.Validation_DatabaseTemporaryTableExists('#MixInfo') = 1
	Begin
	    Drop table #MixInfo
	End

	If dbo.Validation_DatabaseTemporaryTableExists('#MixRecipeInfo') = 1
	Begin
	    Drop table #MixRecipeInfo
	End

    If dbo.Validation_DatabaseTemporaryTableExists('#MaterialInfo') = 1
    Begin
		Drop Table #MaterialInfo
    End
End
Go
