Select IMST.*
From CmdTest_RJ.dbo.iloc As ILOC
Inner Join CmdTest_RJ.dbo.imst As IMST
On IMST.item_code = ILOC.item_code
Where dbo.TrimNVarChar(ILOC.loc_code) = '4'

Select Avg(Material.SPECGR)
From ARGOS_USA_RJ.dbo.MATERIAL As Material
Inner Join iServiceDataExchange.dbo.GetMaterialTypeTreeFromParentByID(9, Default, Default, Default) As MaterialTypeInfo
On Material.MaterialTypeLink = MaterialTypeInfo.MaterialTypeID
         
Select *
From iServiceDataExchange_G2_200_RJansen.dbo.MaterialType As MaterialType
Order By MaterialType.RecipeOrder

Select *
From iServiceDataExchange_G2_200_RJansen.dbo.MaterialType As MaterialType
Where MaterialType.MaterialType Like '%ICE%'
Order By MaterialType.RecipeOrder

Select *
From CmdTest_RJ.dbo.imst As IMST
Where dbo.TrimVarChar(IMST.item_cat) = 'SG02'

Select *
From CmdTest_RJ.dbo.imst As IMST
Where dbo.TrimVarChar(IMST.item_cat) = 'C3'

Select *
From CmdTest_RJ.dbo.imst As IMST
Where dbo.TrimVarChar(IMST.item_cat) = 'FIBER'

Select *
From CmdTest_RJ.dbo.imst As IMST
Where dbo.TrimVarChar(IMST.item_code) = 'SCA'

Select *
From CmdTest_RJ.dbo.imst As IMST
Where dbo.TrimVarChar(IMST.item_code) = '267'

Select *
From CmdTest_RJ.dbo.imst As IMST
Where dbo.TrimVarChar(IMST.descr) = 'SCA220'

Select *
From CmdTest_RJ.dbo.icst As ICST
Where dbo.TrimNVarChar(ICST.const_item_code) = '267'

Select *
From CmdTest_RJ.dbo.icst As ICST
Where dbo.TrimNVarChar(ICST.const_item_code) In ('66', 'SCA')

Select *
From CmdTest_RJ.dbo.iloc As ILOC
Where dbo.TrimVarChar(ILOC.item_code) = '267'

Select *
From CmdTest_RJ.dbo.ICST As ICST
Where dbo.TrimNVarChar(ICSt.item_code) = '20303'
Order By ICST.loc_code, ICST.item_code, ICST.const_item_code

Select *
From CmdTest_RJ.dbo.ICST As ICST
Where dbo.TrimNVarChar(ICSt.item_code) = '20303'
Order By ICST.loc_code, ICST.item_code, ICST.const_item_code

Select *
From CmdTest_RJ.dbo.uoms As UOMS
Where UOMS.uom = '80001'

Select *
From Sonag_RJ.dbo.ProductionItemCategory As CategoryInfo
Order By CategoryInfo.ProdItemCatType, CategoryInfo.ItemCategory


Select MtrlInfo1.*
From Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MtrlInfo1
Left Join Data_Import_RJ.dbo.Import22_MainMaterialInfo As MtrlInfo2
On MtrlInfo1.Name = MtrlInfo2.Name
Where MtrlInfo2.AutoID Is Null


Select *
From CmdTest_RJ.dbo.icat As CategoryInfo

Select CategoryInfo.item_type
From CmdTest_RJ.dbo.icst As Recipe
Inner Join CmdTest_RJ.dbo.imst As MainInfo
On MainInfo.item_code = Recipe.const_item_code
Inner Join CmdTest_RJ.dbo.icat As CategoryInfo
On CategoryInfo.item_cat = MainInfo.item_cat
Group By CategoryInfo.item_type

Select CategoryInfo.item_cat, CategoryInfo.descr, CategoryInfo.short_descr, CategoryInfo.item_type, CategoryInfo.matl_type
From CmdTest_RJ.dbo.icst As Recipe
Inner Join CmdTest_RJ.dbo.imst As MainInfo
On MainInfo.item_code = Recipe.const_item_code
Inner Join CmdTest_RJ.dbo.icat As CategoryInfo
On CategoryInfo.item_cat = MainInfo.item_cat
Group By CategoryInfo.item_cat, CategoryInfo.descr, CategoryInfo.short_descr, CategoryInfo.item_type, CategoryInfo.matl_type
Order By CategoryInfo.item_cat

