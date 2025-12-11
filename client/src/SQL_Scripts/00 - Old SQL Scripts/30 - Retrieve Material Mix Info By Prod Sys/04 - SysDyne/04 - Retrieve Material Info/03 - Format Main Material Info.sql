Update MaterialInfo
    Set MaterialInfo.FamilyMaterialTypeName = dbo.TrimNVarChar(MaterialInfo.FamilyMaterialTypeName),
        MaterialInfo.MaterialTypeName = dbo.TrimNVarChar(MaterialInfo.MaterialTypeName),
        MaterialInfo.IsLiquidAdmix = dbo.TrimNVarChar(MaterialInfo.IsLiquidAdmix)
From Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MaterialInfo

Update MaterialInfo
    Set MaterialInfo.FamilyMaterialTypeName = FamilyMaterialType.Name
From Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MaterialInfo
Inner Join Quadrel_Template_For_Reports.dbo.Static_MaterialType As MaterialType
On MaterialInfo.MaterialTypeName = MaterialType.Name
Inner Join Quadrel_Template_For_Reports.dbo.GetFamilyMaterialTypeInformation() As FamilyMtrlTypeInfo
On MaterialType.Static_MaterialTypeID = FamilyMtrlTypeInfo.Static_MaterialTypeID
Inner Join Quadrel_Template_For_Reports.dbo.Static_MaterialType As FamilyMaterialType
On FamilyMtrlTypeInfo.Family_Static_MaterialTypeID = FamilyMaterialType.Static_MaterialTypeID
Where Isnull(MaterialInfo.FamilyMaterialTypeName, '') <> Isnull(FamilyMaterialType.Name, '')