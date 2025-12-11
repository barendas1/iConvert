If Exists (Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ICAT' And COLUMN_NAME = 'Item_Cat')
Begin
	-- Delete From Data_Import_RJ.dbo.TestImport0000_MixItemCategory
    Insert into Data_Import_RJ.dbo.TestImport0000_MixItemCategory (Name, [Description], ShortDescription, CategoryNumber, CategoryType)
    Select Trim(ICAT.item_cat), Trim(ICAT.descr), Trim(ICAT.short_descr), Trim(ICAT.item_type), 'Mix'
    From dbo.icat As ICAT
    Left Join Data_Import_RJ.dbo.TestImport0000_MixItemCategory As MixCategory
    On Trim(ICAT.item_cat) = MixCategory.Name
    Where trim(ICAT.item_type) = '01' And MixCategory.AutoID Is Null
    Order By Trim(ICAT.item_cat)
End
Go
