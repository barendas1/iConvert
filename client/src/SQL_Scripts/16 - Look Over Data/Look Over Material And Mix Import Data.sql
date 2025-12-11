Select *
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Order By MaterialInfo.PlantName, MaterialInfo.FamilyMaterialTypeName, MaterialInfo.TradeName

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Order By MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode
