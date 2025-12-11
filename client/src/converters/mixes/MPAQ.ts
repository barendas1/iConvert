/**
 * MPAQ Mixes Converter
 * 
 * Converts MPAQ mix export data to Command Series import format
 * 
 * Rules:
 * - Plant duplication: Barrie-01, Orillia-02, Midland-03, Bradford-05, Parry Sound-06
 * - Mix Name := MixId
 * - Description := Name
 * - Strength (MPa) parsed from Name
 * - Max Water (L) := WaterTargetMax if present else WaterTarget
 * - Constituent units:
 *     Aggregates & Cement -> "kg/m³"
 *     Admixtures -> "mL PerHundred"
 *     Admixture ID '07' or name contains 'CNI' -> "L PerHundred"
 */

// ---------- CONFIG ----------
const PLANTS = ["01", "02", "03", "05", "06"];

// Material blocks
const AGG_COUNT = 6;   // Agg1..Agg6
const CEM_COUNT = 4;   // Cem1..Cem4
const ADM_COUNT = 8;   // Adm1..Adm8

// Final output column order
const FINAL_COLUMNS = [
    "Plant Code",
    "Mix Name",
    "Description",
    "Short Description",
    "Item Category",
    "Strength Age (Default 28)",
    "Strength (MPa)",
    "Design Air Content (%)",
    "Min Air Content (%)",
    "Max Air Content (%)",
    "Design Slump (mm)",
    "Min Slump (in)",
    "Max Slump (in)",
    "Max Batch Size",
    "Max Water (L)",
    "Max W/C+P",
    "Max W/C",
    "Mix Class Names, separate with semicolon",
    "Mix Usage",
    "Dispatch Slump Range",
    "Dispatch",
    "Constituent Item Code",
    "Constituent Item Description",
    "Quantity",
    "Unit Name"
];

// ---------- Helper functions ----------
function parseStrengthMpa(nameVal: any): number | string {
    if (nameVal === null || nameVal === undefined) {
        return "";
    }
    const s = String(nameVal);
    const match = s.match(/(\d+(?:\.\d+)?)\s*MPa/i);
    if (match) {
        return parseFloat(match[1]);
    }
    return "";
}

function chooseUnit(matType: string, matId: any, matName: any): string {
    if (matType === "Aggregate" || matType === "Cement") {
        return "kg/m³";
    }
    if (matType === "Admixture") {
        const mid = String(matId || "").trim();
        const mname = String(matName || "").toUpperCase();
        if (mid === "07" || mid === "7" || mname.includes("CNI")) {
            return "L PerHundred";
        }
        return "mL PerHundred";
    }
    return "";
}

function safeGet(row: any, col: string): any {
    return row.hasOwnProperty(col) ? row[col] : "";
}

function isEmptyValue(val: any): boolean {
    return val === null || val === undefined || val === "" || 
           (typeof val === 'number' && isNaN(val));
}

