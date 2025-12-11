Insert into Data_Import_RJ.dbo.TestImport0000_MixItemCategory (Name, [Description], ShortDescription, CategoryNumber, CategoryType)
Select ItemCategory.Code, ItemCategory.[Description],
       ItemCategory.ShortDescription, Cast(ItemCategory.ItemTypeID As Nvarchar), 'Mix'
From Data_Import_RJ.dbo.TestImport0000_XML_ItemCategory As ItemCategory
Left Join Data_Import_RJ.dbo.TestImport0000_MixItemCategory As MixCategory
On ItemCategory.Code = MixCategory.Name
Where ItemCategory.ItemTypeID = 1 And MixCategory.AutoID Is Null
Order By ItemCategory.Code
