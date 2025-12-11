If  Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ') And
    Exists (Select * From sys.objects Where Name = 'Raw_Material_List')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo')
    Begin
    	Declare @UnitSys Nvarchar (30) = 'US'
    	Declare @SlumpModifier Float = (Case when @UnitSys = 'US' Then 2.0 Else 30.0 End)
    	Declare @MaxSlump Float = (Case when @UnitSys = 'US' Then 12.0 Else 305.0 End)
    	
        Declare @AirContentInfo Table 
        (
	        AutoID Int Identity (1, 1), 
	        FormulaID Int, 
	        PlantID Int, 
	        AirContentValue Nvarchar (100),
	        AirContent Float,
	        MinAirContent Float,
	        MaxAirContent Float
        )

        Insert into @AirContentInfo (FormulaID, PlantID, AirContentValue)
        Select Formula.Formula_ID, Formula.Plant_ID, Ltrim(Rtrim(Formula.Air))
        From dbo.Formula As Formula
        Where Ltrim(Rtrim(Isnull(Formula.Air, ''))) <> ''

        Update Info
            Set Info.AirContentValue = Replace(Info.AirContentValue, '%', '')
        From @AirContentInfo As Info

        Update Info
            Set Info.MinAirContent = Left(Info.AirContentValue, Charindex('-', Info.AirContentValue) - 1),
                Info.MaxAirContent = Right(Info.AirContentValue, Len(Info.AirContentValue) - Charindex('-', Info.AirContentValue))
        From @AirContentInfo As Info
        Where Charindex('-', Info.AirContentValue) > 0

        Update Info
            Set Info.AirContent = (Info.MinAirContent + Info.MaxAirContent) / 2.0
        From @AirContentInfo As Info
        Where Isnull(Info.MinAirContent, -1.0) >= 0.0 And Isnull(Info.MaxAirContent, -1.0) > = 0.0

        Update Info
            Set Info.AirContent = Cast(Info.AirContentValue As Float)
        From @AirContentInfo As Info
        Where Info.AirContent Is Null And Isnumeric(Info.AirContentValue) = 1

        Update Info
            Set Info.MinAirContent =
                    Case
                        When Round(Isnull(Info.AirContent, -1.0), 4) < 0.0
                        Then Null
                        When Round(Isnull(Info.AirContent, -1.0), 4) <= 1.5
                        Then 0.0
                        Else Round(Isnull(Info.AirContent, -1.0), 4) - 1.5 
                    End,
                Info.MaxAirContent =
                    Case
                        When Round(Isnull(Info.AirContent, -1.0), 4) < 0.0
                        Then Null
                        When Round(Isnull(Info.AirContent, -1.0), 4) >= 98.5
                        Then 100.0
                        Else Round(Isnull(Info.AirContent, -1.0), 4) + 1.5 
                    End
        From @AirContentInfo As Info
        Where Info.AirContent Is Not Null And Info.MinAirContent Is Null

        Select *
        From @AirContentInfo

        /*
            Truncate Table Data_Import_RJ.dbo.TestImport0000_MixInfo
            DBCC CHECKIDENT ('Data_Import_RJ.dbo.TestImport0000_MixInfo', RESEED, 1)
        */
        
        Insert into Data_Import_RJ.dbo.TestImport0000_MixInfo
        (
	        PlantCode, MixCode, MixDescription, MixShortDescription, ItemCategory,
	        StrengthAge, Strength, AirContent, MinAirContent, MaxAirContent, Slump,
	        MinSlump, MaxSlump, DispatchSlumpRange, MaxLoadSize, SackContent, Price,
	        PriceUnitName, MixInactive, Padding1, MaterialItemCode,
	        MaterialItemDescription, Quantity, QuantityUnitName, SortNumber
        )
        
        Select  Ltrim(Rtrim(Cast(Plant.Plant_ID As Nvarchar))) As PlantCode,
                Ltrim(Rtrim(MixProduct.Product_Number)) As MixCode,
                Ltrim(Rtrim(Isnull(MixProduct.[Description], ''))) As MixDescription,
                Ltrim(Rtrim(Isnull(MixProduct.[Description], ''))) As MixShortDescription,
                Ltrim(Rtrim(Isnull(MixProductType.[Description], ''))) As MixItemCategory,
                Case when Round(Isnull(Formula.Strength, -1.0), 2) > 0.0 Then 28.0 Else Null End As StrengthAge, 
                Case when Round(Isnull(Formula.Strength, -1.0), 2) > 0.0 Then Formula.Strength Else Null End As Strength,
                AirContentInfo.AirContent As AirContent,
                AirContentInfo.MinAirContent As MinAirContent,
                AirContentInfo.MaxAirContent As MaxAirContent,
                Case when Round(Isnull(Formula.Slump, -1.0), 4) > 0.0 Then Formula.Slump Else Null End As Slump,
                Case
                    When Round(Isnull(Formula.Slump, -1.0), 4) <= 0.0
                    Then Null
                    When Round(Isnull(Formula.Slump, -1.0), 4) - @SlumpModifier <= 0.0001
                    Then 0.0
                    Else Round(Isnull(Formula.Slump, -1.0), 4) - @SlumpModifier
                End As MinSlump,
                Case
                    When Round(Isnull(Formula.Slump, -1.0), 4) <= 0.0
                    Then Null
                    When Round(Isnull(Formula.Slump, -1.0), 4) >= @MaxSlump - @SlumpModifier And Round(Isnull(Formula.Slump, -1.0), 4) <= @MaxSlump 
                    Then @MaxSlump
                    Else Round(Isnull(Formula.Slump, -1.0), 4) + @SlumpModifier
                End As MaxSlump,
                '' As DispatchSlumpRange,
                Case when Round(Isnull(Formula.Max_Load_Size, -1.0), 4) > 0.0 Then Formula.Max_Load_Size Else Null End As MaxLoadSize,
                Case when Round(Isnull(Formula.Sack_Equivalent, -1.0), 4) > 0.0 Then Formula.Sack_Equivalent Else Null End As SackContent,  
                Case when Round(Isnull(MixProduct.Price, -1.0), 4) > 0.0 And Isnull(MixUnitInfo.Imperial_Description, '') In ('m3', 'METRES') Then MixProduct.Price Else Null End As MixPrice,
                Case when Isnull(MixUnitInfo.Imperial_Description, '') In ('m3', 'METRES') Then MixUnitInfo.Imperial_Description Else Null End As MixPriceUnitName,
                Case When Isnull(Formula.Inactive_Flag, 0) = 1 Then 'Yes' Else 'No' End As MixInactive,
                '' As Padding,
                Ltrim(Rtrim(Isnull(MaterialProduct.Product_Number, ''))) As MaterialItemCode, 
                Ltrim(Rtrim(Isnull(MaterialProduct.[Description], ''))) As MaterialDescription,
                MaterialList.Quantity As Quantity,
                Ltrim(Rtrim(Isnull(MaterialUnitInfo.Imperial_Description, ''))) As QuantityUnitName,
                MaterialList.[Rank] As QuantityOrderNumber
        From dbo.Plant As Plant
        Inner Join dbo.Formula As Formula
        On Formula.Plant_ID = Plant.Plant_ID
        Left Join @AirContentInfo As AirContentInfo
        On  Formula.Formula_ID = AirContentInfo.FormulaID And
            Formula.Plant_ID = AirContentInfo.PlantID
        Inner Join dbo.Concrete_Product As ConcreteProduct
        On ConcreteProduct.Formula_ID = Formula.Formula_ID
        Inner Join dbo.Product As MixProduct
        On MixProduct.Product_ID = ConcreteProduct.Product_ID
        Left Join dbo.Product_Type As MixProductType
        On MixProductType.Product_Type_ID = MixProduct.Product_Type_ID
        Left Join dbo.GL_Category As MixGLCategory
        On MixGLCategory.GL_Category_ID = MixProduct.GL_Category_ID
        Left Join dbo.Unit_Of_Measure As MixUnitInfo
        On MixUnitInfo.Unit_Of_Measure_ID = MixProduct.Unit_Of_Measure_ID
        Inner Join dbo.Raw_Material_List As MaterialList
        On  MaterialList.Plant_ID = Plant.Plant_ID And
            MaterialList.Formula_ID = Formula.Formula_ID
        Inner Join dbo.Product As MaterialProduct
        On MaterialProduct.Product_ID = MaterialList.Product_ID
        Left Join dbo.Unit_Of_Measure As MaterialUnitInfo
        On MaterialUnitInfo.Unit_Of_Measure_ID = MaterialProduct.Unit_Of_Measure_ID
        Left Join Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
        On  Ltrim(Rtrim(Cast(Plant.Plant_ID As Nvarchar))) = MixInfo.PlantCode And
            Ltrim(Rtrim(MixProduct.Product_Number)) = MixInfo.MixCode And
            Ltrim(Rtrim(MaterialProduct.Product_Number)) = MixInfo.MaterialItemCode
        Where MixInfo.AutoID Is Null
        Order By Plant.Plant_ID, Ltrim(Rtrim(MixProduct.Product_Number)), MixProduct.Product_ID, MaterialList.[Rank], Ltrim(Rtrim(MaterialProduct.Product_Number)), MaterialProduct.Product_ID 
    End
End
Go
