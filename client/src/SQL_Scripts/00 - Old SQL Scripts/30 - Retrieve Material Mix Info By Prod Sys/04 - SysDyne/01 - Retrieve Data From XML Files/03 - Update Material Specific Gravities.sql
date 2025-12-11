Select *
From Data_Import_RJ.dbo.TestImport0000_XML_Material As Material
Where Isnull(Material.SpecificGravity, -1.0) < 0.4

Update Material
    Set Material.SpecificGravity = SpecGravInfo.SpecificGravity
From Data_Import_RJ.dbo.TestImport0000_XML_Material As Material
Inner Join
(
	Select Material2.ItemCode, Material2.SpecificGravity
	From Data_Import_RJ.dbo.TestImport0000_XML_Material As Material2
	Where   Isnull(Material2.SpecificGravity, -1.0) >= 0.4 And
	        Material2.AutoID In
	        (
	        	Select Min(Material3.AutoID)
	        	From Data_Import_RJ.dbo.TestImport0000_XML_Material As Material3
	        	Where Isnull(Material3.SpecificGravity, -1.0) >= 0.4
	        	Group By Material3.ItemCode
	        )	
) As SpecGravInfo
On Material.ItemCode = SpecGravInfo.ItemCode
Where Isnull(Material.SpecificGravity, -1.0) < 0.4
