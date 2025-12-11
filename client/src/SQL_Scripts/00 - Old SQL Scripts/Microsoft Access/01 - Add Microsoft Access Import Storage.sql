Create Table TestImport0000_MixItemCategory
(
    AutoID AutoIncrement (1, 1) Primary Key,
    Name Text (100),
    Description Text (254),
    ShortDescription Text (100),
    CategoryNumber Text (10),
    CategoryType Text (10)
)

Create Table TestImport0000_MaterialItemCategory
(
    AutoID AutoIncrement (1, 1) Primary Key,
    Name Text (100),
    Description Text (254),
    ShortDescription Text (100),
    CategoryNumber Text (10),
    CategoryType Text (10),
    FamilyMaterialTypeName Text (100),
    MaterialTypeName Text (100),
    SpecificGravity Double,
    IsLiquidAdmix Text (100)
)

Create Table TestImport0000_MaterialInfo
(
    AutoID AutoIncrement (1, 1) Primary Key,
    PlantName Text (100),
    TradeName Text (200),
    MaterialDate Text (30),
    FamilyMaterialTypeName Text (100),
    MaterialTypeName Text (100),
    SpecificGravity Double,
    IsLiquidAdmix Text (100),
    MoisturePct Double,
    Cost Double,
    CostUnitName Text (30),
    ManufacturerName Text (100),
    ManufacturerSourceName Text (100),
    BatchingOrderNumber Text (100),
    ItemCode Text (100),
    ItemDescription Text (254),
    ItemShortDescription Text (100),
    ItemCategoryName Text (100),
    ItemCategoryDescription Text (254),
    ItemCategoryShortDescription Text (100),
    ComponentCategoryName Text (100),
    ComponentCategoryDescription Text (254),
    ComponentCategoryShortDescription Text (100),
    BatchPanelCode Text (100),
    UpdatedFromDatabase Bit Default (0)
)

Create Table TestImport0000_MainMaterialInfo
(
    AutoID AutoIncrement (1, 1) Primary Key,
    Name Text (100),
    Description Text (254),
    ShortDescription Text (100),
    ItemCategory Text (100),
    ItemCategoryDescription Text (254),
    FamilyMaterialTypeName Text (100),
    MaterialTypeName Text (100),
    SpecificGravity Double,
    MoisturePct Double,
    IsLiquidAdmix Text (100)
)

Create Table TestImport0000_MaterialItemCode
(
    AutoID AutoIncrement (1, 1) Primary Key,
    ItemCode Text (100)
)

Create Table TestImport0000_OtherMaterialItemCategory
(
    AutoID AutoIncrement (1, 1) Primary Key,
    ItemCategoryName Text (100)
)

Create Table TestImport0000_MixInfo
(
    AutoID AutoIncrement (1, 1) Primary Key,
    PlantCode Text (100),
    MixCode Text (100),
    MixDescription Text (254),
    MixShortDescription Text (100),
    ItemCategory Text (100),
    StrengthAge Double,
    Strength Double,
    AirContent Double,
    MinAirContent Double,
    MaxAirContent Double,
    Slump Double,
    MinSlump Double,
    MaxSlump Double,
    DispatchSlumpRange Text (100),
    AggregateSize Double,
    MinAggregateSize Double,
    MaxAggregateSize Double,
    UnitWeight Double,
    MinUnitWeight Double,
    MaxUnitWeight Double,
    MaxLoadSize Double,
    MaximumWater Double, 
    SackContent Double,
    Price Double,
    PriceUnitName Text (100),
    MixInactive Text (30),
    MinWCRatio Double,
    MaxWCRatio Double,
    MinWCMRatio Double,
    MaxWCMRatio Double,
    MixClassNames Memo,
    MixUsage Memo,
    AttachmentFileNames Memo,
    Padding1 Text (1),
    MaterialItemCode Text (100),
    FamilyMaterialTypeName Text (100),
    MaterialItemDescription Text (254),
    Quantity Double,
    QuantityUnitName Text (100),
    DosageQuantity Double,
    SortNumber Integer
) 

Create Table TestImport0000_MixInfoNotDeleted
(
    AutoID AutoIncrement (1, 1) Primary Key,
    PlantCode Text (100),
    MixCode Text (100),
    MixID Integer
) 


Create Table TestImport0000_PlantInfo
(
    AutoID AutoIncrement (1, 1) Primary Key,
    Name Text (100),
    Description Text (254),
    MaxBatchSize Double,
    MaxBatchSizeUnitName Text (100)
) 
