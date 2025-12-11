/*
	Add Stored Procedures to remove Mixes, Batches, and Batch Specimens from the database.

	This script is only for User Quadrel Databases, not iServiceDataExchange.
*/
--Add Stored Procedures to remove Mixes, Batches, and Batch Specimens from the database.  This script is only for User Quadrel Databases, not iServiceDataExchange.
If ObjectProperty(Object_ID(N'[dbo].[ACIBatchViewDetails]'), N'IsUserTable') = 1
Begin
	If Not Exists (Select ScriptID From [dbo].[DBState] Where ScriptID = 1274)
	Begin
		Insert Into [dbo].[DBState] (ScriptID, ScriptName, ReleaseName, DateCreated, DateApplied, ScriptDescription) 
		    Values (1274, '1274 - Add Stored Procedures To Remove Mixes And Batches And Batch Specimens.sql', 'International_Release', Convert(Datetime, '03/08/2012', 101), Current_TimeStamp, 'Add Stored Procedures to remove Mixes, Batches, and Batch Specimens from the database.  This script is only for User Quadrel Databases, not iServiceDataExchange.')
	End
End
Go

If dbo.Validation_StoredProcedureExists('Utility_PrintMessage') = 1
Begin
	Drop procedure [dbo].[Utility_PrintMessage]
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create Date: 01/16/2015
-- Description:	Exec dbo.Utility_PrintMessage Message.
-- ================================================================================================
Create Procedure [dbo].[Utility_PrintMessage]
(
	@Message Nvarchar (Max)
)
As
Begin
	Raiserror(@Message, 0, 0) With Nowait
End
Go

