/*
	Remove a stored procedure to remove the mixes, batches, materials, aggregates, aggregate samples, aggregate stockpiles,
	aggregate measurement sets, aggregate gradings, aggregate specifications, aggregate composite recipes, tests, and submittals
	for the specified or implied plants.
	Test aggregate entities that did not have items in them at the time the script was written.
	This script is only for User Quadrel Databases, not iServiceDataExchange.
*/
--Remove a stored procedure to remove the mixes, batches, materials, aggregates, aggregate samples, aggregate stockpiles, aggregate measurement sets, aggregate gradings, aggregate specifications, aggregate composite recipes, tests, and submittals for the specified or implied plants.  Test aggregate entities that did not have items in them at the time the script was written.  This script is only for User Quadrel Databases, not iServiceDataExchange.
If ObjectProperty(Object_ID(N'[dbo].[ACIBatchViewDetails]'), N'IsUserTable') = 1
Begin
	If Not Exists (Select ScriptID From [dbo].[DBState] Where ScriptID = 710)
	Begin
		Insert Into [dbo].[DBState] (ScriptID, ScriptName, ReleaseName, DateCreated, DateApplied, ScriptDescription) 
		Values (710, '710 - Remove Plant, Mix, Batch, Materials, etc Removal Procedure.sql', 'R070710', '10/10/2008', Current_TimeStamp, 'Remove a stored procedure to remove the mixes, batches, materials, aggregates, aggregate samples, aggregate stockpiles, aggregate measurement sets, aggregate gradings, aggregate specifications, aggregate composite recipes, tests, and submittals for the specified or implied plants.  Test aggregate entities that did not have items in them at the time the script was written.  This script is only for User Quadrel Databases, not iServiceDataExchange.')
	End
End
Go

If ObjectProperty(Object_ID(N'[dbo].[ACIBatchViewDetails]'), N'IsUserTable') = 1
Begin
	If dbo.Validation_StoredProcedureExists('qsp_RemovePlantData') = 1
	Begin
		Drop Procedure [dbo].[qsp_RemovePlantData]
	End
End
Go

