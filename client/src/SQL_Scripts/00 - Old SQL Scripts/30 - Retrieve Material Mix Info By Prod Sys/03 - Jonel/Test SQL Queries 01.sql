Select TableInfo.name, ColumnsInfo.name, ColumnsInfo.column_id
From sys.tables As TableInfo
Inner Join sys.[columns] As ColumnsInfo
On ColumnsInfo.[object_id] = TableInfo.[object_id]
Where ColumnsInfo.name = 'Class_ID'

Select TableInfo.name, ColumnsInfo.name, ColumnsInfo.column_id
From sys.tables As TableInfo
Inner Join sys.[columns] As ColumnsInfo
On ColumnsInfo.[object_id] = TableInfo.[object_id]
Where ColumnsInfo.name = 'Product_ID'
Order By TableInfo.name, ColumnsInfo.name

Select TableInfo.name, ColumnsInfo.name, ColumnsInfo.column_id
From sys.tables As TableInfo
Inner Join sys.[columns] As ColumnsInfo
On ColumnsInfo.[object_id] = TableInfo.[object_id]
Where ColumnsInfo.name = 'Formula_ID'

Select *
From Quadrel_Demo_RJ.dbo.Static_MaterialType As MaterialType
Order By MaterialType.RecipeOrder

Select MixInfo.QuantityUnitName
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Group By MixInfo.QuantityUnitName

Select MixInfo.PriceUnitName
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Group By MixInfo.PriceUnitName

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Order By MixInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where MixInfo.Strength Is  Null
Order By MixInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where MixInfo.Strength Is  Null And Charindex('PSI', MixInfo.MixDescription) > 0
Order By MixInfo.AutoID

Select *
From dbo.Aggregate_Product

Select *
From Sys.tables As TableInfo
Where TableInfo.name Like '%Import%'

Select *
From dbo.Batch_Panel_Fill_Materials


Select *
From dbo.Raw_Material_List_Import

Select *
From dbo.Concrete_Product As ProductInfo

Select *
From dbo.Plant As Plant
Where Plant.System_Type_ID = 1

Select *
From dbo.System_Type As System_Type

Select  Plant.Plant_ID As PlantCode,
        MixProduct.Product_Number As MixCode,
        Isnull(MixProduct.[Description], '') As MixDescription,
        Isnull(MixProduct.[Description], '') As MixShortDescription,
        Isnull(MixProductType.[Description], '') As MixItemCategory,
        Case when Round(Isnull(Formula.Strength, -1.0), 2) > 0.0 Then 28.0 Else Null End As StrengthAge, 
        Case when Round(Isnull(Formula.Strength, -1.0), 2) > 0.0 Then Formula.Strength Else Null End As Strength,
        Case when Round(Isnull(Formula.Air, -1.0), 4) > 0.0 Then Formula.Air Else Null End As AirContent,
        '' As MinAirContent,
        '' As MaxAiContent,
        Case when Round(Isnull(Formula.Slump, -1.0), 4) > 0.0 Then Formula.Slump Else Null End As Slump,
        '' As MinSlump,
        '' As MaxSlump,
        '' As DispatchSlumpRange,
        Case when Round(Isnull(Formula.Max_Load_Size, -1.0), 4) > 0.0 Then Formula.Max_Load_Size Else Null End As MaxLoadSize,
        Case when Round(Isnull(Formula.Sack_Equivalent, -1.0), 4) > 0.0 Then Formula.Sack_Equivalent Else Null End As SackContent,        
        Case when Round(Isnull(MixProduct.Price, -1.0), 4) > 0.0 Then MixProduct.Price Else Null End As MixPrice,
        MixUnitInfo.Imperial_Description As MixPriceUnitName,
        Case When Isnull(Formula.Inactive_Flag, 0) = 1 Then 'Yes' Else 'No' End As MixInactive,
        '' As Padding,
        Isnull(MaterialProduct.Product_Number, '') As MaterialItemCode, 
        Isnull(MaterialProduct.[Description], '') As MaterialDescription,
        MaterialList.Quantity As Quantity,
        Isnull(MaterialUnitInfo.Imperial_Description, '') As QuantityUnitName,
        MaterialList.[Rank] As QuantityOrderNumber
