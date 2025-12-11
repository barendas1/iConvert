If  ObjectProperty(Object_ID(N'[dbo].[Number_Conversion_Base10ToBase26]'), N'IsProcedure') = 1 
Begin
	Drop Procedure [dbo].[Number_Conversion_Base10ToBase26]
End
Go

If  ObjectProperty(Object_ID(N'[dbo].[Number_Conversion_GetBase26Numbers]'), N'IsProcedure') = 1 
Begin
	Drop Procedure [dbo].[Number_Conversion_GetBase26Numbers]
End
Go

If  ObjectProperty(Object_ID(N'[dbo].[CodeCreation_ReturnNewCodes]'), N'IsProcedure') = 1 
Begin
	Drop Procedure [dbo].[CodeCreation_ReturnNewCodes]
End
Go

Create Procedure [dbo].[Number_Conversion_Base10ToBase26] (@Base10Number Int, @OutputBase26Number NVarChar (100) OutPut) As
Begin
	/*
		Convert a Base 10 Number to a Base 26 Number.
	*/
	
	Declare @ABSNum Int
	Declare @IsNegativeNum Bit
	Declare @RemainderNum Int
	Declare @Base26Divider Int
	Declare @Base26Number NVarChar (100)
	Declare @FirstLetter NVarChar (100)
	Declare @Index Int

	--Print 'Mix Import --> Converting Base 10 Number To Base 26 Number'
    
	Set @OutputBase26Number = Null
	
	If @Base10Number Is Not Null
	Begin
		Set @Base26Divider = 26
		Set @Base26Number = ''
		Set @FirstLetter = Ascii('A')
		Set @Index = 1
		
		If @Base10Number < 0 
		Begin
			Set @IsNegativeNum = 1
		End
		Else
		Begin
			Set @IsNegativeNum = 0
		End
		
		Set @ABSNum = Abs(@Base10Number)
		
		While (@ABSNum <> 0 Or @Index = 1)
		Begin
			Set @RemainderNum = @ABSNum % @Base26Divider
			Set @Base26Number = Char(@FirstLetter + @RemainderNum) + @Base26Number
			Set @ABSNum = Floor(@ABSNum / @Base26Divider)
			Set @Index = @Index + 1
		End
		
		If @IsNegativeNum = 1
		Begin
			Set @Base26Number = '-' + @Base26Number
		End
		
		Set @OutputBase26Number = @Base26Number
	End
End
Go

