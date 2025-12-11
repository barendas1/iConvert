/*
Select  MaterialInfo.PlantCode As [Plant Name], 
        PlantInfo.Name As [Plant Description],  
        MaterialInfo.ItemCode As [Material Item Code],
        MaterialInfo.[Description] As [Description],         
        ItemCategory.Code,
        ItemCategory.[Description],
        MaterialInfo.SpecificGravity As [Specific Gravity],
        MaterialInfo.Cost As [Cost],
        MaterialInfo.PurchaseUnit,
        ItemType.Name,
        ItemType.[Description]
From Data_Import_RJ.dbo.TestImport0000_XML_Material As MaterialInfo
Left Join Data_Import_RJ.dbo.TestImport0000_XML_Plant As PlantInfo
On MaterialInfo.PlantID = PlantInfo.PlantID
Left Join Data_Import_RJ.dbo.TestImport0000_XML_ItemCategory As ItemCategory
On MaterialInfo.ItemCategoryCode = ItemCategory.Code
Left Join Data_Import_RJ.dbo.TestImport0000_XML_ItemType As ItemType
On MaterialInfo.ItemTypeID = ItemType.ItemTypeID
Order By MaterialInfo.ItemCode, MaterialInfo.PlantCode
*/

Select  MixInfo.PlantCode As [Plant Name],
        PlantInfo.Name As [Plant Description],
        MixInfo.ItemCode As [Mix Item Code],
        MixInfo.[Description] As [Mix Description], 
        MixInfo.StrengthAge As [Strength Age], 
        MixInfo.Strength As [Strength (psi)], 
        MixInfo.PercentAirVolume As [Air Content (%)],
        Case
            When dbo.Validation_ValueIsNumeric(MixInfo.Slump) = 0
            Then MixInfo.Slump
            Else Cast(Cast(MixInfo.Slump As Numeric (15, 2)) As Nvarchar)
        End As [Slump (in)],
        ItemCategory.Code As [Item Category Code], 
        ItemCategory.[Description] As [Item Category Description]
From Data_Import_RJ.dbo.TestImport0000_XML_Mix As MixInfo
Left Join Data_Import_RJ.dbo.TestImport0000_XML_Plant As PlantInfo
On MixInfo.PlantID = PlantInfo.PlantID
Left Join Data_Import_RJ.dbo.TestImport0000_XML_ItemCategory As ItemCategory
On MixInfo.ItemCategoryCode = ItemCategory.Code
Where   MixInfo.AutoID In
        (
        	Select Min(MixInfo2.AutoID)
        	From Data_Import_RJ.dbo.TestImport0000_XML_Mix As MixInfo2
        	Group By MixInfo2.PlantCode, MixInfo2.ItemCode
        )
Order By MixInfo.ItemCode, MixInfo.PlantCode