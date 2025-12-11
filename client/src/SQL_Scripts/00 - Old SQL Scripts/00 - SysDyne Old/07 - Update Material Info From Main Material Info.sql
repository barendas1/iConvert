Update MaterialInfo
    Set MaterialInfo.FamilyMaterialTypeName = MainInfo.FamilyMaterialTypeName,
        MaterialInfo.MaterialTypeName = MainInfo.MaterialTypeName,
        MaterialInfo.SpecificGravity = 
            Case
                When Isnull(MaterialInfo.SpecificGravity, -1.0) >= 0.4
                Then MaterialInfo.SpecificGravity
                Else MainInfo.SpecificGravity
            End,
        MaterialInfo.IsLiquidAdmix = 
            Case
                When MainInfo.FamilyMaterialTypeName = 'Admixture & Fiber' 
                Then MaterialInfo.IsLiquidAdmix
                Else 'No'
            End,
        MaterialInfo.MoisturePct = 
            Case
                When MainInfo.FamilyMaterialTypeName = 'Admixture & Fiber' And Isnull(MaterialInfo.MoisturePct, -1.0) >= 0.0
                Then MaterialInfo.MoisturePct
                When MainInfo.FamilyMaterialTypeName = 'Admixture & Fiber'
                Then Isnull(MainInfo.MoisturePct, 0.0)
                Else 0.0
            End
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Inner Join Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MainInfo
On MaterialInfo.ItemCode = MainInfo.Name

Delete MaterialInfo
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Inner Join Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MainInfo
On MaterialInfo.ItemCode = MainInfo.Name
Where MainInfo.MaterialTypeName In ('Delete')