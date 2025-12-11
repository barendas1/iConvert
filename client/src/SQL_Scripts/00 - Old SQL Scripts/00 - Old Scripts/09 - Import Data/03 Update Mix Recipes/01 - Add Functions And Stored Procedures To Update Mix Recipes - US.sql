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

If dbo.Validation_StoredProcedureExists('MixImport_UpdateMixRecipes') = 1
Begin
	Drop Procedure dbo.MixImport_UpdateMixRecipes
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 11/07/2014
-- Description:	Update The Mix Recipes
-- ================================================================================================
Create Procedure [dbo].[MixImport_UpdateMixRecipes]
As
Begin
	Declare @AggregatesInYards Bit
	
	Declare @CodeDate Nvarchar (20)
	Declare @CodeSuffix Int
	Declare @MixNameCode Nvarchar (20)
	Declare @LastID Int
	Declare @MixTimeStamp Datetime
	Declare @MixDate Nvarchar (20)
	Declare @MixTime Nvarchar (20)
		
	Declare @NewLine Nvarchar (10)
	
	Declare @ErrorNumber Int
	Declare @ErrorMessage Nvarchar (Max)
	Declare @ErrorMsg Nvarchar (Max)
	Declare @ErrorSeverity Int
	Declare @ErrorState Int
		
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
		SpreadMeasID Int,
		DBMixID Int,
		DBMixCode Nvarchar (30),
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
	Create Index IX_MixInfo_DBMixID On #MixInfo (DBMixID)
	Create Index IX_MixInfo_DBMixCode On #MixInfo (DBMixCode)
	
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
    
    Set @NewLine = dbo.GetNewLine()
    
    Begin try
		Begin Transaction
		
		If Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
		Begin
		    If	Exists(Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo')
		    Begin
		    	Exec dbo.Utility_Print ''
		    	Exec dbo.Utility_Print 'Update Mix Recipes'
		    	
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
		    	/*		    	
		    	Exec dbo.Utility_Print ''
		    	Exec dbo.Utility_Print 'Set Up Date, Time, Code, And Mix Name Code Info'
		    	
				Set @MixTimeStamp = GetDate()

				Set @MixDate =  Right('00' + LTrim(RTrim(Cast(Month(@MixTimeStamp) As NVarChar))), 2) + '/' +
								Right('00' + LTrim(RTrim(Cast(Day(@MixTimeStamp) As NVarChar))), 2) + '/' +
								Right('0000' + LTrim(RTrim(Cast(Year(@MixTimeStamp) As NVarChar))), 4)
		                        
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
				*/
				
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Format Mix Information To Be Imported'
				
				Update MixInfo
					Set MixInfo.PlantCode = LTrim(RTrim(MixInfo.PlantCode)),
						MixInfo.MixCode = LTrim(RTrim(MixInfo.MixCode)),
						MixInfo.MixDescription = LTrim(RTrim(MixInfo.MixDescription)),
						MixInfo.MixShortDescription = LTrim(RTrim(MixInfo.MixShortDescription)),
						MixInfo.ItemCategory = LTrim(RTrim(MixInfo.ItemCategory)),
						MixInfo.DispatchSlumpRange = LTrim(RTrim(MixInfo.DispatchSlumpRange)),
						MixInfo.Padding1 = LTrim(RTrim(MixInfo.Padding1)),
						MixInfo.MaterialItemCode = LTrim(RTrim(MixInfo.MaterialItemCode)),
						MixInfo.MaterialItemDescription = LTrim(RTrim(MixInfo.MaterialItemDescription)),
						MixInfo.QuantityUnitName = LTrim(RTrim(MixInfo.QuantityUnitName))
				From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo

				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Retrieve Mix Import Information'
				
				Insert Into #MixInfo
				(
				    MixID,
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
				From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
				Where	MixInfo.AutoID In
						(
							Select Min(MixInfo.AutoID)
							From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
							Inner Join dbo.Plant As Plant
							On MixInfo.PlantCode = Plant.PLNTNAME
							Inner Join dbo.Name As MixName
							On MixInfo.MixCode = MixName.Name
							Inner Join dbo.Batch As Mix
							On	Plant.PLANTIDENTIFIER = Mix.Plant_Link And
								MixName.NameID = Mix.NameID
							--Inner Join Data_Import_RJ.dbo.TestImport0000_MixInfoNotDeleted As MixIDInfo
							--On Mix.BATCHIDENTIFIER = MixIDInfo.MixID
							Inner Join
							(
								Select MixRecipe.PlantCode, MixRecipe.MixCode
								From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixRecipe
								Inner Join #MaterialInfo As MaterialInfo
								On	MixRecipe.PlantCode = MaterialInfo.PlantName And
									MixRecipe.MaterialItemCode = MaterialInfo.ItemCode
								Where MaterialInfo.FamilyMaterialTypeID In (2, 4)
								Group By MixRecipe.PlantCode, MixRecipe.MixCode
								Having Round(Sum(MixRecipe.Quantity), 2) > 0.0
							) As CementitiousMix
							On	MixInfo.PlantCode = CementitiousMix.PlantCode And
								MixInfo.MixCode = CementitiousMix.MixCode
							Inner Join
							(
								Select MixRecipe.PlantCode, MixRecipe.MixCode
								From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixRecipe
								Inner Join #MaterialInfo As MaterialInfo
								On	MixRecipe.PlantCode = MaterialInfo.PlantName And
									MixRecipe.MaterialItemCode = MaterialInfo.ItemCode
								Where MaterialInfo.FamilyMaterialTypeID In (5)
								Group By MixRecipe.PlantCode, MixRecipe.MixCode
								Having Round(Sum(MixRecipe.Quantity), 2) > 0.0
							) As WaterMix
							On	MixInfo.PlantCode = WaterMix.PlantCode And
								MixInfo.MixCode = WaterMix.MixCode
							Left Join
							(
								Select -1 As ID, MixInfo.PlantCode, MixInfo.MixCode
								From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
								Group By MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode
								Having Count(*) > 1
							) As MultiMaterial
							On	MultiMaterial.PlantCode = MixInfo.PlantCode And
								MultiMaterial.MixCode = MixInfo.MixCode
							Left Join
							(
								Select -1 As ID, MixInfo.PlantCode, MixInfo.MixCode
								From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
								Left Join #MaterialInfo As MaterialInfo
								On	MixInfo.PlantCode = MaterialInfo.PlantName And
									MixInfo.MaterialItemCode = MaterialInfo.ItemCode
								Where	MaterialInfo.AutoID Is Null
								Group By MixInfo.PlantCode, MixInfo.MixCode
							) As MissingMaterial
							On	MixInfo.PlantCode = MissingMaterial.PlantCode And
								MixInfo.MixCode = MissingMaterial.MixCode
							Where	IsNull(MixInfo.MixCode, '') <> '' And									
									MultiMaterial.ID Is Null And
									MissingMaterial.ID Is Null								
							Group By	MixInfo.PlantCode,
										MixInfo.MixCode
						)
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
				Inner Join Data_Import_RJ.dbo.TestImport0000_MixInfo As MixRecipe
				On	MixInfo.PlantName = MixRecipe.PlantCode And
					MixInfo.MixName = MixRecipe.MixCode
				Inner Join #MaterialInfo As MaterialInfo
				On	MixRecipe.PlantCode = MaterialInfo.PlantName And
					MixRecipe.MaterialItemCode = MaterialInfo.ItemCode
		        Order By MixRecipe.PlantCode, MixRecipe.MixCode, MixRecipe.MaterialItemCode
		        
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
		        Where MixRecipeInfo.QuantityUnit In ('OZ', 'Ounces')
				
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
		        Where MixRecipeInfo.QuantityUnit In ('GL', 'GA', 'Gallons')

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
		        Where MixRecipeInfo.QuantityUnit = 'CW'

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Set Recipe Quantities in Kgs'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit = 'KG'

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Convert Recipe Quantities From L to Kgs'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity * MixRecipeInfo.SpecificGravity * 1.0
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit = 'L'

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Convert Recipe Quantities From Ml to Kgs'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity * MixRecipeInfo.SpecificGravity * 1.0 / 1000.0
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit = 'ML'

		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Set Recipe Quantities in Kgs (Units are Each or Bag)'
		        
		        Update MixRecipeInfo 
					Set MixRecipeInfo.ConvertedQuantity = MixRecipeInfo.Quantity
		        From #MixRecipeInfo As MixRecipeInfo
		        Where MixRecipeInfo.QuantityUnit In ('Each', 'Bag')
				/*
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes To Mix Name Codes'
		        
		        Update MixInfo
					Set MixInfo.MixNameCode = MixNameCodeList.MixNameCode
		        From #MixInfo As MixInfo
		        Inner Join dbo.GetMixNameCodeList(Isnull((Select Count(*) From #MixInfo), 0), @MixNameCode, 4) As MixNameCodeList
		        On MixNameCodeList.AutoID = MixInfo.AutoID
		        
		        Exec dbo.Utility_Print ''
		        Exec dbo.Utility_Print 'Link Mixes To Codes'
		        
		        Update MixInfo
					Set MixInfo.MixCode = 'B' + @CodeDate + Right('00000' + Cast(@CodeSuffix + MixInfo.AutoID - 1 As Nvarchar), 5)										
		        From #MixInfo As MixInfo
		        */
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
		        
		        /*
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
		        On ProdItem.ItemCategory = ItemCategoryInfo.ItemCategory
		        Left Join dbo.ItemMaster As ItemMaster
		        On ItemMaster.NameID = MixNameInfo.NameID
		        Where ItemMaster.ItemMasterID Is Null
		        
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
		        Exec dbo.Utility_Print 'Reset the Spec Meas and Spec Data Point Auto Numbers'
		        
				Exec dbo.Utilities_ResetAutoNumberInPhysicalTable 'SpecMeas'
				Exec dbo.Utilities_ResetAutoNumberInPhysicalTable 'SpecDataPoint'
				
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
				*/

				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Retrieve Mix ID Info'
				
				Update MixInfo
					Set MixInfo.DBMixID = Mix.BATCHIDENTIFIER,
						MixInfo.DBMixCode = Mix.CODE
				From #MixInfo As MixInfo
				Inner Join dbo.Plants As Plants
				On MixInfo.PlantName = Plants.Name
				Inner Join dbo.Name As MixName
				On MixInfo.MixName = MixName.Name
				Inner Join dbo.Batch As Mix
				On	Mix.Plant_Link = Plants.PlantId And
					Mix.NameID = MixName.NameID 
					
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Set In-Sync Mixes To Out-Of-Sync'
				
				Update Mix
					Set Mix.ProductionStatus = 'OutOfSync'
				From dbo.BATCH As Mix
				Inner Join #MixInfo As MixInfo
				On Mix.BATCHIDENTIFIER = MixInfo.DBMixID
				Where Isnull(Mix.ProductionStatus, '') In ('InSync', 'Sent')

				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Remove Existing Mix Recipes'
				
				Delete MaterialRecipe
				From dbo.MaterialRecipe As MaterialRecipe
				Inner Join #MixInfo As MixInfo
				On	MaterialRecipe.EntityID = MixInfo.DBMixID And
					MaterialRecipe.EntityType = 'Mix'
				
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Add New Mix Recipes'
				
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
			    Select	MixInfo.DBMixID,
						'Mix',
						MixInfo.DBMixCode,
						MixRecipeInfo.MaterialID,
						MixRecipeInfo.MaterialCode,
						MixRecipeInfo.ConvertedQuantity,
						0.0 
			    From #MixInfo As MixInfo
			    Inner Join #MixRecipeInfo As MixRecipeInfo
			    On	MixInfo.PlantName = MixRecipeInfo.PlantName And
					MixInfo.MixName = MixRecipeInfo.MixName
			    
			    Exec dbo.Utility_Print ''
			    Exec dbo.Utility_Print 'Calculate Mix Sack Contents'

				Update Mix
					Set SackContent = Recipe.CementitiousQty / (94.0 * 0.45359240000781)
					From dbo.Batch As Mix
					Inner Join #MixInfo As MixInfo
					On Mix.BATCHIDENTIFIER = MixInfo.DBMixID
					Inner Join
					(
						Select MaterialRecipe.EntityID As MixID, Sum(MaterialRecipe.Quantity) As CementitiousQty
							From [dbo].[MaterialRecipe] As MaterialRecipe
							Inner Join #MixInfo As MixInfo
							On	MaterialRecipe.EntityID = MixInfo.DBMixID And
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
					MixID Int Primary Key
				)
				
				Exec dbo.Utility_Print ''
				Exec dbo.Utility_Print 'Get Mix Information For Calculations'
				
				Insert into #MixIDInfo (MixID)
					Select Mix.BATCHIDENTIFIER
					From dbo.Batch As Mix
					Inner Join #MixInfo As MixInfo
					On Mix.BATCHIDENTIFIER = MixInfo.DBMixID
					Group By Mix.BATCHIDENTIFIER
				
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
		Exec dbo.Utility_Print 'The Mix Recipes May Have Been Updated.'
		
    End Try
    Begin catch
		If @@TRANCOUNT > 0
		Begin
			Rollback Transaction
		End
	    
		Select  @ErrorNumber  = Error_number(),
				@ErrorSeverity = Error_severity(),
				@ErrorState = Error_state(),
				@ErrorMessage  = Error_message()
				
		Set @ErrorMsg = @ErrorMessage

		Set @ErrorMessage = --@NewLine +
			'   Error Number: ' + Cast(Isnull(@ErrorNumber, -1) As Nvarchar) + '.  ' + @NewLine +
			'   Error Severity: ' + Cast(Isnull(@ErrorSeverity, -1) As Nvarchar) + '.  ' + @NewLine +
			'   Error State: ' + Cast(Isnull(@ErrorState, -1) As Nvarchar) + '.  ' + @NewLine +
			'   Error Message: ' + Isnull(@ErrorMessage, '') + @NewLine
	    
		Raiserror('', 0, 0) With NoWait 
		Raiserror('The Mix Recipes could not be updated.  The Transaction was rolled back.', 0, 0) With NoWait
		Print @ErrorMessage

		Raiserror(@ErrorMsg, @ErrorSeverity, 1)
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
