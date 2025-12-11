If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If	Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo') And
		Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo') 
    Begin
    	Insert into Data_Import_RJ.dbo.TestImport0000_MixInfo
    	(
    		PlantCode,
    		MixCode,
    		MixDescription,
    		MixShortDescription,
    		ItemCategory,
    		StrengthAge,
    		Strength,
    		AirContent,
    		MinAirContent,
    		MaxAirContent,
    		Slump,
    		MinSlump,
    		MaxSlump,
    		MaxLoadSize, 
    		MaxWCRatio,
    		DispatchSlumpRange,
    		Padding1,
    		MaterialItemCode,
    		MaterialItemDescription,
    		Quantity,
    		QuantityUnitName
    	)
    	Select	dbo.TrimNVarChar(ILOC.loc_code) As [Plant Code],
    			dbo.TrimNVarChar(IMST.item_code) As [Mix Code],
    			dbo.TrimNVarChar(IMST.descr) As [Mix Description],
    			dbo.TrimNVarChar(IMST.short_descr) As [Mix Short Description],
    			dbo.TrimNVarChar(IMST.item_cat) As [Item Category],
    		 	Case
    		 	    When Isnull(IMST.days_to_strgth, -1.0) >= 0.1 And Isnull(IMST.strgth, -1.) >= 0.01
    		 	    Then IMST.days_to_strgth
    		 	    When Isnull(IMST.strgth, -1.) >= 0.01
    		 	    Then 28.0
    		 	    Else Null
    		 	End As [Strength Age],
    			IMST.strgth As [Strength],
    			Coalesce(ILOC.air_pct, IMST.air_pct, IMST.pct_air) As [Air Content],
    			Null As [Min Air Content],
    			Null As [Max Air Content],
    			Case
    			    When    dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.slump)) = 1 Or
    			            dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.min_slump)) = 1 Or
    			            dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.max_slump)) = 1
    			    Then    Case
    			                When dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.slump)) = 1
    			                Then dbo.TrimNVarChar(ILOC.slump)
    			                Else Null
    			    	    End
    			    When dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(IMST.slump)) = 1
    			    Then dbo.TrimNVarChar(IMST.slump)
    			    Else Null
    			End As [Slump],
    			Case 
    			    When    dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.slump)) = 1 Or
    			            dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.min_slump)) = 1 Or
    			            dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.max_slump)) = 1
    			    Then    Case
    			                When dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.min_slump)) = 1
    			                Then dbo.TrimNVarChar(ILOC.min_slump)
    			                Else Null
    			    	    End
    			    When dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(IMST.min_slump)) = 1
    			    Then dbo.TrimNVarChar(IMST.min_slump)
    			    Else Null
    			End As [Min Slump],
    			Case 
    			    When    dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.slump)) = 1 Or
    			            dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.min_slump)) = 1 Or
    			            dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.max_slump)) = 1
    			    Then    Case
    			                When dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(ILOC.max_slump)) = 1
    			                Then dbo.TrimNVarChar(ILOC.max_slump)
    			                Else Null
    			    	    End
    			    When dbo.Validation_ValueIsNumeric(dbo.TrimNVarChar(IMST.max_slump)) = 1
    			    Then dbo.TrimNVarChar(IMST.max_slump)
    			    Else Null
    			End As [Max Slump],
    			Case when Isnull(ILOC.max_batch_size, IMST.max_load_size) >= 0.01 Then Isnull(ILOC.max_batch_size, IMST.max_load_size) Else Null End As [Max Load Size],
    			Case when Isnull(ILOC.water_cem_ratio, IMST.water_cem_ratio) >= 0.01 Then Isnull(ILOC.water_cem_ratio, IMST.water_cem_ratio) Else Null End As [Max WM Ratio],
    			'' As [Dispatch Slump Range],
    			'' As [Padding],
    			dbo.TrimNVarChar(ICSt.const_item_code) As [Material Item Code],
    			dbo.TrimNVarChar(MtrlIMST.descr) As [Material Description],
    			IsNull(ICST.qty, 0.0),
    			dbo.TrimNVarChar(Isnull(UOMS.descr, ICST.qty_uom))
    	From CmdTest_RJ.dbo.imst As IMST
    	Inner Join Data_Import_RJ.dbo.TestImport0000_MixItemCategory As CategoryInfo
    	On IMST.item_cat = CategoryInfo.Name
    	Inner Join CmdTest_RJ.dbo.iloc As ILOC
    	On ILOC.item_code = IMST.item_code
    	Inner Join CmdTest_RJ.dbo.icst As ICST
    	On	ICST.loc_code = ILOC.loc_code And
    		ICST.item_code = ILOC.item_code
    	Inner Join CmdTest_RJ.dbo.IMST As MtrlIMST
    	On ICST.const_item_code = MtrlIMST.item_code
    	Inner Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
    	On	ICST.loc_code = MaterialInfo.PlantName And
    		ICST.const_item_code = MaterialInfo.ItemCode
    	Left Join
    	(
    		Select -1 As ID, dbo.TrimNVarChar(ICST.loc_code) As loc_Code, dbo.TrimNVarChar(ICST.item_code) As item_code
    		From CmdTest_RJ.dbo.icst As ICST
    		Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
    		On	ICST.loc_code = MaterialInfo.PlantName And
    			ICST.const_item_code = MaterialInfo.ItemCode
    		Where MaterialInfo.AutoID Is Null
    		Group By dbo.TrimNVarChar(ICST.loc_code), dbo.TrimNVarChar(ICST.item_code)
    	) As MissingInfo
    	On	dbo.TrimNVarChar(MissingInfo.loc_code) = dbo.TrimNVarChar(ICST.loc_code) And
    		dbo.TrimNVarChar(MissingInfo.item_code) = dbo.TrimNVarChar(ICST.item_code)
    	Left Join Data_Import_RJ.dbo.TestImport0000_MixInfo As ExistingMix
    	On	ICST.loc_code = ExistingMix.PlantCode And
    		ICST.item_code = ExistingMix.MixCode And
    		ICST.const_item_code = ExistingMix.MaterialItemCode
    	Left Join CmdTest_RJ.dbo.uoms As UOMS
    	On ICST.qty_uom = UOMS.uom
    	Where	MissingInfo.ID Is Null And
    			ExistingMix.AutoID Is Null And
    			Isnull(ILOC.inactive_code, '') In ('', '00', '0')
    	Order By	dbo.TrimNVarChar(ICST.loc_code),
    				dbo.TrimNVarChar(ICST.item_code),
    				dbo.TrimNVarChar(ICSt.const_item_code)
    End
End
Go
