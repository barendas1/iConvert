Insert into Data_Import_RJ.dbo.TestImport0000_PlantInfo 
(
	Name, Description, MaxBatchSize, MaxBatchSizeUnitName
)
Select PlantInfo.Code, PlantInfo.Description, PlantInfo.MaxBatchSize, 'yd^3' --PlantInfo.MaxBatchSizeUnitName
From Data_Import_RJ.dbo.TestImport0000_XML_Plant As PlantInfo
Left Join Data_Import_RJ.dbo.TestImport0000_PlantInfo As ExistingPlant
On PlantInfo.Code = ExistingPlant.Name
Where ExistingPlant.AutoID Is Null
Order By PlantInfo.Code
