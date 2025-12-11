If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo')
    Begin
    	Update MixInfo
    	    Set MixInfo.QuantityUnitName = 'Oz'
    	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
    	Where MixInfo.MaterialItemCode = 'DARAFILDRY' And Isnull(MixInfo.QuantityUnitName, '') = ''
    End
End
Go
