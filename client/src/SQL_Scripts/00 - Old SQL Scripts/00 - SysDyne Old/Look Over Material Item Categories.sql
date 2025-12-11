Select ItemCategory.Code, ItemCategory.[Description],
       ItemCategory.ShortDescription, Cast(ItemCategory.ItemTypeID As Nvarchar), 'Mtrl'
From Data_Import_RJ.dbo.TestImport0000_XML_ItemCategory As ItemCategory
Where   ItemCategory.ItemTypeID <> 1  
Order By ItemCategory.Code

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_Material As MaterialInfo
Where MaterialInfo.ItemCategoryCode In ('MATS', '', '')
Order By MaterialInfo.ItemCategoryCode, MaterialInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_Mix As MixInfo
Where MixInfo.MaterialItemCode In ('AEA925', '', '')
Order By MixInfo.MaterialItemCode, MixInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_Mix As MixInfo
Where MixInfo.ItemCode In ('C35AC', 'T40278MP', 'T50278MP')
Order By MixInfo.MaterialItemCode, MixInfo.AutoID
