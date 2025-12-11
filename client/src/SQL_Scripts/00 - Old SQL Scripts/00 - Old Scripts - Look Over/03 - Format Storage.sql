If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixProps')
    Begin
    	Update MixInfo
    	    Set MixInfo.PlantCode = dbo.TrimNVarChar(MixInfo.PlantCode),
    	        MixInfo.PlantDescription = dbo.TrimNVarChar(MixInfo.PlantDescription),
    	        MixInfo.MixCode = dbo.TrimNVarChar(MixInfo.MixCode),
    	        MixInfo.MixDescription = dbo.TrimNVarChar(MixInfo.MixDescription),
    	        MixInfo.ItemCategoryCode = dbo.TrimNVarChar(MixInfo.ItemCategoryCode),
    	        MixInfo.ItemCategoryDescription = dbo.TrimNVarChar(MixInfo.ItemCategoryDescription)
    	From Data_Import_RJ.dbo.TestImport0000_MixProps As MixInfo
    End
End
Go
