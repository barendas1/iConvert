--Use this if needed.
/*
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
	If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialInfo')
	Begin
		Drop Table Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo
	End
End
Go
*/
