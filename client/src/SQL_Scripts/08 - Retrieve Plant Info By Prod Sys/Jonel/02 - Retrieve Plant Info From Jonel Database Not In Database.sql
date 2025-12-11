--> The Quadrel Database Name listed next to .dbo.Plants needs to be updated.

If  Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ') And
    Exists (Select * From sys.objects Where Name = 'Raw_Material_List')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_PlantInfo')
    Begin
        Insert into Data_Import_RJ.dbo.TestImport0000_PlantInfo (Name, [Description])
        Select Ltrim(Rtrim(Cast(Plant.Plant_ID As Nvarchar))), Ltrim(Rtrim(Replace(Plant.[Description], Char(160), ' ')))
        From dbo.Plant As Plant
        Left Join Data_Import_RJ.dbo.TestImport0000_PlantInfo As PlantInfo
        On Ltrim(Rtrim(Cast(Plant.Plant_ID As Nvarchar))) = PlantInfo.Name
        Left Join Rock_Solid_RJ.dbo.Plants As Plants
        On Ltrim(Rtrim(Cast(Plants.PlantId As Nvarchar))) = Plants.Name
        Where PlantInfo.AutoID Is Null And Plants.PlantId Is Null And Plant.System_Type_ID = 1
        Order By Plant.Plant_ID

		Update PlantInfo
			Set PlantInfo.Name = Ltrim(Rtrim(Replace(PlantInfo.Name, Char(160), ' '))),
				PlantInfo.[Description] = Ltrim(Rtrim(Replace(PlantInfo.[Description], Char(160), ' ')))
		From Data_Import_RJ.dbo.TestImport0000_PlantInfo As PlantInfo
    End
End
Go
