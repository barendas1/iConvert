If Exists (Select * From INFORMATION_SCHEMA.ROUTINES As Routines Where Routines.ROUTINE_NAME = 'Validation_ValueIsNumeric')
Begin
    Drop function [dbo].[Validation_ValueIsNumeric]
End
Go

/****** Object:  UserDefinedFunction [dbo].[Validation_ValueIsNumeric]    Script Date: 5/12/2023 1:21:15 AM ******/
Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 11/14/2011
-- Description:	Return true if the Value is Numeric.
-- ================================================================================================
Create Function [dbo].[Validation_ValueIsNumeric]
(
	@Value Nvarchar(Max)
)
Returns Bit
As
Begin
	Declare @IsNumber Bit
	
	Set @Value = Ltrim(Rtrim(Isnull(@Value, '')))
	
	Set @IsNumber = 0
	
    If  Isnumeric(@Value) = 1 And
		@Value <> '' And
        @Value <> '.' And 
        @Value <> '+' And 
        @Value <> '-' And 
        @Value <> ',' And 
        @Value <> '\' And 
        @Value <> '/' And
        @Value <> '*' And 
        @Value <> '^' And 
        Charindex(',', @Value) < 1
    Begin
        Set @IsNumber = 1
    End 
	
	Return @IsNumber 
End
Go

If  Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ') And
    Exists (Select * From sys.objects Where Name = 'Raw_Material_List')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo')
    Begin
    	Declare @UnitSys Nvarchar (30) = 'US'
    	
    	If @UnitSys = 'US'
    	Begin
            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex(' ', MixInfo.MixShortDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex(' ', MixInfo.MixShortDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex(' ', MixInfo.MixShortDescription) - 1)))) = 4 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex(' ', MixInfo.MixShortDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1

            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex(',', MixInfo.MixShortDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex(',', MixInfo.MixShortDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex(',', MixInfo.MixShortDescription) - 1)))) = 4 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex(',', MixInfo.MixShortDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1

            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('@', MixInfo.MixShortDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex('@', MixInfo.MixShortDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('@', MixInfo.MixShortDescription) - 1)))) = 4 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('@', MixInfo.MixShortDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1

            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('_', MixInfo.MixShortDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex('_', MixInfo.MixShortDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('_', MixInfo.MixShortDescription) - 1)))) = 4 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('_', MixInfo.MixShortDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1

            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('psi', MixInfo.MixShortDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex('psi', MixInfo.MixShortDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('psi', MixInfo.MixShortDescription) - 1)))) = 4 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('psi', MixInfo.MixShortDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1
        


            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex(' ', MixInfo.MixDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) - 1)))) = 4 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1

            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex(',', MixInfo.MixDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex(',', MixInfo.MixDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex(',', MixInfo.MixDescription) - 1)))) = 4 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex(',', MixInfo.MixDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1

            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('psi', MixInfo.MixDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex('psi', MixInfo.MixDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('psi', MixInfo.MixDescription) - 1)))) = 4 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('psi', MixInfo.MixDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1



            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(Substring(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription)), Charindex(' ', Substring(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription))) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Isnull(MixInfo.MixDescription, '') = '' 
                        Then 0
                        When Charindex(' ', MixInfo.MixDescription) < 1
                        Then 0
                        When Charindex(' ', Substring(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription))) < 1
                        Then 0
                        When Len(Ltrim(Rtrim(Left(Substring(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription)), Charindex(' ', Substring(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription))) - 1)))) <> 4
                        Then 0
                        When iServiceDataExchange.dbo.Validation_ValueIsNumeric(Ltrim(Rtrim(Left(Substring(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription)), Charindex(' ', Substring(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription))) - 1)))) = 0
                        Then 0
                        When Cast(Ltrim(Rtrim(Left(Substring(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription)), Charindex(' ', Substring(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription))) - 1))) As Float) <= 0.0            
                        Then 0
                        Else 1
                    End = 1
        
            /*        
            Update MixInfo
                Set MixInfo.Strength =
                    Case
                        When Cast(Left(Substring(MixInfo.MixDescription, 5, Len(MixInfo.MixDescription)), Charindex(' ', Substring(MixInfo.MixDescription, 5, Len(MixInfo.MixDescription)))) As Float) >= 0.1
                        Then Cast(Left(Substring(MixInfo.MixDescription, 5, Len(MixInfo.MixDescription)), Charindex(' ', Substring(MixInfo.MixDescription, 5, Len(MixInfo.MixDescription)))) As Float)
                        Else Null
                    End
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    MixInfo.MixDescription Like 'FOB %' And
                    dbo.Validation_ValueIsNumeric(Left(Substring(MixInfo.MixDescription, 5, Len(MixInfo.MixDescription)), Charindex(' ', SubString(MixInfo.MixDescription, 5, Len(MixInfo.MixDescription))))) = 1 And
                    Len(Ltrim(Rtrim(Left(SubString(MixInfo.MixDescription, 5, Len(MixInfo.MixDescription)), Charindex(' ', SubString(MixInfo.MixDescription, 5, Len(MixInfo.MixDescription))))))) = 4 And
                    Charindex('.', Left(SubString(MixInfo.MixDescription, 5, Len(MixInfo.MixDescription)), Charindex(' ', SubString(MixInfo.MixDescription, 5, Len(MixInfo.MixDescription))))) < 1
            */
    	End
    	Else
    	Begin
            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('mpa', MixInfo.MixShortDescription) - 1))) As Float)
            --Select MixInfo.Strength , Cast(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('mpa', MixInfo.MixShortDescription) - 1))) As Float), *
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex('mpa', MixInfo.MixShortDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('mpa', MixInfo.MixShortDescription) - 1)))) = 2 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixShortDescription, Charindex('mpa', MixInfo.MixShortDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1
    	    
            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('mpa', MixInfo.MixDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex('mpa', MixInfo.MixDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('mpa', MixInfo.MixDescription) - 1)))) = 2 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('mpa', MixInfo.MixDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1

            Update MixInfo
                Set MixInfo.Strength = Cast(Substring(MixInfo.MixDescription, Charindex('mpa', MixInfo.MixDescription) - 2, 2) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex('mpa', MixInfo.MixDescription) < 1
                        Then 0
                        When Charindex('mpa', MixInfo.MixDescription) - 3 < 2
                        Then 0
                        When Substring(MixInfo.MixDescription, Charindex('mpa', MixInfo.MixDescription) - 3, 1) <> ' '
                        Then 0
                        When dbo.Validation_ValueIsNumeric(Substring(MixInfo.MixDescription, Charindex('mpa', MixInfo.MixDescription) - 2, 2)) = 0
                        Then 0
                        When Cast(Substring(MixInfo.MixDescription, Charindex('mpa', MixInfo.MixDescription) - 2, 2) As Float) <= 0.0
                        Then 0
                        Else 1
                    End = 1
    	End
    	
        Update MixInfo
            Set MixInfo.StrengthAge = 28.0
        From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
        Where MixInfo.StrengthAge Is Null And MixInfo.Strength Is Not Null

    End
End
Go
