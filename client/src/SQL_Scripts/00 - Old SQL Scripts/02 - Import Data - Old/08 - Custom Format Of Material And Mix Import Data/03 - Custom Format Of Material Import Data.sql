/*
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.MaterialTypeName = 'CSA Type F'
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where	Isnull(MaterialInfo.MaterialTypeName, '') In ('CSA FA1')
    End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.MaterialTypeName = 'CSA Type F'
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where	Isnull(MaterialInfo.MaterialTypeName, '') In ('CSA FA1')
    End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.MaterialTypeName = MaterialInfo.FamilyMaterialTypeName
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where	Isnull(MaterialInfo.MaterialTypeName, '') In ('NA', 'Mineral Filler', 'Air Supressent')
    End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.MaterialTypeName = 'CSA Type GUb-F/SF'
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where	Isnull(MaterialInfo.MaterialTypeName, '') In ('CSA Type GUb-S/SF', 'CSA Type GUb-S-SF')
    End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.MaterialTypeName = 'CSA Type GU'
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where	Isnull(MaterialInfo.MaterialTypeName, '') = 'CSA Type GUB'
    End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.FamilyMaterialTypeName = 'Cement',
				MaterialInfo.MaterialTypeName = 'Cement'
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where	Isnull(MaterialInfo.MaterialTypeName, '') In ('Integrel Hardener', 'Integral Hardener')		                                                     
    End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.SpecificGravity = 1.0
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where	MaterialInfo.FamilyMaterialTypeName = 'Admixture & Fiber' And
				MaterialInfo.SpecificGravity Is Null

		Update MaterialInfo
			Set MaterialInfo.SpecificGravity = 3.15
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where	MaterialInfo.FamilyMaterialTypeName = 'Cement' And
				MaterialInfo.SpecificGravity Is Null
				
		Update MaterialInfo
			Set MaterialInfo.SpecificGravity = 2.2
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where	MaterialInfo.MaterialTypeName = 'Silica Fume' And
				MaterialInfo.SpecificGravity Is Null			

		Update MaterialInfo
			Set MaterialInfo.SpecificGravity = 2.75
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where	MaterialInfo.MaterialTypeName = 'Coarse Aggregate (General)' And
				MaterialInfo.SpecificGravity Is Null			

		Update MaterialInfo
			Set MaterialInfo.SpecificGravity = 2.65
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where	MaterialInfo.MaterialTypeName = 'Fine Aggregate (General)' And
				MaterialInfo.SpecificGravity Is Null			
    End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.CostUnitName = 'TM'
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where MaterialInfo.CostUnitName In ('Ton', 'TO')
    End
End
Go
*/
---------------------------------------------------------------------------------------------------
--The SQL Code below probably does not need to be updated.
---------------------------------------------------------------------------------------------------

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.ItemCode = Null
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Inner Join
		(
			Select MaterialInfo.PlantName, MaterialInfo.ItemCode, Min(MaterialInfo.AutoID) As AutoID
			From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
			Group By MaterialInfo.PlantName, MaterialInfo.ItemCode
			Having Count(*) > 1
		) As DupItemCodeInfo
		On	DupItemCodeInfo.PlantName = MaterialInfo.PlantName And
			DupItemCodeInfo.ItemCode = MaterialInfo.ItemCode
		Where DupItemCodeInfo.AutoID <> MaterialInfo.AutoID		
    End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.TradeName = Ltrim(Rtrim(Left(MaterialInfo.TradeName, 70)))
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where Len(MaterialInfo.TradeName) > 70
    End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
		Update MaterialInfo
			Set MaterialInfo.ManufacturerSourceName = Ltrim(Rtrim(Left(MaterialInfo.ManufacturerSourceName, 50)))
		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
		Where Len(MaterialInfo.ManufacturerSourceName) > 50
    End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
    Begin
    	Declare @MultiNameInfo Table 
    	(
    		AutoID Int Identity (1, 1), 
    		MaterialAutoID Int, 
    		PlantCode Nvarchar (100), 
    		TradeName Nvarchar (200), 
    		Suffix Nvarchar (10),
    		MinAutoID Int
    	)
    	
    	Insert into @MultiNameInfo (MaterialAutoID, PlantCode, TradeName)
    		Select MaterialInfo.AutoID, MaterialInfo.PlantName, LTrim(RTrim(Left(MaterialInfo.TradeName, 67)))
    		From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
    		Inner Join
    		(
    			Select MaterialInfo.PlantName, LTrim(RTrim(Left(MaterialInfo.TradeName, 67))) As TradeName
    			From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
    			Group By MaterialInfo.PlantName, LTrim(RTrim(Left(MaterialInfo.TradeName, 67)))
    			Having Count(*) > 1
    		) As MultiNameInfo
    		On	MaterialInfo.PlantName = MultiNameInfo.PlantName And
    			LTrim(RTrim(Left(MaterialInfo.TradeName, 67))) = MultiNameInfo.TradeName
    		Order By MaterialInfo.PlantName, LTrim(RTrim(Left(MaterialInfo.TradeName, 67))), MaterialInfo.AutoID
    		
    	Update MultiNameInfo
    		Set MultiNameInfo.MinAutoID = NameInfo.MinAutoID
    	From @MultiNameInfo As MultiNameInfo
    	Inner Join 
    	(
    		Select	MultiNameInfo.PlantCode, 
    				MultiNameInfo.TradeName,
    				Min(MultiNameInfo.AutoID) As MinAutoID
    		From @MultiNameInfo As MultiNameInfo
    		Group By MultiNameInfo.PlantCode, MultiNameInfo.TradeName
    	) As NameInfo
    	On	MultiNameInfo.PlantCode = NameInfo.PlantCode And
    		MultiNameInfo.TradeName = NameInfo.TradeName
    		
    	Update MultiNameInfo
    		Set MultiNameInfo.Suffix = '_' + Right('00' + Cast(MultiNameInfo.AutoID - MultiNameInfo.MinAutoID + 1 As Nvarchar), 2)
    	From @MultiNameInfo As MultiNameInfo    	
    	
    	Update MaterialInfo
    		Set MaterialInfo.TradeName = LTrim(RTrim(MultiNameInfo.TradeName)) + Ltrim(Rtrim(MultiNameInfo.Suffix))
    	From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
    	Inner Join @MultiNameInfo As MultiNameInfo
    	On MaterialInfo.AutoID = MultiNameInfo.MaterialAutoID
    End
End
Go

