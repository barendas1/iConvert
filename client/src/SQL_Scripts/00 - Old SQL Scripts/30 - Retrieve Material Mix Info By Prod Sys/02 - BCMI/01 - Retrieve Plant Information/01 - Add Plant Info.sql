If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_PlantInfo')
    Begin
        Insert into Data_Import_RJ.dbo.TestImport0000_PlantInfo
        (
	        -- AutoID -- this column value is auto-generated
	        Name,
	        Description
        )
        Select PlantInfo.PlantCode, Null
        From
        (
        	Select PlantInfo3.PlantCode
        	From
        	(
        	    Select dbo.TrimNVarChar(MaterialInfo.PlantName) As PlantCode
        	    From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
        	    Where Isnull(dbo.TrimNVarChar(MaterialInfo.PlantName), '') <> ''
        	    Group By dbo.TrimNVarChar(MaterialInfo.PlantName)
        	
        	    Union All

        	    Select dbo.TrimNVarChar(MixInfo.PlantCode) As PlantCode
        	    From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
        	    Where Isnull(dbo.TrimNVarChar(MixInfo.PlantCode), '') <> ''
        	    Group By dbo.TrimNVarChar(MixInfo.PlantCode)
        	) As PlantInfo3
        	Group By PlantInfo3.PlantCode
        ) As PlantInfo
        Left Join Data_Import_RJ.dbo.TestImport0000_PlantInfo As ExistingPlantInfo
        On PlantInfo.PlantCode = ExistingPlantInfo.Name
        Where   ExistingPlantInfo.AutoID Is Null
        Group By PlantInfo.PlantCode
        Order By PlantInfo.PlantCode
    End
End
Go
