If Exists (Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ICAT' And COLUMN_NAME = 'Item_Cat')
Begin
	-- Delete From Data_Import_RJ.dbo.TestImport0000_MixItemCategory
    Select Trim(ICAT.item_cat), Trim(ICAT.descr), Trim(ICAT.short_descr), Trim(ICAT.item_type)
    From dbo.icat As ICAT
    Where trim(ICAT.item_type) <> '01'
    Order By Trim(ICAT.item_cat)

	Select ItemCategory.item_cat, ItemCategory.descr, ItemCategory.short_descr, ItemCategory.item_type
	From dbo.ICST As MixRecipe
	Inner Join dbo.IMST As MaterialInfo
	On MixRecipe.const_item_code = MaterialInfo.item_code
	Inner Join dbo.icat As ItemCategory
	On MaterialInfo.item_cat = ItemCategory.item_cat
	Group By ItemCategory.item_cat, ItemCategory.descr, ItemCategory.short_descr, ItemCategory.item_type
	Order By ItemCategory.item_cat
End
Go
