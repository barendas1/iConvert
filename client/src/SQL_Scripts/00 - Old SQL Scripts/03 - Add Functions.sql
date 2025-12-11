If Exists (Select * From INFORMATION_SCHEMA.ROUTINES As RoutineInfo Where RoutineInfo.ROUTINE_NAME = 'Validation_FunctionExists')
Begin
    Drop function [dbo].[Validation_FunctionExists] 
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 10/03/2011
-- Description:	Return true if a function with the specified name exists.
--              This can be used to test for scalar or table functions.
-- ================================================================================================
Create Function [dbo].[Validation_FunctionExists]
(
	@FunctionName Nvarchar (Max)
)
Returns Bit
As
Begin
	Declare @Exists Bit
	
	Set @FunctionName = Ltrim(Rtrim(Isnull(@FunctionName, '')))
	
	Set @Exists = 0
	
	If Exists
	    (
	    	Select * 
	    	    From INFORMATION_SCHEMA.ROUTINES As RoutineInfo
	    	    Where   RoutineInfo.ROUTINE_NAME = @FunctionName And 
	    	            RoutineInfo.ROUTINE_TYPE = 'Function'	    	            
	    )
	Begin
	    Set @Exists = 1
	End
	
	Return @Exists 
End
Go

If dbo.Validation_FunctionExists('GetNewLine') = 1
Begin
    Drop function dbo.GetNewLine
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 12/10/2009
-- Description:	Return characters for a new line.
-- ================================================================================================
Create Function [dbo].[GetNewLine]
(
)
Returns Nvarchar (10)
As
Begin
	Return Char(13) + Char(10)
End
Go

If dbo.Validation_FunctionExists('GetTrimmedValueOrNullValue') = 1
Begin
    Drop function dbo.GetTrimmedValueOrNullValue
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 11/14/2020
-- Description:	Return a value with the leading and trailing white space trimmed from it.
-- ================================================================================================
Create Function [dbo].[GetTrimmedValueOrNullValue]
(
	@Value Nvarchar (Max),
	@RemoveInnerWhiteSpaceCharacters Bit = 1,
	@RemoveInnerNewLineCharacters Bit = 1,
	@NullValue Nvarchar (Max) = Null
)
Returns Nvarchar (Max)
As
Begin
	Declare @TrimmedValue Nvarchar (Max) = Ltrim(Rtrim(@Value))
	Declare @RemoveInnerWhiteSpace Bit = Isnull(@RemoveInnerWhiteSpaceCharacters, 0)
	Declare @RemoveInnerNLChars Bit = Isnull(@RemoveInnerNewLineCharacters, 0)
	Declare @NullTrimmedValue Nvarchar (Max) = @NullValue
	Declare @ValueLength Int
	Declare @ValueIndex Int
	Declare @CharValue Int
	
	If @TrimmedValue Is Null
	Begin
	    Set @TrimmedValue = @NullTrimmedValue
	End
	Else
	Begin
		Set @ValueIndex = Len(@TrimmedValue)
		
	    While @ValueIndex > 0
	    Begin
	        Set @CharValue = Unicode(Substring(@TrimmedValue, @ValueIndex, 1))
	    
	        If @CharValue > 32 And @CharValue <> 160
	        Begin
	            Break
	        End
	    	    
	        Set @ValueIndex = @ValueIndex - 1
	    End
	
	    If @ValueIndex < 1
	    Begin
	        Set @TrimmedValue = ''
	    End
	    Else
        Begin
            Set @TrimmedValue = Left(@TrimmedValue, @ValueIndex)
        End
    
        If @TrimmedValue <> ''
        Begin
            Set @ValueIndex = 1
            Set @ValueLength = Len(@TrimmedValue)
        
            While @ValueIndex <= @ValueLength
            Begin
	            Set @CharValue = Unicode(Substring(@TrimmedValue, @ValueIndex, 1))
	    
	            If @CharValue > 32 And @CharValue <> 160
	            Begin
	                Break
	            End
	    	    
	            Set @ValueIndex = @ValueIndex + 1            
            End
        
            If @ValueIndex > @ValueLength
            Begin
                Set @TrimmedValue = ''
            End
            Else
            Begin
                Set @TrimmedValue = Substring(@TrimmedValue, @ValueIndex, @ValueLength)
            End
        End
        
        If @TrimmedValue <> ''
        Begin
            If @RemoveInnerWhiteSpace = 0 And @RemoveInnerNLChars = 0
            Begin
                Set @TrimmedValue = Replace(@TrimmedValue, NChar(160), ' ')
            End
            Else If @RemoveInnerWhiteSpace = 0
            Begin
            	Set @TrimmedValue = Replace(@TrimmedValue, dbo.GetNewLine(), ' ')
                Set @TrimmedValue = Replace(Replace(Replace(@TrimmedValue, Nchar(10), ' '), Nchar(13), ' '), Nchar(160), ' ')                
            End
            Else
            Begin
            	If @RemoveInnerNLChars = 1
            	Begin
            	    Set @TrimmedValue = Replace(@TrimmedValue, dbo.GetNewLine(), ' ')
            	End
            	
                Set @ValueLength = Len(@TrimmedValue)
                Set @ValueIndex = @ValueLength
                
                While @ValueIndex > 0
                Begin
                    Set @CharValue = Unicode(Substring(@TrimmedValue, @ValueIndex, 1))
                    
                    If  @CharValue = 160 Or 
                        @RemoveInnerNLChars = 1 And (@CharValue = 10 Or @CharValue = 13) Or 
                        @CharValue < 32 And @CharValue <> 10 And @CharValue <> 13
                    Begin
                        Set @TrimmedValue = Left(@TrimmedValue, @ValueIndex - 1) + ' ' + Substring(@TrimmedValue, @ValueIndex + 1, @ValueLength)
                    End
                    
                    Set @ValueIndex = @ValueIndex - 1
                End
            End
        End
	End
		
	Return Ltrim(Rtrim(@TrimmedValue))