If  Objectproperty(Object_id(N'[dbo].[BatchSpecimen_RemoveAllSpecimensByBatchIDTempTable]'), N'IsProcedure') = 1
Begin
    Drop Procedure [dbo].[BatchSpecimen_RemoveAllSpecimensByBatchIDTempTable]
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 02/20/2012
-- Description:	Remove Batch Specimens Linked To Batches With Batch IDs in the Temporary Table.
-- ================================================================================================
Create Procedure [dbo].[BatchSpecimen_RemoveAllSpecimensByBatchIDTempTable]
(
    @BatchIDTempTableName		Nvarchar(255),	--Temporary Table Name containing the Batch IDs.
    @BatchIDFieldName			Nvarchar(255),	--Field Name of Batch ID in the Temporary Table.
    @DeleteUnusedGenSpmnNumbers Bit				--Indicates if unused Generated Specimen Numbers should be deleted.
)
As
Begin
    Declare @TempTable Nvarchar(255)
    Declare @FieldName Nvarchar(255)
    Declare @BatchIDList Table (BatchID Int)
    Declare @GeneratedIDList Table (GeneratedID Int)
    Declare @NewLine Nvarchar(10)
    Declare @ErrorMessage Nvarchar(Max)
	Declare @ErrorSeverity Int
	Declare @ErrorState Int
    
    Set @TempTable = Ltrim(Rtrim(Isnull(@BatchIDTempTableName, '')))
    Set @FieldName = Ltrim(Rtrim(Isnull(@BatchIDFieldName, '')))
    
    Set @NewLine = dbo.GetNewLine()
    
    If  dbo.Validation_TemporaryTableExists(@TempTable) = 1 And
        dbo.Validation_FieldExistsInTemporaryTable(@TempTable, @FieldName) = 1
    Begin
        Insert Into @BatchIDList
        (
            BatchID
        )
        Exec    
        (
			'Select BatchInfo.BatchIdentifier As BatchID ' + @NewLine +
			'	From dbo.vwBatches As BatchInfo ' + @NewLine +
			'	Inner Join [' + @TempTable + '] As BatchIDList ' + @NewLine +
			'	On BatchInfo.BatchIdentifier = BatchIDList.[' + @FieldName + '] ' + @NewLine +
			'	Group By BatchInfo.BatchIdentifier ' + @NewLine
		) 
        
        Begin try
			Begin Transaction

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete StrnPara Data 1'
			
			Delete StrnPara
				From dbo.STRNPARA As StrnPara
				Inner Join dbo.vwBatches As BatchInfo
				On  StrnPara.BatchID = BatchInfo.BATCHIDENTIFIER
				Inner Join @BatchIDList As BatchIDList
				On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete StrnPara Data 2'
			
			Delete StrnPara
				From dbo.STRNPARA As StrnPara
				Inner Join dbo.vwBatches As BatchInfo
				On  Right(StrnPara.CODE, 10) = Right(BatchInfo.BatchCrushLink, 10)
				Inner Join @BatchIDList As BatchIDList
				On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	        
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete Crush Data 1'
			
			Delete Crush
				From dbo.Crush As Crush
				Inner Join dbo.Test As Test
				On  Test.TESTIDENTIFIER = Crush.TestID
				Inner Join dbo.TESTINFO As TestInfo
				On  TestInfo.TESTINFOIDENTIFIER = Test.TestInfoID
				Inner Join dbo.vwBatches As BatchInfo
				On  TestInfo.BatchID = BatchInfo.BATCHIDENTIFIER
				Inner Join @BatchIDList As BatchIDList
				On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
				
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete Crush Data 2'
			
			Delete Crush
				From dbo.Crush As Crush 
				Inner Join @BatchIDList As BatchIDList
				On BatchIDList.BatchID = Crush.BatchID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete Crush Data 3'
			
			Delete Crush
				From dbo.Crush As Crush 
                Inner Join dbo.vwBatches As BatchInfo
                On Right(Crush.CRUSHCODE, 10) = Right(BatchInfo.BatchCrushLink, 10)
				Inner Join @BatchIDList As BatchIDList
				On BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	                        
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Get Generated ID Data 1'
			
			Insert into @GeneratedIDList (GeneratedID)
				Select GeneratedBatchSpecimenNumber.GeneratedBatchSpecimenNumberID
					From dbo.GeneratedBatchSpecimenNumber As GeneratedBatchSpecimenNumber
					Inner Join dbo.Test As Test
					On  Test.GeneratedBatchSpecimenNumberID = GeneratedBatchSpecimenNumber.GeneratedBatchSpecimenNumberID
					Inner Join dbo.TESTINFO As TestInfo
					On  TestInfo.TESTINFOIDENTIFIER = Test.TestInfoID
					Inner Join dbo.vwBatches As BatchInfo
					On  TestInfo.BatchID = BatchInfo.BATCHIDENTIFIER
					Inner Join @BatchIDList As BatchIDList
					On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	        
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete Test Data'
			
			Delete Test
				From dbo.Test As Test
				Inner Join dbo.TESTINFO As TestInfo
				On  TestInfo.TESTINFOIDENTIFIER = Test.TestInfoID
				Inner Join dbo.vwBatches As BatchInfo
				On  TestInfo.BatchID = BatchInfo.BATCHIDENTIFIER
				Inner Join @BatchIDList As BatchIDList
				On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	        
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete TestMeasurement Data'
			
			Delete TestMeasurement
				From dbo.TestMeasurement As TestMeasurement
				Inner Join dbo.DataPoint As DataPoint
				On  DataPoint.DtptID = TestMeasurement.TestMeasDataPointLink
				Inner Join dbo.DataSet As DataSet
				On  DataSet.DtstID = DataPoint.DtptDataSetLink
				Inner Join dbo.SpecimenTest As SpecimenTest
				On  SpecimenTest.SpmnTestID = DataSet.DtstSpmnTestLink
				Inner Join dbo.MaterialSpecimen As MaterialSpecimen
				On  MaterialSpecimen.MtrlSpmnID = SpecimenTest.SpmnTestMtrlSpmnLink
				Inner Join dbo.vwBatches As BatchInfo
				On  MaterialSpecimen.MtrlSpmnBatchLink = BatchInfo.BATCHIDENTIFIER
				Inner Join @BatchIDList As BatchIDList
				On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	        
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete DataPoint Data'
			
			Delete DataPoint
				From dbo.DataPoint As DataPoint
				Inner Join dbo.DataSet As DataSet
				On  DataSet.DtstID = DataPoint.DtptDataSetLink
				Inner Join dbo.SpecimenTest As SpecimenTest
				On  SpecimenTest.SpmnTestID = DataSet.DtstSpmnTestLink
				Inner Join dbo.MaterialSpecimen As MaterialSpecimen
				On  MaterialSpecimen.MtrlSpmnID = SpecimenTest.SpmnTestMtrlSpmnLink
				Inner Join dbo.vwBatches As BatchInfo
				On  MaterialSpecimen.MtrlSpmnBatchLink = BatchInfo.BATCHIDENTIFIER
				Inner Join @BatchIDList As BatchIDList
				On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	        
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete DataSet Data'
			
			Delete DataSet
				From dbo.DataSet As DataSet
				Inner Join dbo.SpecimenTest As SpecimenTest
				On  SpecimenTest.SpmnTestID = DataSet.DtstSpmnTestLink
				Inner Join dbo.MaterialSpecimen As MaterialSpecimen
				On  MaterialSpecimen.MtrlSpmnID = SpecimenTest.SpmnTestMtrlSpmnLink
				Inner Join dbo.vwBatches As BatchInfo
				On  MaterialSpecimen.MtrlSpmnBatchLink = BatchInfo.BATCHIDENTIFIER
				Inner Join @BatchIDList As BatchIDList
				On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	        
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete SpecimenTest Data'
			
			Delete SpecimenTest
				From dbo.SpecimenTest As SpecimenTest
				Inner Join dbo.MaterialSpecimen As MaterialSpecimen
				On  MaterialSpecimen.MtrlSpmnID = SpecimenTest.SpmnTestMtrlSpmnLink
				Inner Join dbo.vwBatches As BatchInfo
				On  MaterialSpecimen.MtrlSpmnBatchLink = BatchInfo.BATCHIDENTIFIER
				Inner Join @BatchIDList As BatchIDList
				On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	        
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete SplitTensileTest Data'
			
			Delete SplitTensileTest
				From dbo.SplitTensileTest As SplitTensileTest
				Inner Join dbo.MaterialSpecimen As MaterialSpecimen
				On  MaterialSpecimen.MtrlSpmnID = SplitTensileTest.MtlSpmnID
				Inner Join dbo.vwBatches As BatchInfo
				On  MaterialSpecimen.MtrlSpmnBatchLink = BatchInfo.BATCHIDENTIFIER
				Inner Join @BatchIDList As BatchIDList
				On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	        
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete DurabilityTest Data'
			
			Delete DurabilityTest
				From dbo.DurabilityTest As DurabilityTest
				Inner Join dbo.MaterialSpecimen As MaterialSpecimen
				On  MaterialSpecimen.MtrlSpmnID = DurabilityTest.MaterialSpecimenID
				Inner Join dbo.vwBatches As BatchInfo
				On  MaterialSpecimen.MtrlSpmnBatchLink = BatchInfo.BATCHIDENTIFIER
				Inner Join @BatchIDList As BatchIDList
				On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	        
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Get Generated ID Data 2'
			
			Insert into @GeneratedIDList (GeneratedID)
				Select GeneratedBatchSpecimenNumber.GeneratedBatchSpecimenNumberID
					From dbo.GeneratedBatchSpecimenNumber As GeneratedBatchSpecimenNumber
					Inner Join dbo.MaterialSpecimen As MaterialSpecimen
					On  MaterialSpecimen.GeneratedBatchSpecimenNumberID = GeneratedBatchSpecimenNumber.GeneratedBatchSpecimenNumberID
					Inner Join dbo.vwBatches As BatchInfo
					On  MaterialSpecimen.MtrlSpmnBatchLink = BatchInfo.BATCHIDENTIFIER
					Inner Join @BatchIDList As BatchIDList
					On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	        
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete MaterialSpecimen Data'
			
			Delete MaterialSpecimen
				From dbo.MaterialSpecimen As MaterialSpecimen
				Inner Join dbo.vwBatches As BatchInfo
				On  MaterialSpecimen.MtrlSpmnBatchLink = BatchInfo.BATCHIDENTIFIER
				Inner Join @BatchIDList As BatchIDList
				On  BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
	            
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete GeneratedBatchSpecimenNumber Data'
			
			Delete GeneratedBatchSpecimenNumber
				From dbo.GeneratedBatchSpecimenNumber As GeneratedBatchSpecimenNumber
				Inner Join @GeneratedIDList As GeneratedIDList
				On GeneratedBatchSpecimenNumber.GeneratedBatchSpecimenNumberID = GeneratedIDList.GeneratedID
				
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Clear Crush Codes'
			
			Update BatchInfo
				Set CRUSHCODE = 'S97000000000'
				From dbo.BATCH As BatchInfo
				Inner Join @BatchIDList As BatchIDList
				On BatchInfo.BATCHIDENTIFIER = BatchIDList.BatchID
			
			If Isnull(@DeleteUnusedGenSpmnNumbers, 0) = 1
			Begin
				Exec dbo.Utility_PrintMessage ''
				Exec dbo.Utility_PrintMessage 'Batch Specimen Data - Delete Unused GeneratedBatchSpecimenNumber Data'
				
                Delete GeneratedBatchSpecimenNumber 
					From dbo.GeneratedBatchSpecimenNumber As GeneratedBatchSpecimenNumber
					Left Join 
					(
						Select Test.TESTIDENTIFIER As SpecimenID, Test.GeneratedBatchSpecimenNumberID
							From dbo.TEST As Test
						
						Union All 
						
						Select MaterialSpecimen.MtrlSpmnID As SpecimenID, MaterialSpecimen.GeneratedBatchSpecimenNumberID
							From dbo.MaterialSpecimen As MaterialSpecimen
					) As TestData
					On TestData.GeneratedBatchSpecimenNumberID = GeneratedBatchSpecimenNumber.GeneratedBatchSpecimenNumberID
					Where TestData.SpecimenID Is Null
			End
			
			Commit Transaction

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'The Batch Specimens were removed.'

        End Try
        Begin catch
			Rollback Transaction
			
			Select  @ErrorMessage = Error_message(),
					@ErrorSeverity = Error_severity(),
					@ErrorState = Error_state()
			
			Raiserror (
						  @ErrorMessage,	-- Message text.
						  @ErrorSeverity,	-- Severity.
						  @ErrorState -- State.
					  )
        End Catch
    End
