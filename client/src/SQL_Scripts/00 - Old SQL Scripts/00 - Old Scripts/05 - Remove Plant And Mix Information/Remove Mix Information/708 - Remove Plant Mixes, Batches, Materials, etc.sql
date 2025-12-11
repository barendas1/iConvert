/*
	Create a stored procedure to remove the mixes, batches, materials, aggregates, aggregate samples, aggregate stockpiles,
	aggregate measurement sets, aggregate gradings, aggregate specifications, aggregate composite recipes, tests, and submittals 
	for the specified or implied plants.
	Test aggregate entities that did not have items in them at the time the script was written.
	This script is only for User Quadrel Databases, not iServiceDataExchange.
*/
--Create a stored procedure to remove the mixes, batches, materials, aggregates, aggregate samples, aggregate stockpiles, aggregate measurement sets, aggregate gradings, aggregate specifications, aggregate composite recipes, tests, and submittals for the specified or implied plants.  Test aggregate entities that did not have items in them at the time the script was written.  This script is only for User Quadrel Databases, not iServiceDataExchange.
If ObjectProperty(Object_ID(N'[dbo].[ACIBatchViewDetails]'), N'IsUserTable') = 1
Begin
	If Not Exists (Select ScriptID From [dbo].[DBState] Where ScriptID = 708)
	Begin
		Insert Into [dbo].[DBState] (ScriptID, ScriptName, ReleaseName, DateCreated, DateApplied, ScriptDescription) 
		Values (708, '708 - Remove Plant Mixes, Batches, Materials, etc.sql', 'R070710', '10/10/2008', Current_TimeStamp, 'Create a stored procedure to remove the mixes, batches, materials, aggregates, aggregate samples, aggregate stockpiles, aggregate measurement sets, aggregate gradings, aggregate specifications, aggregate composite recipes, tests, and submittals for the specified or implied plants.  Test aggregate entities that did not have items in them at the time the script was written.  This script is only for User Quadrel Databases, not iServiceDataExchange.')
	End
End
Go

If dbo.Validation_StoredProcedureExists('qsp_RemovePlantData') = 1
Begin
    Drop Procedure [dbo].[qsp_RemovePlantData]
End
Go