End
Go

If dbo.Validation_FunctionExists('GetTrimmedValue') = 1
Begin
    Drop function dbo.GetTrimmedValue
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 11/14/2020
-- Description:	Return a value with the leading and trailing white space trimmed from it.
-- ================================================================================================
Create Function [dbo].[GetTrimmedValue]
(
	@Value Nvarchar (Max)
)
Returns Nvarchar (Max)
As
Begin		
	Return dbo.GetTrimmedValueOrNullValue(@Value, 1, 1, Null)
End
Go

If Exists
(
	Select * 
	    From INFORMATION_SCHEMA.ROUTINES As RoutineInfo
	    Where   RoutineInfo.ROUTINE_NAME = 'TrimNVarChar' And 
	    	    RoutineInfo.ROUTINE_TYPE = 'Function'	    	            
)
Begin
    Drop function dbo.TrimNVarChar
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 02/14/2017
-- Description:	Trim Leading and Trailing Spaces.
-- ================================================================================================
Create Function [dbo].[TrimNVarChar]
(
	@Value NVarChar (Max)
)
Returns NVarChar (Max)
As
Begin
	Return Ltrim(Rtrim(Replace(@Value, Char(160), ' '))) 
End
Go

If Exists
(
	Select * 
	    From INFORMATION_SCHEMA.ROUTINES As RoutineInfo
	    Where   RoutineInfo.ROUTINE_NAME = 'TrimVarChar' And 
	    	    RoutineInfo.ROUTINE_TYPE = 'Function'	    	            
)
Begin
    Drop function dbo.TrimVarChar
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go
-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 02/14/2017
-- Description:	Trim Leading and Trailing Spaces.
-- ================================================================================================
Create Function [dbo].[TrimVarChar]
(
	@Value Varchar (Max)
)
Returns Varchar (Max)
As
Begin
	Return Ltrim(Rtrim(Replace(@Value, Char(160), ' '))) 
End
Go

If Exists (Select * From INFORMATION_SCHEMA.ROUTINES As Routines Where Routines.ROUTINE_NAME = 'Validation_ValueIsNumeric')
Begin
    Drop function [dbo].[Validation_ValueIsNumeric]
End
Go

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