From dbo.Plant As Plant
Inner Join dbo.Formula As Formula
On Formula.Plant_ID = Plant.Plant_ID
Inner Join dbo.Concrete_Product As ConcreteProduct
On ConcreteProduct.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As MixProduct
On MixProduct.Product_ID = ConcreteProduct.Product_ID
Left Join dbo.Product_Type As MixProductType
On MixProductType.Product_Type_ID = MixProduct.Product_Type_ID
Left Join dbo.GL_Category As MixGLCategory
On MixGLCategory.GL_Category_ID = MixProduct.GL_Category_ID
Left Join dbo.Unit_Of_Measure As MixUnitInfo
On MixUnitInfo.Unit_Of_Measure_ID = MixProduct.Unit_Of_Measure_ID
Inner Join dbo.Raw_Material_List As MaterialList
On MaterialList.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As MaterialProduct
On MaterialProduct.Product_ID = MaterialList.Product_ID
Left Join dbo.Unit_Of_Measure As MaterialUnitInfo
On MaterialUnitInfo.Unit_Of_Measure_ID = MaterialProduct.Unit_Of_Measure_ID
Where Isnull(Formula.Inactive_Flag, 0) = 1
Order By Plant.Plant_ID, MixProduct.Product_Number, MixProduct.Product_ID, MaterialList.[Rank], MaterialProduct.Product_Number, MaterialProduct.Product_ID 

Select  Formula.Plant_ID,
        Plant.[Description],
        Formula.Formula_ID,
        Formula.[Description],
        MixInfo.Product_Number, 
        MixInfo.[Description], 
        MixInfo.Inactive_Flag,
        Formula.Slump,
        Formula.Strength,
        Formula.Sack_Equivalent,
        Formula.Air,
        Formula.Max_Load_Size,
        Formula.Inactive_Flag,
        Product.Product_ID, 
        Product.Product_Number, 
        Product.[Description],
        MaterialList.Quantity, 
        MaterialList.[Rank],
        UnitInfo.Unit_Of_Measure_ID, 
        UnitInfo.Imperial_Description
From dbo.Formula As Formula
Inner Join dbo.Plant As Plant
On Plant.Plant_ID = Formula.Plant_ID
Inner Join dbo.Concrete_Product As ConcreteProduct
On ConcreteProduct.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As MixInfo
On MixInfo.Product_ID = ConcreteProduct.Product_ID
Inner Join dbo.Raw_Material_List As MaterialList
On  MaterialList.Plant_ID = Formula.Plant_ID And
    MaterialList.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As Product
On Product.Product_ID = MaterialList.Product_ID
Inner Join dbo.Unit_Of_Measure As UnitInfo
On UnitInfo.Unit_Of_Measure_ID = Product.Unit_Of_Measure_ID
Left Join dbo.Product_Type As ProductType
On ProductType.Product_Type_ID = Product.Product_Type_ID
Left Join dbo.GL_Category As GLCategory
On GLCategory.GL_Category_ID = Product.GL_Category_ID
Order By MaterialList.Plant_ID, MaterialList.Formula_ID, MaterialList.Product_ID

Select  Plants.Name As PlantName,
        Plants.[Description] As PlantDescription,
        MixName.Name,
        MixDescr.[Description]
From ThirtySevenBP_RJ.dbo.Plants As Plants
Inner Join ThirtySevenBP_RJ.dbo.Batch As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join ThirtySevenBP_RJ.dbo.Name As MixName
On MixName.NameID = Mix.NameID
Left Join ThirtySevenBP_RJ.dbo.[Description] As MixDescr
On MixDescr.DescriptionID = Mix.DescriptionID
Order By Plants.Name, MixName.Name

Select  Formula.Formula_ID,
        Formula.Plant_ID,
        Plant.[Description],
        Formula.[Description],
        Formula.Slump,
        Formula.Strength,
        Formula.Sack_Equivalent,
        Formula.Air,
        Formula.Max_Load_Size,
        Formula.Inactive_Flag,
        Product.Product_ID, 
        Product.Product_Number, 
        Product.[Description],
        MaterialList.Quantity, 
        MaterialList.[Rank],
        UnitInfo.Unit_Of_Measure_ID, 
        UnitInfo.Imperial_Description
From dbo.Formula As Formula
Inner Join dbo.Plant As Plant
On Plant.Plant_ID = Formula.Plant_ID
Inner Join dbo.Raw_Material_List As MaterialList
On  MaterialList.Plant_ID = Formula.Plant_ID And
    MaterialList.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As Product