End
Go

If ObjectProperty(Object_ID(N'[dbo].[BatchMaintenance_RemoveBatchesByBatchIDTempTable]'), N'IsProcedure') = 1 
Begin
    Drop Procedure [dbo].[BatchMaintenance_RemoveBatchesByBatchIDTempTable]
End
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 09/21/2010
-- Description:	Remove Batches specified in the Batch ID Temporary Table.
-- ================================================================================================
Create Procedure [dbo].[BatchMaintenance_RemoveBatchesByBatchIDTempTable]
	@BatchIDTempTableName Nvarchar (255),
	@BatchIDFieldName Nvarchar (255),
    @DeleteUnusedGenSetNumbers	Bit,			--Indicates if unused Generated Set Numbers should be deleted.
    @DeleteUnusedGenSpmnNumbers Bit				--Indicates if unused Generated Specimen Numbers should be deleted.
As
Begin
	Declare @NewLine Nvarchar (10)
    Declare @GeneratedIDList Table (GeneratedID Int)
    Declare @ErrorMessage   Nvarchar(Max)
    Declare @ErrorSeverity  Int
	
	Set @BatchIDTempTableName = Ltrim(Rtrim(Isnull(@BatchIDTempTableName, '')))
	Set @BatchIDFieldName = LTrim(Rtrim(Isnull(@BatchIDFieldName, '')))
	
    Begin Try
		Set @NewLine = dbo.GetNewLine()
	
		If	dbo.Validation_FieldExistsInTemporaryTable(@BatchIDTempTableName, @BatchIDFieldName) = 1 And
			@BatchIDTempTableName <> '#InternalBatchInfo1'
		Begin
			Begin Transaction
			
			If Object_id(N'TempDB..#InternalBatchInfo1') Is Not Null
			Begin
				Drop table #InternalBatchInfo1
			End

			Create table #InternalBatchInfo1
			(
				BatchID Int,
				CrushCode Nvarchar (50),
				Primary Key Clustered
				(
					BatchID
				)
			)
			
			Exec
			(
				'Insert Into #InternalBatchInfo1 (BatchID, CrushCode) ' + @NewLine +
				'	Select Batch.BatchIdentifier, Batch.BatchCrushLink ' + @NewLine +
				'		From dbo.vwBatches As Batch ' + @NewLine +
				'		Inner Join [' + @BatchIDTempTableName + '] As BatchInfo ' + @NewLine +
				'		On Batch.BatchIdentifier = BatchInfo.[' + @BatchIDFieldName + '] ' + @NewLine +
				'		Group By Batch.BatchIdentifier, Batch.BatchCrushLink ' + @NewLine
			)

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Get Generated ID Data'
			
			Insert into @GeneratedIDList (GeneratedID)
				Select GeneratedBatchSetNumber.GeneratedBatchSetNumberID
					From dbo.GeneratedBatchSetNumber As GeneratedBatchSetNumber
					Inner Join dbo.TESTINFO As TestInfo
					On TestInfo.GeneratedBatchSetNumberID = GeneratedBatchSetNumber.GeneratedBatchSetNumberID
					Inner Join dbo.vwBatches As BatchInfo
					On  TestInfo.BatchID = BatchInfo.BATCHIDENTIFIER
					Inner Join #InternalBatchInfo1 As InternalBatchInfo1
					On BatchInfo.BATCHIDENTIFIER = InternalBatchInfo1.BatchID
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete Batch Specimen Data'
			
            Exec [dbo].[BatchSpecimen_RemoveAllSpecimensByBatchIDTempTable] '#InternalBatchInfo1', 'BatchID', @DeleteUnusedGenSpmnNumbers
            		
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete MaterialRecipe Data'
			
			Delete MaterialRecipe
			From dbo.MaterialRecipe As MaterialRecipe
			Inner Join dbo.BATCH As Batch
			On	MaterialRecipe.EntityID = Batch.BATCHIDENTIFIER And
				MaterialRecipe.EntityType = 'Batch' And
				Batch.NameID Is Null
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete TestInfo Data'
			
			Delete TestInfo
			From dbo.TestInfo As TestInfo
			Inner Join dbo.vwBatches As Batch
			On TestInfo.BatchID = Batch.BATCHIDENTIFIER
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete GeneratedBatchSetNumber Data'
			
            Delete GeneratedBatchSetNumber
            From dbo.GeneratedBatchSetNumber As GeneratedBatchSetNumber
            Inner Join @GeneratedIDList As GeneratedIDList 
            On GeneratedBatchSetNumber.GeneratedBatchSetNumberID = GeneratedIDList.GeneratedID
            
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete DLBatchLinkInfo Data'
			
			Delete DLBatchLinkInfo
			From dbo.DLBatchLinkInfo As DLBatchLinkInfo
			Inner Join dbo.vwBatches As Batch
			On DLBatchLinkInfo.DLBatchLinkInfo_BatchLink = Batch.BATCHIDENTIFIER
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete GroupBatch Data'
			
			Delete GroupBatch
			From dbo.GroupBatch As GroupBatch
			Inner Join dbo.vwBatches As Batch
			On GroupBatch.BatchID = Batch.BATCHIDENTIFIER
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete BatchGroup Data'
			
			Delete BatchGroup 
			From dbo.BatchGroup As BatchGroup
			Left Join
			(
				Select GroupBatch.BatchGroupID
				From dbo.GroupBatch As GroupBatch
				Group By GroupBatch.BatchGroupID
			) As GroupBatch
			On GroupBatch.BatchGroupID = BatchGroup.BatchGroupID
			Where GroupBatch.BatchGroupID Is Null
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete iBatchDwnldSuccess Data'
			
			Delete iBatchDwnldSuccess
			From dbo.iBatchDwnldSuccess As iBatchDwnldSuccess
			Inner Join dbo.vwBatches As Batch
			On iBatchDwnldSuccess.BatchID = Batch.BATCHIDENTIFIER
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete Grouping Data'
			
			Delete Grouping
			From dbo.[GROUPING] As Grouping
			Inner Join dbo.vwBatches As Batch
			On Grouping.BATCHCODE = Batch.BatchCode
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID
            
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete TimeDependentMeas Data'
			
            Delete TimeDependentMeas
            From dbo.TimeDependentMeas As TimeDependentMeas
            Inner Join dbo.TimeDependentMeasGroup As TimeDependentMeasGroup
            On TimeDependentMeasGroup.TimeDependentMeasGroupID = TimeDependentMeas.TimeDependentMeasGroupID
            Inner Join dbo.TimeDependentTest As TimeDependentTest
            On TimeDependentTest.TimeDependentTestID = TimeDependentMeasGroup.TimeDependentTestID
            Inner Join dbo.vwBatches As Batch
            On TimeDependentTest.BatchID = Batch.BATCHIDENTIFIER
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete TimeDependentMeasGroup Data'
			
            Delete TimeDependentMeasGroup
            From dbo.TimeDependentMeasGroup As TimeDependentMeasGroup
            Inner Join dbo.TimeDependentTest As TimeDependentTest
            On TimeDependentTest.TimeDependentTestID = TimeDependentMeasGroup.TimeDependentTestID
            Inner Join dbo.vwBatches As Batch
            On TimeDependentTest.BatchID = Batch.BATCHIDENTIFIER
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete TimeDependentAge Data'
			
            Delete TimeDependentAge
            From dbo.TimeDependentAge As TimeDependentAge
            Inner Join dbo.TimeDependentTest As TimeDependentTest
            On TimeDependentTest.TimeDependentTestID = TimeDependentAge.TimeDependentTestID
            Inner Join dbo.vwBatches As Batch
            On TimeDependentTest.BatchID = Batch.BATCHIDENTIFIER
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete TimeDependentTest Data'
			
            Delete TimeDependentTest
            From dbo.TimeDependentTest As TimeDependentTest
            Inner Join dbo.vwBatches As Batch
            On TimeDependentTest.BatchID = Batch.BATCHIDENTIFIER
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID
            
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Clear Submittal Reference Batch Data'
			
            Update SubmittalMix
                Set ReferenceBatchID = Null, ReferenceBatchName = Null
            From dbo.SubmittalMix As SubmittalMix
            Inner Join dbo.vwBatches As Batch 
            On SubmittalMix.ReferenceBatchID = Batch.BATCHIDENTIFIER
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID
            
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Batch Data - Delete Batch Data'
			
			Delete Batch
			From dbo.Batch As Batch
			Inner Join #InternalBatchInfo1 As InternalBatchInfo1
			On Batch.BATCHIDENTIFIER = InternalBatchInfo1.BatchID

			If Isnull(@DeleteUnusedGenSetNumbers, 0) = 1
			Begin		
				Exec dbo.Utility_PrintMessage ''
				Exec dbo.Utility_PrintMessage 'Batch Data - Delete Unused GeneratedBatchSetNumber Data'
				
                Delete GeneratedBatchSetNumber
					From dbo.GeneratedBatchSetNumber As GeneratedBatchSetNumber
					Left Join dbo.TESTINFO As TestInfo
					On TestInfo.GeneratedBatchSetNumberID = GeneratedBatchSetNumber.GeneratedBatchSetNumberID
					Where TestInfo.TESTINFOIDENTIFIER Is Null
			End
			
			If Object_id(N'TempDB..#InternalBatchInfo1') Is Not Null
			Begin
				Drop table #InternalBatchInfo1
			End
			
			Commit Transaction

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'The Batches were removed.'
		End
    End Try
    Begin Catch
        If @@TranCount > 0
        Begin
            Rollback Transaction
        End
        
        Select  @ErrorMessage = Error_message(),
                @ErrorSeverity = Error_severity()
        
        Raiserror(@ErrorMessage, @ErrorSeverity, 1)
    End Catch
