If  Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ') And
    Exists (Select * From sys.objects Where Name = 'Raw_Material_List')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo')
    Begin
    	/*
            Truncate Table Data_Import_RJ.dbo.TestImport0000_MaterialInfo
            DBCC CHECKIDENT ('Data_Import_RJ.dbo.TestImport0000_MaterialInfo', RESEED, 1)
        */

        Declare @UnitSystem Nvarchar (10) = 'US' -- Or 'SI' --> Usually, this should be set to US for US Customers or SI for Non-US Customers 
        
        Declare @MaterialDate Nvarchar (40) = Format(Getdate(), 'MM/dd/yyyy')
        
        
        Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo
        (
	        PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName,
	        SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName,
	        ManufacturerName, ManufacturerSourceName, BatchingOrderNumber, ItemCode,
	        ItemDescription, ItemShortDescription, ItemCategoryName,
	        ItemCategoryDescription, ItemCategoryShortDescription, BatchPanelCode,
	        UpdatedFromDatabase
        )
        
        Select  Ltrim(Rtrim(Cast(Plant.Plant_ID As Nvarchar))) As PlantCode,
                Case when Ltrim(Rtrim(Isnull(Product.[Description], ''))) = '' Then Ltrim(Rtrim(Product.Product_Number)) Else Ltrim(Rtrim(Product.[Description])) End As TradeName,
                @MaterialDate As MaterialDate,
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
                    When Isnull(UnitInfo.Imperial_Description, '') In ('Fluid Oz', 'Ounces', 'ml', 'Ml-liter')
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
                    When Isnull(UnitInfo.Imperial_Description, '') In ('Fluid Oz', 'Ounces', 'ml', 'Ml-liter')
                    Then 'Admixture & Fiber'
                    When Isnull(MaterialProduct.Class_ID, -1) In (0)
                    Then 'Coarse Aggregate'
                    Else ''
                End As MaterialTypeName,
                MaterialProduct.Specific_Gravity As SpecificGravity,
                Case 
                    When Isnull(UnitInfo.Imperial_Description, '') In ('Fluid Oz', 'ml', 'Ml-liter') 
                    Then 'Yes' 
                    When Isnull(GLCategory.[Description], '') In ('Admixture sales')
                    Then 'Yes'
                    Else 'No' 
                End As IsLiquidAdmix,
                0.0 As Moisture,
                Product.Price As Cost,
                Case 
                    When Isnull(@UnitSystem, '') = 'SI' 
                    Then Ltrim(Rtrim(UnitInfo.Metric_Description)) 
                    Else Ltrim(Rtrim(UnitInfo.Imperial_Description))
                End As CostUnitName,
                Null As ManufacturerName,
                Null As ManufacturerSourceName,
                Null As BatchingOrderNumber,
                Ltrim(Rtrim(Product.Product_Number)) As MaterialItemCode, 
                Ltrim(Rtrim(Product.[Description])) As MaterialDescription,
                Ltrim(Rtrim(Product.[Description])) As MaterialShortDescription,
                Null As ItemCategoryName,
                Null As ItemCategoryDescription,
                Null As ItemCategoryShortDescription,
                Null As BatchPanelCode,
                0 As UpdatedFromDatabase
        From dbo.Plant As Plant
        Inner Join dbo.Raw_Material_Product As MaterialProduct
        On MaterialProduct.Plant_ID = Plant.Plant_ID
        Inner Join dbo.Product As Product
        On Product.Product_ID = MaterialProduct.Product_ID
        Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
        On  Ltrim(Rtrim(Cast(Plant.Plant_ID As Nvarchar))) = MaterialInfo.PlantName And
            Ltrim(Rtrim(Product.Product_Number)) = MaterialInfo.ItemCode
        Left Join dbo.Unit_Of_Measure As UnitInfo
        On UnitInfo.Unit_Of_Measure_ID = Product.Unit_Of_Measure_ID
        Left Join dbo.Product_Type As ProductType
        On ProductType.Product_Type_ID = Product.Product_Type_ID
        Left Join dbo.GL_Category As GLCategory
        On GLCategory.GL_Category_ID = Product.GL_Category_ID
        Where MaterialInfo.AutoID Is Null
        Order By MaterialProduct.Plant_ID, Ltrim(Rtrim(Case when Isnull(Product.[Description], '') = '' Then Product.[Description] Else Product.Product_Number End))
    End
End
Go