On Product.Product_ID = MaterialList.Product_ID
Inner Join dbo.Unit_Of_Measure As UnitInfo
On UnitInfo.Unit_Of_Measure_ID = Product.Unit_Of_Measure_ID
Left Join dbo.Product_Type As ProductType
On ProductType.Product_Type_ID = Product.Product_Type_ID
Left Join dbo.GL_Category As GLCategory
On GLCategory.GL_Category_ID = Product.GL_Category_ID
Order By MaterialList.Plant_ID, MaterialList.Formula_ID, MaterialList.Product_ID

Select  UnitInfo.Imperial_Description
From dbo.Formula As Formula
Inner Join dbo.Plant As Plant
On Plant.Plant_ID = Formula.Plant_ID
Inner Join dbo.Raw_Material_List As MaterialList
On  MaterialList.Plant_ID = Formula.Plant_ID And
    MaterialList.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As Product
On Product.Product_ID = MaterialList.Product_ID
Inner Join dbo.Unit_Of_Measure As UnitInfo
On UnitInfo.Unit_Of_Measure_ID = Product.Unit_Of_Measure_ID
Left Join dbo.Product_Type As ProductType
On ProductType.Product_Type_ID = Product.Product_Type_ID
Left Join dbo.GL_Category As GLCategory
On GLCategory.GL_Category_ID = Product.GL_Category_ID
Group By UnitInfo.Imperial_Description

Select UnitInfo.Imperial_Description, ProductType.[Description], GLCategory.[Description], Product.*
From dbo.Product As Product
Inner Join dbo.Unit_Of_Measure As UnitInfo
On UnitInfo.Unit_Of_Measure_ID = Product.Unit_Of_Measure_ID
Left Join dbo.Product_Type As ProductType
On ProductType.Product_Type_ID = Product.Product_Type_ID
Left Join dbo.GL_Category As GLCategory
On GLCategory.GL_Category_ID = Product.GL_Category_ID

Select UnitInfo.Imperial_Description, ProductType.[Description], GLCategory.[Description], Product.*
From dbo.Product As Product
Inner Join dbo.Unit_Of_Measure As UnitInfo
On UnitInfo.Unit_Of_Measure_ID = Product.Unit_Of_Measure_ID
Left Join dbo.Product_Type As ProductType
On ProductType.Product_Type_ID = Product.Product_Type_ID
Left Join dbo.GL_Category As GLCategory
On GLCategory.GL_Category_ID = Product.GL_Category_ID
Where ProductType.[Description] = 'Raw Material'

Select *
From dbo.Product_Price As ProductPriceInfo
Where ProductPriceInfo.Product_ID In (6, 7, 8, 9)

Select UnitInfo.Imperial_Description, ProductType.[Description], GLCategory.[Description], Product.*
From dbo.Product As Product
Inner Join dbo.Unit_Of_Measure As UnitInfo
On UnitInfo.Unit_Of_Measure_ID = Product.Unit_Of_Measure_ID
Left Join dbo.Product_Type As ProductType
On ProductType.Product_Type_ID = Product.Product_Type_ID
Left Join dbo.GL_Category As GLCategory
On GLCategory.GL_Category_ID = Product.GL_Category_ID
Order By Product.Product_Number, Product.Product_ID

Select *
From dbo.Unit_Of_Measure

Select *
From dbo.Raw_Material_List As MaterialList

Select *
From dbo.Product As Product

Select *
From dbo.Product_Price

Select *
From dbo.Raw_Material_Product As Material
Inner Join dbo.Product As Product
On Product.Product_ID = Material.Product_ID
Inner Join dbo.Product_Price As ProductPrice
On ProductPrice.Product_ID = Product.Product_ID


Select *
From dbo.Raw_Material_Product As MaterialProduct

Select ProductType.[Description], Product.*
From dbo.Product As Product
Inner Join dbo.Product_Type As ProductType
On ProductType.Product_Type_ID = Product.Product_Type_ID
Where ProductType.[Description] Not In ('Concrete', 'Other')


