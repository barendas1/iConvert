If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo')
    Begin
    	Update MixInfo
    	    Set MixInfo.MaterialItemCode = MaterialInfo.ItemCode
    	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
        Inner Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
        On  MixInfo.PlantCode = MaterialInfo.PlantName And
            MixInfo.MaterialItemCode = MaterialInfo.ItemCategoryName
    End
End
Go
