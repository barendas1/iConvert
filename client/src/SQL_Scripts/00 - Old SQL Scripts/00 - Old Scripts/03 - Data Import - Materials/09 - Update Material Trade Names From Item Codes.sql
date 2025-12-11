If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
	Update MaterialInfo
	    Set MaterialInfo.TradeName = MaterialInfo.ItemCode
	From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
	Inner Join
	(
	    Select MaterialInfo.PlantName, MaterialInfo.TradeName, Min(MaterialInfo.AutoID) As AutoID
	    From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
	    Group By MaterialInfo.PlantName, MaterialInfo.TradeName
	    Having Count(*) > 1	
	) As MultiMaterial
	On MaterialInfo.PlantName = MultiMaterial.PlantName And MaterialInfo.TradeName = MultiMaterial.TradeName
	Where MaterialInfo.AutoID <> MultiMaterial.AutoID
End
Go