Select  Plant.Plant_ID As PlantCode, 
        Plant.[Description] As PlantDescription,
        Product.Product_Number As MaterialItemCode, 
        Product.[Description] As MaterialDescription,
        MaterialProduct.Specific_Gravity As SpecificGravity,
        MaterialProduct.Class_ID As ClassID,
        Case 
            When Isnull(MaterialProduct.Class_ID, -1) In (1)
            Then 'Cement'
            When Isnull(MaterialProduct.Class_ID, -1) In (2)
            Then 'Admixture & Fiber'
            When Isnull(MaterialProduct.Class_ID, -1) In (3)
            Then 'Water'
            When Isnull(MaterialProduct.Class_ID, -1) In (4)
            Then 'Aggregate'
            When Isnull(GLCategory.[Description], '') In ('Admixture sales')
            Then 'Admixture & Fiber'
            When Isnull(GLCategory.[Description], '') In ('Fiber')
            Then 'Admixture & Fiber'
            When Isnull(UnitInfo.Imperial_Description, '') In ('Fluid Oz', 'Ounces')
            Then 'Admixture & Fiber'
            When Isnull(MaterialProduct.Class_ID, -1) In (0)
            Then 'Aggregate'
            Else ''
        End As FamilyMaterialTypeName,
        Case 
            When Isnull(MaterialProduct.Class_ID, -1) In (1)
            Then 'Cement'
            When Isnull(MaterialProduct.Class_ID, -1) In (2)
            Then 'Admixture & Fiber'
            When Isnull(MaterialProduct.Class_ID, -1) In (3)
            Then 'Water'
            When Isnull(MaterialProduct.Class_ID, -1) In (4)
            Then 'Fine Aggregate'
            When Isnull(GLCategory.[Description], '') In ('Admixture sales')
            Then 'Admixture & Fiber'            
            When Isnull(GLCategory.[Description], '') In ('Fiber')
            Then 'Fibers'
            When Isnull(UnitInfo.Imperial_Description, '') In ('Fluid Oz', 'Ounces')
            Then 'Admixture & Fiber'
            When Isnull(MaterialProduct.Class_ID, -1) In (0)
            Then 'Coarse Aggregate'
            Else ''
        End As MaterialTypeName,
        Product.Price As MaterialPrice,
        ProductType.[Description] As ProductTypeName,
        GLCategory.[Description] As GLCategoryName,
        UnitInfo.Imperial_Description As US_UnitName, 
        UnitInfo.Metric_Description As SI_UnitName, 
        Product.Inactive_Flag As MaterialInactive
From dbo.Plant As Plant
Inner Join dbo.Raw_Material_Product As MaterialProduct
On MaterialProduct.Plant_ID = Plant.Plant_ID
Inner Join dbo.Product As Product
On Product.Product_ID = MaterialProduct.Product_ID
Left Join dbo.Unit_Of_Measure As UnitInfo
On UnitInfo.Unit_Of_Measure_ID = Product.Unit_Of_Measure_ID
Left Join dbo.Product_Type As ProductType
On ProductType.Product_Type_ID = Product.Product_Type_ID
Left Join dbo.GL_Category As GLCategory
On GLCategory.GL_Category_ID = Product.GL_Category_ID
Order By MaterialProduct.Plant_ID, Product.Product_Number


Select  Plant.Plant_ID As PlantCode,
        Plant.[Description] As PlantDescription,
        MixProduct.Product_ID As MixProductID, 
        MixProduct.Product_Number As MixCode, 
        MixProduct.[Description] As MixDescription,
        Formula.Strength As MixStrength, 
        Formula.Air As AirContent, 
        Formula.Slump As Slump, 
        Formula.Max_Load_Size As MaxLoadSize,
        MixProduct.Price As MixPrice,
        MixUnitInfo.Imperial_Description As MixPriceUnitName,
        Formula.Inactive_Flag As MixInactive,
        MixProductType.[Description] As MixProductTypeName,
        MixGLCategory.[Description] As MixGLCategoryName,
        MaterialProduct.Product_Number As MaterialItemCode, 
        MaterialProduct.[Description] As MaterialDescription,
        MaterialList.Quantity As Quantity,
        MaterialUnitInfo.Imperial_Description As QuantityUnitName,
        MaterialList.[Rank] As QuantityOrderNumber
