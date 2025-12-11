Update MixInfo
    Set MixInfo.[Description] = MixProp.MixDescription,
        MixInfo.StrengthAge = MixProp.StrengthAge,
        MixInfo.Strength = MixProp.Strength,
        MixInfo.Slump = MixProp.Slump,
        MixInfo.PercentAirVolume = MixProp.AirContent
From Data_Import_RJ.dbo.TestImport0000_XML_Mix As MixInfo
Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixProps As MixProp
On MixInfo.PlantCode = MixProp.PlantCode And MixInfo.ItemCode = MixProp.MixCode
