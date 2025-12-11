Select *
From Data_Import_RJ.dbo.TestImport0000_XML_Material As Material
Where Isnull(Material.SpecificGravity, -1.0) < 0.3

Update Material
    Set Material.SpecificGravity = SpecGravInfo.SpecificGravity
From Data_Import_RJ.dbo.TestImport0000_XML_Material As Material
Inner Join
(
	Select Material2.ItemCode, Material2.SpecificGravity
	From Data_Import_RJ.dbo.TestImport0000_XML_Material As Material2
	Where   Isnull(Material2.SpecificGravity, -1.0) >= 0.3 And
	        Material2.AutoID In
	        (
	        	Select Min(Material3.AutoID)
	        	From Data_Import_RJ.dbo.TestImport0000_XML_Material As Material3
	        	Where Isnull(Material3.SpecificGravity, -1.0) >= 0.3
	        	Group By Material3.ItemCode
	        )	
) As SpecGravInfo
On Material.ItemCode = SpecGravInfo.ItemCode
Where Isnull(Material.SpecificGravity, -1.0) < 0.3

Update MaterialInfo
    Set MaterialInfo.SpecificGravity = SpecGravInfo.SpecificGravity
From Data_Import_RJ.dbo.TestImport0000_XML_Material As MaterialInfo
Inner Join
(
	Select Plants.Name As PlantCode, ItemName.Name As ItemCode, Material.SPECGR As SpecificGravity
	From dbo.Plants As Plants
	Inner Join dbo.MATERIAL As Material
	On Material.PlantID = Plants.PlantId
	Inner Join dbo.ItemMaster As ItemMaster
	On ItemMaster.ItemMasterID = Material.ItemMasterID
	Inner Join dbo.Name As ItemName
	On ItemName.NameID = ItemMaster.NameID
	Where   Material.MATERIALIDENTIFIER In
	        (
	        	Select Min(Material.MATERIALIDENTIFIER)
	        	From dbo.MATERIAL As Material
	        	Where Material.ItemMasterID Is Not Null
	        	Group By Material.PlantID, Material.ItemMasterID
	        )
) As SpecGravInfo
On  MaterialInfo.PlantCode = SpecGravInfo.PlantCode And MaterialInfo.ItemCode = SpecGravInfo.ItemCode
Where Isnull(MaterialInfo.SpecificGravity, -1.0) < 0.3

Update Material
    Set Material.SpecificGravity = SpecGravInfo.SpecificGravity
From Data_Import_RJ.dbo.TestImport0000_XML_Material As Material
Inner Join
(
	Select Material2.ItemCode, Material2.SpecificGravity
	From Data_Import_RJ.dbo.TestImport0000_XML_Material As Material2
	Where   Isnull(Material2.SpecificGravity, -1.0) >= 0.3 And
	        Material2.AutoID In
	        (
	        	Select Min(Material3.AutoID)
	        	From Data_Import_RJ.dbo.TestImport0000_XML_Material As Material3
	        	Where Isnull(Material3.SpecificGravity, -1.0) >= 0.3
	        	Group By Material3.ItemCode
	        )	
) As SpecGravInfo
On Material.ItemCode = SpecGravInfo.ItemCode
Where Isnull(Material.SpecificGravity, -1.0) < 0.3
