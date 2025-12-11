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

If ObjectProperty(Object_ID(N'[dbo].[ACIBatchViewDetails]'), N'IsUserTable') = 1
Begin
	If Db_name() In ('', '', '', '')
	Begin
		Declare @UpdateMixProdStatus Bit
		Declare @LastID Int 
		
		Declare @NewLine Nvarchar (10)
	
		Declare @ErrorNumber Int
		Declare @ErrorMessage Nvarchar (Max)
		Declare @ErrorSeverity Int
		Declare @ErrorState Int
		
		Set @NewLine = dbo.GetNewLine()
		
		Set @UpdateMixProdStatus = 0
	
		--Set Statistics Time On
		
		Begin Try
			Begin Transaction

			Raiserror('', 0, 0) With NoWait
			Raiserror('Update Mix Design And Specified Properties.', 0, 0) With NoWait

			If dbo.Validation_DatabaseTemporaryTableExists('#MixInfo') = 1
			Begin
				Drop table #MixInfo
			End
		
			Create table #MixInfo
			(
				AutoID Int Identity (1, 1),
				PlantCode Nvarchar (100),
				MixCode Nvarchar (100),
				MixDescription Nvarchar (300),
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
				MaxWaterQuantity Float,
				CurrentStrengthAge Float,
				CurrentStrength Float,
				CurrentAirContent Float,
				CurrentMinAirContent Float,
				CurrentMaxAirContent Float,
				CurrentSlump Float,
				CurrentMinSlump Float,
				CurrentMaxSlump Float,
				CurrentSpread Float,
				CurrentMinSpread Float,
				CurrentMaxSpread Float,
				WCMRatio Float,
				MixID Int,
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
				Ratio1ID Int,
				Numerator11ID Int,
				Denominator11ID Int,
				Denominator12ID Int
			)
			
			Create Index IX_MixInfo_AutoID On #MixInfo (AutoID)
			Create Index IX_MixInfo_PlantCode On #MixInfo (PlantCode)
			Create Index IX_MixInfo_MixCode On #MixInfo (MixCode)
			Create Index IX_MixInfo_StrengthAge On #MixInfo (StrengthAge)
			Create Index IX_MixInfo_MixID On #MixInfo (MixID)
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
			Create Index IX_MixInfo_Ratio1ID On #MixInfo (Ratio1ID)
			Create Index IX_MixInfo_Numerator11ID On #MixInfo (Numerator11ID)
			Create Index IX_MixInfo_Denominator11ID On #MixInfo (Denominator11ID)
			Create Index IX_MixInfo_Denominator12ID On #MixInfo (Denominator12ID)
			--Create Index IX_MixInfo_ On #MixInfo ()

			If dbo.Validation_DatabaseTemporaryTableExists('#MixCalcInfo') = 1
			Begin
				Drop table #MixCalcInfo
			End
			
			Create table #MixCalcInfo
			(
				MixID Int Primary Key
			)
		
			Raiserror('', 0, 0) With NoWait
			Raiserror('Format The Mix Information', 0, 0) With NoWait

		    Update MixInfo
			    Set MixInfo.PlantCode = Ltrim(Rtrim(Replace(MixInfo.PlantCode, Char(160), ' '))),
			        MixInfo.MixCode = Ltrim(Rtrim(Replace(MixInfo.MixCode, Char(160), ' '))),
				    MixInfo.MixDescription = Ltrim(Rtrim(Replace(MixInfo.MixDescription, Char(160), ' ')))
		    From Data_Import_RJ.dbo.Import08_MixInfo21 As MixInfo
				
			Raiserror('', 0, 0) With NoWait
			Raiserror('Retrieve Mixes With Mix Properties That Might Be Updated.', 0, 0) With NoWait
		
			Insert into #MixInfo
			(
				-- AutoID -- this column value is auto-generated
				PlantCode,
				MixCode,
				MixDescription,
				StrengthAge,
				Strength,
				AirContent,
				MinAirContent,
				MaxAirContent,
				Slump,
				MinSlump,
				MaxSlump,
				Spread,
				MinSpread,
				MaxSpread,
				MaxWaterQuantity,
				CurrentAirContent,
				CurrentMinAirContent,
				CurrentMaxAirContent,
				CurrentSlump,
				CurrentMinSlump,
				CurrentMaxSlump,
				CurrentSpread,
				CurrentMinSpread,
				CurrentMaxSpread,
				WCMRatio,
				MixID,
				MixSpecID
			)
			Select	Plants.Name As PlantCode, 
					ItemName.Name As MixItemCode, 
					Isnull(MixInfo.MixDescription, '') As MixItemDescription,
					Case when Round(Isnull(MixInfo.Strength, -1.0), 4) <= 0.0 Then Null When Round(Isnull(MixInfo.StrengthAge, -1.0), 4) <= 0.0 Then 28.0 Else MixInfo.StrengthAge End As StrengthAge, 
					Case When Round(IsNull(MixInfo.Strength, -1.0), 4) <= 0.0 Then Null Else MixInfo.Strength End As Strength,
					Case when Isnull(MixInfo.AirContent, -1.0) >= 0.0 And Isnull(MixInfo.AirContent, -1.0) <= 90.0 Then MixInfo.AirContent Else Null End As AirContent, 
			      	Case when Isnull(MixInfo.MinAirContent, -1.0) <= 0.0 And Isnull(MixInfo.MaxAirContent, -1.0) <= 0.0 Then Null when Isnull(MixInfo.MinAirContent, -1.0) >= 0.0 And Isnull(MixInfo.MinAirContent, -1.0) <= 90.0 Then MixInfo.MinAirContent Else Null End As MinAirContent,
			      	Case when Isnull(MixInfo.MinAirContent, -1.0) <= 0.0 And Isnull(MixInfo.MaxAirContent, -1.0) <= 0.0 Then Null when Isnull(MixInfo.MaxAirContent, -1.0) >= 0.0 And Isnull(MixInfo.MaxAirContent, -1.0) <= 90.0 Then MixInfo.MaxAirContent Else Null End As MaxAirContent,
			      	Case when Isnull(MixInfo.Slump, -1.0) >= 0.0 And Isnull(MixInfo.Slump, -1.0) <= 12.0 Then MixInfo.Slump Else Null End As Slump, 
			      	Case when Isnull(MixInfo.MinSlump, -1.0) < 0.0 Or Isnull(MixInfo.MinSlump, -1.0) <= 0.0 And Isnull(MixInfo.MaxSlump, -1.0) <= 0.0 Then Null When Isnull(MixInfo.MinSlump, -1.0) <= 12.0 And Isnull(MixInfo.MaxSlump, -1.0) <= 12.0 Then MixInfo.MinSlump Else Null End As MinSlump, 
			      	Case when Isnull(MixInfo.MaxSlump, -1.0) < 0.0 Or Isnull(MixInfo.MinSlump, -1.0) <= 0.0 And Isnull(MixInfo.MaxSlump, -1.0) <= 0.0 Then Null When Isnull(MixInfo.MinSlump, -1.0) <= 12.0 And Isnull(MixInfo.MaxSlump, -1.0) <= 12.0 Then MixInfo.MaxSlump Else Null End As MaxSlump,
			      	Case when Isnull(MixInfo.Slump, -1.0) > 12.0 Then MixInfo.Slump Else Null End As Spread, 
			      	Case when Isnull(MixInfo.MinSlump, -1.0) > 12.0 Or Isnull(MixInfo.MaxSlump, -1.0) > 12.0 Then MixInfo.MinSlump Else Null End As MinSpread, 
			      	Case when Isnull(MixInfo.MinSlump, -1.0) > 12.0 Or Isnull(MixInfo.MaxSlump, -1.0) > 12.0 Then MixInfo.MaxSlump Else Null End As MaxSpread,
			      	Null As MaxWaterQuantity,
			      	Case when Isnull(Mix.AIR, -1.0) >= 0.0 Then Mix.AIR Else Null End As CurrentAirContent,
			      	Case when Isnull(AirContentSpec.MinAirContent, -1.0) >= 0.0 Then AirContentSpec.MinAirContent Else Null End As CurrentMinAirContent,
			      	Case when Isnull(AirContentSpec.MaxAirContent, -1.0) >= 0.0 Then AirContentSpec.MaxAirContent Else Null End As CurrentMaxAirContent,
			      	Mix.SLUMP / 25.4 As CurentSlump,
			      	Case when Isnull(SlumpSpec.SlumpUnitsID, -1) = 9 Then SlumpSpec.MinSlump When Isnull(SlumpSpec.SlumpUnitsID, -1) = 8 Then SlumpSpec.MinSlump / 25.4 Else Null End As CurrentMinSlump,
			      	Case when Isnull(SlumpSpec.SlumpUnitsID, -1) = 9 Then SlumpSpec.MaxSlump When Isnull(SlumpSpec.SlumpUnitsID, -1) = 8 Then SlumpSpec.MaxSlump / 25.4 Else Null End As CurrentMaxSlump,
			      	Mix.MixTargetSpread / 25.4 As CurrentSpread,
			      	Case when Isnull(SpreadSpec.SpreadUnitsID, -1) = 9 Then SpreadSpec.MinSpread When Isnull(SpreadSpec.SpreadUnitsID, -1) = 8 Then SpreadSpec.MinSpread / 25.4 Else Null End As CurrentMinSpread,
			      	Case when Isnull(SpreadSpec.SpreadUnitsID, -1) = 9 Then SpreadSpec.MaxSpread When Isnull(SpreadSpec.SpreadUnitsID, -1) = 8 Then SpreadSpec.MaxSpread / 25.4 Else Null End As CurrentMaxSpread,
			      	Null As WCMRatio,
			      	Mix.BATCHIDENTIFIER As MixID,
			      	Mix.MixSpecID As MixSpecID
			From Data_Import_RJ.dbo.Import08_MixInfo21 As MixInfo
			Inner Join dbo.Plants As Plants
			On MixInfo.PlantCode = Plants.Name
			Inner Join dbo.Name As ItemName
			On MixInfo.MixCode = ItemName.Name
			Inner Join dbo.BATCH As Mix
			On	Plants.PlantId = Mix.Plant_Link And
				ItemName.NameID = Mix.NameID
			Left Join dbo.RptMixSpecSlump As SlumpSpec
			On Mix.MixSpecID = SlumpSpec.MixSpecID
			Left Join dbo.RptMixSpecSpread As SpreadSpec
			On Mix.MixSpecID = SpreadSpec.MixSpecID
			Left Join dbo.RptMixSpecAirContent As AirContentSpec
			On Mix.MixSpecID = AirContentSpec.MixSpecID
			Where	MixInfo.AutoID In
					(
						Select Min(MixInfo.AutoID)
						From Data_Import_RJ.dbo.Import08_MixInfo21 As MixInfo
						Where	Isnull(MixInfo.PlantCode, '') <> '' And
						        Isnull(MixInfo.MixCode, '') <> '' And
								(
									Round(Isnull(MixInfo.Strength, -1.0), 4) > 0.0 Or
									Round(IsNull(MixInfo.AirContent, -1.0), 4) >= 0.0 And Round(IsNull(MixInfo.AirContent, -1.0), 4) <= 90.0 Or
									Round(IsNull(MixInfo.MinAirContent, -1.0), 4) >= 0.0 And Round(IsNull(MixInfo.MinAirContent, -1.0), 4) <= 90.0 Or
									Round(IsNull(MixInfo.MaxAirContent, -1.0), 4) >= 0.0 And Round(IsNull(MixInfo.MaxAirContent, -1.0), 4) <= 90.0 Or
									Round(IsNull(MixInfo.Slump, -1.0), 4) > 0.0 Or
									Round(IsNull(MixInfo.MinSlump, -1.0), 4) >= 0.0 Or
									Round(IsNull(MixInfo.MaxSlump, -1.0), 4) > 0.0 
								)
						Group By MixInfo.PlantCode, MixInfo.MixCode
					) /*And
					(
						Round(IsNull(MixInfo.Slump, -1.0), 4) > 0.0 And
						Round(IsNull(MixInfo.Slump, -1.0), 4) <= 12.0 And
						Round(Isnull(Mix.SLUMP / 25.4, -1.0), 4) <> Round(IsNull(MixInfo.Slump, -1.0), 4) Or
						Round(IsNull(MixInfo.Slump, -1.0), 4) > 12.0 And
						Round(Isnull(Mix.MixTargetSpread / 25.4, -1.0), 4) <> Round(IsNull(MixInfo.Slump, -1.0), 4) 
					)*/
			Order By ItemName.Name, Plants.Name
			
			Update MixInfo
			    Set MixInfo.CurrentStrengthAge = StrengthSpec.AgeMinValue,
			        MixInfo.CurrentStrength = 
			            Case
			                When Round(Isnull(StrengthSpec.StrengthMinValue, -1.0), 4) <= 0.0
			                Then Null
			                When Isnull(StrengthSpec.StrengthUnitID, -1.0) = 5 --MPA
			                Then StrengthSpec.StrengthMinValue * 145.037743897283
			                When Isnull(StrengthSpec.StrengthUnitID, -1.0) = 6 --psi
			                Then StrengthSpec.StrengthMinValue 
			                Else Null
			            End
			From #MixInfo As MixInfo
			Inner Join dbo.RptMixSpecAgeComprStrengths As StrengthSpec
			On  MixInfo.MixSpecID = StrengthSpec.MixSpecID And
			    Round(isnull(MixInfo.StrengthAge, -1.0), 8) = Round(Isnull(StrengthSpec.AgeMinValue, -1.0), 8)
			
			Raiserror('', 0, 0) With NoWait
			Raiserror('Get Mixes With Property Updates', 0, 0) With NoWait

			Insert into #MixCalcInfo
			(
				MixID
			)
			Select MixInfo.MixID
			From #MixInfo As MixInfo
			Where	
			        Round(IsNull(MixInfo.Strength, -1.0), 4) > 0.0 And  
					(
						MixInfo.CurrentStrength Is Null Or
						Round(Isnull(MixInfo.Strength, -1.0), 4) <> Round(Isnull(MixInfo.CurrentStrength, -1.0), 4)
					) Or
			        Round(IsNull(MixInfo.AirContent, -1.0), 4) >= 0.0 And Round(IsNull(MixInfo.AirContent, -1.0), 4) <= 90.0 And 
					(
						MixInfo.CurrentAirContent Is Null Or
						Round(Isnull(MixInfo.AirContent, -1.0), 4) <> Round(Isnull(MixInfo.CurrentAirContent, -1.0), 4)
					) Or
			        Round(IsNull(MixInfo.MinAirContent, -1.0), 4) >= 0.0 And Round(IsNull(MixInfo.MinAirContent, -1.0), 4) <= 90.0 And 
					(
						MixInfo.CurrentMinAirContent Is Null Or
						Round(Isnull(MixInfo.MinAirContent, -1.0), 4) <> Round(Isnull(MixInfo.CurrentMinAirContent, -1.0), 4)
					) Or
			        Round(IsNull(MixInfo.MaxAirContent, -1.0), 4) >= 0.0 And Round(IsNull(MixInfo.MaxAirContent, -1.0), 4) <= 90.0 And 
					(
						MixInfo.CurrentMaxAirContent Is Null Or
						Round(Isnull(MixInfo.MaxAirContent, -1.0), 4) <> Round(Isnull(MixInfo.CurrentMaxAirContent, -1.0), 4)
					) Or
			        Round(IsNull(MixInfo.Slump, -1.0), 4) > 0.0 And 
					(
						MixInfo.CurrentSlump Is Null Or
						Round(Isnull(MixInfo.Slump, -1.0), 4) <> Round(Isnull(MixInfo.CurrentSlump, -1.0), 4)
					) Or
					Round(IsNull(MixInfo.MinSlump, -1.0), 4) >= 0.0 And
					(
						MixInfo.CurrentMinSlump Is Null Or
						Round(Isnull(MixInfo.MinSlump, -1.0), 4) <> Round(Isnull(MixInfo.CurrentMinSlump, -1.0), 4)
					) Or
					Round(IsNull(MixInfo.MaxSlump, -1.0), 4) > 0.0 And
					(
						MixInfo.CurrentMaxSlump Is Null Or
						Round(Isnull(MixInfo.MaxSlump, -1.0), 4) <> Round(Isnull(MixInfo.CurrentMaxSlump, -1.0), 4)
					) Or
					Round(IsNull(MixInfo.Spread, -1.0), 4) > 0.0 And
					(
						MixInfo.CurrentSpread Is Null Or
						Round(Isnull(MixInfo.Spread, -1.0), 4) <> Round(Isnull(MixInfo.CurrentSpread, -1.0), 4)
					) Or
					Round(IsNull(MixInfo.MinSpread, -1.0), 4) >= 0.0 And
					(
						MixInfo.CurrentMinSpread Is Null Or
						Round(Isnull(MixInfo.MinSpread, -1.0), 4) <> Round(Isnull(MixInfo.CurrentMinSpread, -1.0), 4)
					) Or
					Round(IsNull(MixInfo.MaxSpread, -1.0), 4) > 0.0 And
					(
						MixInfo.CurrentMaxSpread Is Null Or
						Round(Isnull(MixInfo.MaxSpread, -1.0), 4) <> Round(Isnull(MixInfo.CurrentMaxSpread, -1.0), 4)
					) 
			Group By MixInfo.MixID 
			
			Raiserror('', 0, 0) With NoWait
			Raiserror('Retrieve Specified Air Content And Slump And Spread Information.', 0, 0) With NoWait
		
			Update MixInfo
				Set	MixInfo.SlumpDataPointID = SlumpSpec.SpecDataPointID,
					MixInfo.SlumpMeasID = SlumpSpec.SpecMeasID,
					MixInfo.AirDataPointID = AirSpec.SpecDataPointID,
					MixInfo.AirMeasID = AirSpec.SpecMeasID,
					MixInfo.SpreadDataPointID = SpreadSpec.SpecDataPointID,
					MixInfo.SpreadMeasID = SpreadSpec.SpecMeasID
			From #MixInfo As MixInfo
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
			Left Join dbo.RptMixSpecAirContent As AirSpec
			On MixInfo.MixSpecID = AirSpec.MixSpecID
			Left Join dbo.RptMixSpecSlump As SlumpSpec
			On MixInfo.MixSpecID = SlumpSpec.MixSpecID
			Left Join dbo.RptMixSpecSpread As SpreadSpec
			On MixInfo.MixSpecID = SpreadSpec.MixSpecID
			
			
			Raiserror('', 0, 0) With NoWait
			Raiserror('Retrieve Specified Strength Information.', 0, 0) With NoWait
		
			Update MixInfo
				Set	MixInfo.StrengthDataPointID = StrengthSpec.SpecDataPointID,
					MixInfo.StrengthAgeMeasID = StrengthSpec.AgeSpecMeasID,
					MixInfo.StrengthMeasID = StrengthSpec.StrengthSpecMeasID
			From #MixInfo As MixInfo
			Inner Join dbo.RptMixSpecAgeComprStrengths As StrengthSpec
			On	MixInfo.MixSpecID = StrengthSpec.MixSpecID And
				Round(MixInfo.StrengthAge, 8) = Round(StrengthSpec.AgeMinValue, 8)
			/*	
			Raiserror('', 0, 0) With NoWait
			Raiserror('Retrieve W/CM Ratio Info.', 0, 0) With NoWait
		
			Update MixInfo
				Set MixInfo.Ratio1ID = MixMaterialRatioSpec.MixMaterialRatioSpecID,
					MixInfo.Numerator11ID = NumeratorType1.NOrDMtlTypeID,
					MixInfo.Denominator11ID = DenominatorType1.NOrDMtlTypeID,
					MixInfo.Denominator12ID = DenominatorType2.NOrDMtlTypeID
			From #MixInfo As MixInfo
			Inner Join dbo.MixMaterialRatioSpec As MixMaterialRatioSpec
			On	MixMaterialRatioSpec.MixSpecIDLink = MixInfo.MixSpecID And
				MixMaterialRatioSpec.MtrlTypeNumerCount = 1 And
				MixMaterialRatioSpec.MtrlTypeDenomCount = 2
			Inner Join dbo.NOrDMtlType As NumeratorType1
			On	NumeratorType1.MtlRatioIDLink = MixMaterialRatioSpec.MixMaterialRatioSpecID And
				IsNull(NumeratorType1.IsNumerator, 0) = 1 And
				NumeratorType1.MaterialTypeID = 5
			Inner Join dbo.NOrDMtlType As DenominatorType1
			On	DenominatorType1.MtlRatioIDLink = MixMaterialRatioSpec.MixMaterialRatioSpecID And
				Isnull(DenominatorType1.IsNumerator, 0) = 0 And
				DenominatorType1.MaterialTypeID = 2
			Inner Join dbo.NOrDMtlType As DenominatorType2
			On	DenominatorType2.MtlRatioIDLink = MixMaterialRatioSpec.MixMaterialRatioSpecID And
				Isnull(DenominatorType2.IsNumerator, 0) = 0 And
				DenominatorType2.MaterialTypeID = 4							
			*/
			Raiserror('', 0, 0) With NoWait
			Raiserror('Show Mix Information.', 0, 0) With NoWait

			Select *
			From #MixInfo As MixInfo
			Order By MixInfo.AutoID

			Raiserror('', 0, 0) With NoWait
			Raiserror('Show Mixes With Mix Property Changes.', 0, 0) With NoWait
			
			Select *
			From #MixCalcInfo As MixCalcInfo
			Order By  MixCalcInfo.MixID
			
			Raiserror('', 0, 0) With NoWait
			Raiserror('Add Mix Specifications.', 0, 0) With NoWait
		        
		    Set @LastID = Null		        
		    Set @LastID = (Select Max(MixSpec.MixSpecID) From dbo.MixSpec As MixSpec)
		        
		    Insert into dbo.MixSpec
		    (
		        Name,
		        [Description]
		    )
		    Select '', ''
		    From #MixInfo As MixInfo
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Where MixInfo.MixSpecID Is Null
		        
			Raiserror('', 0, 0) With NoWait
			Raiserror('Link Mix Specifications To Mixes.', 0, 0) With NoWait
		        
		    Update MixInfo
				Set MixInfo.MixSpecID = MixSpecInfo.MinMixSpecID + RowNumberInfo.RowNumber - 1						
		    From #MixInfo As MixInfo
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Inner Join
		    (
		        Select MixInfo.AutoID, Row_number() Over (Order By MixInfo.AutoID) As RowNumber
		        From #MixInfo As MixInfo
			    Inner Join #MixCalcInfo As MixCalcInfo
			    On MixCalcInfo.MixID = MixInfo.MixID
		        Where MixInfo.MixSpecID Is Null
		    ) As RowNumberInfo
		    On MixInfo.AutoID = RowNumberInfo.AutoID
		    Cross Join
		    (
		        Select Min(MixSpec.MixSpecID) As MinMixSpecID
		        From dbo.MixSpec As MixSpec
		        Where MixSpec.MixSpecID > Isnull(@LastID, -1)
		    ) As MixSpecInfo
			
			

            
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Add Spec Data Points for Strength Ages and Strengths', 0, 0) With NoWait
		        
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
		        
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Link Mixes to the Strength Spec Data Points', 0, 0) With NoWait
		        
		    Update MixInfo
				Set MixInfo.StrengthDataPointID = SpecDataPoint.SpecDataPointID
		    From #MixInfo As MixInfo
		    Inner Join dbo.SpecDataPoint As SpecDataPoint
		    On SpecDataPoint.MixSpecID = MixInfo.MixSpecID
		    Where SpecDataPoint.SpecDataPointID > Isnull(@LastID, -1)
            
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Add Specifications for Air Content Ranges', 0, 0) With NoWait
		        
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
		        
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Link Mixes to Air Content Ranges', 0, 0) With NoWait
		        
		    Update MixInfo
				Set MixInfo.AirDataPointID = SpecDataPoint.SpecDataPointID
		    From #MixInfo As MixInfo
		    Inner Join dbo.SpecDataPoint As SpecDataPoint
		    On SpecDataPoint.MixSpecID = MixInfo.MixSpecID
		    Where SpecDataPoint.SpecDataPointID > Isnull(@LastID, -1)
            
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Add Spec Data Points for Slump Ranges', 0, 0) With NoWait
		        
		    Set @LastID = Null
		    Set @LastID = (Select Max(SpecDataPoint.SpecDataPointID) From dbo.SpecDataPoint As SpecDataPoint)
		        
		    Insert into dbo.SpecDataPoint
		    (
		        MixSpecID
		    )
		    Select MixInfo.MixSpecID
		    From #MixInfo As MixInfo
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Where	MixInfo.SlumpDataPointID Is Null And
					(
						IsNull(MixInfo.MinSlump, -1.0) >= 0.0 Or 
						IsNull(MixInfo.MaxSlump, -1.0) >= 0.0
					)
		        
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Link Mixes to Slump Ranges', 0, 0) With NoWait
		        
		    Update MixInfo
				Set MixInfo.SlumpDataPointID = SpecDataPoint.SpecDataPointID
		    From #MixInfo As MixInfo
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Inner Join dbo.SpecDataPoint As SpecDataPoint
		    On SpecDataPoint.MixSpecID = MixInfo.MixSpecID
		    Where SpecDataPoint.SpecDataPointID > Isnull(@LastID, -1)
		    
		    
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Add Spec Data Points for Spread Ranges', 0, 0) With NoWait
		        
		    Set @LastID = Null
		    Set @LastID = (Select Max(SpecDataPoint.SpecDataPointID) From dbo.SpecDataPoint As SpecDataPoint)
		        
		    Insert into dbo.SpecDataPoint
		    (
		        MixSpecID
		    )
		    Select MixInfo.MixSpecID
		    From #MixInfo As MixInfo
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Where	MixInfo.SpreadDataPointID Is null And
					(
						IsNull(MixInfo.MinSpread, -1.0) >= 0.0 Or 
						IsNull(MixInfo.MaxSpread, -1.0) >= 0.0
					)
		        
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Link Mixes to Spread Ranges', 0, 0) With NoWait
		        
		    Update MixInfo
				Set MixInfo.SpreadDataPointID = SpecDataPoint.SpecDataPointID
		    From #MixInfo As MixInfo
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Inner Join dbo.SpecDataPoint As SpecDataPoint
		    On SpecDataPoint.MixSpecID = MixInfo.MixSpecID
		    Where SpecDataPoint.SpecDataPointID > Isnull(@LastID, -1)
		    
		    
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Add Spec Meases for Strength Ages', 0, 0) With NoWait
		        
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
		        
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Link Mixes to Strength Age Spec Meases', 0, 0) With NoWait
		        
		    Update MixInfo
				Set MixInfo.StrengthAgeMeasID = SpecMeas.SpecMeasID
		    From #MixInfo As MixInfo
		    Inner Join dbo.SpecMeas As SpecMeas
		    On MixInfo.StrengthDataPointID = SpecMeas.SpecDataPointID
		    Where SpecMeas.SpecMeasID > Isnull(@LastID, -1)

		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Add Spec Meases for Strengths', 0, 0) With NoWait
		        
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
		        
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Link Mixes to Strength Spec Meases', 0, 0) With NoWait
		        
		    Update MixInfo
				Set MixInfo.StrengthMeasID = SpecMeas.SpecMeasID
		    From #MixInfo As MixInfo
		    Inner Join dbo.SpecMeas As SpecMeas
		    On MixInfo.StrengthDataPointID = SpecMeas.SpecDataPointID
		    Where SpecMeas.SpecMeasID > Isnull(@LastID, -1)
            
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Add Spec Meases for Air Ranges', 0, 0) With NoWait
		        
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
		        
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Link Mixes to Air Range Spec Meases', 0, 0) With NoWait
		        
		    Update MixInfo
				Set MixInfo.AirMeasID = SpecMeas.SpecMeasID
		    From #MixInfo As MixInfo
		    Inner Join dbo.SpecMeas As SpecMeas
		    On MixInfo.AirDataPointID = SpecMeas.SpecDataPointID
		    Where SpecMeas.SpecMeasID > Isnull(@LastID, -1)
            
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Add Spec Meases for Slump Ranges', 0, 0) With NoWait
		        
		    Set @LastID = Null
		    Set @LastID = (Select Max(SpecMeas.SpecMeasID) From dbo.SpecMeas As SpecMeas)
		        
		    Insert into dbo.SpecMeas
		    (
				SpecDataPointID
		    )
		    Select MixInfo.SlumpDataPointID
		    From #MixInfo As MixInfo
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Where	MixInfo.SlumpMeasID Is Null And
					(
						IsNull(MixInfo.MinSlump, -1.0) >= 0.0 Or 
						IsNull(MixInfo.MaxSlump, -1.0) >= 0.0
					)
		        
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Link Mixes to Slump Range Spec Meases', 0, 0) With NoWait
		        
		    Update MixInfo
				Set MixInfo.SlumpMeasID = SpecMeas.SpecMeasID
		    From #MixInfo As MixInfo
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Inner Join dbo.SpecMeas As SpecMeas
		    On MixInfo.SlumpDataPointID = SpecMeas.SpecDataPointID
		    Where SpecMeas.SpecMeasID > Isnull(@LastID, -1)
			
			  
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Add Spec Meases for Spreads', 0, 0) With NoWait
		        
		    Set @LastID = Null
		    Set @LastID = (Select Max(SpecMeas.SpecMeasID) From dbo.SpecMeas As SpecMeas)
		        
		    Insert into dbo.SpecMeas
		    (
				SpecDataPointID
		    )
		    Select MixInfo.SpreadDataPointID
		    From #MixInfo As MixInfo
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Where	MixInfo.SpreadMeasID Is Null And
					(
						IsNull(MixInfo.MinSpread, -1.0) >= 0.0 Or 
						IsNull(MixInfo.MaxSpread, -1.0) >= 0.0
					)		        
		        
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Link Mixes to Spread Range Spec Meases', 0, 0) With NoWait
		        
		    Update MixInfo
				Set MixInfo.SpreadMeasID = SpecMeas.SpecMeasID
		    From #MixInfo As MixInfo
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Inner Join dbo.SpecMeas As SpecMeas
		    On MixInfo.SpreadDataPointID = SpecMeas.SpecDataPointID
		    Where SpecMeas.SpecMeasID > Isnull(@LastID, -1)
			
			
			
			
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Set Up Strength Age Spec Meases', 0, 0) With NoWait
		        
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

		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Set Up Strength Spec Meases', 0, 0) With NoWait
		        
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
            
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Set Up Air Range Spec Meases', 0, 0) With NoWait
		        
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
            
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Set Up Slump Range Spec Meases', 0, 0) With NoWait
		        
		    Update SpecMeas
				Set SpecMeas.MeasTypeID = 28,
					SpecMeas.MinValue = MixInfo.MinSlump,
					SpecMeas.MaxValue = MixInfo.MaxSlump,
					SpecMeas.UnitsLink = 9
		    From dbo.SpecMeas As SpecMeas
		    Inner Join #MixInfo As MixInfo
		    On SpecMeas.SpecMeasID = MixInfo.SlumpMeasID
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Where	IsNull(MixInfo.MinSlump, -1.0) >= 0.0 Or
					IsNull(MixInfo.MaxSlump, -1.0) >= 0.0
			
			
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Set Up Spread Range Spec Meases', 0, 0) With NoWait
		        
		    Update SpecMeas
				Set SpecMeas.MeasTypeID = 32,
					SpecMeas.MinValue = MixInfo.MinSpread,
					SpecMeas.MaxValue = MixInfo.MaxSpread,
					SpecMeas.UnitsLink = 9
		    From dbo.SpecMeas As SpecMeas
		    Inner Join #MixInfo As MixInfo
		    On SpecMeas.SpecMeasID = MixInfo.SpreadMeasID
			Inner Join #MixCalcInfo As MixCalcInfo
			On MixCalcInfo.MixID = MixInfo.MixID
		    Where	IsNull(MixInfo.MinSpread, -1.0) >= 0.0 Or
					IsNull(MixInfo.MaxSpread, -1.0) >= 0.0 
			
			

			/*
			Raiserror('', 0, 0) With NoWait
			Raiserror('Update Existing Mix Specified Max W/CM Ratios.', 0, 0) With NoWait
		        
			Update RatioSpec
				Set RatioSpec.RatioMax = MixInfo.WCMRatio
			From dbo.MixMaterialRatioSpec As RatioSpec
			Inner Join #MixInfo As MixInfo
			On RatioSpec.MixMaterialRatioSpecID = MixInfo.Ratio1ID
			Where Isnull(MixInfo.WCMRatio, -1.0) >= 0.0

			Raiserror('', 0, 0) With NoWait
			Raiserror('Add New Mix Specified Max W/CM Ratios.', 0, 0) With NoWait
		        
			Set @LastID = Null
			Set @LastID = (Select Max(RatioSpec.MixMaterialRatioSpecID) From dbo.MixMaterialRatioSpec As RatioSpec)
			
			Insert into dbo.MixMaterialRatioSpec
			(
				-- MixMaterialRatioSpecID -- this column value is auto-generated
				MixSpecIDLink,
				RatioMin,
				RatioMax,
				MtrlTypeNumerCount,
				MtrlTypeDenomCount
			)
			Select MixInfo.MixSpecID, Null, MixInfo.WCMRatio, 1, 2
			From #MixInfo As MixInfo			
			Where	MixInfo.Ratio1ID Is Null And
					Isnull(MixInfo.WCMRatio, -1.0) >= 0.0
					
			Raiserror('', 0, 0) With NoWait
			Raiserror('Update New Mix Specified Max W/CM Ratio Links.', 0, 0) With NoWait
		        
			Update MixInfo
				Set MixInfo.Ratio1ID = RatioSpec.MixMaterialRatioSpecID
			From #MixInfo As MixInfo
			Inner Join dbo.MixMaterialRatioSpec As RatioSpec
			On MixInfo.MixSpecID = RatioSpec.MixSpecIDLink
			Where RatioSpec.MixMaterialRatioSpecID > Isnull(@LastID, -1)
			
			Raiserror('', 0, 0) With NoWait
			Raiserror('Add New Ratio Water Numerators.', 0, 0) With NoWait
		        
			Set @LastID = Null
			Set @LastID = (Select Max(NOrDMtlType.NOrDMtlTypeID) From dbo.NOrDMtlType As NOrDMtlType)
			
			Insert into dbo.NOrDMtlType
			(
				-- NOrDMtlTypeID -- this column value is auto-generated
				MtlRatioIDLink,
				MaterialTypeID,
				IsNumerator
			)
			Select	MixInfo.Ratio1ID,
					5,
					1
			From #MixInfo As MixInfo
			Where	MixInfo.Numerator11ID Is Null And
					Isnull(MixInfo.WCMRatio, -1.0) >= 0.0
					
			Raiserror('', 0, 0) With NoWait
			Raiserror('Update New Ratio Water Numerator Links.', 0, 0) With NoWait
		        
			Update MixInfo
				Set MixInfo.Numerator11ID = NOrDMtlType.NOrDMtlTypeID
			From #MixInfo As MixInfo
			Inner Join dbo.NOrDMtlType As NOrDMtlType
			On MixInfo.Ratio1ID = NOrDMtlType.MtlRatioIDLink
			Where NOrDMtlType.NOrDMtlTypeID > Isnull(@LastID, -1) 

			Raiserror('', 0, 0) With NoWait
			Raiserror('Add New Ratio Cement Denominators.', 0, 0) With NoWait
		        
			Set @LastID = Null
			Set @LastID = (Select Max(NOrDMtlType.NOrDMtlTypeID) From dbo.NOrDMtlType As NOrDMtlType)
			
			Insert into dbo.NOrDMtlType
			(
				-- NOrDMtlTypeID -- this column value is auto-generated
				MtlRatioIDLink,
				MaterialTypeID,
				IsNumerator
			)
			Select	MixInfo.Ratio1ID,
					2,
					0
			From #MixInfo As MixInfo
			Where	MixInfo.Denominator11ID Is Null And
					Isnull(MixInfo.WCMRatio, -1.0) >= 0.0
					
			Raiserror('', 0, 0) With NoWait
			Raiserror('Update New Ratio Cement Denominator Links.', 0, 0) With NoWait
		        
			Update MixInfo
				Set MixInfo.Denominator11ID = NOrDMtlType.NOrDMtlTypeID
			From #MixInfo As MixInfo
			Inner Join dbo.NOrDMtlType As NOrDMtlType
			On MixInfo.Ratio1ID = NOrDMtlType.MtlRatioIDLink
			Where NOrDMtlType.NOrDMtlTypeID > Isnull(@LastID, -1) 

			Raiserror('', 0, 0) With NoWait
			Raiserror('Add New Ratio Mineral Denominators.', 0, 0) With NoWait
		        
			Set @LastID = Null
			Set @LastID = (Select Max(NOrDMtlType.NOrDMtlTypeID) From dbo.NOrDMtlType As NOrDMtlType)
			
			Insert into dbo.NOrDMtlType
			(
				-- NOrDMtlTypeID -- this column value is auto-generated
				MtlRatioIDLink,
				MaterialTypeID,
				IsNumerator
			)
			Select	MixInfo.Ratio1ID,
					4,
					0
			From #MixInfo As MixInfo
			Where	MixInfo.Denominator12ID Is Null And
					Isnull(MixInfo.WCMRatio, -1.0) >= 0.0
					
			Raiserror('', 0, 0) With NoWait
			Raiserror('Update New Ratio Mineral Denominator Links.', 0, 0) With NoWait
		        
			Update MixInfo
				Set MixInfo.Denominator12ID = NOrDMtlType.NOrDMtlTypeID
			From #MixInfo As MixInfo
			Inner Join dbo.NOrDMtlType As NOrDMtlType
			On MixInfo.Ratio1ID = NOrDMtlType.MtlRatioIDLink
			Where NOrDMtlType.NOrDMtlTypeID > Isnull(@LastID, -1) 
			*/




		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Update The Mix Properties.', 0, 0) With NoWait

			Update Mix
				Set Mix.MixSpecID = 
						Case
							When Mix.MixSpecID Is Null And MixInfo.MixSpecID Is Not null
							Then MixInfo.MixSpecID
							Else Mix.MixSpecID
						End,					
					Mix.AIR = 
						Case
							When MixCalcInfo.MixID Is Not null And Round(Isnull(MixInfo.AirContent, -1.0), 4) >= 0.0
							Then MixInfo.AirContent
							Else Mix.AIR
						End,			
					Mix.SLUMP =
						Case
							When MixCalcInfo.MixID Is Not null And Round(Isnull(MixInfo.Slump, -1.0), 4) > 0.0 
							Then MixInfo.Slump * 25.4
							Else Mix.SLUMP
						End,
					Mix.MixTargetSpread =
						Case
							When MixCalcInfo.MixID Is Not null And Round(Isnull(MixInfo.Spread, -1.0), 4) > 0.0
							Then MixInfo.Spread * 25.4
							Else Mix.MixTargetSpread
						End,
					/*
					Mix.MaxWaterQuantity =
						Case
							When Isnull(MixInfo.MaxWaterQuantity, -1.0) >= 0.0 
							Then MixInfo.MaxWaterQuantity * 3.7854118 --Gallons To Liters
							Else Mix.MaxWaterQuantity
						End,
					*/
					Mix.ProductionStatus =
						Case
							When Isnull(@UpdateMixProdStatus, 0) = 1 And MixCalcInfo.MixID Is Not null And Isnull(Mix.ProductionStatus, '') In ('InSync', 'Sent')
							Then 'OutOfSync'
							Else Mix.ProductionStatus
						End
			From dbo.BATCH As Mix
			Inner Join #MixInfo As MixInfo
			On Mix.BATCHIDENTIFIER = MixInfo.MixID
			Left Join #MixCalcInfo As MixCalcInfo
			On Mix.BATCHIDENTIFIER = MixCalcInfo.MixID
					
			/*
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Update The Mix Specification ID Information.', 0, 0) With NoWait
		        
			Update Mix
				Set Mix.MixSpecID = MixInfo.MixSpecID
			From dbo.BATCH As Mix
			Inner Join #MixInfo As MixInfo
			On Mix.BATCHIDENTIFIER = MixInfo.MixID
			Where	Mix.MixSpecID Is null And
					MixInfo.MixSpecID Is Not null
					
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Update The Mix Air Contents.', 0, 0) With NoWait

			Update Mix
				Set	Mix.AIR = MixInfo.AirContent,
					Mix.ProductionStatus =
						Case 
							When Isnull(Mix.ProductionStatus, '') In ('InSync', 'Sent')
							Then 'OutOfSync'
							Else Mix.ProductionStatus
						End 
			From dbo.BATCH As Mix
			Inner Join #MixInfo As MixInfo
			On Mix.BATCHIDENTIFIER = MixInfo.MixID
			Inner Join #MixCalcInfo As MixCalcInfo
			On Mix.BATCHIDENTIFIER = MixCalcInfo.MixID
			*/
			
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Remove Mix Info That Had Mix Air Contents That Did Not Change.', 0, 0) With NoWait

			Delete MixCalcInfo
			From #MixCalcInfo As MixCalcInfo
			Inner Join #MixInfo As MixInfo
			On MixInfo.MixID = MixCalcInfo.MixID
			Where   Round(Isnull(MixInfo.AirContent, -1.0), 4) < 0.0 Or
			        Round(Isnull(MixInfo.AirContent, -1.0), 4) >= 0.0 And
			        Round(Isnull(MixInfo.AirContent, -1.0), 4) = Round(Isnull(MixInfo.CurrentAirContent, -1.0), 4)
			        
		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Update The Mix Theoretical And Measured Calculations.', 0, 0) With NoWait

			Exec dbo.Mix_CalcTheoAndMeasCalcsByMixIDTempTable '#MixCalcInfo', 'MixID', 1.5, 0

		    Raiserror('', 0, 0) With NoWait
		    Raiserror('Update The Mix Material Costs.', 0, 0) With NoWait

			Exec dbo.Mix_CalcMaterialCostsByMixIDTempTable '#MixCalcInfo', 'MixID', 1.5, 0
			
			Raiserror('Stop Transaction.', 18, 1) With Nowait
			
			Commit Transaction
				
			Raiserror('', 0, 0) With NoWait 
			Raiserror('The Mix Properties may have been updated.', 0, 0) With NoWait 
		End Try
		Begin Catch
			If @@TRANCOUNT > 0
			Begin
				Rollback Transaction
			End
	    
			Select  @ErrorNumber  = Error_number(),
					@ErrorSeverity = Error_severity(),
					@ErrorState = Error_state(),
					@ErrorMessage  = Error_message()

			Set @ErrorMessage = --@NewLine +
				'   Error Number: ' + Cast(Isnull(@ErrorNumber, -1) As Nvarchar) + '.  ' + @NewLine +
				'   Error Severity: ' + Cast(Isnull(@ErrorSeverity, -1) As Nvarchar) + '.  ' + @NewLine +
				'   Error State: ' + Cast(Isnull(@ErrorState, -1) As Nvarchar) + '.  ' + @NewLine +
				'   Error Message: ' + Isnull(@ErrorMessage, '') + @NewLine
	    
			Raiserror('', 0, 0) With NoWait 
			Raiserror('The Mix Properties could not be updated.  Transaction Rolled Back.', 0, 0) With NoWait
			Print @ErrorMessage

		End Catch

		--Set Statistics Time Off
	End
End
Go

If Exists (Select * From sys.views Where Object_id = Object_id(N'[dbo].[RptMixSpecSpread]'))
Begin
    Drop View [dbo].[RptMixSpecSpread]
End
Go