Select *
From CmdTest_RJ.dbo.icat As CategoryInfo
Where	LTrim(RTrim(CategoryInfo.item_type)) In
		(
			Select LTrim(RTrim(CategoryInfo.item_type))
			From CmdTest_RJ.dbo.icst As Recipe
			Inner Join CmdTest_RJ.dbo.imst As MainInfo
			On MainInfo.item_code = Recipe.const_item_code
			Inner Join CmdTest_RJ.dbo.icat As CategoryInfo
			On CategoryInfo.item_cat = MainInfo.item_cat
			Group By CategoryInfo.item_type
		)
		
Select *
From CmdTest_RJ.dbo.icat As CategoryInfo
Where	Ltrim(Rtrim(Isnull(CategoryInfo.item_type, ''))) <> '01' And
		Ltrim(Rtrim(Isnull(CategoryInfo.item_cat, ''))) Not In
		(
			'EXCHG',
			'HC'
		)
Order By LTrim(RTrim(CategoryInfo.item_cat))

Select IMST.item_cat, *
From CmdTest_RJ.dbo.IMST As IMST
Where	Ltrim(Rtrim(IsNull(IMST.item_cat, ''))) In
		(
			'EXCHG',
			'HC'
		)

EXCHG 
EXTRA 
HC    

/*
'ACCEL',
'ADMIX',
'AGG1',  
'AGG2',  
'CA',    
'CEMENT',
'CMT2',  
'MICRO', 
'RETARD',
'SCA',   
'SLAG',  
'WATER' 
*/

Select	Ltrim(Rtrim(CategoryInfo.item_cat)),
		Ltrim(Rtrim(CategoryInfo.descr)),
		Ltrim(Rtrim(CategoryInfo.short_descr)),
		Ltrim(Rtrim(CategoryInfo.item_type))
From CmdTest_RJ.dbo.icat As CategoryInfo
Where	LTrim(RTrim(CategoryInfo.item_cat)) In
		(
			'ACCEL',
			'ADMIX',
			'AGG1',  
			'AGG2',  
			'CA',    
			'CEMENT',
			'CMT2',  
			'MICRO', 
			'RETARD',
			'SCA',   
			'SLAG',  
			'WATER' 
		)
Order By LTrim(RTrim(CategoryInfo.item_cat))

Select	PlantInfo.loc_code,
		MainInfo.item_code, MainInfo.descr, MainInfo.short_descr,
		MainInfo.item_cat,
		PlantInfo.curr_std_cost,
		PlantInfo.spec_grav
From CmdTest_RJ.dbo.iloc As PlantInfo
Inner Join CmdTest_RJ.dbo.imst As MainInfo
On LTrim(RTrim(MainInfo.item_code)) = LTrim(RTrim(PlantInfo.item_code))
Where	LTrim(RTrim(MainInfo.item_cat)) In
		(
			Select CategoryInfo.Name
			From Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
		) 
Order By LTrim(RTrim(PlantInfo.loc_code)), LTrim(RTrim(PlantInfo.item_code))

Select	PlantInfo.loc_code,
		MainInfo.item_code, MainInfo.descr, MainInfo.short_descr,
		MainInfo.item_cat,
		PlantInfo.curr_std_cost,
		PlantInfo.spec_grav
From CmdTest_RJ.dbo.iloc As PlantInfo
Inner Join CmdTest_RJ.dbo.imst As MainInfo
On LTrim(RTrim(MainInfo.item_code)) = LTrim(RTrim(PlantInfo.item_code))
Where	LTrim(RTrim(MainInfo.item_cat)) In
		(
			Select CategoryInfo.Name
			From Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
		) 
Order By Ltrim(Rtrim(MainInfo.item_cat)), LTrim(RTrim(PlantInfo.loc_code)), LTrim(RTrim(PlantInfo.item_code))

Select *
From CmdTest_RJ.dbo.locn

Select	MainInfo.item_code, MainInfo.descr, MainInfo.short_descr,
		MainInfo.item_cat
