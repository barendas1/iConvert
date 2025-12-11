Insert into Data_Import_RJ.dbo.TestImport0000_PlantInfo 
(
	Name, Description, MaxBatchSize, MaxBatchSizeUnitName
)
Select LocationInfo.Code, LocationInfo.Name, PlantInfo.MaxBatchSize, PlantInfo.MaxBatchSizeUnitName
From Data_Import_RJ.dbo.TestImport0000_XML_Location As LocationInfo
Left Join Data_Import_RJ.dbo.TestImport0000_XML_Plant As PlantInfo
On LocationInfo.LocationID = PlantInfo.LocationID
Left Join Data_Import_RJ.dbo.TestImport0000_PlantInfo As ExistingPlant
On LocationInfo.Code = ExistingPlant.Name
Left Join dbo.Plants As Plants
On LocationInfo.Code = Plants.Name
Where ExistingPlant.AutoID Is Null And Plants.PlantId Is Null
Order By LocationInfo.Code
