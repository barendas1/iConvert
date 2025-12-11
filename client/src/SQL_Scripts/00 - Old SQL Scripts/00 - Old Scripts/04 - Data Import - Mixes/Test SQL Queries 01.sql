Select *
From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
Go

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Order By MixInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where Isnull(MixInfo.Strength, -1.0) <= 0.0
Order By MixInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where Isnull(MixInfo.Strength, -1.0) > 0.0
Order By MixInfo.AutoID

Go
/*
Update MixInfo
    Set MixInfo.StrengthAge = Null, MixInfo.Strength = Null
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where Isnull(MixInfo.Strength, -1.0) >= 0.0 And Isnull(MixInfo.Strength, -1.0) < 100.0
*/
Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Order By MixInfo.AutoID
Go

Select * From iServiceDataExchange.dbo.MaterialType As MaterialType Order By MaterialType.RecipeOrder

Select * From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo Order By MixInfo.AutoID
Select * From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo Where Isnull(MixInfo.Strength, -1.0) <= 0.0 Order By MixInfo.AutoID

Select * From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo Where Isnull(MixInfo.Slump, -1.0) = 5.5 Order By MixInfo.AutoID

Select * From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo Where Isnull(MixInfo.MinSlump, -1.0) < 0.0 Order By MixInfo.AutoID
Select * From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo Where Isnull(MixInfo.MinAirContent, -1.0) < 0.0 Order By MixInfo.AutoID

Select * From Data_Import_RJ.dbo.TestImport0000_MaterialInfo Order By AutoID

Select * 
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo 
Where   Isnull(MixInfo.Slump, -1.0) > 0.0 And Isnull(MixInfo.MinSlump, -1.0) < 0.0 And Isnull(MixInfo.MaxSlump, -1.0) < 0.0   
Order By MixInfo.AutoID
/*
Update MixInfo
    Set MixInfo.MinSlump = 3,
        MixInfo.MaxSlump = 6
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo 
Where   Isnull(MixInfo.Slump, -1.0) = 5.5 And Isnull(MixInfo.MinSlump, -1.0) < 0.0 And Isnull(MixInfo.MaxSlump, -1.0) < 0.0   
Order By MixInfo.AutoID
*/
--3 6