Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where Isnull(MixInfo.Strength, -1.0) <= 0.01
Order By MixInfo.AutoID
