If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If	Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo') And
		Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MixInfo') 
    Begin
    	Insert into Data_Import_RJ.dbo.TestImport0000_XML_MixInfo
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
    			28.0 As [Strength Age],
    			IMST.strgth As [Strength],
    			IsNull(ILOC.air_pct, IMST.air_pct) As [Air Content],
    			Null As [Min Air Content],
    			Null As [Max Air Content],
    			dbo.TrimNVarChar(ILOC.slump) As [Slump],
    			dbo.TrimNVarChar(ILOC.min_slump) As [Min Slump],
    			dbo.TrimNVarChar(ILOC.max_slump) As [Max Slump],
    			'' As [Dispatch Slump Range],
    			'' As [Padding],
    			dbo.TrimNVarChar(ICSt.const_item_code) As [Material Item Code],
    			dbo.TrimNVarChar(MtrlIMST.descr) As [Material Description],
    			IsNull(ICST.qty, 0.0),
    			dbo.TrimNVarChar(Isnull(UOMS.descr, ICST.qty_uom))
    	From CmdProd_SONAG_RJ.dbo.imst As IMST
    	Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixItemCategory As CategoryInfo
    	On dbo.TrimNVarChar(IMST.item_cat) = dbo.TrimNVarChar(CategoryInfo.Name)
    	Inner Join CmdProd_SONAG_RJ.dbo.iloc As ILOC
    	On dbo.TrimNVarChar(ILOC.item_code) = dbo.TrimNVarChar(IMST.item_code)
    	Inner Join CmdProd_SONAG_RJ.dbo.icst As ICST
    	On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(ILOC.loc_code) And
    		dbo.TrimNVarChar(ICST.item_code) = dbo.TrimNVarChar(ILOC.item_code)
    	Inner Join CmdProd_SONAG_RJ.dbo.IMST As MtrlIMST
    	On dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(MtrlIMST.item_code)
    	Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
    	On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(MaterialInfo.PlantName) And
    		dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(MaterialInfo.ItemCode)
    	Left Join
    	(
    		Select -1 As ID, dbo.TrimNVarChar(ICST.loc_code) As loc_Code, dbo.TrimNVarChar(ICST.item_code) As item_code
    		From CmdProd_SONAG_RJ.dbo.icst As ICST
    		Left Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
    		On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(MaterialInfo.PlantName) And
    			dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(MaterialInfo.ItemCode)
    		Where MaterialInfo.AutoID Is Null
    		Group By dbo.TrimNVarChar(ICST.loc_code), dbo.TrimNVarChar(ICST.item_code)
    	) As MissingInfo
    	On	dbo.TrimNVarChar(MissingInfo.loc_code) = dbo.TrimNVarChar(ICST.loc_code) And
    		dbo.TrimNVarChar(MissingInfo.item_code) = dbo.TrimNVarChar(ICST.item_code)
    	Left Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As ExistingMix
    	On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(ExistingMix.PlantCode) And
    		dbo.TrimNVarChar(ICST.item_code) = dbo.TrimNVarChar(ExistingMix.MixCode) And
    		dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(ExistingMix.MaterialItemCode)
    	Left Join CmdProd_SONAG_RJ.dbo.uoms As UOMS
    	On dbo.TrimNVarChar(ICST.qty_uom) = dbo.TrimNVarChar(UOMS.uom)
    	Where	MissingInfo.ID Is Null And
    			ExistingMix.AutoID Is Null And
    			(
    				dbo.TrimNVarChar(IsNull(MaterialInfo.FamilyMaterialTypeName, '')) Not In ('Cement', 'Mineral', 'Aggregate') Or
    				dbo.TrimNVarChar(IsNull(MaterialInfo.FamilyMaterialTypeName, '')) In ('Cement', 'Mineral', 'Aggregate') And
    				Isnull(ICST.qty, -1.0) > 0.0 
    			) 
    	Order By	dbo.TrimNVarChar(ICST.loc_code),
    				dbo.TrimNVarChar(ICST.item_code),
    				dbo.TrimNVarChar(ICSt.const_item_code)
    End
End
Go