From CmdTest_RJ.dbo.imst As MainInfo
Where	LTrim(RTrim(MainInfo.item_cat)) In
		(
			Select CategoryInfo.Name
			From Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
		) 
Order By Ltrim(Rtrim(MainInfo.item_cat)), LTrim(RTrim(MainInfo.item_code))

Select	LTrim(RTrim(MainInfo.item_code)), 
		LTrim(RTrim(MainInfo.descr)), 
		LTrim(RTrim(MainInfo.short_descr)),
		LTrim(RTrim(MainInfo.item_cat)),
		Ltrim(Rtrim(CategoryInfo.[Description])),
		Ltrim(Rtrim(CategoryInfo.FamilyMaterialTypeName)),
		Ltrim(Rtrim(CategoryInfo.MaterialTypeName)),
		CategoryInfo.SpecificGravity
From CmdTest_RJ.dbo.imst As MainInfo
Inner Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
On LTrim(RTrim(MainInfo.item_cat)) = CategoryInfo.Name
Order By Ltrim(Rtrim(MainInfo.item_code))

Select *
From CmdTest_RJ.dbo.icst As ICST
Inner Join CmdTest_RJ.dbo.imst As IMST
On ICST.const_item_code = IMST.item_code
Where Imst.descr Like '%Water%'

Select *
From Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As Info
Order By Info.AutoID

--Flaked Ice

Select *
From CmdTest_RJ.dbo.icst As ICST
Inner Join CmdTest_RJ.dbo.imst As IMST
On ICST.const_item_code = IMST.item_code
Where Imst.descr Like '%SCA220%'

Select ILOC.*
From CmdTest_RJ.dbo.iloc As ILoc
Left Join CmdTest_RJ.dbo.imst As IMST
On IMST.item_code = ILoc.item_code
Where IMST.item_code Is Null

Select Ltrim(Rtrim(IMST.item_code))
From CmdTest_RJ.dbo.IMST As IMST
Group By Ltrim(Rtrim(IMST.item_code))
Having Count(*) > 1

Select Ltrim(Rtrim(ILOC.loc_code)), Ltrim(Rtrim(IMST.descr))
From CmdTest_RJ.dbo.ILOC As ILOC
Inner Join CmdTest_RJ.dbo.imst As IMST
On LTrim(RTrim(IMST.item_code)) = LTrim(RTrim(ILOC.item_code))
Inner Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
On LTrim(RTrim(IMST.item_cat)) = Ltrim(Rtrim(CategoryInfo.Name))
Group By Ltrim(Rtrim(ILOC.loc_code)), Ltrim(Rtrim(IMST.descr))
Having Count(*) > 1

Select Ltrim(Rtrim(ILOC.loc_code)), Ltrim(Rtrim(IMST.item_code))
From CmdTest_RJ.dbo.ILOC As ILOC
Inner Join CmdTest_RJ.dbo.imst As IMST
On LTrim(RTrim(IMST.item_code)) = LTrim(RTrim(ILOC.item_code))
Inner Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
On LTrim(RTrim(IMST.item_cat)) = Ltrim(Rtrim(CategoryInfo.Name))
Group By Ltrim(Rtrim(ILOC.loc_code)), Ltrim(Rtrim(IMST.item_code))
Having Count(*) > 1

Select *
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Order By MaterialInfo.AutoID

Select	IMST.slump,
		IMST.min_slump,
		IMST.max_slump,
		*
From CmdTest_RJ.dbo.imst As IMST
Where	IsNull(IMST.slump, '') <> '' Or
		IsNull(IMST.min_slump, '') <> '' Or
		IsNull(IMST.max_slump, '') <> ''

Select	ILOC.slump,
		ILOC.min_slump,
		ILOC.max_slump,
		*
From CmdTest_RJ.dbo.ILOC As ILOC
Where	IsNull(ILOC.slump, '') <> '' Or
		IsNull(ILOC.min_slump, '') <> '' Or
		IsNull(ILOC.max_slump, '') <> ''

Select *
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Order By MaterialInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Order By MixInfo.AutoID

