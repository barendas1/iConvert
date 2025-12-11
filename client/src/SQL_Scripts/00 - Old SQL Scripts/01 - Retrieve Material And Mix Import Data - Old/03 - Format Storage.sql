If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MixProps')
    Begin
    	Update MixInfo
    	    Set MixInfo.PlantCode = dbo.GetTrimmedValue(MixInfo.PlantCode),
    	        MixInfo.PlantDescription = dbo.GetTrimmedValue(MixInfo.PlantDescription),
    	        MixInfo.MixCode = dbo.GetTrimmedValue(MixInfo.MixCode),
    	        MixInfo.MixDescription = dbo.GetTrimmedValue(MixInfo.MixDescription),
    	        MixInfo.ItemCategoryCode = dbo.GetTrimmedValue(MixInfo.ItemCategoryCode),
    	        MixInfo.ItemCategoryDescription = dbo.GetTrimmedValue(MixInfo.ItemCategoryDescription)
    	From Data_Import_RJ.dbo.TestImport0000_XML_MixProps As MixInfo
    End
End
Go