From dbo.Plant As Plant
Inner Join dbo.Formula As Formula
On Formula.Plant_ID = Plant.Plant_ID
Inner Join dbo.Concrete_Product As ConcreteProduct
On ConcreteProduct.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As MixProduct
On MixProduct.Product_ID = ConcreteProduct.Product_ID
Left Join dbo.Product_Type As MixProductType
On MixProductType.Product_Type_ID = MixProduct.Product_Type_ID
Left Join dbo.GL_Category As MixGLCategory
On MixGLCategory.GL_Category_ID = MixProduct.GL_Category_ID
Left Join dbo.Unit_Of_Measure As MixUnitInfo
On MixUnitInfo.Unit_Of_Measure_ID = MixProduct.Unit_Of_Measure_ID
Inner Join dbo.Raw_Material_List As MaterialList
On MaterialList.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As MaterialProduct
On MaterialProduct.Product_ID = MaterialList.Product_ID
Left Join dbo.Unit_Of_Measure As MaterialUnitInfo
On MaterialUnitInfo.Unit_Of_Measure_ID = MaterialProduct.Unit_Of_Measure_ID
Order By Plant.Plant_ID, MixProduct.Product_Number, MixProduct.Product_ID, MaterialList.[Rank], MaterialProduct.Product_Number, MaterialProduct.Product_ID 






Select  Plant.Plant_ID As PlantCode,
        MixProduct.Product_Number As MixCode,
        Isnull(MixProduct.[Description], '') As MixDescription,
        Isnull(MixProduct.[Description], '') As MixShortDescription,
        Isnull(MixProductType.[Description], '') As MixItemCategory,
        Case when Round(Isnull(Formula.Strength, -1.0), 2) > 0.0 Then 28.0 Else Null End As StrengthAge, 
        Case when Round(Isnull(Formula.Strength, -1.0), 2) > 0.0 Then Formula.Strength Else Null End As Strength,
        Case when Round(Isnull(Formula.Air, -1.0), 4) > 0.0 Then Formula.Air Else Null End As AirContent,
        '' As MinAirContent,
        '' As MaxAiContent,
        Case when Round(Isnull(Formula.Slump, -1.0), 4) > 0.0 Then Formula.Slump Else Null End As Slump,
        '' As MinSlump,
        '' As MaxSlump,
        '' As DispatchSlumpRange,
        '' As Padding,
        MaterialProduct.Product_Number As MaterialItemCode, 
        MaterialProduct.[Description] As MaterialDescription,
        MaterialList.Quantity As Quantity,
        MaterialUnitInfo.Imperial_Description As QuantityUnitName,
        
        
        
        Plant.Plant_ID As PlantCode,
        Plant.[Description] As PlantDescription,
        MixProduct.Product_ID As MixProductID, 
        MixProduct.Product_Number As MixCode, 
        MixProduct.[Description] As MixDescription,
        Formula.Strength As MixStrength, 
        Formula.Air As AirContent, 
        Formula.Slump As Slump, 
        Formula.Max_Load_Size As MaxLoadSize,
        MixProduct.Price As MixPrice,
        MixUnitInfo.Imperial_Description As MixPriceUnitName,
        Formula.Inactive_Flag As MixInactive,
        MixProductType.[Description] As MixProductTypeName,
        MixGLCategory.[Description] As MixGLCategoryName,
        MaterialProduct.Product_Number As MaterialItemCode, 
        MaterialProduct.[Description] As MaterialDescription,
        MaterialList.Quantity As Quantity,
        MaterialUnitInfo.Imperial_Description As QuantityUnitName,
        MaterialList.[Rank] As QuantityOrderNumber
From dbo.Plant As Plant
Inner Join dbo.Formula As Formula
On Formula.Plant_ID = Plant.Plant_ID
Inner Join dbo.Concrete_Product As ConcreteProduct
On ConcreteProduct.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As MixProduct
On MixProduct.Product_ID = ConcreteProduct.Product_ID
Left Join dbo.Product_Type As MixProductType
On MixProductType.Product_Type_ID = MixProduct.Product_Type_ID
Left Join dbo.GL_Category As MixGLCategory
On MixGLCategory.GL_Category_ID = MixProduct.GL_Category_ID
Left Join dbo.Unit_Of_Measure As MixUnitInfo
On MixUnitInfo.Unit_Of_Measure_ID = MixProduct.Unit_Of_Measure_ID
Inner Join dbo.Raw_Material_List As MaterialList
On MaterialList.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As MaterialProduct
On MaterialProduct.Product_ID = MaterialList.Product_ID
Left Join dbo.Unit_Of_Measure As MaterialUnitInfo
On MaterialUnitInfo.Unit_Of_Measure_ID = MaterialProduct.Unit_Of_Measure_ID
Order By Plant.Plant_ID, MixProduct.Product_Number, MixProduct.Product_ID, MaterialList.[Rank], MaterialProduct.Product_Number, MaterialProduct.Product_ID 







