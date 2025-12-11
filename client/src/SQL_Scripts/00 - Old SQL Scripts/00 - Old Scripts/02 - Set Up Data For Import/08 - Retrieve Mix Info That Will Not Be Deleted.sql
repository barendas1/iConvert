If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If	Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfoNotDeleted') And
		Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo') 
    Begin
    	Insert into Data_Import_RJ.dbo.TestImport0000_MixInfoNotDeleted
    	(
    		PlantCode,
    		MixCode,
    		MixID
    	)
    	Select	Plants.Name,
    			MixName.Name,
    			Mix.BATCHIDENTIFIER
    	From Sonag_RJ.dbo.Plants As Plants
    	Inner Join Sonag_RJ.dbo.BATCH As Mix
    	On Mix.Plant_Link = Plants.PlantId
    	Inner Join Sonag_RJ.dbo.Name As MixName
    	On MixName.NameID = Mix.NameID
    	Inner Join
    	(
    		Select Batch.MixNameCode
    		From Sonag_RJ.dbo.BATCH As Batch
    		Inner Join Sonag_RJ.dbo.TESTINFO As TestInfo
    		On TestInfo.BatchID = Batch.BATCHIDENTIFIER
    		Inner Join Sonag_RJ.dbo.TEST As Test
    		On Test.TestInfoID = TestInfo.TESTINFOIDENTIFIER
    		Group By Batch.MixNameCode
    	) As BatchInfo
    	On BatchInfo.MixNameCode = Mix.MixNameCode
    	Left Join Data_Import_RJ.dbo.TestImport0000_MixInfoNotDeleted As MixInfo
    	On Mix.BATCHIDENTIFIER = MixInfo.MixID
    	Where MixInfo.AutoID Is Null
    	Group By Plants.Name, MixName.Name, Mix.BATCHIDENTIFIER
    	Order By Plants.Name, MixName.Name
    End
End
Go
