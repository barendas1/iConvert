If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialItemCategory')
    Begin
		Insert Into Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory
		(
			Name,
			[Description],
			ShortDescription,
			CategoryNumber,
			CategoryType
		)
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
				(
				    dbo.TrimNVarChar(CategoryInfo.item_cat) In
				    (
			            Select dbo.TrimNVarChar(IMST.item_cat)
			            From CmdTest_RJ.dbo.ICST As ICST
			            Inner Join CmdTest_RJ.dbo.imst As IMST
			            On ICST.const_item_code = IMST.item_code
			            Group By dbo.TrimNVarChar(IMST.item_cat)
				    ) Or
				    dbo.TrimNVarChar(CategoryInfo.item_cat) In
				    (
			            Select dbo.TrimNVarChar(OtherCategory.ItemCategoryName)
			            From Data_Import_RJ.dbo.TestImport0000_OtherMaterialItemCategory As OtherCategory
			            Inner Join CmdTest_RJ.dbo.icat As ICAT
			            On dbo.TrimNVarChar(ICAT.item_cat) = dbo.TrimNVarChar(OtherCategory.ItemCategoryName)
			            Group By dbo.TrimNVarChar(OtherCategory.ItemCategoryName)
				    ) Or
				    dbo.TrimNVarChar(CategoryInfo.item_cat) In 
				    (
                        '18',
                        '19',
                        '20',
                        '21',
                        '24',
                        '25',
                        '26',
                        '27',
                        '28',
                        '29',
                        '30',
                        '34',
                        '35',
                        '36',
                        '98'
				    )
				) And
				dbo.TrimNVarChar(Isnull(CategoryInfo.item_cat, '')) Not In
				(
				    ''
				)
		Order By dbo.TrimNVarChar(CategoryInfo.item_cat)
	End
End
Go

