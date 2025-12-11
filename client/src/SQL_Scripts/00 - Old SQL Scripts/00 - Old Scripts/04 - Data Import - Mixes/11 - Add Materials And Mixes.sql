If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo')
    Begin
    	Insert into Data_Import_RJ.dbo.TestImport0000_MixInfo
    	(
    		PlantCode, MixCode, MixDescription, ItemCategory, AirContent, Slump,
    		MaxLoadSize, MaterialItemCode, FamilyMaterialTypeName, Quantity,
    		QuantityUnitName
    	)
    	Select  MixInfo.PlantCode,
    	        MixInfo.MixCode,
    	        MixInfo.MixDescription,
    	        'Mix' As ItemCategory,
    	        MixInfo.AirContent,
    	        MixInfo.Slump,
    	        MixInfo.MaxLoadSize,
    	        MixInfo.MaterialItemCode,
    	        MixInfo.FamilyMaterialTypeName,    	       
    	        Cast(MixInfo.Quantity As Float),
    	        MixInfo.QuantityUnitName
    	From 
    	(
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.w_name1 As MaterialItemCode,
                    MixData.w_tar1 As Quantity,
                    'Water' As FamilyMaterialTypeName,
                    'Gal' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.w_name2 As MaterialItemCode,
                    MixData.w_tar2 As Quantity,
                    'Water' As FamilyMaterialTypeName,
                    'Gal' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.w_name3 As MaterialItemCode,
                    MixData.w_tar3 As Quantity,
                    'Water' As FamilyMaterialTypeName,
                    'Gal' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.w_name4 As MaterialItemCode,
                    MixData.w_tar4 As Quantity,
                    'Water' As FamilyMaterialTypeName,
                    'Gal' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.a_name1 As MaterialItemCode,
                    MixData.a_tar1 As Quantity,
                    'Aggregate' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.a_name2 As MaterialItemCode,
                    MixData.a_tar2 As Quantity,
                    'Aggregate' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.a_name3 As MaterialItemCode,
                    MixData.a_tar3 As Quantity,
                    'Aggregate' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.a_name4 As MaterialItemCode,
                    MixData.a_tar4 As Quantity,
                    'Aggregate' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.a_name5 As MaterialItemCode,
                    MixData.a_tar5 As Quantity,
                    'Aggregate' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.a_name6 As MaterialItemCode,
                    MixData.a_tar6 As Quantity,
                    'Aggregate' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.a_name7 As MaterialItemCode,
                    MixData.a_tar7 As Quantity,
                    'Aggregate' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.a_name8 As MaterialItemCode,
                    MixData.a_tar8 As Quantity,
                    'Aggregate' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.c_name1 As MaterialItemCode,
                    MixData.c_tar1 As Quantity,
                    'Cement' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.c_name2 As MaterialItemCode,
                    MixData.c_tar2 As Quantity,
                    'Cement' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.c_name3 As MaterialItemCode,
                    MixData.c_tar3 As Quantity,
                    'Cement' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.c_name4 As MaterialItemCode,
                    MixData.c_tar4 As Quantity,
                    'Cement' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.c_name5 As MaterialItemCode,
                    MixData.c_tar5 As Quantity,
                    'Cement' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.c_name6 As MaterialItemCode,
                    MixData.c_tar6 As Quantity,
                    'Cement' As FamilyMaterialTypeName,
                    'Lb' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name1 As MaterialItemCode,
                    MixData.x_tar1 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz/CWt' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name2 As MaterialItemCode,
                    MixData.x_tar2 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz/CWt' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name3 As MaterialItemCode,
                    MixData.x_tar3 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz/CWt' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name4 As MaterialItemCode,
                    MixData.x_tar4 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz/CWt' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name5 As MaterialItemCode,
                    MixData.x_tar5 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name6 As MaterialItemCode,
                    MixData.x_tar6 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name7 As MaterialItemCode,
                    MixData.x_tar7 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name8 As MaterialItemCode,
                    MixData.x_tar8 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name9 As MaterialItemCode,
                    MixData.x_tar9 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz/CWt' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name10 As MaterialItemCode,
                    MixData.x_tar10 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name11 As MaterialItemCode,
                    MixData.x_tar11 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
            
            Union All
            
            Select  MixData.AutoID As AutoID,
                    '000' As PlantCode,
                    MixData.MixCode, 
                    MixData.MixDescription, 
                    MixData.Slump,
                    MixData.AirContent, 
                    MixData.MaxLoadSize,
                    MixData.x_name12 As MaterialItemCode,
                    MixData.x_tar12 As Quantity,
                    'Admixture & Fiber' As FamilyMaterialTypeName,
                    'Oz' As QuantityUnitName
            From Data_Import_RJ.dbo.TestImport0000_MixData As MixData
    	) As MixInfo
    	Left Join Data_Import_RJ.dbo.TestImport0000_MixInfo As CurMixInfo
    	On  MixInfo.PlantCode = CurMixInfo.PlantCode And
    	    MixInfo.MixCode = CurMixInfo.MixCode And
    	    MixInfo.MaterialItemCode = CurMixInfo.MaterialItemCode
    	Where   CurMixInfo.AutoID Is Null And
    	        (
    	            MixInfo.FamilyMaterialTypeName Not In ('Admixture & Fiber') And
    	            Ltrim(Rtrim(Isnull(MixInfo.MaterialItemCode, ''))) Not In ('', '.') And
    	            dbo.Validation_ValueIsNumeric(MixInfo.Quantity) = 1 Or
        	        MixInfo.FamilyMaterialTypeName In ('Admixture & Fiber') And
    	            Ltrim(Rtrim(Isnull(MixInfo.MaterialItemCode, ''))) Not In ('', '.') And
    	            Case 
    	                When dbo.Validation_ValueIsNumeric(MixInfo.Quantity) = 0
    	                Then 0
    	                When Cast(MixInfo.Quantity As Float) <= 0.001
    	                Then 0
    	                Else 1
    	            End = 1
                )
    	Order By MixInfo.AutoID, MixInfo.FamilyMaterialTypeName, MixInfo.MaterialItemCode
    	
    	Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo
    	(
    		PlantName, TradeName, FamilyMaterialTypeName, MaterialTypeName,
    		ItemCode, ItemDescription, ItemShortDescription, BatchPanelCode
    	)
    	Select  MixInfo.PlantCode,
    	        MixInfo.MaterialItemCode,
    	        MixInfo.FamilyMaterialTypeName,
    	        MixInfo.FamilyMaterialTypeName,
    	        MixInfo.MaterialItemCode,
    	        MixInfo.MaterialItemCode,
    	        MixInfo.MaterialItemCode,
    	        MixInfo.MaterialItemCode
    	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
    	Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
    	On  MixInfo.PlantCode = MaterialInfo.PlantName And
    	    MixInfo.MaterialItemCode = MaterialInfo.ItemCode
    	Where   MaterialInfo.AutoID Is Null And
    	        MixInfo.AutoID In
    	        (
    	        	Select Min(MixInfo.AutoID)
    	        	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
    	        	Group By MixInfo.MaterialItemCode
    	        )
    	Order By MixInfo.FamilyMaterialTypeName, MixInfo.MaterialItemCode
    End
End
Go

