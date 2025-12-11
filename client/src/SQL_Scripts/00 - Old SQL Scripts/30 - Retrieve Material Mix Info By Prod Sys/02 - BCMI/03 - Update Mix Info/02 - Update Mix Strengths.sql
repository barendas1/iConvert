If  Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ') 
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo')
    Begin
    	Declare @UnitSys Nvarchar (30) = 'US'
    	
    	If @UnitSys = 'US'
    	Begin
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
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('-', MixInfo.MixDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex('-', MixInfo.MixDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('-', MixInfo.MixDescription) - 1)))) = 4 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('-', MixInfo.MixDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1
                    
            Update MixInfo
                Set MixInfo.Strength = Cast(MixInfo.MixDescription As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Len(Isnull(MixInfo.MixDescription, '')) <> 4 
                        Then 0
                        When    Len(Isnull(MixInfo.MixDescription, '')) = 4 And
                                iServiceDataExchange.dbo.Validation_ValueIsNumeric(MixInfo.MixDescription) = 0
                        Then 0
                        When Cast(MixInfo.MixDescription As Float) >= 1000
                        Then 1
                        Else 0
                    End = 1
                    
            /*
            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('N', MixInfo.MixDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex('N', MixInfo.MixDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('N', MixInfo.MixDescription) - 1)))) = 4 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('N', MixInfo.MixDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1

            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('A', MixInfo.MixDescription) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Charindex('A', MixInfo.MixDescription) < 1
                        Then 0
                        When    Len(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('A', MixInfo.MixDescription) - 1)))) = 4 And
                                Isnumeric(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex('A', MixInfo.MixDescription) - 1)))) = 1
                        Then 1
                        Else 0
                    End = 1
            */

            /*
    	    Declare @FirstChar Nvarchar (1) = 'C'
    	    Declare @SecondChar Nvarchar (1) = '-'
            
            Update MixInfo
                Set MixInfo.Strength = Cast(Ltrim(Rtrim(Left(Substring(MixInfo.MixDescription, Charindex(@FirstChar, MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription)), Charindex(@SecondChar, Substring(MixInfo.MixDescription, Charindex(@FirstChar, MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription))) - 1))) As Float)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Where   MixInfo.Strength Is Null And
                    Case
                        When Isnull(MixInfo.MixDescription, '') = '' 
                        Then 0
                        When Charindex(@FirstChar, MixInfo.MixDescription) < 1
                        Then 0
                        When Charindex(@SecondChar, Substring(MixInfo.MixDescription, Charindex(@FirstChar, MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription))) < 1
                        Then 0
                        When Len(Ltrim(Rtrim(Left(Substring(MixInfo.MixDescription, Charindex(@FirstChar, MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription)), Charindex(@SecondChar, Substring(MixInfo.MixDescription, Charindex(@FirstChar, MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription))) - 1)))) <> 4
                        Then 0
                        When iServiceDataExchange.dbo.Validation_ValueIsNumeric(Ltrim(Rtrim(Left(Substring(MixInfo.MixDescription, Charindex(@FirstChar, MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription)), Charindex(@SecondChar, Substring(MixInfo.MixDescription, Charindex(@FirstChar, MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription))) - 1)))) = 0
                        Then 0
                        When Cast(Ltrim(Rtrim(Left(Substring(MixInfo.MixDescription, Charindex(@FirstChar, MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription)), Charindex(@SecondChar, Substring(MixInfo.MixDescription, Charindex(@FirstChar, MixInfo.MixDescription) + 1, Len(MixInfo.MixDescription))) - 1))) As Float) <= 0.0            
                        Then 0
                        Else 1
                    End = 1
            */
            
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
