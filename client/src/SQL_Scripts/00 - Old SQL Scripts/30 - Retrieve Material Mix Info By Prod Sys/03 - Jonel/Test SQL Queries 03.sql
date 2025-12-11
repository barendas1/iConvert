/*
Exec dbo.GlobalDateFormat_SwitchMonthAndDayIfInDDMMYYYYMode
Select * From Batch
Select * From Material
Select * From DBSetting Where DBSettingSubcategoryID = 58
*/

Select *
From dbo.Raw_Material_List

Select *
From iServiceDataExchange.dbo.MaterialType As Info
Order By Info.RecipeOrder

Select *
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Order By MaterialInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Order By MixInfo.AutoID
