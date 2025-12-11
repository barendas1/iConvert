If Exists (Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ICAT' And COLUMN_NAME = 'Item_Cat')
Begin
    Declare @ItemCategoriesToSkip Table (ItemCategoryName Nvarchar (200))

    --> Update the Item Categories Skip List.
    Insert into @ItemCategoriesToSkip
    (
	    ItemCategoryName
    )
    Select Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' ')))
    From
    (
		Select 'ADMIX' As ItemCategoryName Union All 
		Select 'BLOCKS' As ItemCategoryName Union All 
		Select 'BREAK' As ItemCategoryName Union All 
		Select 'ICE' As ItemCategoryName Union All 
		Select 'MISC' As ItemCategoryName Union All 
		Select 'PR' As ItemCategoryName Union All 
		Select 'RCA' As ItemCategoryName Union All 
		Select 'RTL' As ItemCategoryName Union All 
		Select 'SKCEM' As ItemCategoryName Union All 
		Select '20' As ItemCategoryName Union All 
		Select '21' As ItemCategoryName Union All 
		Select '22' As ItemCategoryName Union All 
		Select '23' As ItemCategoryName Union All 
		Select '25' As ItemCategoryName Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
    ) As ItemCategoryInfo
    Where Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' '))) <> ''
    Group By Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' ')))
    Order By Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' ')))

    Insert into Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory (Name, [Description], ShortDescription, CategoryNumber, CategoryType)
    Select Trim(ItemCategory.item_cat), Trim(ItemCategory.descr),
           Trim(ItemCategory.short_descr), Trim(ItemCategory.item_type), 'Mtrl'
    From dbo.icat As ItemCategory
    Left Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As MaterialCategory
    On Trim(ItemCategory.item_cat) = MaterialCategory.Name
    Where   Trim(ItemCategory.item_type) <> '01' And 
            MaterialCategory.AutoID Is Null And
            Trim(ItemCategory.item_cat) Not In (Select ItemCategoryInfo.ItemCategoryName From @ItemCategoriesToSkip As ItemCategoryInfo)
    Order By Trim(ItemCategory.item_cat)
End
Go
