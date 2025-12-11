-->  These can be used, if needed.

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

Insert into Data_Import_RJ.dbo.TestImport0000_PlantInfo (Name, Description)
Select MixInfo.PlantCode, Null
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Left Join Data_Import_RJ.dbo.TestImport0000_PlantInfo As PlantInfo
On MixInfo.PlantCode = PlantInfo.Name
Left Join dbo.Plants As Plant
On MixInfo.PlantCode = Plant.Name
Where   Isnull(MixInfo.PlantCode, '') <> '' And
        PlantInfo.AutoID Is Null And
        Plant.PlantId Is Null
Group By MixInfo.PlantCode
Order By MixInfo.PlantCode

Insert into Data_Import_RJ.dbo.TestImport0000_PlantInfo (Name, Description)
Select MaterialInfo.PlantName, Null
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Left Join Data_Import_RJ.dbo.TestImport0000_PlantInfo As PlantInfo
On MaterialInfo.PlantName = PlantInfo.Name
Left Join dbo.Plants As Plant
On MaterialInfo.PlantName = Plant.Name
Where   Isnull(MaterialInfo.PlantName, '') <> '' And
        PlantInfo.AutoID Is Null And
        Plant.PlantId Is Null
Group By MaterialInfo.PlantName
Order By MaterialInfo.PlantName