/*
Truncate Table Data_Import_RJ.dbo.TestImport0000_MaterialInfo
DBCC CHECKIDENT ('Data_Import_RJ.dbo.TestImport0000_MaterialInfo', RESEED, 1)

Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo
(
	PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName,
	SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName,
	ManufacturerName, ManufacturerSourceName, BatchingOrderNumber, ItemCode,
	ItemDescription, ItemShortDescription, ItemCategoryName,
	ItemCategoryDescription, ItemCategoryShortDescription, BatchPanelCode
)
Select  Plant.Plant_ID As PlantCode,
        Case when Isnull(Product.[Description], '') = '' Then Product.Product_Number Else Product.[Description] End As TradeName,
        '11/30/2022' As MaterialDate,
        Case 
            When Isnull(MaterialProduct.Class_ID, -1) In (1)
            Then 'Cement'
            When Isnull(MaterialProduct.Class_ID, -1) In (2)
            Then 'Admixture & Fiber'
            When Isnull(MaterialProduct.Class_ID, -1) In (3)
            Then 'Water'
            When Isnull(MaterialProduct.Class_ID, -1) In (4)
            Then 'Aggregate'
            When Isnull(GLCategory.[Description], '') In ('Admixture sales')
            Then 'Admixture & Fiber'
            When Isnull(GLCategory.[Description], '') In ('Fiber')
            Then 'Admixture & Fiber'
            When Isnull(UnitInfo.Imperial_Description, '') In ('Fluid Oz', 'Ounces', 'ml')
            Then 'Admixture & Fiber'
            When Isnull(MaterialProduct.Class_ID, -1) In (0)
            Then 'Aggregate'
            Else ''
        End As FamilyMaterialTypeName,
        Case 
            When Isnull(MaterialProduct.Class_ID, -1) In (1)
            Then 'Cement'
            When Isnull(MaterialProduct.Class_ID, -1) In (2)
            Then 'Admixture & Fiber'
            When Isnull(MaterialProduct.Class_ID, -1) In (3)
            Then 'Water'
            When Isnull(MaterialProduct.Class_ID, -1) In (4)
            Then 'Fine Aggregate'
            When Isnull(GLCategory.[Description], '') In ('Admixture sales')
            Then 'Admixture & Fiber'            
            When Isnull(GLCategory.[Description], '') In ('Fiber')
            Then 'Fibers'
            When Isnull(UnitInfo.Imperial_Description, '') In ('Fluid Oz', 'Ounces', 'ml')
            Then 'Admixture & Fiber'
            When Isnull(MaterialProduct.Class_ID, -1) In (0)
            Then 'Coarse Aggregate'
            Else ''
        End As MaterialTypeName,
        MaterialProduct.Specific_Gravity As SpecificGravity,
        Case when Isnull(UnitInfo.Imperial_Description, '') In ('Fluid Oz', 'ml') Then 'Yes' Else 'No' End As IsLiquidAdmix,
        0.0 As Moisture,
        Product.Price As Cost,
        UnitInfo.Imperial_Description As CostUnitName,
        Null As ManufacturerName,
        Null As ManufacturerSourceName,
        Null As BatchingOrderNumber,
        Product.Product_Number As MaterialItemCode, 
        Product.[Description] As MaterialDescription,
        Product.[Description] As MaterialShortDescription,
        Null As ItemCategoryName,
        Null As ItemCategoryDescription,
        Null As ItemCategoryShortDescription,
        Null As BatchPanelCode
From dbo.Plant As Plant
Inner Join dbo.Raw_Material_Product As MaterialProduct
On MaterialProduct.Plant_ID = Plant.Plant_ID
Inner Join dbo.Product As Product
On Product.Product_ID = MaterialProduct.Product_ID
Left Join dbo.Unit_Of_Measure As UnitInfo
On UnitInfo.Unit_Of_Measure_ID = Product.Unit_Of_Measure_ID
Left Join dbo.Product_Type As ProductType
On ProductType.Product_Type_ID = Product.Product_Type_ID
Left Join dbo.GL_Category As GLCategory
On GLCategory.GL_Category_ID = Product.GL_Category_ID
Order By MaterialProduct.Plant_ID, Case when Isnull(Product.[Description], '') = '' Then Product.[Description] Else Product.Product_Number End
*/
Select MaterialInfo.PlantName, MaterialInfo.TradeName
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Group By MaterialInfo.PlantName, MaterialInfo.TradeName
Having Count(*) > 1

