If ObjectProperty(Object_ID(N'[dbo].[ACIBatchViewDetails]'), N'IsUserTable') = 1
Begin
	Declare @NewLine Nvarchar (10)
	
	Declare @ErrorNumber Int
	Declare @ErrorMessage Nvarchar (Max)
	Declare @ErrorSeverity Int
	Declare @ErrorState Int
	
	Set @NewLine = dbo.GetNewLine()
	
	Begin Try
		Begin Transaction
		
		/*
		If dbo.Validation_StoredProcedureExists('MixImport_ImportItemCategories') = 1
		Begin
			Raiserror('', 0, 0) With Nowait
			Raiserror('Import Item Categories', 0, 0) With Nowait
			
			Exec dbo.MixImport_ImportItemCategories
		End
		*/
		/*
		If dbo.Validation_StoredProcedureExists('MixImport_ImportPlants') = 1
		Begin
			Raiserror('', 0, 0) With Nowait
			Raiserror('Import Plants', 0, 0) With Nowait
			
			Exec dbo.MixImport_ImportPlants
		End
		
		If dbo.Validation_StoredProcedureExists('MixImport_ImportMaterials') = 1
		Begin
			Raiserror('', 0, 0) With Nowait
			Raiserror('Import Materials', 0, 0) With Nowait
			
			Exec dbo.MixImport_ImportMaterials
		End
		*/
		If dbo.Validation_StoredProcedureExists('MixImport_UpdateMixRecipes') = 1
		Begin
			Raiserror('', 0, 0) With Nowait
			Raiserror('Update Mix Recipes', 0, 0) With Nowait
			
			Exec dbo.MixImport_UpdateMixRecipes
		End
		
		Commit Transaction
	    
		Raiserror('', 0, 0) With Nowait
		Raiserror('The Mix Recipes may have been updated.', 0, 0) With Nowait
	End Try
	Begin catch
		If @@TRANCOUNT > 0
		Begin
			Rollback Transaction
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
	    
		Raiserror('', 0, 0) With NoWait 
		Raiserror('The Mix Recipes could not be updated.  The Transaction was rolled back.', 0, 0) With NoWait
		Print @ErrorMessage
	End Catch
End
