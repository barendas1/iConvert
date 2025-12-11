Update CategoryInfo
    Set CategoryInfo.MaterialTypeName = Trim(Replace(CategoryInfo.MaterialTypeName, Char(160), ' '))
From Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo

Update CategoryInfo
    Set CategoryInfo.FamilyMaterialTypeName = FamilyMaterialType.Name
From Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
Inner Join Quadrel_Template_For_Reports.dbo.Static_MaterialType As MaterialType
On CategoryInfo.MaterialTypeName = MaterialType.Name
Inner Join Quadrel_Template_For_Reports.dbo.GetFamilyMaterialTypeInformation() As FamilyMtrlTypeInfo
On MaterialType.Static_MaterialTypeID = FamilyMtrlTypeInfo.Static_MaterialTypeID
Inner Join Quadrel_Template_For_Reports.dbo.Static_MaterialType As FamilyMaterialType
On FamilyMtrlTypeInfo.Family_Static_MaterialTypeID = FamilyMaterialType.Static_MaterialTypeID
Where Isnull(CategoryInfo.FamilyMaterialTypeName, '') <> Isnull(FamilyMaterialType.Name, '')