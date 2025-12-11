--Remove Mixes that have Material Item Codes.

Delete MixInfo
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where MixInfo.MixCode In (Select MaterialInfo.ItemCode From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo)