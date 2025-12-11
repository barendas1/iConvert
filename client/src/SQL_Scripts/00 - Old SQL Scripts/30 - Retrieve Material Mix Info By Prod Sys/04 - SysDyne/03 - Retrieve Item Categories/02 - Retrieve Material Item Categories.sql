Declare @ItemCategoriesToSkip Table (ItemCategoryName Nvarchar (200))

Insert into @ItemCategoriesToSkip
(
	ItemCategoryName
)
Select Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' ')))
From
(
	Select 'BLOCK' As ItemCategoryName
	Union All
	Select 'DELIVERY RATE' As ItemCategoryName
	Union All
	Select 'DISCOUNT' As ItemCategoryName
	Union All
	Select 'HAUL CHARGE' As ItemCategoryName
	Union All
	Select 'OTHER' As ItemCategoryName
	Union All
	Select 'QUOTE USE ONLY' As ItemCategoryName
	Union All
	Select 'SERVICE' As ItemCategoryName
	Union All
	Select '' As ItemCategoryName
	Union All
	Select '' As ItemCategoryName
) As ItemCategoryInfo
Where Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' '))) <> ''
Group By Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' ')))
Order By Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' ')))

Insert into Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory (Name, [Description], ShortDescription, CategoryNumber, CategoryType)
Select ItemCategory.Code, ItemCategory.[Description],
       ItemCategory.ShortDescription, Cast(ItemCategory.ItemTypeID As Nvarchar), 'Mtrl'
From Data_Import_RJ.dbo.TestImport0000_XML_ItemCategory As ItemCategory
Left Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As MaterialCategory
On ItemCategory.Code = MaterialCategory.Name
Where   ItemCategory.ItemTypeID <> 1 And 
        MaterialCategory.AutoID Is Null And
        ItemCategory.Code Not In (Select ItemCategoryInfo.ItemCategoryName From @ItemCategoriesToSkip As ItemCategoryInfo)
Order By ItemCategory.Code