Create Procedure [dbo].[qsp_RemovePlantData] 
(
	@KeepPlantsTempTable NVarChar (50), 
	@KeepPlantIDFieldName NVarChar(50), 
	@RemovePlantsTempTable NVarChar (50), 
	@RemovePlantIDFieldName NVarChar (50),
	@RemovePlants Bit
) 
As
Begin
/*
	Remove the Districts, Plants, Mixes, Batches, Materials, aggregates, aggregate samples, aggregate stockpiles,
	aggregate measurement sets, aggregate gradings, aggregate specifications, aggregate composite recipes, and Tests
	that are in the Plant List.
	Test aggregate entities that did not have items in them at the time the script was written.
*/

	--Declare @KeepPlantsTempTable NVarChar (50)
	--Declare @KeepPlantIDFieldName NVarChar (50)
	--Declare @RemovePlantsTempTable NVarChar (50)
	--Declare @RemovePlantIDFieldName NVarChar (50)

	--Set @KeepPlantsTempTable = '#KeepPlantIDs'
	--Set @KeepPlantIDFieldName = 'ID'
	--Set @RemovePlantsTempTable = '#RemovePlantIDs'
	--Set @RemovePlantIDFieldName = 'ID'

	--Set @KeepPlantsTempTable = ''
	--Set @KeepPlantIDFieldName = ''
	--Set @RemovePlantsTempTable = ''
	--Set @RemovePlantIDFieldName = ''

	/*
	If Object_ID('TempDB..#KeepPlantIDs') Is Not Null
	Begin
		Drop Table [dbo].[#KeepPlantIDs]
	End 

	Create Table [dbo].[#KeepPlantIDs]
	(
		ID Int Null
	)
	*/

	/*
	Insert Into [dbo].[#KeepPlantIDs] (ID)
	Select Plant.PlantIdentifier
	From [dbo].[Plant]
	*/

	/*
	If Object_ID('TempDB..#RemovePlantIDs') Is Not Null
	Begin
		Drop Table [dbo].[#RemovePlantIDs]
	End 

	Create Table [dbo].[#RemovePlantIDs]
	(
		ID Int Null
	)
	*/

	Declare @KeepTempTable NVarChar (50)
	Declare @KeepIDField NVarChar (50)
	Declare @RemoveTempTable NVarChar (50)
	Declare @RemoveIDField NVarChar (50)
	Declare @ErrorMessage   Nvarchar(Max)
	Declare @ErrorSeverity  Int

	Set @KeepTempTable = LTrim(RTrim(@KeepPlantsTempTable))
	Set @KeepIDField = LTrim(RTrim(@KeepPlantIDFieldName))
	Set @RemoveTempTable = LTrim(RTrim(@RemovePlantsTempTable))
	Set @RemoveIDField = LTrim(RTrim(@RemovePlantIDFieldName))
	
	Set @RemovePlants = Isnull(@RemovePlants, 1)
	
	Begin Try
		Begin Transaction
	
		If Object_ID('TempDB..#PlantIDs') Is Not Null
		Begin
			Drop Table [dbo].[#PlantIDs]
		End 
	
		If Object_ID('TempDB..#UnDelPlantIDs') Is Not Null
		Begin
			Drop Table [dbo].[#UnDelPlantIDs]
		End 
	
		If Object_ID('TempDB..#DistrictIDs') Is Not Null
		Begin
			Drop Table [dbo].[#DistrictIDs]
		End 
	
		If Object_ID('TempDB..#BatchIDs') Is Not Null
		Begin
			Drop Table [dbo].[#BatchIDs]
		End 
	
		If Object_ID('TempDB..#MixIDs') Is Not Null
		Begin
			Drop Table [dbo].[#MixIDs]
		End 
	
		If Object_ID('TempDB..#MixSpecIDs') Is Not Null
		Begin
			Drop Table [dbo].[#MixSpecIDs]
		End 
	
		If Object_ID('TempDB..#ContractMixSpecIDs') Is Not Null
		Begin
			Drop Table [dbo].[#ContractMixSpecIDs]
		End 
	
		If Object_ID('TempDB..#MixSpecIDs') Is Not Null
		Begin
			Drop Table [dbo].[#BatchIDs]
		End 
	
		If Object_ID('TempDB..#GradingIDs') Is Not Null
		Begin
			Drop Table [dbo].[#GradingIDs]
		End 
	
		If Object_ID('TempDB..#BackupDataIDs') Is Not Null
		Begin
			Drop Table [dbo].[#BackupDataIDs]
		End 
	
		If Object_ID('TempDB..#SubmittalIDs') Is Not Null
		Begin
			Drop Table [dbo].[#SubmittalIDs]
		End 
	
		If Object_ID('TempDB..#SubmittalMixIDs') Is Not Null
		Begin
			Drop Table [dbo].[#SubmittalMixIDs]
		End 
	
		If Object_ID('TempDB..#SubMixGradingIDs') Is Not Null
		Begin
			Drop Table [dbo].[#SubMixGradingIDs]
		End 
	
		If Object_ID('TempDB..#BatchGroupIDs') Is Not Null
		Begin
			Drop Table [dbo].[#BatchGroupIDs]
		End 
	
		If Object_ID('TempDB..#AggregateIDs') Is Not Null
		Begin
			Drop Table [dbo].[#AggregateIDs]
		End 
	
		If Object_ID('TempDB..#AggSpecIDs') Is Not Null
		Begin
			Drop Table [dbo].[#AggSpecIDs]
		End 
	
		If Object_ID('TempDB..#AggSampleIDs') Is Not Null
		Begin
			Drop Table [dbo].[#AggSampleIDs]
		End 
	
		If Object_ID('TempDB..#AggMeasSetIDs') Is Not Null
		Begin
			Drop Table [dbo].[#AggMeasSetIDs]
		End 
	
		Create Table [dbo].[#PlantIDs]
		(
			ID Int Null,
			Code NVarChar (12),
			DistrictCode NVarChar (12)
		)
		
		Create Index IX_PlantIDs_ID On dbo.#PlantIDs (ID)
		Create Index IX_PlantIDs_Code On dbo.#PlantIDs (Code)
		Create Index IX_PlantIDs_DistrictCode On dbo.#PlantIDs (DistrictCode)
	
		Create Table [dbo].[#UnDelPlantIDs]
		(
			ID Int Null,
			Code NVarChar (12),
			DistrictCode NVarChar (12)
		)
		
		Create Index IX_UnDelPlantIDs_ID On dbo.#UnDelPlantIDs (ID)
		Create Index IX_UnDelPlantIDs_Code On dbo.#UnDelPlantIDs (Code)
		Create Index IX_UnDelPlantIDs_DistrictCode On dbo.#UnDelPlantIDs (DistrictCode)
	
		Create Table [dbo].[#DistrictIDs]
		(
			ID Int Null,
			Code NVarChar (12)
		)
		
		Create Index IX_DistrictIDs_ID On dbo.#DistrictIDs (ID)
		Create Index IX_DistrictIDs_Code On dbo.#DistrictIDs (Code)
	
		Create Table [dbo].[#MixSpecIDs]
		(
			ID Int Null
		)
		
		Create Index IX_MixSpecIDs_ID On dbo.#MixSpecIDs (ID)
	
		Create Table [dbo].[#ContractMixSpecIDs]
		(
			ID Int Null
		)
		
		Create Index IX_ContractMixSpecIDs_ID On dbo.#ContractMixSpecIDs (ID)
	
		Create Table [dbo].[#GradingIDs]
		(
			ID Int Null
		)
		
		Create Index IX_GradingIDs_ID On dbo.#GradingIDs (ID)
	
		Create Table [dbo].[#SubMixGradingIDs]
		(
			ID Int Null
		)
		
		Create Index IX_SubMixGradingIDs_ID On dbo.#SubMixGradingIDs (ID)
	
		Create Table [dbo].[#BackupDataIDs]
		(
			ID Int Null
		)
		
		Create Index IX_BackupDataIDs_ID On dbo.#BackupDataIDs (ID)
	
		Create Table [dbo].[#SubmittalIDs]
		(
			ID Int Null
		)
		
		Create Index IX_SubmittalIDs_ID On dbo.#SubmittalIDs (ID)
	
		Create Table [dbo].[#SubmittalMixIDs]
		(
			ID Int Null
		)
		
		Create Index IX_SubmittalMixIDs_ID On dbo.#SubmittalMixIDs (ID)
	
		Create Table [dbo].[#BatchIDs]
		(
			ID Int Null,
			Code NVarChar (12) Null,
			MixNameCode NVarChar (12) Null
		)
		
		Create Index IX_BatchIDs_ID On dbo.#BatchIDs (ID)
		Create Index IX_BatchIDs_Code On dbo.#BatchIDs (Code)
		Create Index IX_BatchIDs_MixNameCode On dbo.#BatchIDs (MixNameCode)
	
		Create Table [dbo].[#MixIDs]
		(
			ID Int Null,
			Code NVarChar (12) Null,
			MixNameCode NVarChar (12) Null
		)
		
		Create Index IX_MixIDs_ID On dbo.#MixIDs (ID)
		Create Index IX_MixIDs_Code On dbo.#MixIDs (Code)
		Create Index IX_MixIDs_MixNameCode On dbo.#MixIDs (MixNameCode)
		
		Create Table [dbo].[#BatchGroupIDs]
		(
			ID Int Null
		)
		
		Create Index IX_BatchGroupIDs_ID On dbo.#BatchGroupIDs (ID)
	
		Create Table [dbo].[#AggregateIDs]
		(
			ID Int Null
		)
		
		Create Index IX_AggregateIDs_ID On dbo.#AggregateIDs (ID)
	
		Create Table [dbo].[#AggSpecIDs]
		(
			ID Int Null
		)
		
		Create Index IX_AggSpecIDs_ID On dbo.#AggSpecIDs (ID)
	
		Create Table [dbo].[#AggSampleIDs]
		(
			ID Int Null
		)
		
		Create Index IX_AggSampleIDs_ID On dbo.#AggSampleIDs (ID)
	
		Create Table [dbo].[#AggMeasSetIDs]
		(
			ID Int Null
		)

		Create Index IX_AggMeasSetIDs_ID On dbo.#AggMeasSetIDs (ID)
	
		If @KeepTempTable <> '' And @KeepTempTable <> '#PlantIDs' And @KeepIDField <> ''
		Begin
			Raiserror('', 0, 0) With Nowait
			Raiserror('Retrieve Plants To Delete Using The Keep Plant List', 0, 0) With Nowait
			
			Exec
			(
				'Insert Into [dbo].[#PlantIDs] (ID, Code, DistrictCode)
				Select Plant.PlantIdentifier, Plant.PlntTag, Plant.RGCode
				From [dbo].[Plant]
				Left Join [dbo].[' + @KeepTempTable + ']
				On Plant.PlantIdentifier = ' + @KeepTempTable + '.' + @KeepIDField + ' ' +
				'Where ' + @KeepTempTable + '.' + @KeepIDField + ' Is Null'
			)
		End
		Else If @RemoveTempTable <> '' And @RemoveTempTable <> '#PlantIDs' And @RemoveIDField <> ''
		Begin
			Raiserror('', 0, 0) With Nowait
			Raiserror('Retrieve Plants To Delete Using The Remove Plant List', 0, 0) With Nowait
			
			Exec
			(
				'Insert Into [dbo].[#PlantIDs] (ID, Code, DistrictCode)
				Select Plant.PlantIdentifier, Plant.PlntTag, Plant.RGCode
				From [dbo].[Plant]
				Inner Join [dbo].[' + @RemoveTempTable + ']
				On Plant.PlantIdentifier = ' + @RemoveTempTable + '.' + @RemoveIDField
			)
		End

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Plants That Will Not Be Deleted', 0, 0) With Nowait
	
		Insert Into [dbo].[#UnDelPlantIDs] (ID, Code, DistrictCode)
		Select Plant.PlantIdentifier, Plant.PlntTag, Plant.RGCode
		From [dbo].[Plant]
		Left Join [dbo].[#PlantIDs]
		On Plant.PlantIdentifier = #PlantIDs.ID
		Where #PlantIDs.ID Is Null

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve District Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#DistrictIDs] (ID, Code)
		Select District.DistrictIdentifier, District.RGCode
		From [dbo].[District]
		Inner Join [dbo].[#PlantIDs]
		On District.RGCode = #PlantIDs.DistrictCode

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Mix Spec Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#MixSpecIDs] (ID)
		Select MixSpec.MixSpecID
		From [dbo].[MixSpec]
		Inner Join [dbo].[Batch]
		On MixSpec.MixSpecID = Batch.MixSpecID
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID
		Where MixSpec.Name Is Null Or LTrim(MixSpec.Name) = ''

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Grading Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#GradingIDs] (ID)
		Select SubmittalGradation.SubmittalGradationID
		From [dbo].[SubmittalGradation]
		Inner Join [dbo].[Batch]
		On SubmittalGradation.SubmittalGradationID = Batch.SubmittalGradationID
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Backup Data Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#BackupDataIDs] (ID)
		Select SubmittalBackup.SubmittalBackupID
		From [dbo].[SubmittalBackup]
		Inner Join [dbo].[Batch]
		On SubmittalBackup.SubmittalBackupID = Batch.BackupDataID
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Batch Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#BatchIDs] (ID, Code, MixNameCode)
		Select Batch.BatchIdentifier, Batch.Code, Batch.MixNameCode
		From [dbo].[Batch]
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID
		Where Batch.Mix = 'n'

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Mix Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#MixIDs] (ID, Code, MixNameCode)
		Select Batch.BatchIdentifier, Batch.Code, Batch.MixNameCode
		From [dbo].[Batch]
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID
		Where Batch.Mix = 'y'

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Contract Mix Spec Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#ContractMixSpecIDs] (ID)
		Select MixSpec.MixSpecID
		From [dbo].[MixSpec]
		Inner Join [dbo].[MixForContract]
		On MixSpec.MixSpecID = MixForContract.MixSpecID
		Inner Join [dbo].[#MixIDs]
		On MixForContract.MixID = #MixIDs.ID
		Where MixSpec.Name Is Null Or LTrim(MixSpec.Name) = ''

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Submittal Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#SubmittalIDs] (ID)
		Select Submittal.SubmittalID
		From
		(
			Select SubmittalNew.SubmittalID
			From [dbo].[SubmittalNew]
			Inner Join [dbo].[SubmittalMix]
			On SubmittalNew.SubmittalID = SubmittalMix.SubmittalID
			Inner Join [dbo].[#MixIDs]
			On SubmittalMix.MixID = #MixIDs.ID
		
			Union All
		
			Select SubmittalNew.SubmittalID
			From [dbo].[SubmittalNew]
			Inner Join [dbo].[SubmittalMix]
			On SubmittalNew.SubmittalID = SubmittalMix.SubmittalID
			Inner Join [dbo].[OnlySubmittalMix]
			On SubmittalMix.OnlySubmittalMixID = OnlySubmittalMix.OnlySubmittalMixID
			Inner Join [dbo].[#MixIDs]
			On OnlySubmittalMix.OriginalMixID = #MixIDs.ID
			Where SubmittalMix.MixID Is Null
		) As Submittal
		Group By Submittal.SubmittalID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Submittal Mix Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#SubmittalMixIDs] (ID)
		Select SubmittalMix.SubmittalMixID
		From
		(
			Select SubmittalMix.SubmittalMixID
			From [dbo].[SubmittalMix]
			Left Join [dbo].[#SubmittalIDs]
			On SubmittalMix.SubmittalID = #SubmittalIDs.ID
			Left Join [dbo].[Batch] As vwMixes
			On SubmittalMix.MixID = vwMixes.BATCHIDENTIFIER
			Where SubmittalMix.MixID Is Not Null And #SubmittalIDs.ID Is Null And vwMixes.BATCHIDENTIFIER Is Null		
		
			Union All
		
			Select SubmittalMix.SubmittalMixID
			From [dbo].[SubmittalMix]
			Left Join [dbo].[#SubmittalIDs]
			On SubmittalMix.SubmittalID = #SubmittalIDs.ID
			Inner Join [dbo].[OnlySubmittalMix]
			On SubmittalMix.OnlySubmittalMixID = OnlySubmittalMix.OnlySubmittalMixID
			Left Join [dbo].[Batch] As vwMixes
			On OnlySubmittalMix.OriginalMixID = vwMixes.BATCHIDENTIFIER
			Where SubmittalMix.MixID Is Null And #SubmittalIDs.ID Is Null And vwMixes.BATCHIDENTIFIER Is Null
	
			Union All
	
			Select SubmittalMix.SubmittalMixID
			From [dbo].[SubmittalMix]
			Inner Join [dbo].[#SubmittalIDs]
			On SubmittalMix.SubmittalID = #SubmittalIDs.ID
		) As SubmittalMix
		Group By SubmittalMix.SubmittalMixID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Submittal Mix Grading Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#SubMixGradingIDs] (ID)
		Select SubmittalGradation.SubmittalGradationID
		From [dbo].[SubmittalGradation]
		Inner Join [dbo].[SubmittalMix]
		On SubmittalGradation.SubmittalGradationID = SubmittalMix.SubmittalGradationID
		Inner Join [dbo].[#SubmittalMixIDs]
		On SubmittalMix.SubmittalMixID = #SubmittalMixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Batch Group Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#BatchGroupIDs] (ID)
			Select BatchGroup.BatchGroupID
				From [dbo].[BatchGroup]
				Inner Join [dbo].[GroupBatch]
				On BatchGroup.BatchGroupID = GroupBatch.BatchGroupID
				Inner Join [dbo].[#BatchIDs]
				On GroupBatch.BatchID = #BatchIDs.ID
				Group By BatchGroup.BatchGroupID
				
		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Aggregate Info', 0, 0) With Nowait
				
		Insert Into [dbo].[#AggregateIDs] (ID)
			Select Aggregate.AggregateID
				From [dbo].[Aggregate]
				Inner Join [dbo].[Material]
				On Aggregate.MaterialID = Material.MaterialIdentifier
				Inner Join [dbo].[#PlantIDs]
				On Material.PlantID = #PlantIDs.ID
				Group By Aggregate.AggregateID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Aggregate Spec Info From Aggregates', 0, 0) With Nowait
	
		Insert Into [dbo].[#AggSpecIDs] (ID)
			Select Aggregate.AggSpecID
				From [dbo].[Aggregate]
				Inner Join [dbo].[#AggregateIDs]
				On Aggregate.AggregateID = #AggregateIDs.ID
				Left Join [dbo].[#AggSpecIDs]
				On Aggregate.AggSpecID = #AggSpecIDs.ID
				Where #AggSpecIDs.ID Is Null
				Group By Aggregate.AggSpecID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Aggregate Spec Info From Aggregate Jobs', 0, 0) With Nowait
	
		Insert Into [dbo].[#AggSpecIDs] (ID)
			Select AggForJob.AggSpecID
				From [dbo].[AggForJob]
				Inner Join [dbo].[#AggregateIDs]
				On AggForJob.AggregateID = #AggregateIDs.ID
				Left Join [dbo].[#AggSpecIDs]
				On AggForJob.AggSpecID = #AggSpecIDs.ID
				Where #AggSpecIDs.ID Is Null
				Group By AggForJob.AggSpecID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Aggregate Spec Info From Disabled Alerts', 0, 0) With Nowait
	
		Insert Into [dbo].[#AggSpecIDs] (ID)
			Select AggSpecAlertDisabled.AggSpecID
				From [dbo].[AggSpecAlertDisabled]
				Inner Join [dbo].[#AggregateIDs]
				On AggSpecAlertDisabled.AggregateID = #AggregateIDs.ID
				Left Join [dbo].[#AggSpecIDs]
				On AggSpecAlertDisabled.AggSpecID = #AggSpecIDs.ID
				Where #AggSpecIDs.ID Is Null
				Group By AggSpecAlertDisabled.AggSpecID
				
		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Aggregate Sample IDs', 0, 0) With Nowait
				
		Insert Into [dbo].[#AggSampleIDs] (ID)
			Select AggSample.AggSampleID
				From [dbo].[AggSample]
				Inner Join [dbo].[#AggregateIDs]
				On AggSample.AggregateID = #AggregateIDs.ID
				Group By AggSample.AggSampleID
				
		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Agg Meas Set Info', 0, 0) With Nowait
				
		Insert Into [dbo].[#AggMeasSetIDs] (ID)
			Select AggMeasSet.AggMeasSetID
				From [dbo].[AggMeasSet]
				Inner Join [dbo].[#AggSampleIDs]
				On AggMeasSet.AggSampleID = #AggSampleIDs.ID
				Group By AggMeasSet.AggMeasSetID
	
		/*
		Delete [dbo].[ArchivedMaterialRecipe]
		From [dbo].[ArchivedMaterialRecipe]
		Inner Join [dbo].[Material]
		On ArchivedMaterialRecipe.Material = Material.Code
		Inner Join [dbo].[#PlantIDs]
		On Material.PlantCode = #PlantIDs.Code
		*/
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Archived Material Recipes', 0, 0) With Nowait
		
		Delete ArchivedMaterialRecipe
			From dbo.ArchivedMaterialRecipe As ArchivedMaterialRecipe
			Inner Join dbo.ArchivedBATCH As ArchivedBATCH
			On ArchivedBATCH.BATCHIDENTIFIER = ArchivedMaterialRecipe.EntityID
			Inner Join [dbo].[#PlantIDs] As PlantIDs
			On ArchivedBatch.Plant_Link = PlantIDs.ID
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Archived Crushes', 0, 0) With Nowait
		
		Delete [dbo].[ArchivedCrush]
		From [dbo].[ArchivedCrush]
		Inner Join [dbo].[ArchivedBatch]
		On Right(ArchivedCrush.CrushCode, 10) = Right(ArchivedBatch.CrushCode, 10)
		Inner Join [dbo].[#PlantIDs]
		On ArchivedBatch.Plant_Link = #PlantIDs.ID
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Archived Tests', 0, 0) With Nowait
		
		Delete [dbo].[ArchivedTest]
		From [dbo].[ArchivedTest]
		Inner Join [dbo].[ArchivedTestInfo]
		On ArchivedTest.TestNum = ArchivedTestInfo.TestNum
		Inner Join [dbo].[ArchivedBatch]
		On ArchivedTestInfo.Code = ArchivedBatch.Code
		Inner Join [dbo].[#PlantIDs]
		On ArchivedBatch.Plant_Link = #PlantIDs.ID
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Archived Test Info', 0, 0) With Nowait
		
		Delete [dbo].[ArchivedTestInfo]
		From [dbo].[ArchivedTestInfo]
		Inner Join [dbo].[ArchivedBatch]
		On ArchivedTestInfo.Code = ArchivedBatch.Code
		Inner Join [dbo].[#PlantIDs]
		On ArchivedBatch.Plant_Link = #PlantIDs.ID
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Archived Split Tensile Tests', 0, 0) With Nowait
		
		Delete [dbo].[ArchivedSplitTensileTest]
		From [dbo].[ArchivedSplitTensileTest]
		Inner Join [dbo].[ArchivedMaterialSpecimen]
		On ArchivedSplitTensileTest.MtlSpmnID = ArchivedMaterialSpecimen.MtrlSpmnID
		Inner Join [dbo].[ArchivedBatch]
		On ArchivedMaterialSpecimen.MtrlSpmnBatchLink = ArchivedBatch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On ArchivedBatch.Plant_Link = #PlantIDs.ID
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Archived Test Measurements', 0, 0) With Nowait
		
		Delete [dbo].[ArchivedTestMeasurement]
		From [dbo].[ArchivedTestMeasurement]
		Inner Join [dbo].[ArchivedDataPoint]
		On ArchivedTestMeasurement.TestMeasDataPointLink = ArchivedDataPoint.DtptID
		Inner Join [dbo].[ArchivedDataSet]
		On ArchivedDataPoint.DtptDataSetLink = ArchivedDataSet.DtstID
		Inner Join [dbo].[ArchivedSpecimenTest]
		On ArchivedDataSet.DtstSpmnTestLink = ArchivedSpecimenTest.SpmnTestID
		Inner Join [dbo].[ArchivedMaterialSpecimen]
		On ArchivedSpecimenTest.SpmnTestMtrlSpmnLink = ArchivedMaterialSpecimen.MtrlSpmnID
		Inner Join [dbo].[ArchivedBatch]
		On ArchivedMaterialSpecimen.MtrlSpmnBatchLink = ArchivedBatch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On ArchivedBatch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Archived Data Points', 0, 0) With Nowait
	
		Delete [dbo].[ArchivedDataPoint]
		From [dbo].[ArchivedDataPoint]
		Inner Join [dbo].[ArchivedDataSet]
		On ArchivedDataPoint.DtptDataSetLink = ArchivedDataSet.DtstID
		Inner Join [dbo].[ArchivedSpecimenTest]
		On ArchivedDataSet.DtstSpmnTestLink = ArchivedSpecimenTest.SpmnTestID
		Inner Join [dbo].[ArchivedMaterialSpecimen]
		On ArchivedSpecimenTest.SpmnTestMtrlSpmnLink = ArchivedMaterialSpecimen.MtrlSpmnID
		Inner Join [dbo].[ArchivedBatch]
		On ArchivedMaterialSpecimen.MtrlSpmnBatchLink = ArchivedBatch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On ArchivedBatch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Archived Data Sets', 0, 0) With Nowait
	
		Delete [dbo].[ArchivedDataSet]
		From [dbo].[ArchivedDataSet]
		Inner Join [dbo].[ArchivedSpecimenTest]
		On ArchivedDataSet.DtstSpmnTestLink = ArchivedSpecimenTest.SpmnTestID
		Inner Join [dbo].[ArchivedMaterialSpecimen]
		On ArchivedSpecimenTest.SpmnTestMtrlSpmnLink = ArchivedMaterialSpecimen.MtrlSpmnID
		Inner Join [dbo].[ArchivedBatch]
		On ArchivedMaterialSpecimen.MtrlSpmnBatchLink = ArchivedBatch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On ArchivedBatch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Archived Specimen Tests', 0, 0) With Nowait
	
		Delete [dbo].[ArchivedSpecimenTest]
		From [dbo].[ArchivedSpecimenTest]
		Inner Join [dbo].[ArchivedMaterialSpecimen]
		On ArchivedSpecimenTest.SpmnTestMtrlSpmnLink = ArchivedMaterialSpecimen.MtrlSpmnID
		Inner Join [dbo].[ArchivedBatch]
		On ArchivedMaterialSpecimen.MtrlSpmnBatchLink = ArchivedBatch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On ArchivedBatch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Archive Material Specimens', 0, 0) With Nowait
	
		Delete [dbo].[ArchivedMaterialSpecimen]
		From [dbo].[ArchivedMaterialSpecimen]
		Inner Join [dbo].[ArchivedBatch]
		On ArchivedMaterialSpecimen.MtrlSpmnBatchLink = ArchivedBatch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On ArchivedBatch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Archived Batches', 0, 0) With Nowait
	
		Delete [dbo].[ArchivedBatch]
		From [dbo].[ArchivedBatch]
		Inner Join [dbo].[#PlantIDs]
		On ArchivedBatch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Batch Data - Delete TimeDependentMeas Data', 0, 0) With Nowait

        Delete TimeDependentMeas
        From dbo.TimeDependentMeas As TimeDependentMeas
        Inner Join dbo.TimeDependentMeasGroup As TimeDependentMeasGroup
        On TimeDependentMeasGroup.TimeDependentMeasGroupID = TimeDependentMeas.TimeDependentMeasGroupID
        Inner Join dbo.TimeDependentTest As TimeDependentTest
        On TimeDependentTest.TimeDependentTestID = TimeDependentMeasGroup.TimeDependentTestID
        Inner Join dbo.Batch As Batch
        On TimeDependentTest.BatchID = Batch.BATCHIDENTIFIER
		Inner Join #BatchIDs As BatchIDs
		On Batch.BATCHIDENTIFIER = BatchIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Batch Data - Delete TimeDependentMeasGroup Data', 0, 0) With Nowait

        Delete TimeDependentMeasGroup
        From dbo.TimeDependentMeasGroup As TimeDependentMeasGroup
        Inner Join dbo.TimeDependentTest As TimeDependentTest
        On TimeDependentTest.TimeDependentTestID = TimeDependentMeasGroup.TimeDependentTestID
        Inner Join dbo.Batch As Batch
        On TimeDependentTest.BatchID = Batch.BATCHIDENTIFIER
		Inner Join #BatchIDs As BatchIDs
		On Batch.BATCHIDENTIFIER = BatchIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Batch Data - Delete TimeDependentAge Data', 0, 0) With Nowait

        Delete TimeDependentAge
        From dbo.TimeDependentAge As TimeDependentAge
        Inner Join dbo.TimeDependentTest As TimeDependentTest
        On TimeDependentTest.TimeDependentTestID = TimeDependentAge.TimeDependentTestID
        Inner Join dbo.Batch As Batch
        On TimeDependentTest.BatchID = Batch.BATCHIDENTIFIER
		Inner Join #BatchIDs As BatchIDs
		On Batch.BATCHIDENTIFIER = BatchIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Batch Data - Delete TimeDependentTest Data', 0, 0) With Nowait

        Delete TimeDependentTest
        From dbo.TimeDependentTest As TimeDependentTest
        Inner Join dbo.Batch As Batch
        On TimeDependentTest.BatchID = Batch.BATCHIDENTIFIER
		Inner Join #BatchIDs As BatchIDs
		On Batch.BATCHIDENTIFIER = BatchIDs.ID
	
		/*
		Delete [dbo].[MaterialRecipe]
		From [dbo].[MaterialRecipe]
		Inner Join [dbo].[Material]
		On MaterialRecipe.Material = Material.Code
		Inner Join [dbo].[#PlantIDs]
		On Material.PlantCode = #PlantIDs.Code
		*/
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Batch Recipes', 0, 0) With Nowait
		
		Delete MaterialRecipe
			From dbo.MaterialRecipe As MaterialRecipe
			Inner Join [dbo].[Batch] As Batch
			On Batch.BATCHIDENTIFIER = MaterialRecipe.EntityID
			Inner Join [dbo].[#PlantIDs] As PlantIDs
			On Batch.Plant_Link = PlantIDs.ID
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Strength Parameter Info', 0, 0) With Nowait
		
		Delete [dbo].[StrnPara]
		From [dbo].[StrnPara]
		Inner Join [dbo].[Batch]
		On StrnPara.BatchID = Batch.BATCHIDENTIFIER
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Strength Parameter Info', 0, 0) With Nowait
	
		Delete [dbo].[StrnPara]
		From [dbo].[StrnPara]
		Inner Join [dbo].[Batch]
		On Right(StrnPara.Code, 10) = Right(Batch.CrushCode, 10)
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Crushes', 0, 0) With Nowait
		
		Delete [dbo].[Crush]
		From [dbo].[Crush]
		Inner Join [dbo].[Batch]
		On Right(Crush.CrushCode, 10) = Right(Batch.CrushCode, 10)
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Crushes', 0, 0) With Nowait

		Delete [dbo].[Crush]
		From [dbo].[Crush]
		Inner Join [dbo].[Batch]
		On Crush.BatchID = Batch.BATCHIDENTIFIER
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Tests', 0, 0) With Nowait
	
		Delete [dbo].[Test]
		From [dbo].[Test]
		Inner Join [dbo].[TestInfo]
		On Test.TestNum = TestInfo.TestNum
		Inner Join [dbo].[Batch]
		On TestInfo.Code = Batch.Code
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Test Info', 0, 0) With Nowait
	
		Delete [dbo].[TestInfo]
		From [dbo].[TestInfo]
		Inner Join [dbo].[Batch]
		On TestInfo.Code = Batch.Code
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Split Tensile Tests', 0, 0) With Nowait
	
		Delete [dbo].[SplitTensileTest]
		From [dbo].[SplitTensileTest]
		Inner Join [dbo].[MaterialSpecimen]
		On SplitTensileTest.MtlSpmnID = MaterialSpecimen.MtrlSpmnID
		Inner Join [dbo].[Batch]
		On MaterialSpecimen.MtrlSpmnBatchLink = Batch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Test Measurements', 0, 0) With Nowait
	
		Delete [dbo].[TestMeasurement]
		From [dbo].[TestMeasurement]
		Inner Join [dbo].[DataPoint]
		On TestMeasurement.TestMeasDataPointLink = DataPoint.DtptID
		Inner Join [dbo].[DataSet]
		On DataPoint.DtptDataSetLink = DataSet.DtstID
		Inner Join [dbo].[SpecimenTest]
		On DataSet.DtstSpmnTestLink = SpecimenTest.SpmnTestID
		Inner Join [dbo].[MaterialSpecimen]
		On SpecimenTest.SpmnTestMtrlSpmnLink = MaterialSpecimen.MtrlSpmnID
		Inner Join [dbo].[Batch]
		On MaterialSpecimen.MtrlSpmnBatchLink = Batch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Data Points', 0, 0) With Nowait
	
		Delete [dbo].[DataPoint]
		From [dbo].[DataPoint]
		Inner Join [dbo].[DataSet]
		On DataPoint.DtptDataSetLink = DataSet.DtstID
		Inner Join [dbo].[SpecimenTest]
		On DataSet.DtstSpmnTestLink = SpecimenTest.SpmnTestID
		Inner Join [dbo].[MaterialSpecimen]
		On SpecimenTest.SpmnTestMtrlSpmnLink = MaterialSpecimen.MtrlSpmnID
		Inner Join [dbo].[Batch]
		On MaterialSpecimen.MtrlSpmnBatchLink = Batch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Data Sets', 0, 0) With Nowait
	
		Delete [dbo].[DataSet]
		From [dbo].[DataSet]
		Inner Join [dbo].[SpecimenTest]
		On DataSet.DtstSpmnTestLink = SpecimenTest.SpmnTestID
		Inner Join [dbo].[MaterialSpecimen]
		On SpecimenTest.SpmnTestMtrlSpmnLink = MaterialSpecimen.MtrlSpmnID
		Inner Join [dbo].[Batch]
		On MaterialSpecimen.MtrlSpmnBatchLink = Batch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Specimen Tests', 0, 0) With Nowait
	
		Delete [dbo].[SpecimenTest]
		From [dbo].[SpecimenTest]
		Inner Join [dbo].[MaterialSpecimen]
		On SpecimenTest.SpmnTestMtrlSpmnLink = MaterialSpecimen.MtrlSpmnID
		Inner Join [dbo].[Batch]
		On MaterialSpecimen.MtrlSpmnBatchLink = Batch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Material Specimens', 0, 0) With Nowait
	
		Delete [dbo].[MaterialSpecimen]
		From [dbo].[MaterialSpecimen]
		Inner Join [dbo].[Batch]
		On MaterialSpecimen.MtrlSpmnBatchLink = Batch.BatchIdentifier
		Inner Join [dbo].[#PlantIDs]
		On Batch.Plant_Link = #PlantIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Classes', 0, 0) With Nowait
	
		Delete [dbo].[MixClassDefinitions]
		From [dbo].[MixClassDefinitions]
		Inner Join [dbo].[#MixIDs]
		On MixClassDefinitions.MixLink = #MixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Attachments', 0, 0) With Nowait
	
		Delete [dbo].[MixAttachment]
		From [dbo].[MixAttachment]
		Inner Join [dbo].[#MixIDs]
		On MixAttachment.MixID = #MixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Comments', 0, 0) With Nowait
	
		Delete [dbo].[MixComment]
		From [dbo].[MixComment]
		Inner Join [dbo].[#MixIDs]
		On MixComment.MixID = #MixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove User Info', 0, 0) With Nowait
	
		Delete [dbo].[UserInfo]
		From [dbo].[UserInfo]
		Inner Join [dbo].[#MixIDs]
		On UserInfo.UseCode = #MixIDs.MixNameCode
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Delete Grouping Info', 0, 0) With Nowait
		
		Delete [dbo].[Grouping]
		From [dbo].[Grouping]
		Inner Join [dbo].[#MixIDs]
		On Grouping.Ext_Code = #MixIDs.MixNameCode

		Raiserror('', 0, 0) With Nowait
		Raiserror('Delete Grouping Info', 0, 0) With Nowait
	
		Delete [dbo].[Grouping]
		From [dbo].[Grouping]
		Inner Join [dbo].[#BatchIDs]
		On Grouping.BatchCode = #BatchIDs.Code

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Batch Project Info Links', 0, 0) With Nowait
	
		Update [dbo].[Batch]
			Set ProjectID = Null, ConstrnContractID = Null, MixForContractID = Null
			From [dbo].[Batch]
			Inner Join [dbo].[#BatchIDs]
			On Batch.BatchIdentifier = #BatchIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Backup, Gradation, And Mix Spec Links', 0, 0) With Nowait
	
		Update [dbo].[Batch]
			Set BackupDataID = Null, SubmittalGradationID = Null, MixSpecID = Null
			From [dbo].[Batch]
			Inner Join [dbo].[#MixIDs]
			On Batch.BatchIdentifier = #MixIDs.ID
		/*
		Update [dbo].[MixForContract]
			Set MixSpecID = Null
			From [dbo].[MixForContract]
			Inner Join [dbo].[#MixIDs]
			On MixForContract.MixID = #MixIDs.ID
		*/
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Gradation Info', 0, 0) With Nowait

		Delete [dbo].[SubmittalGradation]
		From [dbo].[SubmittalGradation]
		Inner Join [dbo].[#GradingIDs]
		On SubmittalGradation.SubmittalGradationID = #GradingIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Backup Info', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalBackup]
		From [dbo].[SubmittalBackup]
		Inner Join [dbo].[#BackupDataIDs]
		On SubmittalBackup.SubmittalBackupID = #BackupDataIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Spec Class Info', 0, 0) With Nowait
	
		Delete [dbo].[MixSpecClass]
		From [dbo].[MixSpecClass]
		Inner Join [dbo].[#MixSpecIDs]
		On MixSpecClass.MixSpecIDLink = #MixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Numerator Info', 0, 0) With Nowait
	
		Delete [dbo].[NOrDMtlType]
		From [dbo].[NOrDMtlType]
		Inner Join [dbo].[MixMaterialRatioSpec]
		On NOrDMtlType.MtlRatioIDLink = MixMaterialRatioSpec.MixMaterialRatioSpecID
		Inner Join [dbo].[#MixSpecIDs]
		On MixMaterialRatioSpec.MixSpecIDLink = #MixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Material Ratio Specs', 0, 0) With Nowait
	
		Delete [dbo].[MixMaterialRatioSpec]
		From [dbo].[MixMaterialRatioSpec]
		Inner Join [dbo].[#MixSpecIDs]
		On MixMaterialRatioSpec.MixSpecIDLink = #MixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Spec Meases', 0, 0) With Nowait
	
		Delete [dbo].[SpecMeas]
		From [dbo].[SpecMeas]
		Inner Join [dbo].[SpecDataPoint]
		On SpecMeas.SpecDataPointID = SpecDataPoint.SpecDataPointID
		Inner Join [dbo].[#MixSpecIDs]
		On SpecDataPoint.MixSpecID = #MixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Spec Data Points', 0, 0) With Nowait
	
		Delete [dbo].[SpecDataPoint]
		From [dbo].[SpecDataPoint]
		Inner Join [dbo].[#MixSpecIDs]
		On SpecDataPoint.MixSpecID = #MixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Material Specs', 0, 0) With Nowait
	
		Delete [dbo].[MixMaterialSpec]
		From [dbo].[MixMaterialSpec]
		Inner Join [dbo].[#MixSpecIDs]
		On MixMaterialSpec.MixSpecIDLink = #MixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Specs', 0, 0) With Nowait
	
		Delete [dbo].[MixSpec]
		From [dbo].[MixSpec]
		Inner Join [dbo].[#MixSpecIDs]
		On MixSpec.MixSpecID = #MixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Spec Classes', 0, 0) With Nowait
	
		Delete [dbo].[MixSpecClass]
		From [dbo].[MixSpecClass]
		Inner Join [dbo].[#ContractMixSpecIDs]
		On MixSpecClass.MixSpecIDLink = #ContractMixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Numerator Info', 0, 0) With Nowait
	
		Delete [dbo].[NOrDMtlType]
		From [dbo].[NOrDMtlType]
		Inner Join [dbo].[MixMaterialRatioSpec]
		On NOrDMtlType.MtlRatioIDLink = MixMaterialRatioSpec.MixMaterialRatioSpecID
		Inner Join [dbo].[#ContractMixSpecIDs]
		On MixMaterialRatioSpec.MixSpecIDLink = #ContractMixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Material Ratio Specs', 0, 0) With Nowait
	
		Delete [dbo].[MixMaterialRatioSpec]
		From [dbo].[MixMaterialRatioSpec]
		Inner Join [dbo].[#ContractMixSpecIDs]
		On MixMaterialRatioSpec.MixSpecIDLink = #ContractMixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Spec Meases', 0, 0) With Nowait
	
		Delete [dbo].[SpecMeas]
		From [dbo].[SpecMeas]
		Inner Join [dbo].[SpecDataPoint]
		On SpecMeas.SpecDataPointID = SpecDataPoint.SpecDataPointID
		Inner Join [dbo].[#ContractMixSpecIDs]
		On SpecDataPoint.MixSpecID = #ContractMixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Spec Data Points', 0, 0) With Nowait
	
		Delete [dbo].[SpecDataPoint]
		From [dbo].[SpecDataPoint]
		Inner Join [dbo].[#ContractMixSpecIDs]
		On SpecDataPoint.MixSpecID = #ContractMixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Material Specs', 0, 0) With Nowait
	
		Delete [dbo].[MixMaterialSpec]
		From [dbo].[MixMaterialSpec]
		Inner Join [dbo].[#ContractMixSpecIDs]
		On MixMaterialSpec.MixSpecIDLink = #ContractMixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Specifications', 0, 0) With Nowait
	
		Delete [dbo].[MixSpec]
		From [dbo].[MixSpec]
		Inner Join [dbo].[#ContractMixSpecIDs]
		On MixSpec.MixSpecID = #ContractMixSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Project Mix Info', 0, 0) With Nowait
	
		Delete [dbo].[MixForContract]
		From [dbo].[MixForContract]
		Inner Join [dbo].[#MixIDs]
		On MixForContract.MixID = #MixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Recipes', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalMaterialRecipe]
		From [dbo].[SubmittalMaterialRecipe]
		Left Join [dbo].[Submital]
		On 	Submital.SubNo = SubmittalMaterialRecipe.ID And
			Submital.Code = SubmittalMaterialRecipe.Code And
			Submital.ContractMixID = SubmittalMaterialRecipe.ContractMixID
		Where Submital.SubNo Is Null

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Only Submittal Recipes', 0, 0) With Nowait
	
		Delete [dbo].[OnlySubmittalMatlRecipe]
		From [dbo].[OnlySubmittalMatlRecipe]
		Left Join [dbo].[OnlySubmittalMix]
		On OnlySubmittalMatlRecipe.OnlySubmittalMixID = OnlySubmittalMix.OnlySubmittalMixID
		Where OnlySubmittalMix.OnlySubmittalMixID Is Null

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Only Submittal Recipes', 0, 0) With Nowait
	
		Delete [dbo].[OnlySubmittalMatlRecipe]
		From [dbo].[OnlySubmittalMatlRecipe]
		Inner Join [dbo].[OnlySubmittalMix]
		On OnlySubmittalMatlRecipe.OnlySubmittalMixID = OnlySubmittalMix.OnlySubmittalMixID
		Left Join [dbo].[SubmittalMix]
		On OnlySubmittalMix.OnlySubmittalMixID = SubmittalMix.OnlySubmittalMixID
		Where SubmittalMix.OnlySubmittalMixID Is Null

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Only Submittal Mixes', 0, 0) With Nowait
	
		Delete [dbo].[OnlySubmittalMix]
		From [dbo].[OnlySubmittalMix]
		Left Join [dbo].[SubmittalMix]
		On OnlySubmittalMix.OnlySubmittalMixID = SubmittalMix.OnlySubmittalMixID
		Where SubmittalMix.OnlySubmittalMixID Is Null

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Only Submittal Recipes', 0, 0) With Nowait
	
		Delete [dbo].[OnlySubmittalMatlRecipe]
		From [dbo].[OnlySubmittalMatlRecipe]
		Inner Join [dbo].[OnlySubmittalMix]
		On OnlySubmittalMatlRecipe.OnlySubmittalMixID = OnlySubmittalMix.OnlySubmittalMixID
		Inner Join [dbo].[SubmittalMix]
		On OnlySubmittalMix.OnlySubmittalMixID = SubmittalMix.OnlySubmittalMixID
		Inner Join [dbo].[#SubmittalMixIDs]
		On SubmittalMix.SubmittalMixID = #SubmittalMixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Only Submittal Mix Info', 0, 0) With Nowait
	
		Delete [dbo].[OnlySubmittalMix]
		From [dbo].[OnlySubmittalMix]
		Inner Join [dbo].[SubmittalMix]
		On OnlySubmittalMix.OnlySubmittalMixID = SubmittalMix.OnlySubmittalMixID
		Inner Join [dbo].[#SubmittalMixIDs]
		On SubmittalMix.SubmittalMixID = #SubmittalMixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Mix Project Info', 0, 0) With Nowait
	
		Update [dbo].[SubmittalMix]
			Set ContractMixID = Null, SubmittalGradationID = Null
			From [dbo].[SubmittalMix]
			Inner Join [dbo].[#SubmittalMixIDs]
			On SubmittalMix.SubmittalMixID = #SubmittalMixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Gradations', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalGradation]
		From [dbo].[SubmittalGradation]
		Inner Join [dbo].[#SubMixGradingIDs]
		On SubmittalGradation.SubmittalGradationID = #SubMixGradingIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Mix Attachments', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalMixAttachment]
		From [dbo].[SubmittalMixAttachment]
		Inner Join [dbo].[SubmittalMix]
		On SubmittalMixAttachment.SubmittalMixID = SubmittalMix.SubmittalMixID
		Inner Join [dbo].[#SubmittalMixIDs]
		On SubmittalMix.SubmittalMixID = #SubmittalMixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Mix Comment', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalMixComment]
		From [dbo].[SubmittalMixComment]
		Inner Join [dbo].[SubmittalMix]
		On SubmittalMixComment.SubmittalMixID = SubmittalMix.SubmittalMixID
		Inner Join [dbo].[#SubmittalMixIDs]
		On SubmittalMix.SubmittalMixID = #SubmittalMixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Backup Info', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalBackup]
		From [dbo].[SubmittalBackup]
		Inner Join [dbo].[SubmittalMix]
		On SubmittalBackup.SubmittalMixID = SubmittalMix.SubmittalMixID
		Inner Join [dbo].[#SubmittalMixIDs]
		On SubmittalMix.SubmittalMixID = #SubmittalMixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Mixes', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalMix]
		From [dbo].[SubmittalMix]
		Inner Join [dbo].[#SubmittalMixIDs]
		On SubmittalMix.SubmittalMixID = #SubmittalMixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Retrieve Submittal Info', 0, 0) With Nowait
	
		Insert Into [dbo].[#SubmittalIDs] (ID)
		Select SubmittalNew.SubmittalID
		From [dbo].[SubmittalNew]
		Left Join [dbo].[#SubmittalIDs]
		On SubmittalNew.SubmittalID = #SubmittalIDs.ID
		Left Join [dbo].[SubmittalMix]
		On SubmittalNew.SubmittalID = SubmittalMix.SubmittalID
		Where #SubmittalIDs.ID Is Null
		Group By SubmittalNew.SubmittalID
		Having Count(SubmittalMix.SubmittalMixID) = 0

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Attachment Info', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalAttachment]
		From [dbo].[SubmittalAttachment]
		Inner Join [dbo].[#SubmittalIDs]
		On SubmittalAttachment.SubmittalID = #SubmittalIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Distribution Info', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalDistribution]
		From [dbo].[SubmittalDistribution]
		Inner Join [dbo].[#SubmittalIDs]
		On SubmittalDistribution.SubmittalID = #SubmittalIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Recipe Report Info', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalMaterialRecipe]
		From [dbo].[SubmittalMaterialRecipe]
		Inner Join [dbo].[Submital]
		On 	Submital.SubNo = SubmittalMaterialRecipe.ID And
			Submital.Code = SubmittalMaterialRecipe.Code And
			Submital.ContractMixID = SubmittalMaterialRecipe.ContractMixID
		Inner Join [dbo].[SubmittalNew] 
		On Cast(Submital.SubNo As Int)= SubmittalNew.SubmittalNumber
		Inner Join [dbo].[#SubmittalIDs]
		On SubmittalNew.SubmittalID = #SubmittalIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Material Specimens', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalMtrlSpmn]
		From [dbo].[SubmittalMtrlSpmn]
		Inner Join [dbo].[Submital]
		On SubmittalMtrlSpmn.SubmittalID = Submital.SubmitalIdentifier
		Inner Join [dbo].[SubmittalNew] 
		On Cast(Submital.SubNo As Int)= SubmittalNew.SubmittalNumber
		Inner Join [dbo].[#SubmittalIDs]
		On SubmittalNew.SubmittalID = #SubmittalIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Report Aggregate Props Info', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalReport_AggregateProps1]
		From [dbo].[SubmittalReport_AggregateProps1]
		Inner Join [dbo].[Submital]
		On SubmittalReport_AggregateProps1.SubmittalID = Submital.SubmitalIdentifier
		Inner Join [dbo].[SubmittalNew] 
		On Cast(Submital.SubNo As Int)= SubmittalNew.SubmittalNumber
		Inner Join [dbo].[#SubmittalIDs]
		On SubmittalNew.SubmittalID = #SubmittalIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittal Report Info', 0, 0) With Nowait
	
		Delete [dbo].[Submital]
		From [dbo].[Submital]
		Inner Join [dbo].[SubmittalNew] 
		On Cast(Submital.SubNo As Int)= SubmittalNew.SubmittalNumber
		Inner Join [dbo].[#SubmittalIDs]
		On SubmittalNew.SubmittalID = #SubmittalIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Submittals', 0, 0) With Nowait
	
		Delete [dbo].[SubmittalNew]
		From [dbo].[SubmittalNew] 
		Inner Join [dbo].[#SubmittalIDs]
		On SubmittalNew.SubmittalID = #SubmittalIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Composite Recipe Upload', 0, 0) With Nowait
	
		Delete [dbo].[CompositeMtrlRecipeUpload]
			From [dbo].[CompositeMtrlRecipeUpload]
			Inner Join [dbo].[Material]
			On CompositeMtrlRecipeUpload.ComponentMtrlID = Material.MaterialIdentifier
			Inner Join [dbo].[#PlantIDs]
			On Material.PlantCode = #PlantIDs.Code
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Composite Recipe Upload', 0, 0) With Nowait
			
		Delete [dbo].[CompositeMtrlRecipeUpload]
			From [dbo].[CompositeMtrlRecipeUpload]
			Inner Join [dbo].[MaterialUpload]
			On CompositeMtrlRecipeUpload.MaterialUploadID = MaterialUpload.MaterialUploadID
			Inner Join [dbo].[Material]
			On MaterialUpload.MaterialID = Material.MaterialIdentifier
			Inner Join [dbo].[#PlantIDs]
			On Material.PlantCode = #PlantIDs.Code
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Material Upload Info', 0, 0) With Nowait
			
		Delete [dbo].[MaterialUpload]
			From [dbo].[MaterialUpload]
			Inner Join [dbo].[Material]
			On MaterialUpload.MaterialID = Material.MaterialIdentifier
			Inner Join [dbo].[#PlantIDs]
			On Material.PlantCode = #PlantIDs.Code
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Recipe Upload Info', 0, 0) With Nowait
			
		Delete [dbo].[MixRecipeUpload]
			From [dbo].[MixRecipeUpload]
			Inner Join [dbo].[Material]
			On MixRecipeUpload.MaterialID = Material.MaterialIdentifier
			Inner Join [dbo].[#PlantIDs]
			On Material.PlantCode = #PlantIDs.Code

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Recipe Upload Info', 0, 0) With Nowait
	
		Delete [dbo].[MixRecipeUpload]
			From [dbo].[MixRecipeUpload]
			Inner Join [dbo].[MixUpload]
			On MixRecipeUpload.MixUploadID = MixUpload.MixUploadID
			Inner Join [dbo].[#MixIDs]
			On MixUpload.MixID = #MixIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mix Upload Info', 0, 0) With Nowait
			
		Delete [dbo].[MixUpload]
			From [dbo].[MixUpload]
			Inner Join [dbo].[#MixIDs]
			On MixUpload.MixID = #MixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Material Attachments', 0, 0) With Nowait
	
		Delete [dbo].[MaterialAttachment]
		From [dbo].[MaterialAttachment]
		Inner Join [dbo].[Material]
		On MaterialAttachment.MaterialID = Material.MaterialIdentifier 
		Inner Join [dbo].[#PlantIDs]
		On Material.PlantCode = #PlantIDs.Code

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Material Measurements', 0, 0) With Nowait
	
		Delete [dbo].[MaterialMeasurement]
		From [dbo].[MaterialMeasurement]
		Inner Join [dbo].[MaterialSpecimenInfo]
		On MaterialMeasurement.MtrlSpmnInfoID = MaterialSpecimenInfo.MaterialSpecimenInfoID
		Inner Join [dbo].[Material]
		On MaterialSpecimenInfo.MaterialID = Material.MaterialIdentifier 
		Inner Join [dbo].[#PlantIDs]
		On Material.PlantCode = #PlantIDs.Code
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Sieve Measurements', 0, 0) With Nowait
		
		Delete [dbo].[SieveMeasurement]
		From [dbo].[SieveMeasurement]
		Inner Join [dbo].[MaterialSpecimenInfo]
		On SieveMeasurement.MtrlSpmnInfoID = MaterialSpecimenInfo.MaterialSpecimenInfoID
		Inner Join [dbo].[Material]
		On MaterialSpecimenInfo.MaterialID = Material.MaterialIdentifier 
		Inner Join [dbo].[#PlantIDs]
		On Material.PlantCode = #PlantIDs.Code

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Material Cost History Info', 0, 0) With Nowait
	
		Delete [dbo].[MaterialCostHistory]
	        From [dbo].[MaterialCostHistory]
	        Inner Join [dbo].[Material]
	        On MaterialCostHistory.MaterialID = Material.MaterialIdentifier 
	        Inner Join [dbo].[#PlantIDs]
	        On Material.PlantCode = #PlantIDs.Code

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Material Specimen Info', 0, 0) With Nowait
	
		Delete [dbo].[MaterialSpecimenInfo]
	        From [dbo].[MaterialSpecimenInfo]
	        Inner Join [dbo].[Material]
	        On MaterialSpecimenInfo.MaterialID = Material.MaterialIdentifier 
	        Inner Join [dbo].[#PlantIDs]
	        On Material.PlantCode = #PlantIDs.Code

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Composite Composites', 0, 0) With Nowait
	
		Delete [dbo].[CompositeMtrlRecipe]
			From [dbo].[CompositeMtrlRecipe]
			Inner Join [dbo].[Material]
			On CompositeMtrlRecipe.CompositeMtrlID = Material.MaterialIdentifier
			Inner Join [dbo].[#PlantIDs]
			On Material.PlantCode = #PlantIDs.Code
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Composite Components', 0, 0) With Nowait
			
		Delete [dbo].[CompositeMtrlRecipe]
			From [dbo].[CompositeMtrlRecipe]
			Inner Join [dbo].[Material]
			On CompositeMtrlRecipe.ComponentMtrlID = Material.MaterialIdentifier
			Inner Join [dbo].[#PlantIDs]
			On Material.PlantCode = #PlantIDs.Code
			
		-----------------------------------Remove Aggregates And Aggregate Properties-----------------------------------
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Shipment Location Links', 0, 0) With Nowait

		Update [dbo].[AggShipment]
			Set FromLocationID = Null
			From [dbo].[AggShipment]
			Inner Join [dbo].[AggStockpile]
			On AggShipment.FromLocationID = AggStockpile.AggStockpileID
			Inner Join [dbo].[#AggregateIDs]
			On AggStockpile.AggregateID = #AggregateIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Shipments', 0, 0) With Nowait
	
		Update [dbo].[AggShipment]
			Set ToLocationID = Null
			From [dbo].[AggShipment]
			Inner Join [dbo].[AggStockpile]
			On AggShipment.ToLocationID = AggStockpile.AggStockpileID
			Inner Join [dbo].[#AggregateIDs]
			On AggStockpile.AggregateID = #AggregateIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Job Info', 0, 0) With Nowait
			
		Delete [dbo].[AggForJob]
			From [dbo].[AggForJob]
			Inner Join [dbo].[#AggregateIDs]
			On AggForJob.AggregateID = #AggregateIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Material Type Info', 0, 0) With Nowait
			
		Delete [dbo].[AggMaterialType]
			From [dbo].[AggMaterialType]
			Inner Join [dbo].[#AggregateIDs]
			On AggMaterialType.AggregateID = #AggregateIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Spec Alert Info', 0, 0) With Nowait
	
		Delete [dbo].[AggSpecAlertDisabled]
			From [dbo].[AggSpecAlertDisabled]
			Inner Join [dbo].[#AggregateIDs]
			On AggSpecAlertDisabled.AggregateID = #AggregateIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Aggregate Composite Composites', 0, 0) With Nowait
	
		Delete [dbo].[AggCompositeRecipe]
			From [dbo].[AggCompositeRecipe]
			Inner Join [dbo].[#AggregateIDs]
			On AggCompositeRecipe.CompositeAggID = #AggregateIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Aggregate Composite Components', 0, 0) With Nowait
	
		Delete [dbo].[AggCompositeRecipe]
			From [dbo].[AggCompositeRecipe]
			Inner Join [dbo].[#AggregateIDs]
			On AggCompositeRecipe.ComponentAggID = #AggregateIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Sieve Measurements', 0, 0) With Nowait
			
		Delete [dbo].[AggSieveMeas]
			From [dbo].[AggSieveMeas]
			Inner Join [dbo].[AggGradingTest]
			On AggSieveMeas.AggGradingTestID = AggGradingTest.AggGradingTestID
			Inner Join [dbo].[#AggMeasSetIDs]
			On AggGradingTest.AggMeasSetID = #AggMeasSetIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Alert Violation Gradations', 0, 0) With Nowait
			
		Delete [dbo].[AggAlertViolationGrad]
			From [dbo].[AggAlertViolationGrad]
			Inner Join [dbo].[AggGradingTest]
			On AggAlertViolationGrad.AggGradingTestID = AggGradingTest.AggGradingTestID
			Inner Join [dbo].[#AggMeasSetIDs]
			On AggGradingTest.AggMeasSetID = #AggMeasSetIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Grading Tests', 0, 0) With Nowait
			
		Delete [dbo].[AggGradingTest]
			From [dbo].[AggGradingTest]
			Inner Join [dbo].[#AggMeasSetIDs]
			On AggGradingTest.AggMeasSetID = #AggMeasSetIDs.ID
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Single Discrete Meases', 0, 0) With Nowait
		
		Delete [dbo].[AggSingleDiscreteMeas]
			From [dbo].[AggSingleDiscreteMeas]
			Inner Join [dbo].[#AggMeasSetIDs]
			On AggSingleDiscreteMeas.AggMeasSetID = #AggMeasSetIDs.ID
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Single Measurements', 0, 0) With Nowait
		
		Delete [dbo].[AggSingleMeasurement]
			From [dbo].[AggSingleMeasurement]
			Inner Join [dbo].[#AggMeasSetIDs]
			On AggSingleMeasurement.AggMeasSetID = #AggMeasSetIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Alert Violation Info', 0, 0) With Nowait
	
		Delete [dbo].[AggAlertViolationSingle]
			From [dbo].[AggAlertViolationSingle]
			Inner Join [dbo].[AggSingleTest]
			On AggAlertViolationSingle.AggSingleTestID = AggSingleTest.AggSingleTestID
			Inner Join [dbo].[#AggMeasSetIDs]
			On AggSingleTest.AggMeasSetID = #AggMeasSetIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Aggregate Single Tests', 0, 0) With Nowait
	
		Delete [dbo].[AggSingleTest]
			From [dbo].[AggSingleTest]
			Inner Join [dbo].[#AggMeasSetIDs]
			On AggSingleTest.AggMeasSetID = #AggMeasSetIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Aggregate Measurement Sets', 0, 0) With Nowait
	
		Delete [dbo].[AggMeasSet]
			From [dbo].[AggMeasSet]
			Inner Join [dbo].[#AggMeasSetIDs]
			On AggMeasSet.AggMeasSetID = #AggMeasSetIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Aggregate Samples', 0, 0) With Nowait
			
		Delete [dbo].[AggSample]
			From [dbo].[AggSample]
			Inner Join [dbo].[#AggSampleIDs]
			On AggSample.AggSampleID = #AggSampleIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Stock Piles', 0, 0) With Nowait
			
		Delete [dbo].[AggStockPile]
			From [dbo].[AggStockPile]
			Inner Join [dbo].[#AggregateIDs]
			On AggStockPile.AggregateID = #AggregateIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Aggregate Parent Aggregate Links', 0, 0) With Nowait
			
		Update [dbo].[Aggregate]
			Set ManufacturingParentAggID = Null
			From [dbo].[Aggregate]
			Inner Join [dbo].[#AggregateIDs]
			On Aggregate.ManufacturingParentAggID = #AggregateIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Aggregates', 0, 0) With Nowait
	
		Delete [dbo].[Aggregate]
			From [dbo].[Aggregate]
			Inner Join [dbo].[#AggregateIDs]
			On Aggregate.AggregateID = #AggregateIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Spec Allowed Values', 0, 0) With Nowait
			
		Delete [dbo].[AggSpecAllowedValue]
			From [dbo].[AggSpecAllowedValue]
			Inner Join [dbo].[AggSpecDiscreteMeas]
			On AggSpecAllowedValue.AggSpecDiscreteMeasID = AggSpecDiscreteMeas.AggSpecDiscreteMeasID
			Inner Join [dbo].[#AggSpecIDs]
			On AggSpecDiscreteMeas.AggSpecID = #AggSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Spec Discrete Meases', 0, 0) With Nowait
	
		Delete [dbo].[AggSpecDiscreteMeas]
			From [dbo].[AggSpecDiscreteMeas]
			Inner Join [dbo].[#AggSpecIDs]
			On AggSpecDiscreteMeas.AggSpecID = #AggSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Agg Alert Info', 0, 0) With Nowait
	
		Delete [dbo].[AggAlertViolationSingle]
			From [dbo].[AggAlertViolationSingle]
			Inner Join [dbo].[AggSpecMeas]
			On AggAlertViolationSingle.AggSpecMeasID = AggSpecMeas.AggSpecMeasID
			Inner Join [dbo].[#AggSpecIDs]
			On AggSpecMeas.AggSpecID = #AggSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Aggregate Spec Meases', 0, 0) With Nowait
	
		Delete [dbo].[AggSpecMeas]
			From [dbo].[AggSpecMeas]
			Inner Join [dbo].[#AggSpecIDs]
			On AggSpecMeas.AggSpecID = #AggSpecIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Aggregate Specs', 0, 0) With Nowait
	
		Delete [dbo].[AggSpec]
			From [dbo].[AggSpec]
			Inner Join [dbo].[#AggSpecIDs]
			On AggSpec.AggSpecID = #AggSpecIDs.ID
		----------------------------------------------------------------------------------------------------------------
		
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Materials', 0, 0) With Nowait
		
		Delete [dbo].[Material]
		From [dbo].[Material]
		Inner Join [dbo].[#PlantIDs]
		On Material.PlantCode = #PlantIDs.Code

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove QDrum Mix Links', 0, 0) With Nowait
	
		Update [dbo].[DLBatchLinkInfo]
			Set DLBatchLinkInfo_MixLink = Null
			From [dbo].[DLBatchLinkInfo]
			Inner Join [dbo].[#MixIDs]
			On DLBatchLinkInfo.DLBatchLinkInfo_MixLink = #MixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove QDrum Batch Links', 0, 0) With Nowait
	
		Update [dbo].[DLBatchLinkInfo]
			Set DLBatchLinkInfo_BatchLink = Null
			From [dbo].[DLBatchLinkInfo]
			Inner Join [dbo].[#BatchIDs]
			On DLBatchLinkInfo.DLBatchLinkInfo_BatchLink = #BatchIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Success Log Info', 0, 0) With Nowait
			
		Delete [dbo].[iBatchDwnldSuccess]
			From [dbo].[iBatchDwnldSuccess]
			Inner Join [dbo].[#BatchIDs]
			On iBatchDwnldSuccess.BatchID = #BatchIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Group Batches', 0, 0) With Nowait
			
		Delete [dbo].[GroupBatch]
			From [dbo].[GroupBatch]
			Inner Join [dbo].[Batch]
			On GroupBatch.BatchID = Batch.BatchIdentifier
			Inner Join [dbo].[#BatchIDs]
			On Batch.Batchidentifier = #BatchIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Batch Groups', 0, 0) With Nowait
			
		Delete [dbo].[BatchGroup]
			From [dbo].[BatchGroup]
			Inner Join [dbo].[#BatchGroupIDs]
			On BatchGroup.BatchGroupID = #BatchGroupIDs.ID
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Mixes', 0, 0) With Nowait
			
		Delete [dbo].[Batch]
		From [dbo].[Batch]
		Inner Join [dbo].[#MixIDs]
		On Batch.BatchIdentifier = #MixIDs.ID

		Raiserror('', 0, 0) With Nowait
		Raiserror('Remove Batches', 0, 0) With Nowait
	
		Delete [dbo].[Batch]
		From [dbo].[Batch]
		Inner Join [dbo].[#BatchIDs]
		On Batch.BatchIdentifier = #BatchIDs.ID
		If @RemovePlants = 1
		Begin
			/*
			Delete [dbo].[District]
			From [dbo].[District]
			Inner Join [dbo].[#DistrictIDs]
			On District.DistrictIdentifier = #DistrictIDs.ID
			Left Join
			(
				Select #UnDelPlantIDs.DistrictCode
				From [dbo].[#UnDelPlantIDs]
				Group By #UnDelPlantIDs.DistrictCode
			) As UnDelDistricts
			On District.RGCode = UnDelDistricts.DistrictCode
			Where UnDelDistricts.DistrictCode Is Null
			*/
			Raiserror('', 0, 0) With Nowait
			Raiserror('Remove QDrum Plant Links', 0, 0) With Nowait

			Update [dbo].[DLBatchLinkInfo]
				Set DLBatchLinkInfo_PlantLink = Null
				From [dbo].[DLBatchLinkInfo]
				Inner Join [dbo].[#PlantIDs]
				On DLBatchLinkInfo.DLBatchLinkInfo_PlantLink = #PlantIDs.ID

			Raiserror('', 0, 0) With Nowait
			Raiserror('Delete Plant Contacts', 0, 0) With Nowait

			Delete [dbo].[PlantContact]
			From [dbo].[PlantContact]
			Inner Join [dbo].[#PlantIDs]
			On PlantContact.PlantID = #PlantIDs.ID

			Raiserror('', 0, 0) With Nowait
			Raiserror('Delete Project Plants', 0, 0) With Nowait
		
			Delete [dbo].[PlantForContract]
			From [dbo].[PlantForContract]
			Inner Join [dbo].[#PlantIDs]
			On PlantForContract.PlantID = #PlantIDs.ID
			
			Raiserror('', 0, 0) With Nowait
			Raiserror('Delete Project Plant Links', 0, 0) With Nowait
		
			Delete [dbo].[ProjectPlant_Link]
			From [dbo].[ProjectPlant_Link]
			Inner Join [dbo].[#PlantIDs]
			On ProjectPlant_Link.PlantLink = #PlantIDs.ID
		
			Raiserror('', 0, 0) With Nowait
			Raiserror('Clear Concrete Project Primary Yards', 0, 0) With Nowait
		
			Update ConcreteProject
				Set ConcreteProject.PrimaryYard_PlantId = 
					(
						Select Min(Plants.PlantId) As PlantID
							From dbo.Plants As Plants
							Left Join dbo.#PlantIDs As PlantIDs
							On Plants.PlantId = PlantIDs.ID
							Where	PlantIDs.ID Is Null And
									Plants.PlantKind = 'ConcreteYard' And
									Plants.IsProductPlant = 1
					)
			From dbo.ConcreteProject As ConcreteProject
			Inner Join dbo.#PlantIDs As PlantIDs
			On ConcreteProject.PrimaryYard_PlantId = PlantIDs.ID

			Raiserror('', 0, 0) With Nowait
			Raiserror('Delete Plants Linked To Yards', 0, 0) With Nowait

			Delete Plant
			From [dbo].[Plant] As Plant
			Inner Join [dbo].[#PlantIDs]
			On Plant.PlantIdentifier = #PlantIDs.ID
			Where Plant.PlantIDForYard Is Not Null
		
			Raiserror('', 0, 0) With Nowait
			Raiserror('Delete Plants Not Linked To Yards', 0, 0) With Nowait

			Delete [dbo].[Plant]
			From [dbo].[Plant]
			Inner Join [dbo].[#PlantIDs]
			On Plant.PlantIdentifier = #PlantIDs.ID
		End
		
		If Object_ID('TempDB..#PlantIDs') Is Not Null
		Begin
			Drop Table [dbo].[#PlantIDs]
		End 
	
		If Object_ID('TempDB..#UnDelPlantIDs') Is Not Null
		Begin
			Drop Table [dbo].[#UnDelPlantIDs]
		End 
	
		If Object_ID('TempDB..#DistrictIDs') Is Not Null
		Begin
			Drop Table [dbo].[#DistrictIDs]
		End 
	
		If Object_ID('TempDB..#BatchIDs') Is Not Null
		Begin
			Drop Table [dbo].[#BatchIDs]
		End 
	
		If Object_ID('TempDB..#MixIDs') Is Not Null
		Begin
			Drop Table [dbo].[#MixIDs]
		End 
	
		If Object_ID('TempDB..#MixSpecIDs') Is Not Null
		Begin
			Drop Table [dbo].[#MixSpecIDs]
		End 
	
		If Object_ID('TempDB..#ContractMixSpecIDs') Is Not Null
		Begin
			Drop Table [dbo].[#ContractMixSpecIDs]
		End 
	
		If Object_ID('TempDB..#MixSpecIDs') Is Not Null
		Begin
			Drop Table [dbo].[#BatchIDs]
		End 
	
		If Object_ID('TempDB..#GradingIDs') Is Not Null
		Begin
			Drop Table [dbo].[#GradingIDs]
		End 
	
		If Object_ID('TempDB..#BackupDataIDs') Is Not Null
		Begin
			Drop Table [dbo].[#BackupDataIDs]
		End 
	
		If Object_ID('TempDB..#SubmittalIDs') Is Not Null
		Begin
			Drop Table [dbo].[#SubmittalIDs]
		End 
	
		If Object_ID('TempDB..#SubmittalMixIDs') Is Not Null
		Begin
			Drop Table [dbo].[#SubmittalMixIDs]
		End 
	
		If Object_ID('TempDB..#SubMixGradingIDs') Is Not Null
		Begin
			Drop Table [dbo].[#SubMixGradingIDs]
		End 
	
		If Object_ID('TempDB..#BatchGroupIDs') Is Not Null
		Begin
			Drop Table [dbo].[#BatchGroupIDs]
		End 
	
		If Object_ID('TempDB..#AggregateIDs') Is Not Null
		Begin
			Drop Table [dbo].[#AggregateIDs]
		End 
	
		If Object_ID('TempDB..#AggSpecIDs') Is Not Null
		Begin
			Drop Table [dbo].[#AggSpecIDs]
		End 
	
		If Object_ID('TempDB..#AggSampleIDs') Is Not Null
		Begin
			Drop Table [dbo].[#AggSampleIDs]
		End 
	
		If Object_ID('TempDB..#AggMeasSetIDs') Is Not Null
		Begin
			Drop Table [dbo].[#AggMeasSetIDs]
		End 
	
		/*
		If Object_ID('TempDB..#KeepPlantIDs') Is Not Null
		Begin
			Drop Table [dbo].[#KeepPlantIDs]
		End 
		*/
	
		/*
		If Object_ID('TempDB..#RemovePlantIDs') Is Not Null
		Begin
			Drop Table [dbo].[#RemovePlantIDs]
		End 
		*/
				
		Commit Transaction

		Raiserror('', 0, 0) With Nowait
		Raiserror('The Plant Data may have been removed.', 0, 0) With Nowait
		
	End Try
	Begin Catch
		If @@TranCount > 0
		Begin
			Rollback Transaction
			
			Raiserror('', 0, 0) With Nowait
			Raiserror('Transaction Rolled Back.', 0, 0) With Nowait
		End
        
		Select  @ErrorMessage = Error_message(),
				@ErrorSeverity = Error_severity()
			
		Raiserror('', 0, 0) With Nowait
		Raiserror('Failed to Remove Plants, Mixes, Batches, Materials, Etc.  Transaction Rolled Back.', 0, 0) With Nowait
		Print 'Error Message: ' + @ErrorMessage + '. Error Severity: ' + Cast(@ErrorSeverity As Nvarchar)
		
		Raiserror(@ErrorMessage, @ErrorSeverity, 1)
	End Catch
End		
Go