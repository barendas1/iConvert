/*
	Remove Stored Procedures to remove Mixes and Batches and Batch Specimens from the database.

	This script is only for User Quadrel Databases, not iServiceDataExchange.
*/
--Remove Stored Procedures to remove Mixes and Batches and Batch Specimens from the database.  This script is only for User Quadrel Databases, not iServiceDataExchange.
If ObjectProperty(Object_ID(N'[dbo].[ACIBatchViewDetails]'), N'IsUserTable') = 1
Begin
	If Not Exists (Select ScriptID From [dbo].[DBState] Where ScriptID = 1275)
	Begin
		Insert Into [dbo].[DBState] (ScriptID, ScriptName, ReleaseName, DateCreated, DateApplied, ScriptDescription) 
		    Values (1275, '1275 - Remove Stored Procedures To Remove Mixes And Batches And Batch Specimens.sql', 'International_Release', Convert(Datetime, '03/08/2012', 101), Current_TimeStamp, 'Remove Stored Procedures to remove Mixes and Batches and Batch Specimens from the database.  This script is only for User Quadrel Databases, not iServiceDataExchange.')
	End
End
Go

If  Objectproperty(Object_id(N'[dbo].[BatchSpecimen_RemoveAllSpecimensByBatchIDTempTable]'), N'IsProcedure') = 1
Begin
    Drop Procedure [dbo].[BatchSpecimen_RemoveAllSpecimensByBatchIDTempTable]
End
Go

If ObjectProperty(Object_ID(N'[dbo].[BatchMaintenance_RemoveBatchesByBatchIDTempTable]'), N'IsProcedure') = 1 
Begin
    Drop Procedure [dbo].[BatchMaintenance_RemoveBatchesByBatchIDTempTable]
End
Go

If ObjectProperty(Object_ID(N'[dbo].[MixMaintenance_RemoveMixesByMixIDTempTable]'), N'IsProcedure') = 1 
Begin
    Drop Procedure [dbo].[MixMaintenance_RemoveMixesByMixIDTempTable]
End
Go

If dbo.Validation_StoredProcedureExists('Utility_PrintMessage') = 1
Begin
	Drop procedure [dbo].[Utility_PrintMessage]
End
Go