// ---------- Main conversion function ----------
export function convertMPAQMixes(inputData: any[][]): any[][] {
    console.log("Starting MPAQ Mixes conversion...");
    console.log("Input data rows:", inputData.length);
    
    if (inputData.length === 0) {
        throw new Error("Input data is empty");
    }
    
    // First row is headers
    const headers = inputData[0];
    console.log("Headers:", headers);
    
    // Convert array of arrays to array of objects
    const data = inputData.slice(1).map(row => {
        const obj: any = {};
        headers.forEach((header: any, index: number) => {
            obj[header] = row[index];
        });
        return obj;
    });
    
    console.log("Converted to objects:", data.length, "rows");
    
    // Prepare material column names
    const aggCols: [string, string, string][] = [];
    for (let i = 1; i <= AGG_COUNT; i++) {
        aggCols.push([`Agg${i}Id`, `Agg${i}Name`, `Agg${i}Target`]);
    }
    
    const cemCols: [string, string, string][] = [];
    for (let i = 1; i <= CEM_COUNT; i++) {
        cemCols.push([`Cem${i}Id`, `Cem${i}Name`, `Cem${i}Target`]);
    }
    
    const admCols: [string, string, string][] = [];
    for (let i = 1; i <= ADM_COUNT; i++) {
        admCols.push([`Adm${i}Id`, `Adm${i}Name`, `Adm${i}Target`]);
    }
    
    // Verify required columns
    if (!data[0] || !data[0].hasOwnProperty("MixId") || !data[0].hasOwnProperty("Name")) {
        throw new Error("Input file must contain 'MixId' and 'Name' columns.");
    }
    
    const outRows: any[][] = [];
    
    // Add header row
    outRows.push(FINAL_COLUMNS);
    
    // Process each mix row
    for (let idx = 0; idx < data.length; idx++) {
        const row = data[idx];
        
        const mixId = safeGet(row, "MixId");
        const nameVal = safeGet(row, "Name");
        const defaultWorkType = safeGet(row, "DefaultWorkType");
        const airFactor = safeGet(row, "AirFactor");
        const slumpVal = safeGet(row, "Slump");
        const waterTarget = row.hasOwnProperty("WaterTarget") ? safeGet(row, "WaterTarget") : null;
        const waterTargetMax = row.hasOwnProperty("WaterTargetMax") ? safeGet(row, "WaterTargetMax") : null;
        
        // Parse strength from Name
        const strengthMpa = parseStrengthMpa(nameVal);
        
        // Max Water (L) rule: WaterTargetMax if present else WaterTarget
        let chosenWaterVal: string | number = "";
        if (!isEmptyValue(waterTargetMax)) {
            chosenWaterVal = waterTargetMax;
        } else if (!isEmptyValue(waterTarget)) {
            chosenWaterVal = waterTarget;
        }
        
        // Build list of constituents from Agg/Cem/Adm blocks
        const constituents: [string, any, any, any][] = [];
        
        // Aggregates
        for (const [aid, aname, atarget] of aggCols) {
            const matId = safeGet(row, aid);
            const matName = safeGet(row, aname);
            const matTarget = safeGet(row, atarget);
            if (isEmptyValue(matId)) continue;
            constituents.push(["Aggregate", matId, matName, matTarget]);
        }
        
        // Cements
        for (const [cid, cname, ctarget] of cemCols) {
            const matId = safeGet(row, cid);
            const matName = safeGet(row, cname);
            const matTarget = safeGet(row, ctarget);
            if (isEmptyValue(matId)) continue;
            constituents.push(["Cement", matId, matName, matTarget]);
        }
        
        // Admixtures
        for (const [aid, aname, atarget] of admCols) {
            const matId = safeGet(row, aid);
            const matName = safeGet(row, aname);
            const matTarget = safeGet(row, atarget);
            if (isEmptyValue(matId)) continue;
            constituents.push(["Admixture", matId, matName, matTarget]);
        }
        
        // Duplicate each constituent row for every plant
        for (const [matType, matId, matName, matTarget] of constituents) {
            const unitName = chooseUnit(matType, matId, matName);
            
            for (const plant of PLANTS) {
                const outRow = [
                    plant,                              // Plant Code
                    mixId,                              // Mix Name
                    nameVal || "",                      // Description
                    "",                                 // Short Description
                    "",                                 // Item Category
                    28,                                 // Strength Age (Default 28)
                    strengthMpa,                        // Strength (MPa)
                    airFactor || "",                    // Design Air Content (%)
                    "",                                 // Min Air Content (%)
                    "",                                 // Max Air Content (%)
                    slumpVal || "",                     // Design Slump (mm)
                    "",                                 // Min Slump (in)
                    "",                                 // Max Slump (in)
                    "",                                 // Max Batch Size
                    chosenWaterVal,                     // Max Water (L)
                    "",                                 // Max W/C+P
                    "",                                 // Max W/C
                    "",                                 // Mix Class Names
                    defaultWorkType || "",              // Mix Usage
                    "",                                 // Dispatch Slump Range
                    "",                                 // Dispatch
                    matId,                              // Constituent Item Code
                    matName || "",                      // Constituent Item Description
                    matTarget || "",                    // Quantity
                    unitName                            // Unit Name
                ];
                outRows.push(outRow);
            }
        }
        
        if ((idx + 1) % 50 === 0) {
            console.log(`Processed ${idx + 1} input rows...`);
        }
    }
    
    console.log("Conversion complete. Output rows:", outRows.length - 1); // -1 for header
    return outRows;
}