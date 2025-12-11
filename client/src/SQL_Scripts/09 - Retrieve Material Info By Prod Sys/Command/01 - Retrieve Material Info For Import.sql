--> This script imports all Materials in all Plants.
If Exists (Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ICAT' And COLUMN_NAME = 'Item_Cat')
Begin
	--> Delete From Data_Import_RJ.dbo.TestImport0000_MaterialInfo
	Declare @MixMaterial Table 
	(
		ID Int, 
		PlantName NVarChar (100) Index IX_MixMaterial_PlantName,
		ItemCode NVarChar (100) Index IX_MixMaterial_ItemCode
	)

    Declare @ItemCategoriesToSkip Table (ItemCategoryName Nvarchar (200))

	Declare @IncludeInactiveMixes Bit = 1
    Declare @MaterialDate Nvarchar (40) = Format(Getdate(), 'MM/dd/yyyy') 
    --> Declare @MaterialDate Nvarchar (40) = Format(Getdate(), 'dd/MM/yyyy') ==> Use this line for mostly International Customers
    

    --> Update the Item Categories Skip List.
    Insert into @ItemCategoriesToSkip
    (
	    ItemCategoryName
    )
    Select Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' ')))
    From
    (
		Select 'ADMIX' As ItemCategoryName Union All 
		Select 'BLOCKS' As ItemCategoryName Union All 
		Select 'BREAK' As ItemCategoryName Union All 
		Select 'ICE' As ItemCategoryName Union All 
		Select 'MISC' As ItemCategoryName Union All 
		Select 'PR' As ItemCategoryName Union All 
		Select 'RCA' As ItemCategoryName Union All 
		Select 'RTL' As ItemCategoryName Union All 
		Select 'SKCEM' As ItemCategoryName Union All 
		Select '20' As ItemCategoryName Union All 
		Select '21' As ItemCategoryName Union All 
		Select '22' As ItemCategoryName Union All 
		Select '23' As ItemCategoryName Union All 
		Select '25' As ItemCategoryName Union All
	    Select '14' As ItemCategoryName
	    Union All
	    Select '15' As ItemCategoryName
	    Union All
	    Select '113' As ItemCategoryName
	    Union All
	    Select '114' As ItemCategoryName
	    Union All
	    Select '24' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
	    Union All
	    Select '' As ItemCategoryName
    ) As ItemCategoryInfo
    Where Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' '))) <> ''
    Group By Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' ')))
    Order By Ltrim(Rtrim(Replace(Isnull(ItemCategoryInfo.ItemCategoryName, ''), Char(160), ' ')))

	Insert Into @MixMaterial (ID, PlantName, ItemCode)
	Select -1 As ID, Trim(MixICST.loc_code) As Loc_Code, Trim(MixICST.const_item_code) As Item_Code
	From dbo.ILOC As MixILOC
	Inner Join dbo.ICST As MixICST
	On  MixILOC.loc_code = MixICST.loc_code And
		MixILOC.item_code = MixICST.item_code
	Where Trim(Isnull(MixILOC.inactive_code, '')) In ('', '00', '0') Or Isnull(@IncludeInactiveMixes, 0) = 1
	Group By Trim(MixICST.loc_code), Trim(MixICST.const_item_code)
	
    Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo 
    (
	    PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName,
	    SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName,
	    ManufacturerName, ManufacturerSourceName, BatchingOrderNumber, ItemCode,
	    ItemDescription, ItemShortDescription, ItemCategoryName,
	    ItemCategoryDescription, ItemCategoryShortDescription, ComponentCategoryName,
	    ComponentCategoryDescription, ComponentCategoryShortDescription,
	    BatchPanelCode, UpdatedFromDatabase, IsInactive
    )
    
    Select  Trim(MaterialInfo.loc_code), 
            Case when Isnull(Trim(MainInfo.descr), '') <> '' Then Trim(MainInfo.descr) Else Trim(MaterialInfo.item_code) End As TradeName,
            @MaterialDate As MaterialDate,
            CategoryInfo.FamilyMaterialTypeName As FamilyMaterialTypeName,
            CategoryInfo.MaterialTypeName As MaterialTypeName,
            Case when Isnull(MaterialInfo.spec_grav, -1.0) >= 0.4 Then MaterialInfo.spec_grav Else CategoryInfo.SpecificGravity End As SpecificGravity,
            CategoryInfo.IsLiquidAdmix As IsLiquidAdmix,
            0.0 As MoisturePercent,
            Case when Trim(Isnull(CostUnitInfo.uom, '')) <> '' Then MaterialInfo.curr_std_cost Else Null End As [Cost],
            Case when Trim(CostUnitInfo.uom) = '60001' Then 'Dry Oz' Else Trim(CostUnitInfo.abbr) End As [Cost Units],
            Null As ManufacturerName,
            Null As ManufacturerSourceName,
            Null As BatchingOrderNumber,
            Trim(MaterialInfo.item_code),
            Trim(MainInfo.descr),
            Trim(MainInfo.short_descr),
            CategoryInfo.Name,
            CategoryInfo.Description,
            CategoryInfo.ShortDescription,
            Null As ComponentCategoryName,
            Null As ComponentCategoryDescription,
            Null As ComponentCategoryShortDescription,
            BatchPanelInfo.batch_code As BatchPanelCode,
            0 As UpdatedFromDatabase,
            Case when Trim(Isnull(MaterialInfo.inactive_code, '')) In ('', '0', '00') Then 'No' Else 'Yes' End As IsInactive 
    From dbo.iloc As MaterialInfo
    Inner Join dbo.imst As MainInfo
    On MainInfo.item_code = MaterialInfo.item_code    
    Inner Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
    On Trim(MainInfo.item_cat) = CategoryInfo.Name
	Left Join @ItemCategoriesToSkip As ItemCategoryToSkip
	On CategoryInfo.Name = ItemCategoryToSkip.ItemCategoryName
    Left Join dbo.UOMS As CostUnitInfo
    On MainInfo.purch_uom = CostUnitInfo.uom
	Left Join
	(
		Select  Trim(BatchPanelInfo.loc_code) As loc_code, 
			    Trim(BatchPanelInfo.item_code) As item_code,
			    Min(Trim(BatchPanelInfo.batch_code)) As batch_code 
		From dbo.IMLB As BatchPanelInfo
		Where Isnull(Trim(BatchPanelInfo.batch_code), '') <> ''
		Group By Trim(BatchPanelInfo.loc_code), Trim(BatchPanelInfo.item_code) 
	) As BatchPanelInfo
	On	BatchPanelInfo.loc_code = Trim(MaterialInfo.loc_code) And
		BatchPanelInfo.item_code = Trim(MaterialInfo.item_code)
    Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As ExistingMaterialInfo
    On  Trim(MaterialInfo.loc_code) = ExistingMaterialInfo.PlantName And
        Trim(MaterialInfo.item_code) = ExistingMaterialInfo.ItemCode
    Left Join @MixMaterial As MixMaterial
	On Trim(MaterialInfo.loc_code) = MixMaterial.PlantName And Trim(MaterialInfo.item_code) = MixMaterial.ItemCode
	/*
	(
		Select -1 As ID, Trim(MixICST.loc_code) As Loc_Code, Trim(MixICST.const_item_code) As Item_Code
		From dbo.ILOC As MixILOC
		Inner Join dbo.ICST As MixICST
		On  MixILOC.loc_code = MixICST.loc_code And
		    MixILOC.item_code = MixICST.item_code
		Where Trim(Isnull(MixILOC.inactive_code, '')) In ('', '00', '0') Or Isnull(@IncludeInactiveMixes, 0) = 1
		Group By Trim(MixICST.loc_code), Trim(MixICST.const_item_code)
	) As MixMaterial
	On Trim(MaterialInfo.loc_code) = MixMaterial.Loc_Code And Trim(MaterialInfo.item_code) = MixMaterial.Item_Code
	*/
	Where   ExistingMaterialInfo.AutoID Is Null And
		    (
		        Trim(Isnull(MaterialInfo.inactive_code, '')) In ('', '00', '0') And ItemCategoryToSkip.ItemCategoryName Is Null Or
		        MixMaterial.ID Is Not Null
		    )
	Order By	Trim(MaterialInfo.loc_code), 
				Trim(CategoryInfo.FamilyMaterialTypeName),
				Trim(CategoryInfo.Name), 
				Trim(MainInfo.descr),
				Trim(MaterialInfo.item_code)


    Update MaterialInfo
	    Set MaterialInfo.TradeName = MaterialInfo.ItemCode
    From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
    Inner Join
    (
	    Select MaterialInfo.PlantName, MaterialInfo.TradeName, Min(MaterialInfo.AutoID) As MinAutoID
	    From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
	    Group By MaterialInfo.PlantName, MaterialInfo.TradeName
	    Having Count(*) > 1
    ) As DuplicateInfo
    On  DuplicateInfo.PlantName = MaterialInfo.PlantName And
	    DuplicateInfo.TradeName = MaterialInfo.TradeName 
    Where MaterialInfo.AutoID <> DuplicateInfo.MinAutoID
End
Go
