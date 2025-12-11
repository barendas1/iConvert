If ObjectProperty(Object_ID(N'[dbo].[ACIBatchViewDetails]'), N'IsUserTable') = 1
Begin
	Declare @ErrorMessage Nvarchar (Max)
	Declare @ErrorSeverity Int
	
	Begin Try
		Begin Transaction
		
		If dbo.Validation_StoredProcedureExists('MixImport_ImportItemCategories') = 1
		Begin
			Raiserror('', 0, 0) With Nowait
			Raiserror('Import Item Categories', 0, 0) With Nowait
			
			Exec dbo.MixImport_ImportItemCategories
		End
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
		If dbo.Validation_StoredProcedureExists('MixImport_ImportMixes') = 1
		Begin
			Raiserror('', 0, 0) With Nowait
			Raiserror('Import Mixes', 0, 0) With Nowait
			
			Exec dbo.MixImport_ImportMixes
		End

		If dbo.Validation_StoredProcedureExists('MixImport_ImportMixes') = 1
		Begin
			Raiserror('', 0, 0) With Nowait
			Raiserror('Add Mix Classes', 0, 0) With Nowait
			
			Insert into dbo.ClassDefinitions
			(
				-- ClassDefID -- this column value is auto-generated
				Name,
				[Description]
			)
			Select MixClassInfo.MixClass, Null
			From
			(
				Select 'MIX_M' As MixClass
				Union All
				Select 'SAP' As MixClass
			) As MixClassInfo
			Left Join dbo.ClassDefinitions As ClassDef
			On MixClassInfo.MixClass = ClassDef.Name
			Where ClassDef.ClassDefID Is Null
			Order By MixClassInfo.MixClass

			Raiserror('', 0, 0) With Nowait
			Raiserror('Add Mix Classes To Mixes', 0, 0) With Nowait
			
			Insert into dbo.MixClassDefinitions
			(
				ClassDefLink,
				MixLink
			)
			Select ClassDef.ClassDefID, Mix.BATCHIDENTIFIER
			From dbo.Plants As Plants
			Inner Join dbo.BATCH As Mix
			On Mix.Plant_Link = Plants.PlantId
			Inner Join dbo.Name As MixName
			On MixName.NameID = Mix.NameID
			Inner Join
			(
				Select MixInfo.PlantCode, MixInfo.MixCode
				From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
				Group By MixInfo.PlantCode, MixInfo.MixCode
			) As MixInfo
			On  Plants.Name = MixInfo.PlantCode And
			    MixName.Name = MixInfo.MixCode
			Cross Join dbo.ClassDefinitions As ClassDef
			Left Join dbo.MixClassDefinitions As MixClassDef
			On  MixClassDef.MixLink = Mix.BATCHIDENTIFIER And
			    MixClassDef.ClassDefLink = ClassDef.ClassDefID
			Where   MixClassDef.ClassDefLink Is Null And
			        ClassDef.Name In ('SAP', 'MIX_M')
			Order By Plants.Name, MixName.Name, ClassDef.Name
		End
		
		Commit Transaction
	    
		Raiserror('', 0, 0) With Nowait
		Raiserror('The Item Categories, Plants, Materials, and Mixes may have been imported.', 0, 0) With Nowait
	End Try
	Begin catch
		If @@TRANCOUNT > 0
		Begin
			Rollback Transaction
		End

		Select	@ErrorMessage = Error_message(),
				@ErrorSeverity = Error_severity()

		Print ''
		Print 'The Item Categories, Plants, Materials, and/or Mixes could not be imported.  The Import was rolled back.'
		Print 'Error Message - ' + @ErrorMessage
		Print 'Error Severity - ' + Cast(@ErrorSeverity As Nvarchar)
	End Catch
End
