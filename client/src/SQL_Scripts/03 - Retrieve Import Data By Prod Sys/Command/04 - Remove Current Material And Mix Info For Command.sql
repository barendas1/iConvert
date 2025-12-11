--> This Script removes Material and Mix Information from a Command Database.

If Exists (Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ICAT' And COLUMN_NAME = 'Item_Cat')
Begin
    Delete from dbo.icst
    Delete from dbo.iprc
    Delete from dbo.pdwn
    Delete from dbo.imlb
    Delete from dbo.iloc
    Delete from dbo.imst
    Delete from dbo.icat
    Delete from dbo.locn
    Delete from dbo.uoms
End
Go