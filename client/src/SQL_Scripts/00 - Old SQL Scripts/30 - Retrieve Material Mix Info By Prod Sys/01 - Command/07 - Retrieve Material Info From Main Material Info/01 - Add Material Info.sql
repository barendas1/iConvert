If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo')
    Begin
		Insert Into Data_Import_RJ.dbo.TestImport0000_MaterialInfo
		(
			PlantName,
			TradeName,
			MaterialDate,
			FamilyMaterialTypeName,
			MaterialTypeName,
			SpecificGravity,
			IsLiquidAdmix,
			MoisturePct,
			Cost,
			CostUnitName,
			ManufacturerName,
			ManufacturerSourceName,
			BatchingOrderNumber,
			ItemCode,
			ItemDescription,
			ItemShortDescription,
			ItemCategoryName,
			ItemCategoryDescription,
			ItemCategoryShortDescription,
			ComponentCategoryName,
			ComponentCategoryDescription,
			ComponentCategoryShortDescription,
			BatchPanelCode
		)
		Select	dbo.TrimNVarChar(ILOC.loc_code) As [Plant Code],
				dbo.TrimNVarChar(IMST.descr) As [Trade Name],
				'10/06/2023' As [Material Date],
				dbo.TrimNVarChar(MaterialInfo.FamilyMaterialTypeName) As [Family Material Type],
				dbo.TrimNVarChar(MaterialInfo.MaterialTypeName) As [Material Type],
				Case when Isnull(iloc.spec_grav, -1.0) >= 0.4 Then Cast(ILoc.spec_grav As Float) Else MaterialInfo.SpecificGravity End As [Specific Gravity],
				MaterialInfo.IsLiquidAdmix,
				0.0 As [Moisture Percent],
				ILOC.curr_std_cost As [Cost],
				Case when dbo.TrimNVarChar(UOMS.uom) = '60001' Then 'Dry Oz' Else dbo.TrimNVarChar(UOMS.abbr) End As [Cost Units],
				'' As [Manufacturer],
				'' As [Manufacturer Source],
				Null As [Batching Order Number],
				dbo.TrimNVarChar(IMST.item_code) As [Item Code],
				dbo.TrimNVarChar(IMST.descr) As [Item Description],
				dbo.TrimNVarChar(IMST.short_descr) As [Item Short Description],
				dbo.TrimNVarChar(CategoryInfo.Name) As [Item Category],
				dbo.TrimNVarChar(CategoryInfo.[Description]) As [Item Category Description],
				dbo.TrimNVarChar(CategoryInfo.ShortDescription) As [Item Category Short Description],
				Null As [Component Category],
				Null As [Component Category Description],
				Null As [Component Category Short Description],
				dbo.TrimNVarChar(Isnull(IMLB.batch_code, '')) As [Batch Panel Code]
		From CmdTest_RJ.dbo.imst As IMST
		Inner Join CmdTest_RJ.dbo.iloc As ILOC
		On ILOC.item_code = IMST.item_code
		Left Join CmdTest_RJ.dbo.UOMS As UOMS
		On IMST.purch_uom = UOMS.uom
		Left Join
		(
			Select  dbo.TrimNVarChar(IMLB.loc_code) As loc_code, 
			        dbo.TrimNVarChar(IMLB.item_code) As item_code,
			        Min(dbo.TrimNVarChar(IMLB.batch_code)) As batch_code 
			From CmdTest_RJ.dbo.imlb As IMLB
			Where Isnull(dbo.TrimNVarChar(IMLB.batch_code), '') <> ''
			Group By dbo.TrimNVarChar(IMLB.loc_code), dbo.TrimNVarChar(IMLB.item_code) 
			--Having Count(*) > 1   
		) As IMLB
		On	IMLB.loc_code = dbo.TrimNVarChar(ILOC.loc_code) And
			IMLB.item_code = dbo.TrimNVarChar(ILOC.item_code)
		Inner Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
		On IMST.item_cat = CategoryInfo.Name
		Inner Join Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MaterialInfo
		On IMST.item_code = MaterialInfo.Name
		Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As ExistingMaterialInfo
		On	ILOC.loc_code = ExistingMaterialInfo.PlantName And
			IMST.item_code = ExistingMaterialInfo.ItemCode
	    Left Join
	    (
		    Select -1 As ID, dbo.TrimNVarChar(MixICST.loc_code) As Loc_Code, dbo.TrimNVarChar(MixICST.const_item_code) As Item_Code
		    From CmdTest_RJ.dbo.ILOC As MixILOC
		    Inner Join CmdTest_RJ.dbo.ICST As MixICST
		    On  MixILOC.loc_code = MixICST.loc_code And
		        MixILOC.item_code = MixICST.item_code
		    Where Isnull(MixILOC.inactive_code, '') In ('', '00', '0')
		    Group By dbo.TrimNVarChar(MixICST.loc_code), dbo.TrimNVarChar(MixICST.const_item_code)
	    ) As MixMaterial
	    On dbo.TrimNVarChar(ILOC.loc_code) = MixMaterial.Loc_Code And dbo.TrimNVarChar(ILOC.item_code) = MixMaterial.Item_Code
		Where   ExistingMaterialInfo.AutoID Is Null And
		        (
		        	Isnull(ILOC.inactive_code, '') In ('', '00', '0') Or
		        	MixMaterial.ID Is Not Null
		        )
		Order By	dbo.TrimNVarChar(ILOC.loc_code), 
					dbo.TrimNVarChar(MaterialInfo.FamilyMaterialTypeName),
					dbo.TrimNVarChar(MaterialInfo.ItemCategory), 
					dbo.TrimNVarChar(IMST.descr)
					
		Update MaterialInfo
		    Set MaterialInfo.TradeName = MaterialInfo.ItemCode
		From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
		Inner Join
		(
	        Select MaterialInfo.PlantName, MaterialInfo.TradeName, Min(MaterialInfo.AutoID) As MinAutoID
	        From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
	        Group By MaterialInfo.PlantName, MaterialInfo.TradeName
	        Having Count(*) > 1
		) As DuplicateInfo
		On  DuplicateInfo.PlantName = MaterialInfo.PlantName And
		    DuplicateInfo.TradeName = MaterialInfo.TradeName 
		Where MaterialInfo.AutoID <> DuplicateInfo.MinAutoID
		/*
		Update MaterialInfo
		    Set MaterialInfo.BatchPanelCode = PanelName.Name
		From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
		Inner Join Sonag_RJ.dbo.Plants As Plants
		On  MaterialInfo.PlantName = Plants.Name 
		Inner Join Sonag_RJ.dbo.Name As TradeNameInfo
		On MaterialInfo.TradeName = TradeNameInfo.Name
		Inner Join iServiceDataExchange.dbo.MaterialType As FamilyMtrlTypeInfo
		On MaterialInfo.FamilyMaterialTypeName = FamilyMtrlTypeInfo.MaterialType
		Inner Join Sonag_RJ.dbo.MATERIAL As Material
		On  Plants.PlantId = Material.PlantID And
		    FamilyMtrlTypeInfo.MaterialTypeID = Material.FamilyMaterialTypeID And
		    TradeNameInfo.NameID = Material.NameID
	    Inner Join Sonag_RJ.dbo.Name As PanelName
	    On PanelName.NameID = Material.BatchPanelNameID
		Where Isnull(MaterialInfo.BatchPanelCode, '') = ''
		*/
    End
End
Go