Create Procedure [dbo].[Number_Conversion_GetBase26Numbers] (@StartNumber Int, @EndNumber Int, @StepNumber Int, @Base26Prefix NVarChar (50), @NumberOfBase26Chars Int) As
Begin
	/*
		Convert Base 10 Numbers to Base 26 Numbers and return them.
	*/
	
    Declare @Base26Numbers Table (Base10Number Int, Base26Number Nvarchar (100))
	Declare @Step Int
	Declare @Prefix NVarChar (50)
	Declare @Base26Count Int
	Declare @Index Int
	Declare @Base26Number NVarChar (300)

	If  ObjectProperty(Object_ID(N'[dbo].[Number_Conversion_Base10ToBase26]'), N'IsProcedure') = 1
	Begin
		Set @Step = @StepNumber
		
		If @Step Is Null Or @Step = 0
		Begin
			If @EndNumber >= @StartNumber
			Begin
				Set @Step = 1
			End
			Else
			Begin
				Set @Step = -1
			End
		End
		Else If @EndNumber > @StartNumber And @Step < 0 Or @StartNumber > @EndNumber And @Step > 0
		Begin
			Set @Step = 0 - @Step
		End
		
		Set @Prefix = @Base26Prefix
		
		If @Prefix Is Null 
		Begin
			Set @Prefix = ''
		End
		
		Set @Base26Count = @NumberOfBase26Chars
		
		If @Base26Count Is Null 
		Begin
			Set @Base26Count = 0
		End
		
		Set @Index = @StartNumber
		
		While (@Index <= @EndNumber And @Step > 0 Or @Index >= @EndNumber And @Step < 0)
		Begin
			Exec Number_Conversion_Base10ToBase26 @Index, @OutputBase26Number = @Base26Number Output
			
			If @Base26Count > 0 
			Begin
				Set @Base26Number = Right(Replicate(@Prefix, @Base26Count) + @Base26Number, @Base26Count)
			End
			
			Set @Base26Number = Replace(@Base26Number, '''', '''''')

            Insert into @Base26Numbers (Base10Number, Base26Number)
                Values (@Index, @Base26Number)
			
			Set @Index = @Index + @Step
		End
	End
    
    Select Base10Number, Base26Number
    From @Base26Numbers
End
Go

Create Procedure [dbo].[CodeCreation_ReturnNewCodes] (@NumberOfCodes Int, @CodeTable NVarChar (200), @CodeTableCodeField NVarChar (200), @CodePrefix NVarChar (3), @CharsFromRight Int) As
Begin
/*
	Create and return new codes.
*/
	
    Declare @NewCodes Table (ID Int Identity (1, 1), Code Nvarchar (50))
	Declare @ItemCodeCount Int
	Declare @CurrentDate DateTime
	Declare @ImportDate DateTime
	Declare @CodeDatePart NVarChar (10)
	Declare @Index Int
	Declare @DayIndex Int
	Declare @AvailCount Int
	Declare @Prefix NVarChar (3)
	Declare @PrefixLenStr NVarChar (30)
	Declare @NumOfDateChars Int
	Declare @NumOfDateCharsStr NVarChar (30)
	Declare @StartID Int
	Declare @EndID Int
	Declare @CodeDateEvalStr NVarChar (30)
        
    If Isnull(@NumberOfCodes, -1) > 0    
    Begin
        Set @Index = 1
        
        While (@Index <= @NumberOfCodes)
        Begin
            Insert into @NewCodes (Code)
                Values ('')
                
            Set @Index = @Index + 1
        End
        
	    If @CharsFromRight Is Null Or @CharsFromRight < 1 Or @CharsFromRight > 6
	    Begin
		    Set @NumOfDateChars = 6
	    End
	    Else
	    Begin 
		    Set @NumOfDateChars = @CharsFromRight
	    End
    	
	    Set @NumOfDateCharsStr = Cast(@NumOfDateChars As NVarChar)
    	
	    If @CodePrefix Is Null
	    Begin
		    Set @Prefix = ''
	    End
	    Else
	    Begin
		    Set @Prefix = LTrim(RTrim(@CodePrefix))
	    End
    	
	    Set @PrefixLenStr = Cast(Len(@Prefix) + 6 As NVarChar)
    	
	    If Object_ID('TempDB..#CodeInfo') Is Not Null
	    Begin
		    Drop Table #CodeInfo
	    End

	    If Object_ID('TempDB..#NumOfAvailCodes') Is Not Null
	    Begin
		    Drop Table #NumOfAvailCodes
	    End
    	
	    Create Table #CodeInfo
	    (
	 	    ID Int Identity ( 1, 1) Not Null,
		    CodePrefix NVarChar (30) Null,
		    MaxNumOfCodes Int Null,
		    StartNum Int Null,
		    StartID Int Null,
		    EndID Int Null
	    )
    	
	    Create Table #NumOfAvailCodes
	    (
	 	    AvailCount Int
	    )
    	
	    Select @ItemCodeCount = Count(NewCodes.ID) 
	    From @NewCodes As NewCodes
    	
	    Set @CurrentDate = GetDate()
    	
	    Set @Index = 0
	    Set @DayIndex = 0
	    Set @StartID = 1
	    Set @EndID = 0
    	
	    While @Index < @ItemCodeCount
	    Begin
    		
		    Set @ImportDate = DateAdd(	day, @DayIndex, @CurrentDate)
    		
		    Set @CodeDatePart = 	Right('00' + LTrim(RTrim(Cast(Year(@ImportDate) As NVarChar))), 2) +  
								    Right('00' + LTrim(RTrim(Cast(Month(@ImportDate) As NVarChar))), 2) +
								    Right('00' + LTrim(RTrim(Cast(Day(@ImportDate) As NVarChar))), 2)
    				
		    Delete From #NumOfAvailCodes
    		
		    Set @CodeDateEvalStr = Right(@CodeDatePart, @NumOfDateChars)
    		
		    Exec
		    (
		 	    'Insert Into #NumOfAvailCodes ( AvailCount) ' +
			    'Select 20000 - Max( Cast( Right(CodeInfo.' + @CodeTableCodeField + ', 5) As Int)) ' +
			    'From ' +
			    '( ' +
			    '	Select ' + @CodeTable + '.' + @CodeTableCodeField + ' ' +
			    '	From [dbo].[' + @CodeTable + '] ' +
			    '	Union All ' +
			    '	Select Archived' + @CodeTable + '.' + @CodeTableCodeField + ' ' +
			    '	From [dbo].[Archived' + @CodeTable + '] ' +
			    ') As CodeInfo ' +
			    'Where Right(Left(CodeInfo.' + @CodeTableCodeField + ', ' + @PrefixLenStr + '), ' +
			    @NumOfDateCharsStr + ') = ''' + @CodeDateEvalStr + ''''
		    )
    		
		    Select @AvailCount = Count(#NumOfAvailCodes.AvailCount)
		    From #NumOfAvailCodes
    		
		    If @AvailCount Is Null Or @AvailCount < 1 
		    Begin
			    Set @AvailCount = 20000
		    End
		    Else
		    Begin
			    Select @AvailCount = Max(#NumOfAvailCodes.AvailCount)
			    From #NumOfAvailCodes
		    End
    		
		    If @AvailCount > 1000 
		    Begin
			    Set @EndID = @StartID + @AvailCount - 1
    			 
			    Insert Into #CodeInfo (CodePrefix, MaxNumOfCodes, StartNum, StartID, EndID)
			    Values ( @Prefix + @CodeDatePart, @AvailCount, 20000 - @AvailCount + 1, @StartID, @EndID)
    			
			    Set @Index = @Index + @AvailCount
    					
			    Set @StartID = @StartID + @AvailCount
		    End 
    		
		    Set @DayIndex = @DayIndex + 1
	    End
    	
 	    Update NewCodes
	    	Set NewCodes.Code = #CodeInfo.CodePrefix + Right('00000' + LTrim(RTrim(Cast(StartNum + NewCodes.ID - #CodeInfo.StartID As NVarChar))), 5) 
            From @NewCodes As NewCodes
	    	Inner Join #CodeInfo 
	    	On NewCodes.ID >= #CodeInfo.StartID And NewCodes.ID <= #CodeInfo.EndID 
        
	    If Object_ID('TempDB..#CodeInfo') Is Not Null
	    Begin
		    Drop Table #CodeInfo
	    End

	    If Object_ID('TempDB..#NumOfAvailCodes') Is Not Null
	    Begin
		    Drop Table #NumOfAvailCodes
	    End
    End
    
    Select ID, Code
        From @NewCodes
End
Go

Declare @Index1 As Int
Declare @Index2 As Int 
Declare @MaxIndex1 As Int
Declare @DistrictCode As Nvarchar (100)
Declare @DistrictID As Int
Declare @Name Nvarchar (100)
Declare @Description Nvarchar (255)
Declare @MaterialCode Nvarchar (100)

Declare @ItemCategory Table (
            AutoID Int Identity(1, 1),
            Name Nvarchar(100),
            Description Nvarchar(255),
            ShortDescription Nvarchar(255),
            Type Nvarchar(100),
            FamilyMtrlTypeID Int,
            MtrlTypeID Int,
            SpecificGravity Float,
            SpecificHeat Float,
            MaterialCategory Nvarchar (100),
            Moisture Float            
        )

Declare @Plant Table (AutoID Int Identity(1, 1), Name Nvarchar(100), Description Nvarchar(255))
Declare @Mix Table (
            AutoID Int Identity(1, 1),
            PlantName Nvarchar(100),
            Name Nvarchar(100),
            Description Nvarchar(255),
            ShortDescription Nvarchar(255),
            ItemCategory Nvarchar(100),
            MixDate Datetime,
            MixCode Nvarchar (100),
            MixNameCode Nvarchar (100)
        )

Declare @Material Table (
            AutoID Int Identity(1, 1),
            PlantName Nvarchar(100),
            Name Nvarchar(100),
            Description Nvarchar(255),
            ShortDescription Nvarchar(255),
            ItemCategory Nvarchar(100),
            PanelCode Nvarchar(100),
            PanelDescription Nvarchar(255),
            MaterialDate Datetime,
            FamilyMtrlTypeID Int,
            MtrlTypeID Int,
            SpecificGravity Float,
            SpecificHeat Float,
            Code Nvarchar (100),
            CodeNumber Int,
            Prefix Nvarchar (10),
            Category Nvarchar (100),
            Moisture Float
        )

Declare @MixRecipe Table (
            AutoID Int Identity(1, 1),
            PlantName Nvarchar(100),
            MixName Nvarchar(100),
            MaterialName Nvarchar(100),
            Quantity Float,
            QuantityUnits Nvarchar(100),
            ConvertedQuantity Float
        ) 

Declare @NewMixNameCodes Table (CodeNumber Int, MixNameCode Nvarchar (100)) 
Declare @MixNameCodes Table (AutoID Int Identity (1, 1), MixNameCode Nvarchar (100))
Declare @NewMixCodes Table (ID Int, MixCode Nvarchar (50))

Insert Into @ItemCategory
(
    Name,
    [Description],
    ShortDescription,
    [Type]
)
Select  Ltrim(Rtrim(ICAT.ITEM_CAT)),
        Ltrim(Rtrim(ICAT.DESCR)),
        Ltrim(Rtrim(ICAT.SHORT_DESCR)),
        'Mix'
    From [PRA cmd_dev_20110307 RJ_110311].dbo.ICAT As ICAT
    Inner Join [PRA cmd_dev_20110307 RJ_110311].dbo.IMST As IMST
    On  IMST.ITEM_CAT = ICAT.ITEM_CAT
    Inner Join [PRA cmd_dev_20110307 RJ_110311].dbo.ICST As ICST
    On  ICST.ITEM_CODE = IMST.ITEM_CODE
    Group By
            Ltrim(Rtrim(ICAT.ITEM_CAT)),
            Ltrim(Rtrim(ICAT.DESCR)),
            Ltrim(Rtrim(ICAT.SHORT_DESCR))

Insert Into @ItemCategory
(
    Name,
    [Description],
    ShortDescription,
    [Type]
)
Select  Ltrim(Rtrim(ICAT.ITEM_CAT)),
        Ltrim(Rtrim(ICAT.DESCR)),
        Ltrim(Rtrim(ICAT.SHORT_DESCR)),
        'Mtrl'
    From [PRA cmd_dev_20110307 RJ_110311].dbo.ICAT As ICAT
    Inner Join [PRA cmd_dev_20110307 RJ_110311].dbo.IMST As IMST
    On  IMST.ITEM_CAT = ICAT.ITEM_CAT
    Inner Join [PRA cmd_dev_20110307 RJ_110311].dbo.ICST As ICST
    On  ICST.CONST_ITEM_CODE = IMST.ITEM_CODE 
    Group By
            Ltrim(Rtrim(ICAT.ITEM_CAT)),
            Ltrim(Rtrim(ICAT.DESCR)),
            Ltrim(Rtrim(ICAT.SHORT_DESCR))

Insert Into @ItemCategory
(
    Name,
    [Description],
    ShortDescription,
    [Type]
)
Select  Ltrim(Rtrim(ICAT.ITEM_CAT)),
        Ltrim(Rtrim(ICAT.DESCR)),
        Ltrim(Rtrim(ICAT.SHORT_DESCR)),
        Null
    From [PRA cmd_dev_20110307 RJ_110311].dbo.ICAT As ICAT
    Left Join @ItemCategory As ItemCategory
    On LTrim(RTrim(ICAT.ITEM_CAT)) = ItemCategory.Name
    Where ItemCategory.AutoID Is Null And ICAT.ITEM_CAT <> 'Extra'
    Group By
            Ltrim(Rtrim(ICAT.ITEM_CAT)),
            Ltrim(Rtrim(ICAT.DESCR)),
            Ltrim(Rtrim(ICAT.SHORT_DESCR))

Update @ItemCategory
    Set [Type] = 'Mtrl'
    Where Name In ('20', '50', '51', '52') And Type Is Null

--Inner Join [PRA cmd_dev_20110307 RJ_110311].dbo.IMST As IMST
--On ItemCategory.Name = IMST.ITEM_CAT
--Where ItemCategory.[Type] Is Null

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 3,
        ItemCategory.MtrlTypeID = 16, 
        ItemCategory.SpecificGravity = 1.0,
        ItemCategory.SpecificHeat = 4.185,
        ItemCategory.MaterialCategory = 'Type C Accelerator',
        ItemCategory.Moisture = 1E-08
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('10')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 1,
        ItemCategory.MtrlTypeID = 8, 
        ItemCategory.SpecificGravity = 2.5,
        ItemCategory.SpecificHeat = 0.837,
        ItemCategory.MaterialCategory = 'Coarse Aggregate',
        ItemCategory.Moisture = 0.0
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('1000')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 1,
        ItemCategory.MtrlTypeID = 6, 
        ItemCategory.SpecificGravity = 2.5,
        ItemCategory.SpecificHeat = 0.837,
        ItemCategory.MaterialCategory = 'Fine Aggregate',
        ItemCategory.Moisture = 0.0
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('1100')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 2,
        ItemCategory.MtrlTypeID = 2, 
        ItemCategory.SpecificGravity = 3.15,
        ItemCategory.SpecificHeat = 0.837,
        ItemCategory.MaterialCategory = 'Cement',
        ItemCategory.Moisture = 0.0
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('30')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 4,
        ItemCategory.MtrlTypeID = 67, 
        ItemCategory.SpecificGravity = 2.5,
        ItemCategory.SpecificHeat = 0.837,
        ItemCategory.MaterialCategory = 'Fly Ash',
        ItemCategory.Moisture = 0.0
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('40')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 3,
        ItemCategory.MtrlTypeID = 3, 
        ItemCategory.SpecificGravity = 1.0,
        ItemCategory.SpecificHeat = 4.185,
        ItemCategory.MaterialCategory = 'Admixture & Fiber',
        ItemCategory.Moisture = 1E-08
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('60')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 3,
        ItemCategory.MtrlTypeID = 9, 
        ItemCategory.SpecificGravity = 1.0,
        ItemCategory.SpecificHeat = 4.185,
        ItemCategory.MaterialCategory = 'Fibers',
        ItemCategory.Moisture = 0.0
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('80')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 3,
        ItemCategory.MtrlTypeID = 76, 
        ItemCategory.SpecificGravity = 1.0,
        ItemCategory.SpecificHeat = 4.185,
        ItemCategory.MaterialCategory = 'Stabilizer',
        ItemCategory.Moisture = 1E-08
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('90')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 5,
        ItemCategory.MtrlTypeID = 5, 
        ItemCategory.SpecificGravity = 0.9882,
        ItemCategory.SpecificHeat = 4.185,
        ItemCategory.MaterialCategory = 'Water',
        ItemCategory.Moisture = 0.0
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('95')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 3,
        ItemCategory.MtrlTypeID = 72, 
        ItemCategory.SpecificGravity = 1.0,
        ItemCategory.SpecificHeat = 4.185,
        ItemCategory.MaterialCategory = 'Corrosion Inhibitor',
        ItemCategory.Moisture = 1E-08
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('CORR')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 2,
        ItemCategory.MtrlTypeID = 2, 
        ItemCategory.SpecificGravity = 3.15,
        ItemCategory.SpecificHeat = 0.837,
        ItemCategory.MaterialCategory = 'Cement',
        ItemCategory.Moisture = 0.0,
        ItemCategory.[Type] = 'Mtrl'
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('20')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 3,
        ItemCategory.MtrlTypeID = 22, 
        ItemCategory.SpecificGravity = 1.0,
        ItemCategory.SpecificHeat = 4.185,
        ItemCategory.MaterialCategory = 'Color',
        ItemCategory.Moisture = 0.0,
        ItemCategory.[Type] = 'Mtrl'
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('50')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 3,
        ItemCategory.MtrlTypeID = 22, 
        ItemCategory.SpecificGravity = 1.0,
        ItemCategory.SpecificHeat = 4.185,
        ItemCategory.MaterialCategory = 'Color',
        ItemCategory.Moisture = 0.0,
        ItemCategory.[Type] = 'Mtrl'
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('51')

Update ItemCategory
    Set ItemCategory.FamilyMtrlTypeID = 3,
        ItemCategory.MtrlTypeID = 22, 
        ItemCategory.SpecificGravity = 1.0,
        ItemCategory.SpecificHeat = 4.185,
        ItemCategory.MaterialCategory = 'Color',
        ItemCategory.Moisture = 0.0,
        ItemCategory.[Type] = 'Mtrl'
From @ItemCategory As ItemCategory
Where ItemCategory.Name In ('52')

Insert Into @Plant
(
    Name,
    [Description]
)
Select  Ltrim(Rtrim(LOC_CODE)),
        Ltrim(Rtrim(DESCR))
    From [PRA cmd_dev_20110307 RJ_110311].dbo.LOCN As LOCN
    Left Join dbo.Plant As Plant
    On Ltrim(Rtrim(Locn.LOC_CODE)) = Plant.PLNTNAME
    Where Plant.PLANTIDENTIFIER Is Null

Insert Into @Mix
(
    PlantName,
    Name,
    [Description],
    ShortDescription,
    ItemCategory,
    MixDate
)
Select  Ltrim(Rtrim(Iloc.LOC_CODE)),
        Ltrim(Rtrim(IMST.ITEM_CODE)),
        Ltrim(Rtrim(IMST.DESCR)),
        Ltrim(Rtrim(IMST.SHORT_DESCR)),
        Ltrim(Rtrim(IMST.ITEM_CAT)),
        iloc.STD_COST_EFFECT_DATE
    From [PRA cmd_dev_20110307 RJ_110311].dbo.IMST As IMST
    Inner Join [PRA cmd_dev_20110307 RJ_110311].dbo.ILOC As ILOC
    On  ILOC.ITEM_CODE = IMST.ITEM_CODE
    Inner Join [PRA cmd_dev_20110307 RJ_110311].dbo.ICST As ICST
    On  ICST.ITEM_CODE = IMST.ITEM_CODE And
        ICST.LOC_CODE = ILOC.LOC_CODE
    Left Join dbo.Plant As Plant
    On Ltrim(Rtrim(ILoc.LOC_CODE)) = Plant.PLNTNAME
    Left Join dbo.Name As Name 
    On Ltrim(Rtrim(IMST.ITEM_CODE)) = Name.Name 
    Left Join dbo.Batch As MixInfo
    On Plant.PLANTIDENTIFIER = MixInfo.Plant_Link And MixInfo.NameID = Name.NameID
    Where MixInfo.BATCHIDENTIFIER Is Null 
    Group By
            Ltrim(Rtrim(Iloc.LOC_CODE)),
            Ltrim(Rtrim(IMST.ITEM_CODE)),
            Ltrim(Rtrim(IMST.DESCR)),
            Ltrim(Rtrim(IMST.SHORT_DESCR)),
            Ltrim(Rtrim(IMST.ITEM_CAT)),
            iloc.STD_COST_EFFECT_DATE

Insert Into @Material
(
    PlantName,
    Name,
    [Description],
    ShortDescription,
    ItemCategory,
    PanelCode,
    PanelDescription,
    MaterialDate
)
Select  Ltrim(Rtrim(Iloc.LOC_CODE)),
        Ltrim(Rtrim(imst.ITEM_CODE)),
        Ltrim(Rtrim(imst.DESCR)),
        Ltrim(Rtrim(imst.SHORT_DESCR)),
        Ltrim(Rtrim(IMST.ITEM_CAT)),
        Ltrim(Rtrim(imlb.BATCH_CODE)),
        Ltrim(Rtrim(imlb.DESCR)),
        iloc.STD_COST_EFFECT_DATE
    From [PRA cmd_dev_20110307 RJ_110311].dbo.IMST As IMST
    Inner Join [PRA cmd_dev_20110307 RJ_110311].dbo.ILOC As ILOC
    On  ILOC.ITEM_CODE = IMST.ITEM_CODE
    Inner Join @ItemCategory As ItemCategory
    On LTRim(RTrim(IMST.ITEM_CAT)) = ItemCategory.Name And ItemCategory.[Type] = 'Mtrl'
    Left Join 
    (
        Select IMLB.ITEM_CODE, IMLB.LOC_CODE, Max(IMLB.BATCH_CODE) As Batch_Code
        From [PRA cmd_dev_20110307 RJ_110311].dbo.IMLB As IMLB
        Group By IMLB.ITEM_CODE, IMLB.LOC_CODE        
    ) As DupIMLB
    On  DupIMLB.ITEM_CODE = IMST.ITEM_CODE And
        DupIMLB.LOC_CODE = ILOC.LOC_CODE
    Left Join [PRA cmd_dev_20110307 RJ_110311].dbo.IMLB As IMLB
    On  IMLB.ITEM_CODE = DupIMLB.ITEM_CODE And 
        IMLB.LOC_CODE = DupIMLB.LOC_CODE And 
        IMLB.Batch_Code = DupIMLB.Batch_Code
    Left Join dbo.Plant As Plant 
    On Ltrim(Rtrim(ILOC.LOC_CODE)) = Plant.PLNTNAME
    Left Join dbo.Name As Name 
    On Ltrim(Rtrim(IMST.ITEM_CODE)) = Name.Name
    Left Join dbo.ItemMaster As ItemMaster
    On Name.NameID = ItemMaster.NameID And ItemMaster.ItemType = 'Mtrl'
    Left Join dbo.MATERIAL As Material
    On  Material.PlantID = Plant.PLANTIDENTIFIER And 
        Material.ItemMasterID = ItemMaster.ItemMasterID
    Where Material.MATERIALIDENTIFIER Is Null 
    Group By
            Ltrim(Rtrim(Iloc.LOC_CODE)),
            Ltrim(Rtrim(imst.ITEM_CODE)),
            Ltrim(Rtrim(imst.DESCR)),
            Ltrim(Rtrim(imst.SHORT_DESCR)),
            Ltrim(Rtrim(IMST.ITEM_CAT)),
            Ltrim(Rtrim(imlb.BATCH_CODE)),
            Ltrim(Rtrim(imlb.DESCR)),
            iloc.STD_COST_EFFECT_DATE

/*
Insert Into @Material
(
    PlantName,
    Name,
    [Description],
    ShortDescription,
    ItemCategory,
    PanelCode,
    PanelDescription,
    MaterialDate
)
Select  Ltrim(Rtrim(Iloc.PLNTNAME)),
        Ltrim(Rtrim(imst.ITEM_CODE)),
        Ltrim(Rtrim(imst.DESCR)),
        Ltrim(Rtrim(imst.SHORT_DESCR)),
        Ltrim(Rtrim(IMST.ITEM_CAT)),
        Ltrim(Rtrim(imlb.BATCH_CODE)),
        Ltrim(Rtrim(imlb.DESCR)),
        Current_timestamp
    From [PRA cmd_dev_20110307 RJ_110311].dbo.IMST As IMST
    Cross Join dbo.PLANT As ILOC
    Inner Join @ItemCategory As ItemCategory
    On LTRim(RTrim(IMST.ITEM_CAT)) = ItemCategory.Name And ItemCategory.[Type] = 'Mtrl'
    Left Join 
    (
        Select IMLB.ITEM_CODE, IMLB.LOC_CODE, Max(IMLB.BATCH_CODE) As Batch_Code
        From [PRA cmd_dev_20110307 RJ_110311].dbo.IMLB As IMLB
        Group By IMLB.ITEM_CODE, IMLB.LOC_CODE        
    ) As DupIMLB
    On  DupIMLB.ITEM_CODE = IMST.ITEM_CODE And
        DupIMLB.LOC_CODE = ILOC.PLNTNAME
    Left Join [PRA cmd_dev_20110307 RJ_110311].dbo.IMLB As IMLB
    On  IMLB.ITEM_CODE = DupIMLB.ITEM_CODE And 
        IMLB.LOC_CODE = DupIMLB.LOC_CODE And 
        IMLB.Batch_Code = DupIMLB.Batch_Code
    Left Join dbo.Plant As Plant 
    On Ltrim(Rtrim(ILOC.PLNTNAME)) = Plant.PLNTNAME
    Left Join dbo.Name As Name 
    On Ltrim(Rtrim(IMST.ITEM_CODE)) = Name.Name
    Left Join dbo.ItemMaster As ItemMaster
    On Name.NameID = ItemMaster.NameID And ItemMaster.ItemType = 'Mtrl'
    Left Join dbo.MATERIAL As Material
    On  Material.PlantID = Plant.PLANTIDENTIFIER And 
        Material.ItemMasterID = ItemMaster.ItemMasterID
    Where Material.MATERIALIDENTIFIER Is Null 
    Group By
            Ltrim(Rtrim(Iloc.PLNTNAME)),
            Ltrim(Rtrim(imst.ITEM_CODE)),
            Ltrim(Rtrim(imst.DESCR)),
            Ltrim(Rtrim(imst.SHORT_DESCR)),
            Ltrim(Rtrim(IMST.ITEM_CAT)),
            Ltrim(Rtrim(imlb.BATCH_CODE)),
            Ltrim(Rtrim(imlb.DESCR))
*/
Insert Into @MixRecipe
(
    PlantName,
    MixName,
    MaterialName,
    Quantity,
    QuantityUnits
)
Select  Ltrim(Rtrim(ICST.LOC_CODE)),
        Ltrim(Rtrim(ICST.ITEM_CODE)),
        Ltrim(Rtrim(ICST.CONST_ITEM_CODE)),
        ICST.QTY,
        Ltrim(Rtrim(ICST.QTY_UOM))
    From [PRA cmd_dev_20110307 RJ_110311].dbo.ICST As ICST
    Inner Join @Mix As Mix
    On  Ltrim(Rtrim(ICST.ITEM_CODE)) = Ltrim(Rtrim(Mix.Name)) And
        Ltrim(Rtrim(ICST.LOC_CODE)) = Ltrim(Rtrim(Mix.PlantName))
    Group By
            Ltrim(Rtrim(ICST.LOC_CODE)),
            Ltrim(Rtrim(ICST.ITEM_CODE)),
            Ltrim(Rtrim(ICST.CONST_ITEM_CODE)),
            ICST.QTY,
            Ltrim(Rtrim(ICST.QTY_UOM))

Update MtrlInfo
    Set MtrlInfo.FamilyMtrlTypeID = ItemCategory.FamilyMtrlTypeID,
        MtrlInfo.MtrlTypeID = ItemCategory.MtrlTypeID,
        MtrlInfo.SpecificGravity = ItemCategory.SpecificGravity,
        MtrlInfo.SpecificHeat = ItemCategory.SpecificHeat,
        MtrlInfo.Category = ItemCategory.MaterialCategory,
        MtrlInfo.Moisture = ItemCategory.Moisture
From @Material As MtrlInfo
Inner Join @ItemCategory As ItemCategory 
On MtrlInfo.ItemCategory = ItemCategory.Name

Insert into dbo.ProductionItemCategory (ItemCategory, [Description],
            ShortDescription, ProdItemCatType)
Select ItemCategory.Name, ItemCategory.[Description],
       ItemCategory.ShortDescription, ItemCategory.[Type] 
From @ItemCategory As ItemCategory
Left Join dbo.ProductionItemCategory As ProductionItemCategory
On ItemCategory.Name = ProductionItemCategory.ItemCategory
Where ProductionItemCategory.ProdItemCatID Is Null

Insert into dbo.Name (Name, NameType)
Select MixName.Name, 'MixItem'
From @Mix As MixName
Left Join dbo.Name As Name
On MixName.Name = Name.Name
Where Name.NameID Is Null
Group By MixName.Name

Insert into dbo.Name (Name, MaterialTypeID, NameType)
Select MtrlName.PanelCode, MtrlName.MtrlTypeID, 'MtrlBatchCode'
From @Material As MtrlName
Left Join dbo.Name As Name
On Name.Name = MtrlName.PanelCode
Where Name.NameID Is Null And MtrlName.PanelCode Is Not Null
Group By MtrlName.PanelCode, MtrlName.MtrlTypeID

Insert into dbo.Name (Name, MaterialTypeID, NameType)
Select MtrlName.Name, MtrlName.MtrlTypeID, 'MtrlItem'
From @Material As MtrlName
Left Join dbo.Name As Name
On Name.Name = MtrlName.Name
Where Name.NameID Is Null 
Group By MtrlName.Name, MtrlName.MtrlTypeID

Insert into dbo.[Description] ([Description], DescriptionType)
Select MixDescr.[Description], 'MixItem'
From @Mix As MixDescr
Left Join dbo.[Description] As Description
On Description.[Description] = MixDescr.[Description]
Where Description.DescriptionID Is Null
Group By MixDescr.[Description]

Insert into dbo.[Description] ([Description], MaterialTypeID, DescriptionType)
Select MtrlDescr.[Description], MtrlDescr.MtrlTypeID, 'MtrlItem'
From @Material As MtrlDescr
Left Join dbo.[Description] As Description
On Description.[Description] = MtrlDescr.[Description]
Where Description.DescriptionID Is Null
Group By MtrlDescr.[Description], MtrlDescr.MtrlTypeID

Insert into dbo.ItemMaster (NameID, DescriptionID, ItemShortDescription,
            ProdItemCatID, ItemType)
Select Name.NameID, Description.DescriptionID, Mix.ShortDescription, ProductionItemCategory.ProdItemCatID, 'Mix'
From @Mix As Mix
Inner Join dbo.Name As Name 
On Name.Name = Mix.Name
Left Join dbo.[Description] As Description
On Description.[Description] = Mix.[Description]
Left Join dbo.ProductionItemCategory As ProductionItemCategory
On ProductionItemCategory.ItemCategory = Mix.ItemCategory
Left Join dbo.ItemMaster As ItemMaster
On ItemMaster.NameID = Name.NameID
Where ItemMaster.ItemMasterID Is Null
Group By Name.NameID, Description.DescriptionID, Mix.ShortDescription, ProductionItemCategory.ProdItemCatID

Insert into dbo.ItemMaster (NameID, DescriptionID, ItemShortDescription,
            ProdItemCatID, ItemType)
Select Name.NameID, Description.DescriptionID, MtrlInfo.ShortDescription, ProductionItemCategory.ProdItemCatID, 'Mtrl'
From @Material As MtrlInfo
Inner Join dbo.Name As Name 
On Name.Name = MtrlInfo.Name
Left Join dbo.[Description] As Description
On Description.[Description] = MtrlInfo.[Description]
Left Join dbo.ProductionItemCategory As ProductionItemCategory
On ProductionItemCategory.ItemCategory = MtrlInfo.ItemCategory
Left Join dbo.ItemMaster As ItemMaster
On ItemMaster.NameID = Name.NameID
Where ItemMaster.ItemMasterID Is Null
Group By Name.NameID, Description.DescriptionID, MtrlInfo.ShortDescription, ProductionItemCategory.ProdItemCatID

Select @MaxIndex1 = Max(AutoID) 
From @Plant

Select @DistrictID = District.DISTRICTIDENTIFIER, @DistrictCode = District.RGCODE
  From dbo.DISTRICT As District

Select @Index2 = Max(Cast(Right(Plant.PLNTTAG, Len(Plant.PLNTTAG) - 2) As Int))
From dbo.PLANT As Plant

If @Index2 Is Null
Begin
    Set @Index2 = 1
End 
Else 
Begin
    Set @Index2 = @Index2 + 1
End

Set @Index1 = 1

While (@MaxIndex1 Is Not null And @Index1 <= @MaxIndex1)
Begin
    Select @Name = Name, @Description = [Description] 
    From @Plant 
    Where AutoID = @Index1
    
    Insert into dbo.PLANT (PLNTTAG, RGCODE, PLNTNAME, [DESCRIPTION],
                DistrictID, PlantKind)
        Values ('P-' + Right('0000000' + Cast(@Index2 As Nvarchar), 7), @DistrictCode, @Name, @Description, @DistrictID, 'BatchPlant')
    
    Set @Index2 = @Index2 + 1 
        
    Set @Index1 = @Index1 + 1    
End

Set @MaterialCode = Right('00' + Cast(Year(Current_timestamp) As Nvarchar), 2) + 
                    Right('00' + Cast(Month(Current_timestamp) As Nvarchar), 2) +
                    Right('00' + Cast(Day(Current_timestamp) As Nvarchar), 2)
                    
Select @Index2 = Max(Cast(Right(Material.CODE, 5) As Int))
From dbo.MATERIAL As Material
Where Material.CODE Like '_' + @MaterialCode + '%'

If @Index2 Is Null 
Begin 
    Set @Index2 = 1
End

Update @Material
    Set CodeNumber = AutoID + @Index2
    
Update @Material
    Set Prefix = 'A'
    Where FamilyMtrlTypeID = 1

Update @Material
    Set Prefix = 'C'
    Where FamilyMtrlTypeID = 2

Update @Material
    Set Prefix = 'H'
    Where FamilyMtrlTypeID = 3

Update @Material
    Set Prefix = 'M'
    Where FamilyMtrlTypeID = 4

Update @Material
    Set Prefix = 'W'
    Where FamilyMtrlTypeID = 5

Insert Into dbo.MATERIAL
(
    CODE,
    DATE,
    [TYPE],
    SPECGR,
    SPECHT,
    PLANTCODE,
    MaterialTypeLink,
    ItemCode,
    FamilyMaterialTypeID,
    PlantID,
    ItemMasterID,
    BatchPanelDescription,
    NameID,
    DescriptionID,
    ProductionStatus,
    BatchPanelNameID,
    MOISTURE
)
Select  MtrlInfo.Prefix + @MaterialCode + Right('00000' + Cast(MtrlInfo.CodeNumber As Nvarchar), 5),
        Right('00' + Cast(Month(MtrlInfo.MaterialDate) As Nvarchar), 2) + '/' + Right('00' + Cast(Day(MtrlInfo.MaterialDate) As Nvarchar), 2) 
        + '/' + Right('0000' + Cast(Year(MtrlInfo.MaterialDate) As Nvarchar), 4),
        MtrlInfo.Category,
        MtrlInfo.SpecificGravity,
        MtrlInfo.SpecificHeat,
        Plant.PLNTTAG,
        MtrlInfo.MtrlTypeID,
        ItemName.Name,
        MtrlInfo.FamilyMtrlTypeID,
        Plant.PLANTIDENTIFIER,
        ItemMaster.ItemMasterID,
        MtrlInfo.PanelDescription,
        MtrlName.NameID,
        Description.DescriptionID,
        Null,
        PanelName.NameID,
        MtrlInfo.Moisture
    From @Material As MtrlInfo
    Inner Join dbo.PLANT As Plant
    On  MtrlInfo.PlantName = Plant.PLNTNAME
    Inner Join dbo.Name As MtrlName
    On  MtrlInfo.Name = MtrlName.Name
    Left Join dbo.[Description] As Description
    On  MtrlInfo.[Description] = Description.Description
    Left Join dbo.Name As PanelName
    On  MtrlInfo.PanelCode = PanelName.Name
    Left Join dbo.Name As ItemName
    On  MtrlInfo.Name = ItemName.Name
    Left Join dbo.ItemMaster As ItemMaster
    On  ItemName.NameID = ItemMaster.NameID And
        ItemMaster.ItemType = 'Mtrl'

Insert into @NewMixNameCodes (CodeNumber, MixNameCode)    
Exec ('[dbo].[Number_Conversion_GetBase26Numbers] 0, 100000, 1, ''A'', 4')

Insert into @NewMixCodes (ID, MixCode)
Exec ('[dbo].[CodeCreation_ReturnNewCodes] 80000, ''Batch'', ''Code'', ''B'', 0')

Delete NewMixNameCodes
From @NewMixNameCodes As NewMixNameCodes
Inner Join dbo.vwMixes As MixInfo
On MixInfo.MixNameCode = NewMixNameCodes.MixNameCode

Insert into @MixNameCodes (MixNameCode)
Select MixNameCode
From @NewMixNameCodes
Order By MixNameCode

Update MixInfo
    Set MixInfo.MixCode = NewMixCodes.MixCode,
        MixInfo.MixNameCode = MixNameCodes.MixNameCode 
From @Mix As MixInfo
Inner Join @NewMixCodes As NewMixCodes
On MixInfo.AutoID = NewMixCodes.ID
Inner Join @MixNameCodes As MixNameCodes
On MixNameCodes.AutoID = MixInfo.AutoID

Insert Into dbo.BATCH
(
    CODE,
    CRUSHCODE,
    DATE,
    [TIME],
    MixNameCode,
    THRMCOND,
    MIX,
    Plant_Link,
    BatchPanelCode,
    BatchPanelDescription,
    NameID,
    DescriptionID,
    ProductionStatus,
    ItemMasterID
)
Select  MixInfo.MixCode,
        'S97000000000',
        Right('00' + Cast(Month(MixInfo.MixDate) As Nvarchar), 2) + '/' + Right('00' + Cast(Day(MixInfo.MixDate) As Nvarchar), 2) + '/' + 
        Right('0000' + Cast(Year(MixInfo.MixDate) As Nvarchar), 4),
        '12:00',
        MixInfo.MixNameCode,
        8.1,
        'y',
        Plant.PLANTIDENTIFIER,
        MixName.Name,
        MixDescription.[Description],
        MixName.NameID,
        MixDescription.DescriptionID,
        Null,
        ItemMaster.ItemMasterID
    From @Mix As MixInfo
    Inner Join dbo.Plant As Plant
    On  MixInfo.PlantName = Plant.PLNTNAME
    Inner Join dbo.Name As MixName
    On  MixInfo.Name = MixName.Name
    Left Join dbo.[Description] As MixDescription
    On  MixDescription.[Description] = MixInfo.[Description]
    Left Join dbo.ItemMaster As ItemMaster
    On  ItemMaster.NameID = MixName.NameID And
        ItemMaster.ItemType = 'Mix'

Update MixRecipe
    Set MixRecipe.ConvertedQuantity = MixRecipe.Quantity * 0.45359240000781 * 2000.0
From @MixRecipe As MixRecipe
Where MixRecipe.QuantityUnits = '60003'

Update MixRecipe
    Set MixRecipe.ConvertedQuantity = MixRecipe.Quantity * 0.45359240000781
From @MixRecipe As MixRecipe
Where MixRecipe.QuantityUnits = '60002'

Update MixRecipe
    Set MixRecipe.ConvertedQuantity = MixRecipe.Quantity * Material.SPECGR * 0.0651984837440621 * 0.45359240000781  
From @MixRecipe As MixRecipe
Inner Join dbo.Plant As Plant
On MixRecipe.PlantName = Plant.PLNTNAME
Inner Join dbo.Name As Name 
On MixRecipe.MaterialName = Name.Name
Inner Join dbo.ItemMaster As ItemMaster
On  ItemMaster.NameID = Name.NameID And 
    ItemMaster.ItemType = 'Mtrl'
Inner Join dbo.Material As Material
On  Material.ItemMasterID = ItemMaster.ItemMasterID And
    Plant.PLANTIDENTIFIER = Material.PlantID 
Where MixRecipe.QuantityUnits = '50001'

Update MixRecipe
    Set MixRecipe.ConvertedQuantity = MixRecipe.Quantity * Material.SPECGR * 8.3454044 * 0.45359240000781 
From @MixRecipe As MixRecipe
Inner Join dbo.Plant As Plant
On MixRecipe.PlantName = Plant.PLNTNAME
Inner Join dbo.Name As Name 
On MixRecipe.MaterialName = Name.Name
Inner Join dbo.ItemMaster As ItemMaster
On  ItemMaster.NameID = Name.NameID And 
    ItemMaster.ItemType = 'Mtrl'
Inner Join dbo.Material As Material
On  Material.ItemMasterID = ItemMaster.ItemMasterID And
    Plant.PLANTIDENTIFIER = Material.PlantID 
Where MixRecipe.QuantityUnits = '50004'

Update MixRecipe
    Set MixRecipe.ConvertedQuantity = MixRecipe.Quantity * 1000.0 
From @MixRecipe As MixRecipe
Where MixRecipe.QuantityUnits = '60013'

Update MixRecipe
    Set MixRecipe.ConvertedQuantity = MixRecipe.Quantity  
From @MixRecipe As MixRecipe
Where MixRecipe.QuantityUnits = '60012'

Update MixRecipe
    Set MixRecipe.ConvertedQuantity = MixRecipe.Quantity * Material.SPECGR * 0.001
From @MixRecipe As MixRecipe
Inner Join dbo.Plant As Plant
On MixRecipe.PlantName = Plant.PLNTNAME
Inner Join dbo.Name As Name 
On MixRecipe.MaterialName = Name.Name
Inner Join dbo.ItemMaster As ItemMaster
On  ItemMaster.NameID = Name.NameID And 
    ItemMaster.ItemType = 'Mtrl'
Inner Join dbo.Material As Material
On  Material.ItemMasterID = ItemMaster.ItemMasterID And
    Plant.PLANTIDENTIFIER = Material.PlantID 
Where MixRecipe.QuantityUnits = '50012'

Update MixRecipe
    Set MixRecipe.ConvertedQuantity = MixRecipe.Quantity * Material.SPECGR * 1.0 
From @MixRecipe As MixRecipe
Inner Join dbo.Plant As Plant
On MixRecipe.PlantName = Plant.PLNTNAME
Inner Join dbo.Name As Name 
On MixRecipe.MaterialName = Name.Name
Inner Join dbo.ItemMaster As ItemMaster
On  ItemMaster.NameID = Name.NameID And 
    ItemMaster.ItemType = 'Mtrl'
Inner Join dbo.Material As Material
On  Material.ItemMasterID = ItemMaster.ItemMasterID And
    Plant.PLANTIDENTIFIER = Material.PlantID 
Where MixRecipe.QuantityUnits = '50011'

Update MixRecipe
    Set MixRecipe.ConvertedQuantity = MixRecipe.Quantity  
From @MixRecipe As MixRecipe
Where MixRecipe.ConvertedQuantity Is Null

Insert into dbo.MaterialRecipe (CODE, MATERIAL, QUANTITY, MOISTURE, EntityID,
            EntityType, MaterialID)
Select  MixInfo.CODE, 
        Material.CODE, 
        MixRecipe.ConvertedQuantity, 
        0.0, 
        MixInfo.BATCHIDENTIFIER, 
        'Mix', 
        Material.MATERIALIDENTIFIER
From @MixRecipe As MixRecipe
Inner Join dbo.Plant As Plant
On MixRecipe.PlantName = Plant.PLNTNAME
Inner Join dbo.Name As MixName
On MixRecipe.MixName = MixName.Name
Inner Join dbo.Batch As MixInfo
On  MixInfo.NameID = MixName.NameID And 
    MixInfo.Plant_Link = Plant.PLANTIDENTIFIER
Inner Join dbo.Name As MtrlName
On MixRecipe.MaterialName = MtrlName.Name
Inner Join dbo.ItemMaster As ItemMaster
On ItemMaster.NameID = MtrlName.NameID And ItemMaster.ItemType = 'Mtrl'
Inner Join dbo.MATERIAL As Material
On  ItemMaster.ItemMasterID = Material.ItemMasterID And 
    Plant.PLANTIDENTIFIER = Material.PlantID

Update MixInfo
    Set MixInfo.SackContent = RecipeInfo.CementitiousQty / 42.6376856007341
From dbo.BATCH As MixInfo
Inner Join dbo.Name As Name
On Name.NameID = MixInfo.NameID
Inner Join dbo.PLANT As Plant 
On Plant.PLANTIDENTIFIER = MixInfo.Plant_Link
Inner Join @Mix As ProdMix
On  Plant.PLNTNAME = ProdMix.PlantName And 
    Name.Name = ProdMix.Name
Inner Join 
(
    Select  MaterialRecipe.EntityID As MixID, 
            Sum(IsNull(MaterialRecipe.QUANTITY, 0.0) * (1 - IsNull(Material.MOISTURE, 0.0))) As CementitiousQty 
    From dbo.MaterialRecipe As MaterialRecipe
    Inner Join dbo.MATERIAL As Material
    On Material.MATERIALIDENTIFIER = MaterialRecipe.MaterialID
    Where Material.FamilyMaterialTypeID In (2, 4)
    Group By MaterialRecipe.EntityID 
) As RecipeInfo
On MixInfo.BATCHIDENTIFIER = RecipeInfo.MixID
Where IsNull(RecipeInfo.CementitiousQty, 0.0) >= 0.0
Go 

 
If Object_id(N'TempDB..#MixInfo') Is Not null 
Begin
    Drop table #MixInfo
End

Create table #MixInfo
(
    MixID Int 
)

Insert into #MixInfo (MixID)
    Select MixData.MixIdentifier
    From dbo.vwMixes As MixData
    
Exec dbo.Mix_CalcMaterialCostsByMixIDTempTable '#MixInfo', 'MixID', 1.5, 0

Exec dbo.Mix_CalcTheoAndMeasCalcsByMixIDTempTable '#MixInfo', 'MixID', 1.5, 0

If Object_id(N'TempDB..#MixInfo') Is Not null 
Begin
    Drop table #MixInfo
End
Go 
    
If  ObjectProperty(Object_ID(N'[dbo].[Number_Conversion_Base10ToBase26]'), N'IsProcedure') = 1 
Begin
	Drop Procedure [dbo].[Number_Conversion_Base10ToBase26]
End
Go

If  ObjectProperty(Object_ID(N'[dbo].[Number_Conversion_GetBase26Numbers]'), N'IsProcedure') = 1 
Begin
	Drop Procedure [dbo].[Number_Conversion_GetBase26Numbers]
End
Go

If  ObjectProperty(Object_ID(N'[dbo].[CodeCreation_ReturnNewCodes]'), N'IsProcedure') = 1 
Begin
	Drop Procedure [dbo].[CodeCreation_ReturnNewCodes]
End
Go
