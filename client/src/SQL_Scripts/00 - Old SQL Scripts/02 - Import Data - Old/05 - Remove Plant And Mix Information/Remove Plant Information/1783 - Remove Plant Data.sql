/*
	Run a stored procedure to remove the mixes, batches, materials, aggregates, aggregate samples, aggregate stockpiles,
	aggregate measurement sets, aggregate gradings, aggregate specifications, aggregate composite recipes, tests, and submittals
	for Holcim GLR Plants.
	Test aggregate entities that did not have items in them at the time the script was written.

	This script is only for User Quadrel Databases, not iServiceDataExchange.
*/
--Run a stored procedure to remove the mixes, batches, materials, aggregates, aggregate samples, aggregate stockpiles, aggregate measurement sets, aggregate gradings, aggregate specifications, aggregate composite recipes, tests, and submittals  for Holcim GLR Plants.  Test aggregate entities that did not have items in them at the time the script was written.  This script is only for User Quadrel Databases, not iServiceDataExchange.
If ObjectProperty(Object_ID(N'[dbo].[ACIBatchViewDetails]'), N'IsUserTable') = 1
Begin
	If Not Exists (Select ScriptID From [dbo].[DBState] Where ScriptID = 1783)
	Begin
		Insert Into [dbo].[DBState] (ScriptID, ScriptName, ReleaseName, DateCreated, DateApplied, ScriptDescription) 
			Values (1783, '1783 - Remove Plant Data.sql', 'G2-200', Convert(Datetime, '02/09/2016', 101), Current_TimeStamp, 'Run a stored procedure to remove the mixes, batches, materials, aggregates, aggregate samples, aggregate stockpiles, aggregate measurement sets, aggregate gradings, aggregate specifications, aggregate composite recipes, tests, and submittals for Holcim GLR Plants.  Test aggregate entities that did not have items in them at the time the script was written.  This script is only for User Quadrel Databases, not iServiceDataExchange.')
	End
End
Go

If ObjectProperty(Object_ID(N'[dbo].[ACIBatchViewDetails]'), N'IsUserTable') = 1
Begin
	If Db_name() In ('', '', '', '')
	Begin
		If dbo.Validation_StoredProcedureExists('qsp_RemovePlantData') = 1 
		Begin
			Declare @ErrorMessage Nvarchar(Max)
			Declare @ErrorSeverity Int

			If dbo.Validation_TemporaryTableExists('#PlantInfo') = 1
			Begin
				Drop table #PlantInfo
			End

			Create table #PlantInfo
			(
				AutoID Int Identity (1, 1),
				PlantID Int,
				Name Nvarchar (100),
				Primary Key Clustered
				(
					PlantID
				)
			)
			
			Begin Try
				Begin Transaction

				Raiserror('', 0, 0) With Nowait
				Raiserror('Retrieve Plants That Will Be Deleted.', 0, 0) With Nowait

				Insert into #PlantInfo (PlantID, Name)
					Select Plant.PLANTIDENTIFIER, Plant.PLNTNAME
					From dbo.PLANT As Plant
					Where	Plant.PlntName In 
							(
								Select LTrim(RTrim(MaterialInfo.PlantName))
								From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
								Group By LTrim(RTrim(MaterialInfo.PlantName))
							)
					Order By Plant.PlntName

				Raiserror('', 0, 0) With Nowait
				Raiserror('Retrieve Yard That Will Be Deleted.', 0, 0) With Nowait

				Insert into #PlantInfo
				(
					-- AutoID -- this column value is auto-generated
					PlantID,
					Name
				)
				Select Yards.PlantId, Yards.Name
				From dbo.Plants As Yards
				Inner Join dbo.Plants As Plants
				On Yards.PlantId = Plants.PlantIdForYard
				Inner Join #PlantInfo As PlantInfo
				On Plants.PlantId = PlantInfo.PlantID
				Left Join #PlantInfo As YardInfo
				On Yards.PlantId = YardInfo.PlantID
				Left Join
				(
					Select Yards.PlantId, Yards.Name
					From dbo.Plants As Yards
					Inner Join dbo.Plants As Plants
					On Yards.PlantId = Plants.PlantIdForYard
					Left Join #PlantInfo As PlantInfo
					On Plants.PlantId = PlantInfo.PlantID
					Where PlantInfo.AutoID Is Null
					Group By Yards.PlantId, Yards.Name
				) As MultiPlantYards
				On Yards.PlantId = MultiPlantYards.PlantID
				Where YardInfo.AutoID Is Null And MultiPlantYards.PlantID Is Null 
				Group By Yards.PlantId, Yards.Name
				Order By Yards.Name

				Raiserror('', 0, 0) With Nowait
				Raiserror('Show Yards And Plants That Will Have Data Removed From Them', 0, 0) With Nowait
				
				Select * 
				From #PlantInfo
				Order By AutoID
					
				Raiserror('', 0, 0) With Nowait
				Raiserror('Remove Plants, Mixes, Batches, Materials, etc.', 0, 0) With Nowait
				
				Exec dbo.qsp_RemovePlantData '', '', '#PlantInfo', 'PlantID', 0
				
				Raiserror('', 0, 0) With Nowait
				Raiserror('Delete Production Items Not Linked To Materials Or Mixes.', 0, 0) With Nowait

				Delete ItemMaster
				From dbo.ItemMaster As ItemMaster
				Left Join dbo.Batch As Mix
				On Mix.ItemMasterID = ItemMaster.ItemMasterID
				Left Join dbo.MATERIAL As Material
				On Material.ItemMasterID = ItemMaster.ItemMasterID
				Where	Mix.BATCHIDENTIFIER Is Null And
						Material.MATERIALIDENTIFIER Is Null

				Commit Transaction
				
				Raiserror('', 0, 0) With Nowait
				Raiserror('The Plants, Mixes, Batches, Materials, etc. were removed.', 0, 0) With Nowait
			End Try
			Begin Catch
				If @@TranCount > 0
				Begin
					Rollback Transaction
				End
		        
				Select  @ErrorMessage = Error_message(),
						@ErrorSeverity = Error_severity()
						
				Raiserror('', 0, 0) With Nowait
				Raiserror('Failed to remove the Plants, Mixes, Batches, Materials, etc.  Transaction Rolled Back.', 0, 0) With Nowait
				Print 'Error Message: ' + @ErrorMessage + '. Error Severity: ' + Cast(@ErrorSeverity As Nvarchar)
			End Catch

			If dbo.Validation_TemporaryTableExists('#PlantInfo') = 1
			Begin
				Drop table #PlantInfo
			End
		End
	End
End
Go