Select MaterialInfo.PlantName, MaterialInfo.ItemCode
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Group By MaterialInfo.PlantName, MaterialInfo.ItemCode
Having Count(*) > 1




Declare @AirContentInfo Table 
(
	AutoID Int Identity (1, 1), 
	FormulaID Int, 
	PlantID Int, 
	AirContentValue Nvarchar (100),
	AirContent Float,
	MinAirContent Float,
	MaxAirContent Float
)

Insert into @AirContentInfo (FormulaID, PlantID, AirContentValue)
Select Formula.Formula_ID, Formula.Plant_ID, Ltrim(Rtrim(Formula.Air))
From dbo.Formula As Formula
Where Ltrim(Rtrim(Isnull(Formula.Air, ''))) <> ''

Update Info
    Set Info.AirContentValue = Replace(Info.AirContentValue, '%', '')
From @AirContentInfo As Info

Update Info
    Set Info.MinAirContent = Left(Info.AirContentValue, Charindex('-', Info.AirContentValue) - 1),
        Info.MaxAirContent = Right(Info.AirContentValue, Len(Info.AirContentValue) - Charindex('-', Info.AirContentValue))
From @AirContentInfo As Info
Where Charindex('-', Info.AirContentValue) > 0

Update Info
    Set Info.AirContent = (Info.MinAirContent + Info.MaxAirContent) / 2.0
From @AirContentInfo As Info
Where Isnull(Info.MinAirContent, -1.0) >= 0.0 And Isnull(Info.MaxAirContent, -1.0) > = 0.0

Update Info
    Set Info.AirContent = Cast(Info.AirContentValue As Float)
From @AirContentInfo As Info
Where Info.AirContent Is Null And Isnumeric(Info.AirContentValue) = 1

Update Info
    Set Info.MinAirContent =
            Case
                When Round(Isnull(Info.AirContent, -1.0), 4) < 0.0
                Then Null
                When Round(Isnull(Info.AirContent, -1.0), 4) <= 1.5
                Then 0.0
                Else Round(Isnull(Info.AirContent, -1.0), 4) - 1.5 
            End,
        Info.MaxAirContent =
            Case
                When Round(Isnull(Info.AirContent, -1.0), 4) < 0.0
                Then Null
                When Round(Isnull(Info.AirContent, -1.0), 4) >= 98.5
                Then 100.0
                Else Round(Isnull(Info.AirContent, -1.0), 4) + 1.5 
            End
From @AirContentInfo As Info
Where Info.AirContent Is Not Null And Info.MinAirContent Is Null

Select *
From @AirContentInfo

Truncate Table Data_Import_RJ.dbo.TestImport0000_MixInfo
DBCC CHECKIDENT ('Data_Import_RJ.dbo.TestImport0000_MixInfo', RESEED, 1)

