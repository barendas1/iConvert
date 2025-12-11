Select *
From dbo.icat As ItemCategory
Where   ItemCategory.item_type <> '01'  
Order By Trim(ItemCategory.item_cat)

Select Trim(ItemCategory.item_cat), Trim(ItemCategory.descr),
       Trim(ItemCategory.short_descr), Trim(ItemCategory.Item_Type), 'Mtrl'
From dbo.ICAT As ItemCategory
Where   ItemCategory.item_type <> '01'  
Order By Trim(ItemCategory.Item_Cat)

Select *
From dbo.imst As MaterialInfo
Where Trim(MaterialInfo.item_cat) In ('PLANT CHARGE', '', '')
Order By Trim(MaterialInfo.item_code)

Select *
From dbo.icst As ICST
Where Trim(ICST.const_item_code) In ('AEA925', '', '')
Order By Trim(ICST.const_item_code)

Select *
From dbo.icst As MixInfo
Where Trim(MixInfo.item_code) In ('C35AC', 'T40278MP', 'T50278MP')
Order By MixInfo.item_code, MixInfo.loc_code, MixInfo.const_item_code
