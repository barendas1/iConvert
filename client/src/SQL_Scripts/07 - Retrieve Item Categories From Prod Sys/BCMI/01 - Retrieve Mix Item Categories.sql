Insert into Data_Import_RJ.dbo.TestImport0000_MixItemCategory (Name, [Description], ShortDescription, CategoryNumber, CategoryType)
Select Isnull(ItemCategoryInfo.ItemCategory, ''), Isnull(ItemCategoryInfo.ItemCategory, ''),
       Isnull(ItemCategoryInfo.ItemCategory, ''), Null, 'Mix'
From Data_Import_RJ.dbo.TestImport0000_MixInfo As ItemCategoryInfo
Left Join Data_Import_RJ.dbo.TestImport0000_MixItemCategory As MixCategory
On ItemCategoryInfo.ItemCategory = MixCategory.Name
Where Isnull(ItemCategoryInfo.ItemCategory, '') <> '' And MixCategory.AutoID Is Null
Group By Isnull(ItemCategoryInfo.ItemCategory, '')
Order By Isnull(ItemCategoryInfo.ItemCategory, '')
