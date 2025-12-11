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
	If Db_name() In ('Sonag_RJ_', 'KansasReadyMix_', '')
	Begin
		If dbo.Validation_StoredProcedureExists('MixMaintenance_RemoveMixesByMixIDTempTable') = 1 
		Begin
			Declare @ErrorMessage Nvarchar(Max)
			Declare @ErrorSeverity Int

			If dbo.Validation_TemporaryTableExists('#MixInfo') = 1
			Begin
				Drop table #MixInfo
			End

			Create table #MixInfo
			(
				AutoID Int Identity (1, 1),
				MixID Int,
				Primary Key Clustered
				(
					MixID
				)
			)
			
			Begin Try
				Begin Transaction

				Raiserror('', 0, 0) With Nowait
				Raiserror('Retrieve Mixes That Will Be Deleted.', 0, 0) With Nowait

				Insert into #MixInfo (MixID)
					Select Mix.BATCHIDENTIFIER
					From dbo.Batch As Mix
					Where Mix.NameID Is Not Null

				Raiserror('', 0, 0) With Nowait
				Raiserror('Remove Mixes, Batches, Etc.', 0, 0) With Nowait
				
				Exec [dbo].[MixMaintenance_RemoveMixesByMixIDTempTable] '#MixInfo', 'MixID', 1, 1, 1
				
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
				Raiserror('The Mixes, Batches, Etc. were removed.', 0, 0) With Nowait
			End Try
			Begin Catch
				If @@TranCount > 0
				Begin
					Rollback Transaction
				End
		        
				Select  @ErrorMessage = Error_message(),
						@ErrorSeverity = Error_severity()
						
				Raiserror('', 0, 0) With Nowait
				Raiserror('Failed to remove the Mixes, Batches, Etc.  Transaction Rolled Back.', 0, 0) With Nowait
				Print 'Error Message: ' + @ErrorMessage + '. Error Severity: ' + Cast(@ErrorSeverity As Nvarchar)
			End Catch

			If dbo.Validation_TemporaryTableExists('#MixInfo') = 1
			Begin
				Drop table #MixInfo
			End
		End
	End
End
Go
