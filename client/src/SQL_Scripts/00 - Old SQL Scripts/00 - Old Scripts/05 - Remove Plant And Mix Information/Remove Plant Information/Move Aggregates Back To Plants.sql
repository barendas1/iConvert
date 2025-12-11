If Not Exists
(
	Select Plants.PlantIdForYard
	From dbo.Plants As Plants
	Where	Plants.PlantIdForYard Is Not null And
			Plants.PlantKind = 'BatchPlant'
	Group By Plants.PlantIdForYard
	Having Count(*) > 1
) And
Not Exists
(
	Select *
	From dbo.Plants As Yards
	Left Join dbo.Plants As Plants
	On Plants.PlantIdForYard = Yards.PlantId
	Where	Yards.PlantKind = 'ConcreteYard' And
			Plants.PlantId Is Null 	
) And
(
	Exists
	(
		Select *
		From dbo.Plants As Yards
		Where Yards.PlantKind = 'ConcreteYard'
	)
	Or
	Exists
	(
		Select *
		From dbo.DBSetting As DBSetting
		Where	DBSetting.DBSettingSubcategoryID = 59 And
				dbo.Validation_StringValueIsTrue(DBSetting.[Value]) = 1
	)
)	
Begin
	Begin Try
	    Begin Transaction
	    
		Update dbo.ConcreteProject
			Set PrimaryYard_PlantId = Null,
				PrimaryPlant_PlantId =  Null
		Where	PrimaryYard_PlantId Is Not Null Or
				PrimaryPlant_PlantId Is Not Null

		Update Material
			Set Material.PlantID = Plants.PlantId,
				Material.PLANTCODE = Plants.PLNTTAGShouldGoAway
		From dbo.MATERIAL As Material
		Inner Join dbo.Plants As Yards
		On	Yards.PlantId = Material.PlantID And
			Yards.PlantKind = 'ConcreteYard'
		Inner Join dbo.Plants As Plants
		On Yards.PlantId = Plants.PlantIdForYard
		
		Update MaterialCostHistory
			Set MaterialCostHistory.Yard_PlantId = Material.PlantID
		From dbo.MaterialCostHistory As MaterialCostHistory
		Inner Join dbo.MATERIAL As Material
		On Material.MATERIALIDENTIFIER = MaterialCostHistory.MaterialId 
	
		Update Plants
			Set Plants.PlantIdForYard = Null
		From dbo.Plants As Plants
		Where Plants.PlantIdForYard Is Not null
	
		Delete Plants
		From dbo.Plants As Plants
		Where Plants.PlantKind = 'ConcreteYard'
	
		Update DBSetting
			Set DBSetting.[Value] = 'NO'
		From dbo.DBSetting As DBSetting
		Where DBSetting.DBSettingSubcategoryID = 59
	    
	    Commit Transaction
	End Try
	Begin Catch
        If @@TranCount > 0
        Begin
            RollBack Transaction
        End
	    Select  Error_number()     As ErrorNumber,
	            Error_severity()   As ErrorSeverity,
	            Error_state()      As ErrorState,
	            Error_procedure()  As ErrorProcedure,
	            Error_line()       As ErrorLine,
	            Error_message()    As ErrorMessage
	End Catch
End
Go
