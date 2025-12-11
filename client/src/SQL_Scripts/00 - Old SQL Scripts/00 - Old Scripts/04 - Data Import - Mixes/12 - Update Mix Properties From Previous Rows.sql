If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo')
    Begin
    	Declare @MixInfo Table (CurAutoID Int, MinAutoID Int, MixCode Nvarchar (100))
    	
    	Insert into @MixInfo (CurAutoID, MinAutoID, MixCode)
    	Select MixInfo.AutoID, Null, MixInfo.MixCode
    	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
    	Order By MixInfo.AutoID
    	
    	Update MixInfo
    	    Set MixInfo.MinAutoID = 
    	            (
    	                Select Max(MixInfo2.AutoID)
    	                From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo2
    	                Where   Isnull(MixInfo2.MixCode, '') <> '' And
    	                        MixInfo.CurAutoID > MixInfo2.AutoID	
    	            )
    	From @MixInfo As MixInfo
    	Where Isnull(MixInfo.MixCode, '') = ''
    	
    	Select *
    	From @MixInfo As MixInfo
    	Order By MixInfo.CurAutoID
    	
    	Update MixData1
    	    Set MixData1.PlantCode = MixData2.PlantCode,
                MixData1.MixCode = MixData2.MixCode,
                MixData1.MixDescription = MixData2.MixDescription,
                MixData1.MixShortDescription = MixData2.MixShortDescription,
                MixData1.ItemCategory = MixData2.ItemCategory,
                MixData1.StrengthAge = MixData2.StrengthAge,
                MixData1.Strength = MixData2.Strength,
                MixData1.AirContent = MixData2.AirContent,
                MixData1.MinAirContent = MixData2.MinAirContent,
                MixData1.MaxAirContent = MixData2.MaxAirContent,
                MixData1.Slump = MixData2.Slump,
                MixData1.MinSlump = MixData2.MinSlump,
                MixData1.MaxSlump = MixData2.MaxSlump
    	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixData1
    	Inner Join @MixInfo As MixInfo
    	On  MixData1.AutoID = MixInfo.CurAutoID And
    	    Isnull(MixInfo.MixCode, '') = ''
    	Inner Join Data_Import_RJ.dbo.TestImport0000_MixInfo As MixData2
    	On MixInfo.MinAutoID = MixData2.AutoID
    	
    	Select *
    	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
    	Order By MixInfo.AutoID
    End
End
Go
