If Exists (Select * From INFORMATION_SCHEMA.ROUTINES As RoutineInfo Where RoutineInfo.ROUTINE_NAME = 'GetSelectSQLQueryFromTableName' And RoutineInfo.ROUTINE_TYPE = 'Function')
Begin
    Drop function [dbo].[GetSelectSQLQueryFromTableName]
End
Go

Set Ansi_nulls On
Go

Set Quoted_identifier On
Go

-- ================================================================================================
-- Author:		Robert Jansen
-- Create date: 01/25/2021
-- Description:	Return a SQL Query from a Table Name.
-- ================================================================================================
Create Function [dbo].[GetSelectSQLQueryFromTableName]
(
	@SchemaName Nvarchar (Max),
    @TableName Nvarchar(Max)
)
Returns NVarChar (Max)
As
Begin
	Declare @ColumnInfo Table (AutoID Int Identity (1, 1), SchemaName Nvarchar (100), TableName Nvarchar (100), ColumnName Nvarchar (100), DataTypeName Nvarchar (100))
	Declare @Schema Nvarchar (Max) = Ltrim(Rtrim(Isnull(@SchemaName, '')))
	Declare @Table Nvarchar (Max) = Ltrim(Rtrim(Isnull(@TableName, '')))
	Declare @Column Nvarchar (Max) = Null
	Declare @DataType Nvarchar (Max) = Null
	Declare @Index Int = Null
	Declare @MaxIndex Int = Null
	Declare @NewLine Nvarchar (10) = Char(13) + Char(10)
	Declare @SQLQuery NVarChar (Max) = ''
		
	If Exists (Select * From INFORMATION_SCHEMA.TABLES As TableInfo Where TableInfo.TABLE_SCHEMA = @Schema And TableInfo.TABLE_NAME = @Table)
	Begin
	    Insert into @ColumnInfo
	    (
	    	-- AutoID -- this column value is auto-generated
	    	SchemaName,
	    	TableName,
	    	ColumnName,
	    	DataTypeName
	    )
	    Select  ColumnInfo.TABLE_SCHEMA, 
	            ColumnInfo.TABLE_NAME,
	            ColumnInfo.COLUMN_NAME, 
	            ColumnInfo.DATA_TYPE
	    From INFORMATION_SCHEMA.[COLUMNS] As ColumnInfo
	    Where   ColumnInfo.TABLE_SCHEMA = @Schema And
	            ColumnInfo.TABLE_NAME = @Table
	    Order By ColumnInfo.ORDINAL_POSITION
	    
	    Select @Index = Min(AutoID), @MaxIndex = Max(AutoID)
	    From @ColumnInfo As ColumnInfo
	    
	    While (@Index <= @MaxIndex)	    
	    Begin
	    	Set @Schema = Null
	    	Set @Table = Null
	    	Set @Column = Null
	    	Set @DataType = Null
	    	
	    	Select  @Schema = ColumnInfo.SchemaName,
	    	        @Table = ColumnInfo.TableName,
	    	        @Column = ColumnInfo.ColumnName,
	    	        @DataType = ColumnInfo.DataTypeName
	    	From @ColumnInfo As ColumnInfo
	    	Where ColumnInfo.AutoID = @Index
	    	--'Select  '
	    	--'        '
	    	If @SQLQuery <> ''
	    	Begin
                Set @SQLQuery = @SQLQuery + ', ' + @NewLine + '        ' 
	    	End
	    	Else
	    	Begin
	            Set @SQLQuery = @SQLQuery + 'Select  '
	    	End
	    	
	    	If @DataType Like '%Char%' --Or @DataType Like '%Text%'
	    	Begin
	    	    Set @SQLQuery = @SQLQuery + 'LTrim(RTrim(Replace([' + @Table + '].[' + @Column + '], Char(160), '' ''))) AS [' + @Column + ']'
	    	End
	    	Else
	        Begin
	            Set @SQLQuery = @SQLQuery + '[' + @Table + '].[' + @Column + '] AS [' + @Column + ']'
	        End
	        
	        Set @Index = @Index + 1
	    End
	    	    
	    If @SQLQuery <> ''
	    Begin
	        Set @SQLQuery = @SQLQuery + ' ' + @NewLine +
	            'From [' + @Schema + '].[' + @Table + '] As [' + @Table + '] ' + @NewLine
	    End	    
	End
	
	Return @SQLQuery
End
Go
