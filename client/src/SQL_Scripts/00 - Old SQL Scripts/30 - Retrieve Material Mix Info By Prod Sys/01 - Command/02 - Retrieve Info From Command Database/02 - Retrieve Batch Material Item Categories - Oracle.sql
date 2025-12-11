Select  Ltrim(Rtrim(Replace(ICAT.item_cat, Chr(160), ' '))) As Item_Cat, 
        Ltrim(Rtrim(Replace(ICAT.descr, Chr(160), ' '))) As Descr, 
        Ltrim(Rtrim(Replace(ICAT.short_descr, Chr(160), ' '))) As Short_Descr, 
        Ltrim(Rtrim(Replace(ICAT.item_type, Chr(160), ' '))) As Item_Type, 
        Ltrim(Rtrim(Replace(icat.matl_type, Chr(160), ' '))) As Matl_Type
From TICK TICK     
Inner Join TWGT TWGT     
On  TICK.ORDER_DATE = TWGT.ORDER_DATE And     
    TICK.ORDER_CODE = TWGT.ORDER_CODE And     
    TICK.TKT_CODE = TWGT.TKT_CODE     
Inner Join IMST As IMST
On TWGT.const_prod_code = IMST.item_code
Inner Join icat As ICAT
On ICAT.item_cat = IMST.item_cat
Where Tick.tkt_date >= '2022-10-01'
Group By    Ltrim(Rtrim(Replace(ICAT.item_cat, Chr(160), ' '))), 
            Ltrim(Rtrim(Replace(ICAT.descr, Chr(160), ' '))), 
            Ltrim(Rtrim(Replace(ICAT.short_descr, Chr(160), ' '))), 
            Ltrim(Rtrim(Replace(ICAT.item_type, Chr(160), ' '))), 
            Ltrim(Rtrim(Replace(icat.matl_type, Chr(160), ' ')))
Order By Ltrim(Rtrim(Replace(ICAT.item_cat, Chr(160), ' ')))

Select  Ltrim(Rtrim(Replace(IMST.item_cat, Chr(160), ' '))) As Item_Cat 
From TICK TICK     
Inner Join TWGT TWGT     
On  TICK.ORDER_DATE = TWGT.ORDER_DATE And     
    TICK.ORDER_CODE = TWGT.ORDER_CODE And     
    TICK.TKT_CODE = TWGT.TKT_CODE     
Inner Join IMST As IMST
On TWGT.const_prod_code = IMST.item_code
Where Tick.tkt_date >= '2022-10-01'
Group By Ltrim(Rtrim(Replace(IMST.item_cat, Chr(160), ' ')))
Order By Ltrim(Rtrim(Replace(IMST.item_cat, Chr(160), ' ')))
