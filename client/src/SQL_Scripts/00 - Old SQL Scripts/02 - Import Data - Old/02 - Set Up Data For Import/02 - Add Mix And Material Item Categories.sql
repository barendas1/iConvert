If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialItemCategory')
    Begin
		Insert Into Data_Import_RJ.dbo.TestImport0000_XML_MaterialItemCategory
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
		From CmdProd_SONAG_RJ.dbo.icat As CategoryInfo
		Left Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialItemCategory As MtrlCategory
		On	dbo.TrimNVarChar(CategoryInfo.item_cat) = dbo.TrimNVarChar(MtrlCategory.Name) And
			MtrlCategory.CategoryType = 'Mtrl'
		Where	MtrlCategory.AutoID Is Null And
				dbo.TrimNVarChar(Isnull(CategoryInfo.item_type, '')) <> '01' And
				dbo.TrimNVarChar(Isnull(CategoryInfo.item_cat, '')) Not In
				(
                    'BAG',
                    'BM',
                    'C1',
                    'C2',
                    'C3',
                    'C4',
                    'C5',
                    'C6',
                    'C7',
                    'DC',
                    'E1',
                    'EXCHG',
                    'EXTRA',
                    'HC',
                    'S1',
                    'SG02',
					'',
					''
				)
		Order By dbo.TrimNVarChar(CategoryInfo.item_cat)
	End
End
Go

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MixItemCategory')
    Begin
		Insert Into Data_Import_RJ.dbo.TestImport0000_XML_MixItemCategory
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
		From CmdProd_SONAG_RJ.dbo.icat As CategoryInfo
		Left Join Data_Import_RJ.dbo.TestImport0000_XML_MixItemCategory As MixCategory
		On	dbo.TrimNVarChar(CategoryInfo.item_cat) = dbo.TrimNVarChar(MixCategory.Name) And
			MixCategory.CategoryType = 'Mix'
		Where	MixCategory.AutoID Is Null And
				dbo.TrimNVarChar(CategoryInfo.item_type) = '01'
		Order By dbo.TrimNVarChar(CategoryInfo.item_cat)
	End
End
Go
/*
If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If	Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_XML_MaterialItemCategory') And
		Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'Import24_MaterialItemCategory')
    Begin
    	Update MtrlItemCategory
    		Set MtrlItemCategory.FamilyMaterialTypeName = PrevItemCategory.FamilyMaterialTypeName,
    			MtrlItemCategory.MaterialTypeName = PrevItemCategory.MaterialTypeName,
    			MtrlItemCategory.SpecificGravity = PrevItemCategory.SpecificGravity
    	From Data_Import_RJ.dbo.TestImport0000_XML_MaterialItemCategory As MtrlItemCategory
    	Inner Join Data_Import_RJ.dbo.Import22_MaterialItemCategory As PrevItemCategory
    	On dbo.TrimNVarChar(MtrlItemCategory.Name) = dbo.TrimNVarChar(PrevItemCategory.Name)
    	Where Isnull(MtrlItemCategory.MaterialTypeName, '') = ''
	End
End
Go
*/