Insert into Data_Import_RJ.dbo.TestImport0000_MixInfo
(
	PlantCode, MixCode, MixDescription, MixShortDescription, ItemCategory,
	StrengthAge, Strength, AirContent, MinAirContent, MaxAirContent, Slump,
	MinSlump, MaxSlump, DispatchSlumpRange, MaxLoadSize, SackContent, Price,
	PriceUnitName, MixInactive, Padding1, MaterialItemCode,
	MaterialItemDescription, Quantity, QuantityUnitName, SortNumber
)
Select  Plant.Plant_ID As PlantCode,
        MixProduct.Product_Number As MixCode,
        Isnull(MixProduct.[Description], '') As MixDescription,
        Isnull(MixProduct.[Description], '') As MixShortDescription,
        Isnull(MixProductType.[Description], '') As MixItemCategory,
        Case when Round(Isnull(Formula.Strength, -1.0), 2) > 0.0 Then 28.0 Else Null End As StrengthAge, 
        Case when Round(Isnull(Formula.Strength, -1.0), 2) > 0.0 Then Formula.Strength Else Null End As Strength,
        AirContentInfo.AirContent As AirContent,
        AirContentInfo.MinAirContent As MinAirContent,
        AirContentInfo.MaxAirContent As MaxAirContent,
        Case when Round(Isnull(Formula.Slump, -1.0), 4) > 0.0 Then Formula.Slump Else Null End As Slump,
        Case
            When Round(Isnull(Formula.Slump, -1.0), 4) <= 0.0
            Then Null
            When Round(Isnull(Formula.Slump, -1.0), 4) <= 2
            Then 0.0
            Else Round(Isnull(Formula.Slump, -1.0), 4) - 2.0
        End As MinSlump,
        Case
            When Round(Isnull(Formula.Slump, -1.0), 4) <= 0.0
            Then Null
            When Round(Isnull(Formula.Slump, -1.0), 4) >= 10.0 And Round(Isnull(Formula.Slump, -1.0), 4) <= 12.0 
            Then 12.0
            Else Round(Isnull(Formula.Slump, -1.0), 4) + 2.0
        End As MaxSlump,
        '' As DispatchSlumpRange,
        Case when Round(Isnull(Formula.Max_Load_Size, -1.0), 4) > 0.0 Then Formula.Max_Load_Size Else Null End As MaxLoadSize,
        Case when Round(Isnull(Formula.Sack_Equivalent, -1.0), 4) > 0.0 Then Formula.Sack_Equivalent Else Null End As SackContent,        
        Case when Round(Isnull(MixProduct.Price, -1.0), 4) > 0.0 And Isnull(MixUnitInfo.Imperial_Description, '') In ('m3') Then MixProduct.Price Else Null End As MixPrice,
        Case when Isnull(MixUnitInfo.Imperial_Description, '') In ('m3') Then MixUnitInfo.Imperial_Description Else Null End As MixPriceUnitName,
        Case When Isnull(Formula.Inactive_Flag, 0) = 1 Then 'Yes' Else 'No' End As MixInactive,
        '' As Padding,
        Isnull(MaterialProduct.Product_Number, '') As MaterialItemCode, 
        Isnull(MaterialProduct.[Description], '') As MaterialDescription,
        MaterialList.Quantity As Quantity,
        Isnull(MaterialUnitInfo.Imperial_Description, '') As QuantityUnitName,
        MaterialList.[Rank] As QuantityOrderNumber
From dbo.Plant As Plant
Inner Join dbo.Formula As Formula
On Formula.Plant_ID = Plant.Plant_ID
Left Join @AirContentInfo As AirContentInfo
On  Formula.Formula_ID = AirContentInfo.FormulaID And
    Formula.Plant_ID = AirContentInfo.PlantID
Inner Join dbo.Concrete_Product As ConcreteProduct
On ConcreteProduct.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As MixProduct
On MixProduct.Product_ID = ConcreteProduct.Product_ID
Left Join dbo.Product_Type As MixProductType
On MixProductType.Product_Type_ID = MixProduct.Product_Type_ID
Left Join dbo.GL_Category As MixGLCategory
On MixGLCategory.GL_Category_ID = MixProduct.GL_Category_ID
Left Join dbo.Unit_Of_Measure As MixUnitInfo
On MixUnitInfo.Unit_Of_Measure_ID = MixProduct.Unit_Of_Measure_ID
Inner Join dbo.Raw_Material_List As MaterialList
On  MaterialList.Plant_ID = Plant.Plant_ID And
    MaterialList.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As MaterialProduct
On MaterialProduct.Product_ID = MaterialList.Product_ID
Left Join dbo.Unit_Of_Measure As MaterialUnitInfo
On MaterialUnitInfo.Unit_Of_Measure_ID = MaterialProduct.Unit_Of_Measure_ID
Order By Plant.Plant_ID, MixProduct.Product_Number, MixProduct.Product_ID, MaterialList.[Rank], MaterialProduct.Product_Number, MaterialProduct.Product_ID 

Update MixInfo
    Set MixInfo.Strength =
        Case
            When Cast(Left(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription)) As Float) >= 0.1
            Then Cast(Left(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription)) As Float)
            Else Null
        End
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where   MixInfo.Strength Is Null And 
        Quadrel_Demo_RJ.dbo.Validation_ValueIsNumeric(Left(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription))) = 1 And
        Len(Ltrim(Rtrim(Left(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription))))) = 4 And
        Charindex('.', Left(MixInfo.MixDescription, Charindex(' ', MixInfo.MixDescription))) < 1
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
Update MixInfo
    Set MixInfo.StrengthAge = 28.0
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where MixInfo.StrengthAge Is Null And MixInfo.Strength Is Not Null

