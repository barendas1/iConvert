Select *
From Data_Import_RJ.dbo.TestImport0000_XML_ItemCategory As ItemCategory
Where   ItemCategory.ItemTypeID <> 1  
Order By ItemCategory.Code

Select ItemCategory.Code, ItemCategory.[Description], ItemCategory.ShortDescription, Cast(ItemCategory.ItemTypeID As Nvarchar), 'Mtrl'
From Data_Import_RJ.dbo.TestImport0000_XML_ItemCategory As ItemCategory
Where   ItemCategory.ItemTypeID <> 1  
Order By ItemCategory.Code