Select *
From CmdTest_RJ.dbo.icat As ICAT
Left Join Sonag_RJ.dbo.ProductionItemCategory As CategoryInfo
On LTrim(RTrim(Replace(ICAT.item_cat, Char(160), ' '))) = CategoryInfo.ItemCategory
Where CategoryInfo.ProdItemCatID Is Null

Select *
From Sonag_RJ.dbo.ProductionItemCategory

Select ILOC.*
From CmdTest_RJ.dbo.iloc As ILOC
Inner Join CmdTest_RJ.dbo.imst As IMST
On LTrim(RTrim(Replace(ILOC.item_code, Char(160), ' '))) = LTrim(RTrim(Replace(IMST.item_code, Char(160), ' ')))
Inner Join Sonag_RJ.dbo.ProductionItemCategory As CategoryInfo
On LTrim(RTrim(Replace(IMST.item_cat, Char(160), ' '))) = LTrim(RTrim(Replace(CategoryInfo.ItemCategory, Char(160), ' ')))
Left Join
(
	Select -1 As ID, Plants.Name As PlantCode, ItemName.Name As ItemCode
	From Sonag_RJ.dbo.Plants As Plants
	Inner Join Sonag_RJ.dbo.MATERIAL As Material
	On Material.PlantID = Plants.PlantId
	Inner Join Sonag_RJ.dbo.ItemMaster As ItemMaster
	On ItemMaster.ItemMasterID = Material.ItemMasterID
	Inner Join Sonag_RJ.dbo.Name As ItemName
	On ItemName.NameID = ItemMaster.NameID
	Group By Plants.Name, ItemName.Name
) As MaterialInfo
On	LTrim(RTrim(Replace(ILOC.loc_code, Char(160), ' '))) = LTrim(RTrim(Replace(MaterialInfo.PlantCode, Char(160), ' '))) And
	LTrim(RTrim(Replace(ILOC.item_code, Char(160), ' '))) = LTrim(RTrim(Replace(MaterialInfo.ItemCode, Char(160), ' '))) 
Where CategoryInfo.ProdItemCatType = 'Mtrl' And MaterialInfo.ID Is Null

Select ILOC.*
From CmdTest_RJ.dbo.iloc As ILOC
Inner Join CmdTest_RJ.dbo.imst As IMST
On LTrim(RTrim(Replace(ILOC.item_code, Char(160), ' '))) = LTrim(RTrim(Replace(IMST.item_code, Char(160), ' ')))
Inner Join Sonag_RJ.dbo.ProductionItemCategory As CategoryInfo
On LTrim(RTrim(Replace(IMST.item_cat, Char(160), ' '))) = LTrim(RTrim(Replace(CategoryInfo.ItemCategory, Char(160), ' ')))
Left Join
(
	Select -1 As ID, Plants.Name As PlantCode, ItemName.Name As ItemCode
	From Sonag_RJ.dbo.Plants As Plants
	Inner Join Sonag_RJ.dbo.MATERIAL As Material
	On Material.PlantID = Plants.PlantId
	Inner Join Sonag_RJ.dbo.ItemMaster As ItemMaster
	On ItemMaster.ItemMasterID = Material.ItemMasterID
	Inner Join Sonag_RJ.dbo.Name As ItemName
	On ItemName.NameID = ItemMaster.NameID
	Group By Plants.Name, ItemName.Name
) As MaterialInfo
On	LTrim(RTrim(Replace(ILOC.loc_code, Char(160), ' '))) = LTrim(RTrim(Replace(MaterialInfo.PlantCode, Char(160), ' '))) And
	LTrim(RTrim(Replace(ILOC.item_code, Char(160), ' '))) = LTrim(RTrim(Replace(MaterialInfo.ItemCode, Char(160), ' ')))
Inner Join CmdTest_RJ.dbo.icst As ICST
On	LTrim(RTrim(Replace(ILOC.loc_code, Char(160), ' '))) = LTrim(RTrim(Replace(ICST.loc_code, Char(160), ' ')))  And
	LTrim(RTrim(Replace(ILOC.item_code, Char(160), ' '))) = LTrim(RTrim(Replace(ICST.const_item_code, Char(160), ' '))) 
Where CategoryInfo.ProdItemCatType = 'Mtrl' And MaterialInfo.ID Is Null
