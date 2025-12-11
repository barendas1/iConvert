Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where MixInfo.Strength Is Null
Order By MixInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where MixInfo.Strength Is Null And MixInfo.MixDescription Like '%PSI%'
Order By MixInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where MixInfo.Strength Is Null And MixInfo.MixDescription Like '%MPA%'
Order By MixInfo.AutoID

/*
Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where MixInfo.Strength Is Not Null
Order By MixInfo.AutoID
*/
