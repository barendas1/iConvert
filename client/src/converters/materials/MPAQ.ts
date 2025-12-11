/**
 * MPAQ Materials Converter
 * 
 * Converts MPAQ material export data (admix, aggregate, cement lists) 
 * to Command Series import format
 * 
 * Expected input: Three sheets or combined data with material types
 * - Admixtures (admix-list)
 * - Aggregates (aggregate-list)  
 * - Cements (cement-list)
 * 
 * Rules:
 * - Duplicate each material for 5 plants: 01, 02, 03, 05, 06
 * - Set Family Material Type based on source
 * - Liquid Admixture = Yes for Admixtures, No for others
 */

// ---------- PLANTS ----------
const PLANTS = ["01", "02", "03", "05", "06"];

// ---------- TEMPLATE STRUCTURE (FINAL FORMAT) ----------
const TEMPLATE_COLUMNS = [
    "Plant Code (Required)",
    "Trade Name (Required)",
    "Material Date (mm/dd/yyyy)",
    "Family Material Type (Required)",
    "Material Type (Required)",
    "Specific Gravity (Required)",
    "Is Liquid Admixture (Yes/No)",
    "Water Contribution (%)",
    "Cost",
    "Cost Units",
    "Manufacturer",
    "Manufacturer Source",
    "Batching Order Number",
    "Production Item Code",
    "Production Item Description",
    "Production Item Short Description",
    "Production Item Category",
    "Production Item Category Description",
    "Production Item Category Short Description",
    "Batch Panel Code"
];

interface MaterialData {
    [key: string]: any;
}

// ---------- Helper Functions ----------
function getTodayDate(): string {
    const today = new Date();
    return `${String(today.getMonth() + 1).padStart(2, '0')}/${String(today.getDate()).padStart(2, '0')}/${today.getFullYear()}`;
}

function safeGet(row: any, col: string): any {
    return row.hasOwnProperty(col) ? row[col] : "";
}

function isEmptyValue(val: any): boolean {
    return val === null || val === undefined || val === "" || 
           (typeof val === 'number' && isNaN(val));
}

// ---------- CREATE MATERIAL ROWS ----------
function createMaterialRows(data: MaterialData[], familyType: string): any[][] {
    const rows: any[][] = [];
    const materialDate = getTodayDate();
    
    for (const row of data) {
        // Get ID from first column or specific ID field
        const matId = row.Id || row.ID || row.id || row[Object.keys(row)[0]];
        const matName = row.Name || row.name || "";
        const specificGravity = parseFloat(row.SpecificGravity || row["Specific Gravity"] || "1.0");
        
        // Skip if no name
        if (isEmptyValue(matName)) continue;
        
        for (const plant of PLANTS) {
            const materialRow = [
                plant,                                      // Plant Code (Required)
                matName,                                    // Trade Name (Required)
                materialDate,                               // Material Date (mm/dd/yyyy)
                familyType,                                 // Family Material Type (Required)
                matName,                                    // Material Type (Required)
                specificGravity,                            // Specific Gravity (Required)
                familyType === "Admixture & Fiber" ? "Yes" : "No",  // Is Liquid Admixture
                "",                                         // Water Contribution (%)
                "",                                         // Cost
                "",                                         // Cost Units
                "",                                         // Manufacturer
                "",                                         // Manufacturer Source
                "",                                         // Batching Order Number
                matId,                                      // Production Item Code
                matName,                                    // Production Item Description
                matName.substring(0, 10),                   // Production Item Short Description
                familyType,                                 // Production Item Category
                familyType,                                 // Production Item Category Description
                familyType.substring(0, 10),                // Production Item Category Short Description
                ""                                          // Batch Panel Code
            ];
            rows.push(materialRow);
        }
    }
    
    return rows;
}

// ---------- Main conversion function ----------
export function convertMPAQMaterials(inputData: any[][]): any[][] {
    console.log("Starting MPAQ Materials conversion...");
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
    
    // Determine material type based on column names or data patterns
    // Check if we have specific columns that indicate material type
    const hasAdmixColumns = headers.some((h: string) => 
        String(h).toLowerCase().includes('admix') || 
        String(h).toLowerCase().includes('fiber')
    );
    const hasAggregateColumns = headers.some((h: string) => 
        String(h).toLowerCase().includes('aggregate') || 
        String(h).toLowerCase().includes('sand') ||
        String(h).toLowerCase().includes('stone')
    );
    const hasCementColumns = headers.some((h: string) => 
        String(h).toLowerCase().includes('cement') || 
        String(h).toLowerCase().includes('slag')
    );
    
    // Try to detect material type from data
    let familyType = "Material"; // default
    
    // Check if there's a Type or MaterialType column
    if (data.length > 0 && data[0].hasOwnProperty('Type')) {
        familyType = data[0].Type;
    } else if (data.length > 0 && data[0].hasOwnProperty('MaterialType')) {
        familyType = data[0].MaterialType;
    } else if (data.length > 0 && data[0].hasOwnProperty('Family')) {
        familyType = data[0].Family;
    } else {
        // Infer from column names
        if (hasAdmixColumns) {
            familyType = "Admixture & Fiber";
        } else if (hasAggregateColumns) {
            familyType = "Aggregate";
        } else if (hasCementColumns) {
            familyType = "Cement";
        }
    }
    
    console.log("Detected material family type:", familyType);
    
    // Process materials
    const outRows: any[][] = [];
    
    // Add header row
    outRows.push(TEMPLATE_COLUMNS);
    
    // Create material rows
    const materialRows = createMaterialRows(data, familyType);
    outRows.push(...materialRows);
    
    console.log("Conversion complete. Output rows:", outRows.length - 1); // -1 for header
    return outRows;
}

/**
 * Convert multiple material sheets (admix, aggregate, cement)
 * This is used when the input file has separate sheets for each material type
 */
export function convertMPAQMaterialsMultiSheet(
    admixData: any[][] | null,
    aggregateData: any[][] | null,
    cementData: any[][] | null
): any[][] {
    console.log("Starting MPAQ Materials multi-sheet conversion...");
    
    const outRows: any[][] = [];
    outRows.push(TEMPLATE_COLUMNS);
    
    // Process admixtures
    if (admixData && admixData.length > 1) {
        const headers = admixData[0];
        const data = admixData.slice(1).map(row => {
            const obj: any = {};
            headers.forEach((header: any, index: number) => {
                obj[header] = row[index];
            });
            return obj;
        });
        const admixRows = createMaterialRows(data, "Admixture & Fiber");
        outRows.push(...admixRows);
        console.log("Processed admixtures:", admixRows.length, "rows");
    }
    
    // Process aggregates
    if (aggregateData && aggregateData.length > 1) {
        const headers = aggregateData[0];
        const data = aggregateData.slice(1).map(row => {
            const obj: any = {};
            headers.forEach((header: any, index: number) => {
                obj[header] = row[index];
            });
            return obj;
        });
        const aggRows = createMaterialRows(data, "Aggregate");
        outRows.push(...aggRows);
        console.log("Processed aggregates:", aggRows.length, "rows");
    }
    
    // Process cements
    if (cementData && cementData.length > 1) {
        const headers = cementData[0];
        const data = cementData.slice(1).map(row => {
            const obj: any = {};
            headers.forEach((header: any, index: number) => {
                obj[header] = row[index];
            });
            return obj;
        });
        const cemRows = createMaterialRows(data, "Cement");
        outRows.push(...cemRows);
        console.log("Processed cements:", cemRows.length, "rows");
    }
    
    console.log("Multi-sheet conversion complete. Total output rows:", outRows.length - 1);
    return outRows;
}