If  Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ') And
    Exists (Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ICAT' And COLUMN_NAME = 'Item_Cat')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_PlantInfo')
    Begin
    	--> Delete From Data_Import_RJ.dbo.TestImport0000_PlantInfo
        Insert into Data_Import_RJ.dbo.TestImport0000_PlantInfo
        (
	        -- AutoID -- this column value is auto-generated
	        Name,
	        Description
        )
        Select  Trim(PlantInfo.loc_code), Max(Trim(PlantInfo.descr)) 
        From dbo.locn As PlantInfo
        Left Join Data_Import_RJ.dbo.TestImport0000_PlantInfo As ExistingPlantInfo
        On Trim(PlantInfo.loc_code) = ExistingPlantInfo.Name
        Where   Isnull(Trim(PlantInfo.loc_code), '') <> '' And 
                ExistingPlantInfo.AutoID Is Null
        Group By Trim(PlantInfo.loc_code)
        Order By Trim(PlantInfo.loc_code)
    End
End
Go
