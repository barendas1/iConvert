If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo')
    Begin
    	Update MaterialInfo
    	    Set MaterialInfo.TradeName = MaterialInfo.ItemDescription
    	From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
    	Inner Join
    	(
    		Select Min(MaterialInfo2.AutoID) As AutoID    		
    		From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo2    		
    		Group By MaterialInfo2.PlantName, MaterialInfo2.ItemDescription
    	) As MaterialInfo3    	
    	On MaterialInfo.AutoID = MaterialInfo3.AutoID
    	Left Join
    	(
    		Select -1 As ID, Plant.Name As PlantCode, TradeNameInfo.Name As TradeName
    		From dbo.Plants As Plant
    		Inner Join dbo.MATERIAL As Material
    		On Material.PlantID = Plant.PlantId
    		Inner Join dbo.Name As TradeNameInfo
    		On TradeNameInfo.NameID = Material.NameID    		
    	) As ExistingMtrl
    	On MaterialInfo.PlantName = ExistingMtrl.PlantCode And MaterialInfo.ItemDescription = ExistingMtrl.TradeName
    	Where   Isnull(MaterialInfo.ItemDescription, '') <> '' And
    	        ExistingMtrl.ID Is Null And
    	        Isnull(MaterialInfo.TradeName, '') <> Isnull(MaterialInfo.ItemDescription, '')
    End
End
Go
