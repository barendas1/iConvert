If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixItemCategory')
    Begin
		Insert Into Data_Import_RJ.dbo.TestImport0000_MixItemCategory
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
				'Mix'
		From CmdTest_RJ.dbo.icat As CategoryInfo
		Left Join Data_Import_RJ.dbo.TestImport0000_MixItemCategory As MixCategory
		On	dbo.TrimNVarChar(CategoryInfo.item_cat) = dbo.TrimNVarChar(MixCategory.Name) And
			MixCategory.CategoryType = 'Mix'
		Where	MixCategory.AutoID Is Null And
				dbo.TrimNVarChar(CategoryInfo.item_type) = '01'
		Order By dbo.TrimNVarChar(CategoryInfo.item_cat)
	End
End
Go
