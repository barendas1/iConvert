Select MixInfo.QuantityUnitName
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Group By MixInfo.QuantityUnitName

Select MixInfo.PriceUnitName
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Group By MixInfo.PriceUnitName

Select  Distinct MixUnitInfo.Imperial_Description, MixUnitInfo.Metric_Description
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
On  MaterialList.Plant_ID = Plant.Plant_ID And
    MaterialList.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As MaterialProduct
On MaterialProduct.Product_ID = MaterialList.Product_ID
Left Join dbo.Unit_Of_Measure As MaterialUnitInfo
On MaterialUnitInfo.Unit_Of_Measure_ID = MaterialProduct.Unit_Of_Measure_ID

Select  '' As Padding,
        MixProduct.Price As MixPrice,
        MixUnitInfo.Imperial_Description,
        MixUnitInfo.Metric_Description,
        Ltrim(Rtrim(Cast(Plant.Plant_ID As Nvarchar))) As PlantCode,
        Ltrim(Rtrim(MixProduct.Product_Number)) As MixCode,
        Ltrim(Rtrim(Isnull(MixProduct.[Description], ''))) As MixDescription,
        Ltrim(Rtrim(Isnull(MixProduct.[Description], ''))) As MixShortDescription,
        Ltrim(Rtrim(Isnull(MixProductType.[Description], ''))) As MixItemCategory,
        Case when Round(Isnull(Formula.Strength, -1.0), 2) > 0.0 Then 28.0 Else Null End As StrengthAge, 
        Case when Round(Isnull(Formula.Strength, -1.0), 2) > 0.0 Then Formula.Strength Else Null End As Strength,
        '' As DispatchSlumpRange,
        Case when Round(Isnull(Formula.Max_Load_Size, -1.0), 4) > 0.0 Then Formula.Max_Load_Size Else Null End As MaxLoadSize,
        Case when Round(Isnull(Formula.Sack_Equivalent, -1.0), 4) > 0.0 Then Formula.Sack_Equivalent Else Null End As SackContent,
        Case When Isnull(Formula.Inactive_Flag, 0) = 1 Then 'Yes' Else 'No' End As MixInactive,
        '' As Padding,
        Ltrim(Rtrim(Isnull(MaterialProduct.Product_Number, ''))) As MaterialItemCode, 
        Ltrim(Rtrim(Isnull(MaterialProduct.[Description], ''))) As MaterialDescription,
        MaterialList.Quantity As Quantity,
        Ltrim(Rtrim(Isnull(MaterialUnitInfo.Imperial_Description, ''))) As QuantityUnitName,
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
On  MaterialList.Plant_ID = Plant.Plant_ID And
    MaterialList.Formula_ID = Formula.Formula_ID
Inner Join dbo.Product As MaterialProduct
On MaterialProduct.Product_ID = MaterialList.Product_ID
Left Join dbo.Unit_Of_Measure As MaterialUnitInfo
On MaterialUnitInfo.Unit_Of_Measure_ID = MaterialProduct.Unit_Of_Measure_ID
Order By Plant.Plant_ID, Ltrim(Rtrim(MixProduct.Product_Number)), MixProduct.Product_ID, MaterialList.[Rank], Ltrim(Rtrim(MaterialProduct.Product_Number)), MaterialProduct.Product_ID 
