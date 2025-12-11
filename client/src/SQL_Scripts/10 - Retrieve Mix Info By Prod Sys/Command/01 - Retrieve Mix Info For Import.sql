--> This SQL Query retrieves all Mixes in all Plants.
If  Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ') And
    Exists (Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ICAT' And COLUMN_NAME = 'Item_Cat')
Begin
    If	Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo') And
		Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo') 
    Begin
    	Declare @IncludeInactiveMixes Bit = 1
    	    	
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
    		DispatchSlumpRange,
    		MaxLoadSize, 
    		MaximumWater, 
    		MaxWCMRatio,
    		MixInactive,
    		Padding1,
    		MaterialItemCode,
    		MaterialItemDescription,
    		Quantity,
    		QuantityUnitName
    	)
    	
    	Select	Trim(ILOC.loc_code) As [Plant Code],
    			Trim(IMST.item_code) As [Mix Code],
    			Trim(IMST.descr) As [Mix Description],
    			Trim(IMST.short_descr) As [Mix Short Description],
    			Trim(IMST.item_cat) As [Item Category],
    			Case 
    			    When Isnull(IMST.strgth, -1.0) >= 0.1 
    			    Then    Case
    			                When Isnull(IMST.days_to_strgth, -1.0) >= 0.1 
    			                Then IMST.days_to_strgth
    			                Else 28.0
    			            End
    			    Else Null 
    			End As [Strength Age],
    			Case 
    			    When Isnull(IMST.strgth, -1.0) >= 0.1
    			    Then IMST.strgth
    			    Else Null
    		    End As [Strength],
    			Coalesce(ILOC.air_pct, IMST.air_pct, IMST.pct_air) As [Air Content],
    			Null As [Min Air Content],
    			Null As [Max Air Content],
    			Case
    			    When iServiceDataExchange.dbo.Validation_ValueIsNumeric(ILOC.slump) = 1
    			    Then    Case
    			                When Cast(ILOC.slump As Float) >= 0.01
    			                Then Cast(ILOC.slump As Float)
    			                When iServiceDataExchange.dbo.Validation_ValueIsNumeric(IMST.slump) = 0
    			                Then Null
    			                When Cast(IMST.slump As Float) >= 0.01
    			                Then IMST.slump
    			                Else Null
    			            End
    			    When iServiceDataExchange.dbo.Validation_ValueIsNumeric(IMST.slump) = 1
    			    Then    Case
    			                When Cast(IMST.slump As Float) >= 0.01
    			                Then Cast(IMST.slump As Float)
    			                Else Null
    			            End    			    	    
    			    Else Null
    			End As [Slump],
    			
    			Case
    			    When    (
    			    	        Trim(Isnull(ILOC.min_slump, '')) = '' Or
    			                iServiceDataExchange.dbo.Validation_ValueIsNumeric(ILOC.min_slump) = 1
    			            ) And
    			            (
    			            	Trim(Isnull(ILOC.max_slump, '')) = '' Or
    			                iServiceDataExchange.dbo.Validation_ValueIsNumeric(ILOC.max_slump) = 1
    			            )
    			    Then    Case
    			                When iServiceDataExchange.dbo.Validation_ValueIsNumeric(ILOC.min_slump) = 1
    			                Then Cast(Trim(ILOC.min_slump) As Float)
    			                Else Null
    			            End
    			    When    (
    			    	        Trim(Isnull(IMST.min_slump, '')) = '' Or
    			                iServiceDataExchange.dbo.Validation_ValueIsNumeric(IMST.min_slump) = 1
    			            ) And
    			            (
    			            	Trim(Isnull(IMST.max_slump, '')) = '' Or
    			                iServiceDataExchange.dbo.Validation_ValueIsNumeric(IMST.max_slump) = 1
    			            )
    			    Then    Case
    			                When iServiceDataExchange.dbo.Validation_ValueIsNumeric(IMST.min_slump) = 1
    			                Then Cast(Trim(IMST.min_slump) As Float)
    			                Else Null
    			            End
    			    Else Null       
    			End As [Min Slump],

    			Case
    			    When    (
    			    	        Trim(Isnull(ILOC.min_slump, '')) = '' Or
    			                iServiceDataExchange.dbo.Validation_ValueIsNumeric(ILOC.min_slump) = 1
    			            ) And
    			            (
    			            	Trim(Isnull(ILOC.max_slump, '')) = '' Or
    			                iServiceDataExchange.dbo.Validation_ValueIsNumeric(ILOC.max_slump) = 1
    			            )
    			    Then    Case
    			                When iServiceDataExchange.dbo.Validation_ValueIsNumeric(ILOC.max_slump) = 1
    			                Then Cast(Trim(ILOC.max_slump) As Float)
    			                Else Null
    			            End
    			    When    (
    			    	        Trim(Isnull(IMST.min_slump, '')) = '' Or
    			                iServiceDataExchange.dbo.Validation_ValueIsNumeric(IMST.min_slump) = 1
    			            ) And
    			            (
    			            	Trim(Isnull(IMST.max_slump, '')) = '' Or
    			                iServiceDataExchange.dbo.Validation_ValueIsNumeric(IMST.max_slump) = 1
    			            )
    			    Then    Case
    			                When iServiceDataExchange.dbo.Validation_ValueIsNumeric(IMST.max_slump) = 1
    			                Then Cast(Trim(IMST.max_slump) As Float)
    			                Else Null
    			            End
    			    Else Null  
    	        End As [Max Slump],
    			'' As [Dispatch Slump Range],
    			Case
    			    When Isnull(ILOC.max_batch_size, -1.0) >= 0.01
    			    Then ILOC.max_batch_size
    			    When Isnull(IMST.max_load_size, -1.0) >= 0.01
    			    Then ILOC.max_batch_size
    			    Else Null
    			End As MaxLoadSize,
    			Case when Isnull(IMST.max_water, -1.0) >= 0.01 Then IMST.max_water Else Null End As MaxWater,
    			Case
    			    When Isnull(ILOC.water_cem_ratio, -1.0) >= 0.01
    			    Then ILOC.water_cem_ratio
    			    When Isnull(IMST.water_cem_ratio, -1.0) >= 0.01
    			    Then IMST.water_cem_ratio
    			    Else Null
    			End As MaxWCMRatio,
    			Case when Trim(Isnull(ILOC.inactive_code, '')) In ('', '0', '00') Then 'No' Else 'Yes' End As IsInactive,
    			'' As [Padding],
    			Trim(ICSt.const_item_code) As [Material Item Code],
    			Trim(MtrlIMST.descr) As [Material Description],
    			IsNull(ICST.qty, 0.0),
    			Trim(Isnull(UOMS.descr, ICST.qty_uom))
    	From dbo.imst As IMST
    	Inner Join Data_Import_RJ.dbo.TestImport0000_MixItemCategory As CategoryInfo
    	On Trim(IMST.item_cat) = Trim(CategoryInfo.Name)
    	Inner Join dbo.iloc As ILOC
    	On Trim(ILOC.item_code) = Trim(IMST.item_code)
    	Inner Join dbo.icst As ICST
    	On	Trim(ICST.loc_code) = Trim(ILOC.loc_code) And
    		Trim(ICST.item_code) = Trim(ILOC.item_code)
    	Inner Join dbo.IMST As MtrlIMST
    	On Trim(ICST.const_item_code) = Trim(MtrlIMST.item_code)
    	Inner Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
    	On	Trim(ICST.loc_code) = Trim(MaterialInfo.PlantName) And
    		Trim(ICST.const_item_code) = Trim(MaterialInfo.ItemCode)
    	Left Join
    	(
    		Select -1 As ID, Trim(ICST.loc_code) As loc_Code, Trim(ICST.item_code) As item_code
    		From dbo.icst As ICST
    		Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
    		On	Trim(ICST.loc_code) = Trim(MaterialInfo.PlantName) And
    			Trim(ICST.const_item_code) = Trim(MaterialInfo.ItemCode)
    		Where MaterialInfo.AutoID Is Null
    		Group By Trim(ICST.loc_code), Trim(ICST.item_code)
    	) As MissingInfo
    	On	Trim(MissingInfo.loc_code) = Trim(ICST.loc_code) And
    		Trim(MissingInfo.item_code) = Trim(ICST.item_code)
    	Left Join Data_Import_RJ.dbo.TestImport0000_MixInfo As ExistingMix
    	On	Trim(ICST.loc_code) = Trim(ExistingMix.PlantCode) And
    		Trim(ICST.item_code) = Trim(ExistingMix.MixCode) And
    		Trim(ICST.const_item_code) = Trim(ExistingMix.MaterialItemCode)
    	Left Join dbo.uoms As UOMS
    	On Trim(ICST.qty_uom) = Trim(UOMS.uom)
    	Where	MissingInfo.ID Is Null And
    			ExistingMix.AutoID Is Null And
    			(Trim(Isnull(ILOC.inactive_code, '')) In ('', '0', '00') Or Isnull(@IncludeInactiveMixes, 0) = 1)
    	Order By	Trim(ICST.loc_code),
    				Trim(ICST.item_code),
    				Trim(ICSt.const_item_code)
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
