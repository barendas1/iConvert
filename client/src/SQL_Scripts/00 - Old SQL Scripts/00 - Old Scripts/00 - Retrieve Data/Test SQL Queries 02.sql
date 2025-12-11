Select Plants.Name, MixName.Name, Mix.*
From Plants 
Inner Join Batch As Mix
On Plants.PlantId = Mix.Plant_Link
Inner Join Name As MixName
On MixName.NameID = Mix.NameID
Where MixName.Name = '(71808)'

Select Plants.Name, MixName.Name, Mix.*
From Plants 
Inner Join Batch As Mix
On Plants.PlantId = Mix.Plant_Link
Inner Join Name As MixName
On MixName.NameID = Mix.NameID
Inner Join
(
	Select MixInfo.PlantCode, MixInfo.MixCode
	From Data_Import_RJ.dbo.Import55_MixInfo As MixInfo
	Group By MixInfo.PlantCode, MixInfo.MixCode
) As MixInfo
On Plants.Name = MixInfo.PlantCode And MixName.Name = MixInfo.MixCode
Where Isnull(Mix.MixInactive, 0) = 1

Select Plants.Name, MixName.Name, Mix.*
From Plants 
Inner Join Batch As Mix
On Plants.PlantId = Mix.Plant_Link
Inner Join Name As MixName
On MixName.NameID = Mix.NameID
Inner Join CmdTest_RJ.dbo.ILOC As ILOC
On Plants.Name = ILOC.loc_code And MixName.Name = ILOC.item_code
Where ILOC.inactive_code <> '00' And Isnull(Mix.MixInactive, 0) = 0

Select Plants.Name, MixName.Name, Mix.*
From Plants 
Inner Join Batch As Mix
On Plants.PlantId = Mix.Plant_Link
Inner Join Name As MixName
On MixName.NameID = Mix.NameID
Inner Join CmdTest_RJ.dbo.ILOC As ILOC
On Plants.Name = ILOC.loc_code And MixName.Name = ILOC.item_code
Where ILOC.inactive_code = '00' And Isnull(Mix.MixInactive, 0) = 1

