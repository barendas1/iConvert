If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Insert Into Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo
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
				'03/25/2020' As [Material Date],
				dbo.TrimNVarChar(MaterialInfo.FamilyMaterialTypeName) As [Family Material Type],
				dbo.TrimNVarChar(MaterialInfo.MaterialTypeName) As [Material Type],
				MaterialInfo.SpecificGravity As [Specific Gravity],
				Case
					When	dbo.TrimNVarChar(IsNull(MaterialInfo.FamilyMaterialTypeName, '')) <> 'Admixture & Fiber' Or
							dbo.TrimNVarChar(IsNull(MaterialInfo.MaterialTypeName, '')) = 'Color' Or
							dbo.TrimNVarChar(IsNull(MaterialInfo.MaterialTypeName, '')) Like '%Fiber%' And
							dbo.TrimNVarChar(IsNull(MaterialInfo.MaterialTypeName, '')) <> 'Admixture & Fiber'
					Then 'No'
					Else 'Yes'
				End As [Is Liquid Admix],
				0.0 As [Moisture Percent],
				Null As [Cost],
				'' As [Cost Units],
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
		From CmdProd_SONAG_RJ.dbo.imst As IMST
		Inner Join CmdProd_SONAG_RJ.dbo.iloc As ILOC
		On dbo.TrimNVarChar(ILOC.item_code) = dbo.TrimNVarChar(IMST.item_code)
		Left Join
		(
			Select  dbo.TrimNVarChar(IMLB.loc_code) As loc_code, 
			        dbo.TrimNVarChar(IMLB.item_code) As item_code,
			        Min(dbo.TrimNVarChar(IMLB.batch_code)) As batch_code 
			From CmdProd_Sonag_RJ.dbo.imlb As IMLB
			Where Isnull(dbo.TrimNVarChar(IMLB.batch_code), '') <> ''
			Group By dbo.TrimNVarChar(IMLB.loc_code), dbo.TrimNVarChar(IMLB.item_code) 
			--Having Count(*) > 1   
		) As IMLB
		On	dbo.TrimNVarChar(IMLB.loc_code) = dbo.TrimNVarChar(ILOC.loc_code) And
			dbo.TrimNVarChar(IMLB.item_code) = dbo.TrimNVarChar(ILOC.item_code)
		Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialItemCategory As CategoryInfo
		On dbo.TrimNVarChar(IMST.item_cat) = dbo.TrimNVarChar(CategoryInfo.Name)
		Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MainMaterialInfo As MaterialInfo
		On dbo.TrimNVarChar(IMST.item_code) = dbo.TrimNVarChar(MaterialInfo.Name)
		Left Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As ExistingMaterialInfo
		On	dbo.TrimNVarChar(ILOC.loc_code) = dbo.TrimNVarChar(ExistingMaterialInfo.PlantName) And
			dbo.TrimNVarChar(IMST.item_code) = dbo.TrimNVarChar(ExistingMaterialInfo.ItemCode)
		Where ExistingMaterialInfo.AutoID Is Null
		Order By	dbo.TrimNVarChar(ILOC.loc_code), 
					dbo.TrimNVarChar(MaterialInfo.FamilyMaterialTypeName),
					dbo.TrimNVarChar(MaterialInfo.ItemCategory), 
					dbo.TrimNVarChar(IMST.descr)
					
		Update MaterialInfo
		    Set MaterialInfo.TradeName = MaterialInfo.ItemCode
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Inner Join
		(
	        Select MaterialInfo.PlantName, MaterialInfo.TradeName, Min(MaterialInfo.AutoID) As MinAutoID
	        From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
	        Group By MaterialInfo.PlantName, MaterialInfo.TradeName
	        Having Count(*) > 1
		) As DuplicateInfo
		On  DuplicateInfo.PlantName = MaterialInfo.PlantName And
		    DuplicateInfo.TradeName = MaterialInfo.TradeName 
		Where MaterialInfo.AutoID <> DuplicateInfo.MinAutoID
		/*
		Update MaterialInfo
		    Set MaterialInfo.BatchPanelCode = PanelName.Name
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
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
