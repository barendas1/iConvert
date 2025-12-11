/*
Select *
From iServiceDataExchange.dbo.MaterialType As MaterialType
Order By MaterialType.RecipeOrder
*/
/*
Select MaterialType.MaterialType, Material.SPECGR, Count(*) As MaterialCount
From dbo.MATERIAL As Material
Inner Join iServiceDataExchange.dbo.MaterialType As MaterialType
On Material.MaterialTypeLink = MaterialType.MaterialTypeID
Where MaterialType.MaterialType = 'Hydration Stabilizer'
Group By MaterialType.MaterialType, Material.SPECGR
*/

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Order By MixInfo.AutoID

Select *
From dbo.Formula

Select *
From dbo.Concrete_Product

Select *
From dbo.Product

Select *
From dbo.Raw_Material_List
