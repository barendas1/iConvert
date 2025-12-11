import * as fs from 'fs';
import * as XLSX from 'xlsx';

// ---------- PLANTS ----------
const PLANTS = ["01", "02", "03", "05", "06"];

// ---------- RAW MATERIAL STRUCTURE ----------
const RAW_COLUMNS = [
    "ID", "Plant Code", "Trade Name", "Material Date", "Family Material Type",
    "Material Type", "Specific Gravity", "Is Liquid Admixture",
    "Water Contribution", "Cost", "Cost Units", "Manufacturer",
    "Manufacturer Source", "Batching Order Number", "Production Item Code",
    "Production Item Description", "Production Item Short Description",
    "Production Item Category", "Production Item Category Description",
    "Production Item Category Short Description", "Batch Panel Code"
];

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

interface MaterialRow {
    [key: string]: any;
}

interface RawMaterialRow {
    ID: string | number;
    "Plant Code": string;
    "Trade Name": string;
    "Material Date": string;
    "Family Material Type": string;
    "Material Type": string;
    "Specific Gravity": number;
    "Is Liquid Admixture": string;
    "Water Contribution": string;
    Cost: string;
    "Cost Units": string;
    Manufacturer: string;
    "Manufacturer Source": string;
    "Batching Order Number": string;
    "Production Item Code": string | number;
    "Production Item Description": string;
    "Production Item Short Description": string;
    "Production Item Category": string;
    "Production Item Category Description": string;
    "Production Item Category Short Description": string;
    "Batch Panel Code": string;
}

// ---------- LOAD CSV FILES ----------
function loadCSV(filename: string): any[] {
    const workbook = XLSX.readFile(filename);
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    return XLSX.utils.sheet_to_json(worksheet);
}

// ---------- CREATE MATERIAL ROWS ----------
function createMaterialRows(data: any[], familyType: string): RawMaterialRow[] {
    const rows: RawMaterialRow[] = [];
    
    for (const row of data) {
        for (const plant of PLANTS) {
            // Get today's date in MM/DD/YYYY format
            const today = new Date();
            const materialDate = `${String(today.getMonth() + 1).padStart(2, '0')}/${String(today.getDate()).padStart(2, '0')}/${today.getFullYear()}`;
            
            const newRow: RawMaterialRow = {
                ID: row[Object.keys(row)[0]], // First column as ID
                "Plant Code": plant,
                "Trade Name": row.Name,
                "Material Date": materialDate,
                "Family Material Type": familyType,
                "Material Type": row.Name,
                "Specific Gravity": parseFloat(row.SpecificGravity),
                "Is Liquid Admixture": familyType === "Admixture & Fiber" ? "Yes" : "No",
                "Water Contribution": "",
                Cost: "",
                "Cost Units": "",
                Manufacturer: "",
                "Manufacturer Source": "",
                "Batching Order Number": "",
                "Production Item Code": row[Object.keys(row)[0]],
                "Production Item Description": row.Name,
                "Production Item Short Description": row.Name.substring(0, 10),
                "Production Item Category": familyType,
                "Production Item Category Description": familyType,
                "Production Item Category Short Description": familyType.substring(0, 10),
                "Batch Panel Code": ""
            };
            
            rows.push(newRow);
        }
    }
    
    return rows;
}

// ---------- MAIN PROCESSING ----------
function processMaterials() {
    console.log("Loading source files...");
    
    // Load source CSV files
    const admixData = loadCSV('admix-list.csv');
    const aggregateData = loadCSV('aggregate-list.csv');
    const cementData = loadCSV('cement-list.csv');
    
    console.log("Creating material rows...");
    
    // Create raw materials
    const rawMaterials: RawMaterialRow[] = [
        ...createMaterialRows(admixData, "Admixture & Fiber"),
        ...createMaterialRows(aggregateData, "Aggregate"),
        ...createMaterialRows(cementData, "Cement")
    ];
    
    // Save intermediate file (optional)
    const rawWorkbook = XLSX.utils.book_new();
    const rawWorksheet = XLSX.utils.json_to_sheet(rawMaterials, { header: RAW_COLUMNS });
    XLSX.utils.book_append_sheet(rawWorkbook, rawWorksheet, "Raw Materials");
    XLSX.writeFile(rawWorkbook, "Master_Materials_AllPlants_RAW.csv");
    
    console.log("Mapping to template format...");
    
    // ---------- MAP RAW COLUMNS → TEMPLATE COLUMNS ----------
    const columnMap: { [key: string]: string } = {
        "Plant Code": "Plant Code (Required)",
        "Trade Name": "Trade Name (Required)",
        "Material Date": "Material Date (mm/dd/yyyy)",
        "Family Material Type": "Family Material Type (Required)",
        "Material Type": "Material Type (Required)",
        "Specific Gravity": "Specific Gravity (Required)",
        "Is Liquid Admixture": "Is Liquid Admixture (Yes/No)",
        "Water Contribution": "Water Contribution (%)",
        "Cost": "Cost",
        "Cost Units": "Cost Units",
        "Manufacturer": "Manufacturer",
        "Manufacturer Source": "Manufacturer Source",
        "Batching Order Number": "Batching Order Number",
        "Production Item Code": "Production Item Code",
        "Production Item Description": "Production Item Description",
        "Production Item Short Description": "Production Item Short Description",
        "Production Item Category": "Production Item Category",
        "Production Item Category Description": "Production Item Category Description",
        "Production Item Category Short Description": "Production Item Category Short Description",
        "Batch Panel Code": "Batch Panel Code"
    };
    
    // Create template data
    const templateData: MaterialRow[] = rawMaterials.map(row => {
        const newRow: MaterialRow = {};
        for (const [rawCol, finalCol] of Object.entries(columnMap)) {
            newRow[finalCol] = row[rawCol as keyof RawMaterialRow];
        }
        return newRow;
    });
    
    // ---------- EXPORT AS XLSX ----------
    console.log("Exporting to Excel...");
    const templateWorkbook = XLSX.utils.book_new();
    const templateWorksheet = XLSX.utils.json_to_sheet(templateData, { header: TEMPLATE_COLUMNS });
    XLSX.utils.book_append_sheet(templateWorkbook, templateWorksheet, "Materials");
    XLSX.writeFile(templateWorkbook, "Material_Import_Template.xlsx");
    
    console.log("FINAL MATERIAL IMPORT TEMPLATE CREATED: Material_Import_Template.xlsx");
}

// ---------- ENTRY POINT ----------
processMaterials();