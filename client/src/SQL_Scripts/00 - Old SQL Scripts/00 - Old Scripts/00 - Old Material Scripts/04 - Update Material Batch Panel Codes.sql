If	Db_name() In ('Sonag_RJ_', 'Sonag_') And
	Exists (Select * From Sys.databases As Databases Where Databases.name = 'Data_Import_RJ')
Begin
	If ObjectProperty(Object_ID(N'[dbo].[ACIBatchViewDetails]'), N'IsUserTable') = 1 
	Begin
        Declare @NewLine Nvarchar (10)
	
        Declare @ErrorNumber Int
        Declare @ErrorMessage Nvarchar (Max)
        Declare @ErrorSeverity Int
        Declare @ErrorState Int
		
        Set @NewLine = dbo.GetNewLine()

        --Set Nocount On

        Begin try
	        Begin Transaction
	
	    	/*
	    	RaisError('', 0, 0) With Nowait
	    	RaisError('', 0, 0) With Nowait
	    	
	    	*/

	    	RaisError('', 0, 0) With Nowait
	    	RaisError('Update Material Batch Panel Codes', 0, 0) With Nowait

	    	RaisError('', 0, 0) With Nowait
	    	RaisError('Format the Material Information', 0, 0) With Nowait

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

	    	RaisError('', 0, 0) With Nowait
	    	RaisError('Add New Material Batch Panel Codes.', 0, 0) With Nowait

            Insert into dbo.Name
            (
            	-- NameID -- this column value is auto-generated
            	Name,
            	MaterialTypeID,
            	NameType
            )
            Select MaterialInfo.BatchPanelCode, Min(ItemName.MaterialTypeID), 'MtrlBatchCode'
            From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
            Inner Join dbo.Plants As Plants
            On MaterialInfo.PlantName = Plants.Name
            Inner Join dbo.Name As ItemName
            On MaterialInfo.ItemCode = ItemName.Name
            Inner Join dbo.ItemMaster As ItemMaster
            On ItemMaster.NameID = ItemName.NameID
            Inner Join dbo.MATERIAL As Material
            On  Material.PlantID = Plants.PlantId And
                Material.ItemMasterID = ItemMaster.ItemMasterID
            Left Join dbo.Name As PanelName
            On MaterialInfo.BatchPanelCode = PanelName.Name
            Where PanelName.NameID Is Null And Isnull(MaterialInfo.BatchPanelCode, '') <> ''
            Group By MaterialInfo.BatchPanelCode

	    	RaisError('', 0, 0) With Nowait
	    	RaisError('Update the Material Batch Panel Codes.', 0, 0) With Nowait

            Update Material
                Set Material.BatchPanelNameID = PanelCode.NameID
            From dbo.Material As Material
            Inner Join dbo.ItemMaster As ItemMaster
            On ItemMaster.ItemMasterID = Material.ItemMasterID
            Inner Join dbo.Name As ItemName
            On ItemName.NameID = ItemMaster.NameID
            Inner Join dbo.Plants As Plants
            On Plants.PlantId = Material.PlantID
            Inner Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
            On  Plants.Name = MaterialInfo.PlantName And
                ItemName.Name = MaterialInfo.ItemCode
            Inner Join dbo.Name As PanelCode
            On MaterialInfo.BatchPanelCode = PanelCode.Name            
	
	        Raiserror('', 0, 0) With Nowait
	        Raiserror('Stop Transaction.', 18, 1) With Nowait
	        
	        Commit Transaction
	
	        RaisError('', 0, 0) With Nowait
	        RaisError('The Material Batch Panel Codes may have been updated.', 0, 0) With Nowait
	
        End Try
        Begin catch
            If @@TRANCOUNT > 0
            Begin
	            Rollback Transaction
				
	            Raiserror('', 0, 0) With Nowait
	            Raiserror('The Transaction was rolled back.', 0, 0) With Nowait
            End
	    
            Select  @ErrorNumber  = Error_number(),
		            @ErrorSeverity = Error_severity(),
		            @ErrorState = Error_state(),
		            @ErrorMessage  = Error_message()

            Set @ErrorMessage = --@NewLine +
	            '   Error Number: ' + Cast(Isnull(@ErrorNumber, -1) As Nvarchar) + '.  ' + @NewLine +
	            '   Error Severity: ' + Cast(Isnull(@ErrorSeverity, -1) As Nvarchar) + '.  ' + @NewLine +
	            '   Error State: ' + Cast(Isnull(@ErrorState, -1) As Nvarchar) + '.  ' + @NewLine +
	            '   Error Message: ' + Isnull(@ErrorMessage, '') + @NewLine
	    
            Raiserror('', 0, 0) With Nowait
            Raiserror('The Material Batch Panel Codes could not be updated.  Transaction Rolled Back.', 0, 0)
            Print @ErrorMessage
	 
	        --Raiserror(@ErrorMessage, @ErrorSeverity, 1)
        End Catch
	End
End
