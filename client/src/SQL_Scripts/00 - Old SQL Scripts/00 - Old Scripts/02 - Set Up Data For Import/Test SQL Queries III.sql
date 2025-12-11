Select MixInfo.MixCode
From Data_Import_RJ.dbo.TestImport0000_MixData As MixInfo
Group By MixInfo.MixCode
Having Count(*) > 1