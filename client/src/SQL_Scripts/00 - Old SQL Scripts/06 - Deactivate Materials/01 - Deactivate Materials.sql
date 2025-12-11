Declare @MaterialInfo Table (MaterialID Int Unique, ItemCode Nvarchar (100))

Insert into @MaterialInfo
(
	MaterialID, ItemCode
)
Select Material.MATERIALIDENTIFIER, ItemName.Name
From dbo.MaterialRecipe As Recipe
Inner Join dbo.MATERIAL As Material
On Material.MATERIALIDENTIFIER = Recipe.MaterialID
Inner Join dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Inner Join dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Group By Material.MATERIALIDENTIFIER, ItemName.Name

Update Material
    Set Material.Inactive = 1
From dbo.MATERIAL As Material
Inner Join dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Inner Join dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Where   Material.FamilyMaterialTypeID = 3 And
        ItemName.Name Not In (Select ItemCode From @MaterialInfo)