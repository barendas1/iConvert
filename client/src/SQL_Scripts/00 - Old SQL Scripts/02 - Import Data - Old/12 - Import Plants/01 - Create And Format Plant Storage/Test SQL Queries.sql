Insert into Data_Import_RJ.dbo.TestImport0000_XML_PlantInfo (Name, [Description])
Select Cast(Plant.Plant_ID As Nvarchar), Plant.[Description]
From dbo.Plant As Plant
Left Join Data_Import_RJ.dbo.TestImport0000_XML_PlantInfo As PlantInfo
On Cast(Plant.Plant_ID As Nvarchar) = PlantInfo.Name
Where PlantInfo.AutoID Is Null
Order By Plant.Plant_ID
