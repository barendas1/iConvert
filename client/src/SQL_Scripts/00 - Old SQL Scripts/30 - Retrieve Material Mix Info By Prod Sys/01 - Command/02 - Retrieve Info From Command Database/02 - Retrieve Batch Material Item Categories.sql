Select  Ltrim(Rtrim(Replace(ICAT.item_cat, Char(160), ' '))) As Item_Cat, 
        Ltrim(Rtrim(Replace(ICAT.descr, Char(160), ' '))) As Descr, 
        Ltrim(Rtrim(Replace(ICAT.short_descr, Char(160), ' '))) As Short_Descr, 
        Ltrim(Rtrim(Replace(ICAT.item_type, Char(160), ' '))) As Item_Type, 
        Ltrim(Rtrim(Replace(icat.matl_type, Char(160), ' '))) As Matl_Type
From dbo.TICK TICK     
Inner Join dbo.TWGT TWGT     
On  TICK.ORDER_DATE = TWGT.ORDER_DATE And     
    TICK.ORDER_CODE = TWGT.ORDER_CODE And     
    TICK.TKT_CODE = TWGT.TKT_CODE     
Inner Join dbo.IMST As IMST
On TWGT.const_prod_code = IMST.item_code
Inner Join dbo.icat As ICAT
On ICAT.item_cat = IMST.item_cat
Where Tick.tkt_date >= '2022-10-01'
Group By    Ltrim(Rtrim(Replace(ICAT.item_cat, Char(160), ' '))), 
            Ltrim(Rtrim(Replace(ICAT.descr, Char(160), ' '))), 
            Ltrim(Rtrim(Replace(ICAT.short_descr, Char(160), ' '))), 
            Ltrim(Rtrim(Replace(ICAT.item_type, Char(160), ' '))), 
            Ltrim(Rtrim(Replace(icat.matl_type, Char(160), ' ')))
Order By Ltrim(Rtrim(Replace(ICAT.item_cat, Char(160), ' ')))

Select  Ltrim(Rtrim(Replace(IMST.item_cat, Char(160), ' '))) As Item_Cat 
From dbo.TICK TICK     
Inner Join dbo.TWGT TWGT     
On  TICK.ORDER_DATE = TWGT.ORDER_DATE And     
    TICK.ORDER_CODE = TWGT.ORDER_CODE And     
    TICK.TKT_CODE = TWGT.TKT_CODE     
Inner Join dbo.IMST As IMST
On TWGT.const_prod_code = IMST.item_code
Where Tick.tkt_date >= '2022-10-01'
Group By Ltrim(Rtrim(Replace(IMST.item_cat, Char(160), ' ')))
Order By Ltrim(Rtrim(Replace(IMST.item_cat, Char(160), ' ')))
