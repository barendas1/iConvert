Select *
From CmdTest_RJ.dbo.icat As ICAT
Order By Case when ICAT.item_type = '01' Then 1 Else 0 End, ICAT.item_cat

Select *
From CmdTest_RJ.dbo.icat As ICAT
Order By Case when ICAT.item_type = '01' Then 1 Else 0 End, ICAT.item_cat

Select *
From CmdTest_RJ.dbo.icat As ICAT
Where ICAT.item_type <> '01'
Order By ICAT.item_cat

Select	dbo.TrimNVarChar(CategoryInfo.item_cat),
		dbo.TrimNVarChar(CategoryInfo.descr),
		dbo.TrimNVarChar(CategoryInfo.short_descr),
		dbo.TrimNVarChar(CategoryInfo.item_type),
		'Mtrl'
From CmdTest_RJ.dbo.icat As CategoryInfo
Left Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As MtrlCategory
On	dbo.TrimNVarChar(CategoryInfo.item_cat) = dbo.TrimNVarChar(MtrlCategory.Name) And
	MtrlCategory.CategoryType = 'Mtrl'
Where	MtrlCategory.AutoID Is Null And
		dbo.TrimNVarChar(Isnull(CategoryInfo.item_type, '')) <> '01' And
		dbo.TrimNVarChar(CategoryInfo.item_cat) In
		(
			Select dbo.TrimNVarChar(IMST.item_cat)
			From CmdTest_RJ.dbo.ICST As ICST
			Inner Join CmdTest_RJ.dbo.imst As IMST
			On ICST.const_item_code = IMST.item_code
			Group By dbo.TrimNVarChar(IMST.item_cat)
		)
Order By dbo.TrimNVarChar(CategoryInfo.item_cat)

Select	dbo.TrimNVarChar(CategoryInfo.item_cat),
		dbo.TrimNVarChar(CategoryInfo.descr),
		dbo.TrimNVarChar(CategoryInfo.short_descr),
		dbo.TrimNVarChar(CategoryInfo.item_type),
		'Mtrl'
From CmdTest_RJ.dbo.icat As CategoryInfo
Where	dbo.TrimNVarChar(Isnull(CategoryInfo.item_type, '')) <> '01' And
		dbo.TrimNVarChar(CategoryInfo.item_cat) In
		(
			Select dbo.TrimNVarChar(IMST.item_cat)
			From CmdTest_RJ.dbo.ICST As ICST
			Inner Join CmdTest_RJ.dbo.imst As IMST
			On ICST.const_item_code = IMST.item_code
			Group By dbo.TrimNVarChar(IMST.item_cat)
		) 
Order By dbo.TrimNVarChar(CategoryInfo.item_cat)
