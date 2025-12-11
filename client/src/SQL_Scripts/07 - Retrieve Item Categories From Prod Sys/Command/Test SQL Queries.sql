Select * 
From dbo.icst As MixInfo
Where trim(MixInfo.const_item_code) In ('6400')

Select * 
From dbo.icst As MixInfo
Where Trim(MixInfo.item_code) In ('6400')

Select * 
From dbo.imst As MaterialInfo
Where Trim(MaterialInfo.item_code) In ('')
