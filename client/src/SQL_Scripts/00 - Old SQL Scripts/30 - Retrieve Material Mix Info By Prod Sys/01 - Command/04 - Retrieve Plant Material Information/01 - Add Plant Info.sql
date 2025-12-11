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
        Select  dbo.TrimNVarChar(PlantInfo.loc_code), Max(dbo.TrimNVarChar(PlantInfo.descr)) 
        From CmdTest_RJ.dbo.locn As PlantInfo
        Left Join Data_Import_RJ.dbo.TestImport0000_PlantInfo As ExistingPlantInfo
        On dbo.TrimNVarChar(PlantInfo.loc_code) = ExistingPlantInfo.Name
        Where   Isnull(dbo.TrimNVarChar(PlantInfo.loc_code), '') <> '' And 
                ExistingPlantInfo.AutoID Is Null
        Group By dbo.TrimNVarChar(PlantInfo.loc_code)
        Order By dbo.TrimNVarChar(PlantInfo.loc_code)
    End
End
Go
