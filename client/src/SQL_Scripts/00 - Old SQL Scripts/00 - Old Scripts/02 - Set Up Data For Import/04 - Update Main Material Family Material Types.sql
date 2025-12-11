If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MainMaterialInfo')
    Begin
    	Update MaterialInfo
    		Set MaterialInfo.FamilyMaterialTypeName = FamilyMaterialTypeInfo.MaterialType
    	From Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MaterialInfo
    	Inner Join iServiceDataExchange.dbo.MaterialType As MtrlTypeInfo
    	On MaterialInfo.MaterialTypeName = MtrlTypeInfo.MaterialType
    	Inner Join iServiceDataExchange.dbo.GetFamilyMaterialTypeInfo() As FamilyMtrlTypeInfo
    	On MtrlTypeInfo.MaterialTypeID = FamilyMtrlTypeInfo.MaterialTypeID
    	Inner Join iServiceDataExchange.dbo.MaterialType As FamilyMaterialTypeInfo
    	On FamilyMtrlTypeInfo.FamilyMaterialTypeID = FamilyMaterialTypeInfo.MaterialTypeID
    End
End
Go