End
Go

If ObjectProperty(Object_ID(N'[dbo].[MixMaintenance_RemoveMixesByMixIDTempTable]'), N'IsProcedure') = 1 
Begin
    Drop Procedure [dbo].[MixMaintenance_RemoveMixesByMixIDTempTable]
End
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 09/21/2010
-- Description:	Remove Mixes specified in the Mix ID Temporary Table.
-- ================================================================================================
Create Procedure [dbo].[MixMaintenance_RemoveMixesByMixIDTempTable]
	@MixIDTempTableName Nvarchar (255),
	@MixIDFieldName Nvarchar (255),
	@RemoveEmptySubmittals Bit,
    @DeleteUnusedGenSetNumbers	Bit,			--Indicates if unused Generated Set Numbers should be deleted.
    @DeleteUnusedGenSpmnNumbers Bit				--Indicates if unused Generated Specimen Numbers should be deleted.
As
Begin
	Declare @NewLine Nvarchar (10)

    Declare @ErrorMessage   Nvarchar(Max)
    Declare @ErrorSeverity  Int
	
	Declare @MixSpecInfo Table (MixSpecID Int, Primary Key Clustered (MixSpecID))
	Declare @BackUpDataInfo Table (BackupDataID Int, Primary Key Clustered (BackupDataID))
	Declare @GradationInfo Table (GradationInfoID Int, Primary Key Clustered (GradationInfoID))
	Declare @OnlySubmittalMixInfo Table (OnlySubmittalMixInfoID Int, Primary Key Clustered (OnlySubmittalMixInfoID))
	Declare @SubmittalInfo Table (SubmittalID Int, Primary Key Clustered (SubmittalID))
	Declare @SubmittalsToDelete Table (SubmittalID Int, Primary Key Clustered (SubmittalID))
	
	Set @MixIDTempTableName = Ltrim(Rtrim(Isnull(@MixIDTempTableName, '')))
	Set @MixIDFieldName = LTrim(Rtrim(Isnull(@MixIDFieldName, '')))

    Begin Try
		Set @NewLine = dbo.GetNewLine()
		
		If	dbo.Validation_FieldExistsInTemporaryTable(@MixIDTempTableName, @MixIDFieldName) = 1 And
			@MixIDTempTableName <> '#InternalMixInfo1' And
			@MixIDTempTableName <> '#InternalMixBatchInfo1'
		Begin
			Begin Transaction
			
			If Object_id(N'TempDB..#InternalMixInfo1') Is Not Null
			Begin
				Drop table #InternalMixInfo1
			End

			If Object_id(N'TempDB..#InternalMixBatchInfo1') Is Not Null
			Begin
				Drop table #InternalMixBatchInfo1
			End

			Create table #InternalMixInfo1
			(
				MixID Int,
				MixCode Nvarchar (50),
				MixNameCode Nvarchar (50),
				MixSpecID Int,
				GradationInfoID Int,
				BackUpDataID Int,
				Primary Key Clustered
				(
					MixID
				)
			)
			
			Create table #InternalMixBatchInfo1
			(
				BatchID Int,
				Primary Key Clustered
				(
					BatchID
				)
			)
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Retrieve the Mix Information for Mixes that will be removed'

			Exec
			(
				'Insert Into #InternalMixInfo1 (MixID, MixCode, MixNameCode, MixSpecID, GradationInfoID, BackupDataID) ' + @NewLine +
				'	Select Mix.MixIdentifier, Mix.MixCode, Mix.MixNameCode, Mix.MixSpecID, Mix.SubmittalGradationID, Mix.BackupDataID ' + @NewLine +
				'		From dbo.vwMixes As Mix ' + @NewLine +
				'		Inner Join [' + @MixIDTempTableName + '] As MixInfo ' + @NewLine +
				'		On Mix.MixIdentifier = MixInfo.[' + @MixIDFieldName + '] ' + @NewLine +
				'		Group By Mix.MixIdentifier, Mix.MixCode, Mix.MixNameCode, Mix.MixSpecID, Mix.SubmittalGradationID, Mix.BackupDataID ' + @NewLine
			)
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Retrieve the Batch Information of Batches that will be removed'

			Insert into #InternalMixBatchInfo1 (BatchID)
				Select Batch.BATCHIDENTIFIER
				From dbo.vwBatches As Batch
				Inner Join dbo.vwMixes As Mix
				On Batch.BatchMixLink = Mix.MixNameCode
				Inner Join #InternalMixInfo1 As MixInfo
				On Mix.MixIdentifier = MixInfo.MixID
				Group By Batch.BATCHIDENTIFIER
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove the Batches'

			Exec [dbo].[BatchMaintenance_RemoveBatchesByBatchIDTempTable] '#InternalMixBatchInfo1', 'BatchID', @DeleteUnusedGenSetNumbers, @DeleteUnusedGenSpmnNumbers

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'The Batches were removed'
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Retrieve the Mix Spec Information of Mix Specs that will be removed'

			Insert into @MixSpecInfo (MixSpecID)
				Select MixSpecInfo.MixSpecID
				From 
				(
					Select MixInfo.MixSpecID
					From #InternalMixInfo1 As MixInfo
					Where MixInfo.MixSpecID Is Not Null
					
					Union All 
					
					Select ContractMix.MixSpecID
					From dbo.MixForContract As ContractMix
					Inner Join #InternalMixInfo1 As MixInfo
					On MixInfo.MixID = ContractMix.MixID
					Where ContractMix.MixSpecID Is Not Null 
				) As MixSpecInfo
				Inner Join dbo.MixSpec As MixSpec
				On MixSpecInfo.MixSpecID = MixSpec.MixSpecID
				Where Ltrim(Rtrim(Isnull(MixSpec.[Name], ''))) = ''
				Group By MixSpecInfo.MixSpecID
				
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Retrieve Gradation Information of Gradations that will be removed'

			Insert into @GradationInfo (GradationInfoID)
				Select GradationInfo.GradationInfoID
				From 
				(
					Select MixInfo.GradationInfoID
					From #InternalMixInfo1 As MixInfo
					Where MixInfo.GradationInfoID Is Not Null
					
					Union All 
					
					Select SubmittalMix.SubmittalGradationID As GradationInfoID 
					From dbo.SubmittalMix As SubmittalMix
					Inner Join #InternalMixInfo1 As MixInfo
					On MixInfo.MixID = SubmittalMix.MixID
					Where SubmittalMix.SubmittalGradationID Is Not null
				) As GradationInfo
				Group By GradationInfo.GradationInfoID
				 
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Retrieve Backup Information of Backup Information that will be removed'

			Insert into @BackUpDataInfo (BackupDataID)
				Select MixInfo.BackUpDataID
				From #InternalMixInfo1 As MixInfo
				Where MixInfo.BackUpDataID Is Not Null
				Group By MixInfo.BackUpDataID
				
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Retrieve Submittal Information of Submittals that will be removed'

			Insert into @OnlySubmittalMixInfo (OnlySubmittalMixInfoID)
				Select SubmittalMixInfo.OnlySubmittalMixID
				From 
				(
					Select OnlySubmittalMix.OnlySubmittalMixID
					From dbo.OnlySubmittalMix As OnlySubmittalMix
					Inner Join #InternalMixInfo1 As MixInfo
					On OnlySubmittalMix.OriginalMixID = MixInfo.MixID
					
					Union All 

					Select OnlySubmittalMix.OnlySubmittalMixID
					From dbo.OnlySubmittalMix As OnlySubmittalMix
					Inner Join #InternalMixInfo1 As MixInfo
					On OnlySubmittalMix.OriginalMixCode = MixInfo.MixCode
					
					Union All 
					
					Select SubmittalMix.OnlySubmittalMixID
					From dbo.SubmittalMix As SubmittalMix
					Inner Join #InternalMixInfo1 As MixInfo
					On SubmittalMix.MixID = MixInfo.MixID
					Where SubmittalMix.OnlySubmittalMixID Is Not Null
				) As SubmittalMixInfo
				Group By SubmittalMixInfo.OnlySubmittalMixID
				
			If IsNull(@RemoveEmptySubmittals, 0) = 1
			Begin
				Exec dbo.Utility_PrintMessage ''
				Exec dbo.Utility_PrintMessage 'Retrieve Submittal Information for Empty Submittals that will be removed'

				Insert into @SubmittalInfo (SubmittalID)
					Select SubmittalInfo.SubmittalID
					From
					(
						Select SubmittalNew.SubmittalID
						From dbo.SubmittalNew As SubmittalNew
						Inner Join dbo.SubmittalMix As SubmittalMix
						On SubmittalMix.SubmittalID = SubmittalNew.SubmittalID
						Inner Join #InternalMixInfo1 As MixInfo
						On SubmittalMix.MixID = MixInfo.MixID
						
						Union All

						Select SubmittalNew.SubmittalID
						From dbo.SubmittalNew As SubmittalNew
						Inner Join dbo.SubmittalMix As SubmittalMix
						On SubmittalMix.SubmittalID = SubmittalNew.SubmittalID
						Inner Join dbo.OnlySubmittalMix As OnlySubmittalMix
						On OnlySubmittalMix.OnlySubmittalMixID = SubmittalMix.OnlySubmittalMixID
						Inner Join #InternalMixInfo1 As MixInfo
						On OnlySubmittalMix.OriginalMixID = MixInfo.MixID
						
						Union All

						Select SubmittalNew.SubmittalID
						From dbo.SubmittalNew As SubmittalNew
						Inner Join dbo.SubmittalMix As SubmittalMix
						On SubmittalMix.SubmittalID = SubmittalNew.SubmittalID
						Inner Join dbo.OnlySubmittalMix As OnlySubmittalMix
						On OnlySubmittalMix.OnlySubmittalMixID = SubmittalMix.OnlySubmittalMixID
						Inner Join #InternalMixInfo1 As MixInfo
						On OnlySubmittalMix.OriginalMixCode = MixInfo.MixCode
					) As SubmittalInfo
					Group By SubmittalInfo.SubmittalID
			End 
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Retrieve Submittal Backup Information of Submittal Backup Items that will be removed'

			Update SubmittalBackup
				Set	SubmittalBackup.WCPMixID = Null, 
					SubmittalBackup.WCPMixName = Null,
					SubmittalBackup.WCPType = Null
			From dbo.SubmittalBackup As SubmittalBackup
			Inner Join #InternalMixInfo1 As MixInfo
			On SubmittalBackup.WCPMixID = MixInfo.MixID
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Clear some Information of Mixes that will be removed'

			Update Mix
				Set Mix.MixSpecID = Null, Mix.SubmittalGradationID = Null, Mix.BackupDataID = Null
			From dbo.vwMixes As Mix
			Inner Join #InternalMixInfo1 As MixInfo
			On Mix.MixIdentifier = MixInfo.MixID
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Clear Submittal Mix Information of Submittal Mixes that will be removed'

			Update SubmittalMix
				Set SubmittalMix.OnlySubmittalMixID = Null
			From dbo.SubmittalMix As SubmittalMix
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = SubmittalMix.MixID

			/*
			Update MixForContract
				Set MixForContract.MixSpecID = Null
			From dbo.MixForContract As MixForContract
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = MixForContract.MixID
			*/

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Clear Submittal Gradation Information of Submittal Mixes that will be removed'

			Update SubmittalMix
				Set SubmittalMix.SubmittalGradationID = Null
			From dbo.SubmittalMix As SubmittalMix
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = SubmittalMix.MixID 
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Recipes'

			Delete MaterialRecipe
			From dbo.MaterialRecipe As MaterialRecipe
			Inner Join dbo.Batch As Mix
			On	MaterialRecipe.EntityID = Mix.BATCHIDENTIFIER And
				MaterialRecipe.EntityType = 'Mix' And
				Mix.NameID Is Not Null
			Inner Join #InternalMixInfo1 As InternalMixInfo1
			On Mix.BATCHIDENTIFIER = InternalMixInfo1.MixID
						
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Submittal Gradations'

			Delete SubmittalGradation
			From dbo.SubmittalGradation As SubmittalGradation
			Inner Join @GradationInfo As GradationInfo
			On SubmittalGradation.SubmittalGradationID = GradationInfo.GradationInfoID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Submittal Backup Items'

			Delete SubmittalBackup
			From dbo.SubmittalBackup As SubmittalBackup
			Inner Join @BackUpDataInfo As BackUpDataInfo
			On SubmittalBackup.SubmittalBackupID = BackupDataInfo.BackupDataID
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Spec Meases'

			Delete SpecMeas 
			From dbo.SpecMeas As SpecMeas
			Inner Join dbo.SpecDataPoint As SpecDataPoint
			On SpecDataPoint.SpecDataPointID = SpecMeas.SpecDataPointID
			Inner Join dbo.MixSpec As MixSpec
			On MixSpec.MixSpecID = SpecDataPoint.MixSpecID
			Inner Join @MixSpecInfo As MixSpecInfo
			On MixSpecInfo.MixSpecID = MixSpec.MixSpecID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Spec Datapoints'

			Delete SpecDataPoint
			From dbo.SpecDataPoint As SpecDataPoint
			Inner Join dbo.MixSpec As MixSpec
			On MixSpec.MixSpecID = SpecDataPoint.MixSpecID
			Inner Join @MixSpecInfo As MixSpecInfo
			On MixSpecInfo.MixSpecID = MixSpec.MixSpecID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Spec Classes'

			Delete MixSpecClass
			From dbo.MixSpecClass As MixSpecClass
			Inner Join dbo.MixSpec As MixSpec
			On MixSpec.MixSpecID = MixSpecClass.MixSpecIDLink
			Inner Join @MixSpecInfo As MixSpecInfo
			On MixSpecInfo.MixSpecID = MixSpec.MixSpecID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Material Specs'

			Delete MixMaterialSpec
			From dbo.MixMaterialSpec As MixMaterialSpec
			Inner Join dbo.MixSpec As MixSpec
			On MixSpec.MixSpecID = MixMaterialSpec.MixSpecIDLink
			Inner Join @MixSpecInfo As MixSpecInfo
			On MixSpecInfo.MixSpecID = MixSpec.MixSpecID
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Ratio Information'

			Delete NOrDMtlType
			From dbo.NOrDMtlType As NOrDMtlType
			Inner Join dbo.MixMaterialRatioSpec As MixMaterialRatioSpec
			On MixMaterialRatioSpec.MixMaterialRatioSpecID = NOrDMtlType.MtlRatioIDLink
			Inner Join dbo.MixSpec As MixSpec
			On MixSpec.MixSpecID = MixMaterialRatioSpec.MixSpecIDLink
			Inner Join @MixSpecInfo As MixSpecInfo
			On MixSpecInfo.MixSpecID = MixSpec.MixSpecID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Material Ratio Specs'

			Delete MixMaterialRatioSpec
			From dbo.MixMaterialRatioSpec As MixMaterialRatioSpec
			Inner Join dbo.MixSpec As MixSpec
			On MixSpec.MixSpecID = MixMaterialRatioSpec.MixSpecIDLink
			Inner Join @MixSpecInfo As MixSpecInfo
			On MixSpecInfo.MixSpecID = MixSpec.MixSpecID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Specs'

			Delete MixSpec
			From dbo.MixSpec As MixSpec
			Inner Join @MixSpecInfo As MixSpecInfo
			On MixSpecInfo.MixSpecID = MixSpec.MixSpecID
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Submittal Mix Recipes'

			Delete OnlySubmittalMatlRecipe
			From dbo.OnlySubmittalMatlRecipe As OnlySubmittalMatlRecipe
			Inner Join dbo.OnlySubmittalMix As OnlySubmittalMix
			On OnlySubmittalMix.OnlySubmittalMixID = OnlySubmittalMatlRecipe.OnlySubmittalMixID
			Inner Join @OnlySubmittalMixInfo As OnlySubmittalMixInfo
			On OnlySubmittalMix.OnlySubmittalMixID = OnlySubmittalMixInfo.OnlySubmittalMixInfoID 

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Stored Submittal Mixes'

			Delete OnlySubmittalMix
			From dbo.OnlySubmittalMix As OnlySubmittalMix
			Inner Join @OnlySubmittalMixInfo As OnlySubmittalMixInfo
			On OnlySubmittalMix.OnlySubmittalMixID = OnlySubmittalMixInfo.OnlySubmittalMixInfoID 

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Submittal Mix Attachments'

			Delete SubmittalMixAttachment
			From dbo.SubmittalMixAttachment As SubmittalMixAttachment
			Inner Join dbo.SubmittalMix As SubmittalMix
			On SubmittalMix.SubmittalMixID = SubmittalMixAttachment.SubmittalMixID
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = SubmittalMix.MixID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Submittal Mix Comments'

			Delete SubmittalMixComment
			From dbo.SubmittalMixComment As SubmittalMixComment
			Inner Join dbo.SubmittalMix As SubmittalMix
			On SubmittalMix.SubmittalMixID = SubmittalMixComment.SubmittalMixID
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = SubmittalMix.MixID
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Submittal Backup Items'

			Delete SubmittalBackup
			From dbo.SubmittalBackup As SubmittalBackup
			Inner Join dbo.SubmittalMix As SubmittalMix
			On SubmittalMix.SubmittalMixID = SubmittalBackup.SubmittalMixID
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = SubmittalMix.MixID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Submittal Mixes'

			Delete SubmittalMix
			From dbo.SubmittalMix As SubmittalMix
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = SubmittalMix.MixID

			If Isnull(@RemoveEmptySubmittals, 0) = 1
			Begin
				Exec dbo.Utility_PrintMessage ''
				Exec dbo.Utility_PrintMessage 'Retrieve Empty Submittals'

				Insert into @SubmittalsToDelete (SubmittalID)
					Select SubmittalInfo.SubmittalID
					From @SubmittalInfo As SubmittalInfo
					Left Join dbo.SubmittalMix As SubmittalMix
					On SubmittalMix.SubmittalID = SubmittalInfo.SubmittalID
					Where SubmittalMix.SubmittalMixID Is Null
					
				Exec dbo.Utility_PrintMessage ''
				Exec dbo.Utility_PrintMessage 'Remove Empty Submittal Attachments'
				
				Delete SubmittalAttachment
				From dbo.SubmittalAttachment As SubmittalAttachment
				Inner Join dbo.SubmittalNew As SubmittalNew
				On SubmittalNew.SubmittalID = SubmittalAttachment.SubmittalID
				Inner Join @SubmittalsToDelete As SubmittalsToDelete
				On SubmittalsToDelete.SubmittalID = SubmittalNew.SubmittalID

				Exec dbo.Utility_PrintMessage ''
				Exec dbo.Utility_PrintMessage 'Remove Empty Submittal Distribution Lists'
				
				Delete SubmittalDistribution
				From dbo.SubmittalDistribution As SubmittalDistribution
				Inner Join dbo.SubmittalNew As SubmittalNew
				On SubmittalNew.SubmittalID = SubmittalDistribution.SubmittalID
				Inner Join @SubmittalsToDelete As SubmittalsToDelete
				On SubmittalsToDelete.SubmittalID = SubmittalNew.SubmittalID

				Exec dbo.Utility_PrintMessage ''
				Exec dbo.Utility_PrintMessage 'Remove Empty Submittals'
				
				Delete SubmittalNew
				From dbo.SubmittalNew As SubmittalNew
				Inner Join @SubmittalsToDelete As SubmittalsToDelete
				On SubmittalsToDelete.SubmittalID = SubmittalNew.SubmittalID
			End

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Datalogger Items'

			Delete DLBatchLinkInfo
			From dbo.DLBatchLinkInfo As DLBatchLinkInfo
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = DLBatchLinkInfo.DLBatchLinkInfo_MixLink
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Project Mix Items'

			Delete MixForContract
			From dbo.MixForContract As MixForContract
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = MixForContract.MixID
			
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Class Definitions'

			Delete MixClassDefinitions
			From dbo.MixClassDefinitions As MixClassDefinitions
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = MixClassDefinitions.MixLink

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Attachments'

			Delete MixAttachment
			From dbo.MixAttachment As MixAttachment
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = MixAttachment.MixID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Comments'

			Delete MixComment
			From dbo.MixComment As MixComment
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = MixComment.MixID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Groups'

			Delete Grouping
			From dbo.[GROUPING] As Grouping 
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixNameCode = Grouping.EXT_CODE

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix User Information'

			Delete USERINFO
			From dbo.USERINFO As USERINFO 
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixNameCode = USERINFO.USECODE
								
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Recipe Uploads'

			Delete MixRecipeUpload
			From dbo.MixRecipeUpload As MixRecipeUpload
			Inner Join dbo.MixUpload As MixUpload
			On MixUpload.MixUploadID = MixRecipeUpload.MixUploadID
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = MixUpload.MixID

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mix Uploads'

			Delete MixUpload
			From dbo.MixUpload As MixUpload
			Inner Join #InternalMixInfo1 As MixInfo
			On MixInfo.MixID = MixUpload.MixID
						
			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'Remove Mixes'

			Delete Batch
			From dbo.Batch As Batch
			Inner Join #InternalMixInfo1 As InternalMixInfo1
			On Batch.BATCHIDENTIFIER = InternalMixInfo1.MixID
			
			If Object_id(N'TempDB..#InternalMixInfo1') Is Not Null
			Begin
				Drop table #InternalMixInfo1
			End

			If Object_id(N'TempDB..#InternalMixBatchInfo1') Is Not Null
			Begin
				Drop table #InternalMixBatchInfo1
			End
			
			Commit Transaction

			Exec dbo.Utility_PrintMessage ''
			Exec dbo.Utility_PrintMessage 'The Mixes were removed.'
		End        
    End try    
    Begin Catch
        If @@TranCount > 0
        Begin
            Rollback Transaction
        End
        
        Select  @ErrorMessage = Error_message(),
                @ErrorSeverity = Error_severity()
        
        Raiserror(@ErrorMessage, @ErrorSeverity, 1)
    End Catch
End
Go
