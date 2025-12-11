Select *
From dbo.Plants As Plants
Inner Join dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join dbo.Name As MixName
On MixName.NameID = Mix.NameID
Left Join dbo.[Description] As MixDescr
On MixDescr.DescriptionID = Mix.DescriptionID
Left Join dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Mix.ItemMasterID
Left Join dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Left Join dbo.[Description] As ItemDescr
On ItemDescr.DescriptionID = ItemMaster.DescriptionID
Left Join dbo.ProductionItemCategory As ProdCatInfo
On ProdCatInfo.ProdItemCatID = ItemMaster.ProdItemCatID
Left Join dbo.RptMixSpecFirstAgeComprStrengths As StrengthInfo
On StrengthInfo.MixSpecID = Mix.MixSpecID
Inner Join CmdTest_RJ.dbo.iloc As ILOC
On	Ltrim(Rtrim(ILOC.loc_code)) = Ltrim(Rtrim(Plants.Name)) And
	Ltrim(Rtrim(ILOC.item_code)) = Ltrim(Rtrim(MixName.Name))
Inner Join CmdTest_RJ.dbo.IMST As IMST
On Ltrim(Rtrim(IMST.item_code)) = Ltrim(Rtrim(ILOC.item_code))
Inner Join CmdTest_RJ.dbo.icat As ICAT
On Ltrim(Rtrim(ICAT.item_cat)) = Ltrim(Rtrim(IMST.item_cat))
Where	Ltrim(Rtrim(Isnull(IMST.item_code, ''))) <> Ltrim(Rtrim(Isnull(ItemName.Name, ''))) Or
		Ltrim(Rtrim(Isnull(IMST.descr, ''))) <> Ltrim(Rtrim(Isnull(MixDescr.[Description], ''))) Or
		Ltrim(Rtrim(Isnull(IMST.descr, ''))) <> Ltrim(Rtrim(Isnull(ItemDescr.[Description], ''))) Or
		Ltrim(Rtrim(Isnull(IMST.descr, ''))) <> Ltrim(Rtrim(Isnull(Mix.BatchPanelDescription, ''))) Or
		Ltrim(Rtrim(Isnull(IMST.item_code, ''))) <> Ltrim(Rtrim(Isnull(Mix.BatchPanelCode, ''))) Or
		Ltrim(Rtrim(Isnull(IMST.short_descr, ''))) <> Ltrim(Rtrim(Isnull(ItemMaster.ItemShortDescription, ''))) Or
		Ltrim(Rtrim(Isnull(ICAT.item_cat, ''))) <> Ltrim(Rtrim(Isnull(ProdCatInfo.ItemCategory, ''))) Or
		Ltrim(Rtrim(Isnull(ICAT.descr, ''))) <> Ltrim(Rtrim(Isnull(ProdCatINfo.[Description], ''))) Or
		Ltrim(Rtrim(Isnull(ICAT.short_descr, ''))) <> Ltrim(Rtrim(Isnull(ProdCatInfo.ShortDescription, ''))) Or
		Isnull(ILOC.air_pct, 1.5) <> Isnull(Mix.AIR, -1.0) Or
		Isnull(IMST.strgth, -1.0) <> Isnull(StrengthInfo.StrengthMinValue, -1.0)

Select	Plants.Name,
		MixName.Name,
		ICST.qty,
		Case 
			When Isnull(UOMS.descr, '') = 'Ounces'
			Then Round(IsNull(Recipe.QUANTITY, 0.0)/(Material.SPECGR * 6.51984837440621E-02 * 0.45359240000781), 2)
			When Isnull(UOMs.descr, '') = 'Pounds'
			Then Round(IsNull(Recipe.QUANTITY, 0.0) / 0.45359240000781, 2)
			When Isnull(UOMS.descr, '') = 'Gallons'
			Then Round(IsNull(Recipe.QUANTITY, 0.0) * 0.26417205 / (Material.SPECGR * 1.0) , 2)
			Else Round(IsNull(Recipe.QUANTITY, 0.0), 2)
		End,
		UOMS.descr
From dbo.Plants As Plants
Inner Join dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join dbo.Name As MixName
On MixName.NameID = Mix.NameID
Inner Join dbo.MaterialRecipe As Recipe
On Recipe.EntityID = Mix.BATCHIDENTIFIER
Inner Join dbo.MATERIAL As Material
On Material.MATERIALIDENTIFIER = Recipe.MaterialID
Inner Join dbo.ItemMaster As MtrlItemMaster
On MtrlItemMaster.ItemMasterID = Material.ItemMasterID
Inner Join dbo.Name As MtrlItemName
On MtrlItemName.NameID = MtrlItemMaster.NameID
Inner Join CmdTest_RJ.dbo.icst As ICST
On	Ltrim(Rtrim(ICST.loc_code)) = Ltrim(Rtrim(Plants.Name)) And
	Ltrim(Rtrim(ICST.item_code)) = Ltrim(Rtrim(MixName.Name)) And
	Ltrim(Rtrim(ICST.const_item_code)) = Ltrim(Rtrim(MtrlItemName.Name))
Inner Join CmdTest_RJ.dbo.uoms As UOMS
On Ltrim(Rtrim(ICST.qty_uom)) = Ltrim(Rtrim(UOMS.uom))
Where	Round(Cast(Isnull(ICST.qty, 0.0) As Float), 2) =
		Case 
			When Isnull(UOMS.descr, '') = 'Ounces'
			Then Round(IsNull(Recipe.QUANTITY, 0.0)/(Material.SPECGR * 6.51984837440621E-02 * 0.45359240000781), 2)
			When Isnull(UOMS.descr, '') = 'Pounds'
			Then Round(IsNull(Recipe.QUANTITY, 0.0) / 0.45359240000781, 2)
			When Isnull(UOMS.descr, '') = 'Gallons'
			Then Round(IsNull(Recipe.QUANTITY, 0.0) * 0.26417205 / (Material.SPECGR * 1.0) , 2)
			Else Round(IsNull(Recipe.QUANTITY, 0.0), 2)
		End

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where   MixInfo.PlantCode = '7' And MixInfo.MixCode = '40217'	
