Update MaterialInfo
    Set MaterialInfo.Cost = Null,
        MaterialInfo.CostUnitName = Null
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Where MaterialInfo.CostUnitName = 'EA'

Delete MaterialInfo
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Where MaterialInfo.PlantName In ('S1', 'S2')

Delete MixInfo
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
Where MixInfo.PlantCode In ('S1', 'S2')
