/************************************************************
 * Code formatted by SoftTree SQL Assistant © v11.1.125
 * Time: 5/26/2020 8:50:28 PM
 ************************************************************/

Select  PlantCode,
        MixCode,
        MixDescription,
        MixShortDescription,
        ItemCategory,
        StrengthAge,
        Strength,
        AirContent,
        MinAirContent,
        MaxAirContent,
        Slump,
        MinSlump,
        MaxSlump,
        DispatchSlumpRange,
		MaxLoadSize,
		SackContent, 
		Price,
		PriceUnitName,
		MixInactive,
        Padding1,
        MaterialItemCode,
        MaterialItemDescription,
        Quantity,
        QuantityUnitName,
        SortNumber
    From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As TestImport0000_XML_MixInfo
