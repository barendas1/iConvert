If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo')
    Begin
    	Declare @UpdateWaterSpecGrav Bit = 0 
    	
		Update MaterialInfo
			Set MaterialInfo.PlantName = LTrim(RTrim(Replace(MaterialInfo.PlantName, Char(160), ' '))),
				MaterialInfo.TradeName = LTrim(RTrim(Replace(MaterialInfo.TradeName, Char(160), ' '))),
				MaterialInfo.MaterialDate = LTrim(RTrim(Replace(MaterialInfo.MaterialDate, Char(160), ' '))),
				MaterialInfo.FamilyMaterialTypeName = LTrim(RTrim(Replace(MaterialInfo.FamilyMaterialTypeName, Char(160), ' '))),
				MaterialInfo.MaterialTypeName = LTrim(RTrim(Replace(MaterialInfo.MaterialTypeName, Char(160), ' '))),
				MaterialInfo.IsLiquidAdmix = LTrim(RTrim(Replace(MaterialInfo.IsLiquidAdmix, Char(160), ' '))),
				MaterialInfo.CostUnitName = LTrim(RTrim(Replace(MaterialInfo.CostUnitName, Char(160), ' '))),
				MaterialInfo.ManufacturerName = LTrim(RTrim(Replace(MaterialInfo.ManufacturerName, Char(160), ' '))),
				MaterialInfo.ManufacturerSourceName = LTrim(RTrim(Replace(MaterialInfo.ManufacturerSourceName, Char(160), ' '))),
				MaterialInfo.BatchingOrderNumber = LTrim(RTrim(Replace(MaterialInfo.BatchingOrderNumber, Char(160), ' '))),
				MaterialInfo.ItemCode = LTrim(RTrim(Replace(MaterialInfo.ItemCode, Char(160), ' '))),
				MaterialInfo.ItemDescription = LTrim(RTrim(Replace(MaterialInfo.ItemDescription, Char(160), ' '))),
				MaterialInfo.ItemShortDescription = LTrim(RTrim(Replace(MaterialInfo.ItemShortDescription, Char(160), ' '))),
				MaterialInfo.ItemCategoryName = LTrim(RTrim(Replace(MaterialInfo.ItemCategoryName, Char(160), ' '))),
				MaterialInfo.ItemCategoryDescription = LTrim(RTrim(Replace(MaterialInfo.ItemCategoryDescription, Char(160), ' '))),
				MaterialInfo.ItemCategoryShortDescription = LTrim(RTrim(Replace(MaterialInfo.ItemCategoryShortDescription, Char(160), ' '))),
				MaterialInfo.ComponentCategoryName = LTrim(RTrim(Replace(MaterialInfo.ComponentCategoryName, Char(160), ' '))),
				MaterialInfo.ComponentCategoryDescription = LTrim(RTrim(Replace(MaterialInfo.ComponentCategoryDescription, Char(160), ' '))),
				MaterialInfo.ComponentCategoryShortDescription = LTrim(RTrim(Replace(MaterialInfo.ComponentCategoryShortDescription, Char(160), ' '))),
				MaterialInfo.BatchPanelCode = LTrim(RTrim(Replace(MaterialInfo.BatchPanelCode, Char(160), ' ')))
		From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo

		Update MaterialInfo
			Set MaterialInfo.FamilyMaterialTypeName = 'Admixture & Fiber'
		From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
		Where Isnull(MaterialInfo.FamilyMaterialTypeName, '') = 'AdmixtureFiber'
		
		Update MaterialInfo
			Set MaterialInfo.SpecificGravity = 
			        Case 
			            When Isnull(MaterialInfo.SpecificGravity, -1.0) <= 0.4 Or Isnull(@UpdateWaterSpecGrav, 0) = 1 
			            Then 0.9982 
			            Else MaterialInfo.SpecificGravity 
			        End,
			    MaterialInfo.IsLiquidAdmix = 'No'
		From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
		Where Isnull(MaterialInfo.FamilyMaterialTypeName, '') = 'Water'

		Update MaterialInfo
		    Set MaterialInfo.TradeName = MaterialInfo.ItemCode
		From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
		Inner Join 
		(
			Select MaterialInfo2.PlantName, MaterialInfo2.TradeName, Min(MaterialInfo2.AutoID) As AutoID
			From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo2
			Group By MaterialInfo2.PlantName, MaterialInfo2.TradeName
			Having Count(*) > 1			
		) As MultTradeNameInfo
		On  MaterialInfo.PlantName = MultTradeNameInfo.PlantName And 
		    MaterialInfo.TradeName = MultTradeNameInfo.TradeName
		Where   MaterialInfo.AutoID <> MultTradeNameInfo.AutoID And
		        Isnull(MaterialInfo.TradeName, '') <> Isnull(MaterialInfo.ItemCode, '')

		Update MaterialInfo
		    Set MaterialInfo.TradeName = MaterialInfo.ItemCode
		From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
		Inner Join 
		(
			Select MaterialInfo2.PlantName, MaterialInfo2.TradeName, Max(MaterialInfo2.AutoID) As AutoID
			From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo2
			Group By MaterialInfo2.PlantName, MaterialInfo2.TradeName
			Having Count(*) > 1			
		) As MultTradeNameInfo
		On  MaterialInfo.PlantName = MultTradeNameInfo.PlantName And 
		    MaterialInfo.TradeName = MultTradeNameInfo.TradeName
		Where   MaterialInfo.AutoID <> MultTradeNameInfo.AutoID And
		        Isnull(MaterialInfo.TradeName, '') <> Isnull(MaterialInfo.ItemCode, '')
		
		Select *
		From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
		Inner Join 
		(
			Select MaterialInfo2.PlantName, MaterialInfo2.TradeName, Min(MaterialInfo2.AutoID) As AutoID
			From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo2
			Group By MaterialInfo2.PlantName, MaterialInfo2.TradeName
			Having Count(*) > 1			
		) As MultTradeNameInfo
		On  MaterialInfo.PlantName = MultTradeNameInfo.PlantName And 
		    MaterialInfo.TradeName = MultTradeNameInfo.TradeName
    End
End
Go
