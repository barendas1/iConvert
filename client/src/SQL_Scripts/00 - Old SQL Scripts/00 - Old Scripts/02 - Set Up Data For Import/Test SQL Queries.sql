Select MaterialInfo.PlantName, MaterialInfo.TradeName
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Group By MaterialInfo.PlantName, MaterialInfo.TradeName
Having Count(*) > 1

Select MaterialInfo.PlantName, MaterialInfo.ItemCode
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Group By MaterialInfo.PlantName, MaterialInfo.ItemCode
Having Count(*) > 1

Select MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Group By MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode
Having Count(*) > 1

Select *
From dbo.imst As IMST
Where IMSt.min_slump Is Not null

Select * 
From dbo.uoms As UOMS

Select *
From dbo.IMST As IMST
Where IMST.pct_air Is Not null

Select *
From dbo.iloc As ILOC
Where ILOC.max_slump Is Not null

Select *
From dbo.iloc As ILOC
Inner Join dbo.IMST As IMST
On IMST.item_code = ILOC.item_code
Inner Join dbo.icat As ICAT
On ICAT.item_cat = IMST.item_cat
Where ICAT.item_type <> '01'

Select *
From dbo.iloc As ILOC
Inner Join dbo.IMST As IMST
On IMST.item_code = ILOC.item_code
Inner Join dbo.icat As ICAT
On ICAT.item_cat = IMST.item_cat
Where ICAT.item_type <> '01' And ILOC.spec_grav Is Not Null

Select *
From dbo.icst As ICST
Where dbo.TrimNVarChar(ICST.const_item_code) In ('349', '350')

Select *
From iServiceDataExchange.dbo.MaterialType As MaterialType
Order By MaterialType.RecipeOrder

Select *
From LOCN
Order By LOCN.LOC_CODE

Select *
From IMST
Order By IMST.ITEM_CODE

Select *
From ILOC
Order By ILOC.LOC_CODE, ILOC.ITEM_CODE

Select *
From IMLB
Order By IMLB.LOC_CODE, IMLB.ITEM_CODE

Select *
From ICST
Order By ICST.LOC_CODE, ICST.ITEM_CODE, ICST.CONST_ITEM_CODE

Select *
From UOMS
Order By UOMS.UOM

Select *
From ICAT
Order By ICAT.item_type, ICAT.ITEM_CAT

Select *
From dbo.ILOC As ILOC
Inner Join dbo.IMST As IMST
On IMST.item_code = ILOC.item_code
Inner Join dbo.icat As ICAT
On  ICAT.item_cat = IMST.item_cat
Where ICAT.item_type <> '01'

Select Distinct ICAT.item_cat, ICAT.descr, ICAT.short_descr, ICAT.item_type
From dbo.ILOC As ILOC
Inner Join dbo.IMST As IMST
On IMST.item_code = ILOC.item_code
Inner Join dbo.icat As ICAT
On  ICAT.item_cat = IMST.item_cat
Where ICAT.item_type <> '01'
Order By ICAT.item_cat

Select Distinct ICAT.item_cat, ICAT.descr, ICAT.short_descr, ICAT.item_type
From dbo.ILOC As ILOC
Inner Join dbo.IMST As IMST
On IMST.item_code = ILOC.item_code
Inner Join dbo.icat As ICAT
On  ICAT.item_cat = IMST.item_cat
Inner Join dbo.icst As ICST
On  ILOC.loc_code = ICST.loc_code And
    ILOC.item_code = ICST.const_item_code
Where ICAT.item_type <> '01'
Order By ICAT.item_cat

Select CategoryInfo.ItemCategory, CategoryInfo.[Description],
       CategoryInfo.ShortDescription
From Sonag_RJ.dbo.ProductionItemCategory As CategoryInfo
Where CategoryInfo.ProdItemCatType = 'Mtrl'
Order By CategoryInfo.ItemCategory

Select *
From dbo.iloc As ILOC
Where ILOC.slump Is Not null Or ILOC.min_slump Is Not null Or ILOC.max_slump Is Not null

Select *
From dbo.IMST As IMST
Where IMST.slump Is Not null Or IMST.min_slump Is Not null Or IMST.max_slump Is Not null
