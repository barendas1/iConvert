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
        	    Select Trim(Replace(MaterialInfo.PlantName, Char(160), ' ')) As PlantCode
        	    From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
        	    Where Trim(Replace(Isnull(MaterialInfo.PlantName, ''), Char(160), ' ')) <> ''
        	    Group By Trim(Replace(MaterialInfo.PlantName, Char(160), ' '))
        	
        	    Union All

        	    Select Trim(Replace(MixInfo.PlantCode, Char(160), ' ')) As PlantCode
        	    From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
        	    Where Trim(Replace(Isnull(MixInfo.PlantCode, ''), Char(160), ' ')) <> ''
        	    Group By Trim(Replace(MixInfo.PlantCode, Char(160), ' '))
        	) As PlantInfo3
        	Group By PlantInfo3.PlantCode
        ) As PlantInfo
        Left Join Data_Import_RJ.dbo.TestImport0000_PlantInfo As ExistingPlantInfo
        On PlantInfo.PlantCode = ExistingPlantInfo.Name
        Left Join dbo.Plants As Plants
        On PlantInfo.PlantCode = Plants.Name
        Where   ExistingPlantInfo.AutoID Is Null And Plants.PlantID Is Null
        Group By PlantInfo.PlantCode
        Order By PlantInfo.PlantCode
    End
End
Go
