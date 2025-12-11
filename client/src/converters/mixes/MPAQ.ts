#!/usr/bin/env ts-node
/**
 * process_mixes.ts
 * 
 * Reads a horizontal mix-list (CSV or XLSX) with Agg/Cem/Adm blocks,
 * expands into vertical constituent rows, duplicates for five plants,
 * maps fields to the final import schema, and writes an XLSX:
 *     mixes_prepped_ready.xlsx
 * 
 * Rules (as provided):
 * - Plant duplication: Barrie-01, Orillia-02, Midland-03, Bradford-05, Parry Sound-06
 * - Mix Name := MixId
 * - Description := Name
 * - Short Description := blank
 * - Strength (MPa) parsed from Name (pattern like '7 MPa' or '0.4 Mpa')
 * - Design Slump (mm) := Slump (no conversion)
 * - Max Water (L) := WaterTargetMax if present else WaterTarget
 * - Mix Usage := DefaultWorkType
 * - Constituent units:
 *     Aggregates & Cement -> "kg/m³"
 *     Admixtures -> "mL PerHundred"
 *     Admixture ID '07' or name contains 'CNI' -> "L PerHundred"
 * - Fields marked as unknown are left blank
 */

import * as XLSX from 'xlsx';
import * as fs from 'fs';

// ---------- CONFIG ----------
const PLANTS = ["01", "02", "03", "05", "06"];
const PLANT_NAMES: { [key: string]: string } = {
    '01': 'Barrie',
    '02': 'Orillia',
    '03': 'Midland',
    '05': 'Bradford',
    '06': 'Parry Sound'
};

// Default input / output
const INPUT_FILE = "mix-list.csv";   // change if needed (can be .csv or .xlsx)
const OUTPUT_XLSX = "mixes_prepped_ready.xlsx";

// Material blocks (as in your header)
const AGG_COUNT = 6;   // Agg1..Agg6
const CEM_COUNT = 4;   // Cem1..Cem4
const ADM_COUNT = 8;   // Adm1..Adm8

// Final output column order (exact)
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

interface InputRow {
    [key: string]: any;
}

interface OutputRow {
    "Plant Code": string;
    "Mix Name": string | number;
    "Description": string;
    "Short Description": string;
    "Item Category": string;
    "Strength Age (Default 28)": number | string;
    "Strength (MPa)": number | string;
    "Design Air Content (%)": string | number;
    "Min Air Content (%)": string;
    "Max Air Content (%)": string;
    "Design Slump (mm)": string | number;
    "Min Slump (in)": string;
    "Max Slump (in)": string;
    "Max Batch Size": string;
    "Max Water (L)": string | number;
    "Max W/C+P": string;
    "Max W/C": string;
    "Mix Class Names, separate with semicolon": string;
    "Mix Usage": string;
    "Dispatch Slump Range": string;
    "Dispatch": string;
    "Constituent Item Code": string | number;
    "Constituent Item Description": string;
    "Quantity": string | number;
    "Unit Name": string;
}

type Constituent = [string, any, any, any]; // [type, id, name, target]

// ---------- Helper functions ----------
function loadInputFile(path: string): any[] {
    const workbook = XLSX.readFile(path);
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    return XLSX.utils.sheet_to_json(worksheet);
}

function parseStrengthMpa(nameVal: any): number | null {
    /**Extract the MPa numeric value from mix name. Examples: '0.4 Mpa ...', '7 MPa ...'*/
    if (nameVal === null || nameVal === undefined) {
        return null;
    }
    const s = String(nameVal);
    const match = s.match(/(\d+(?:\.\d+)?)\s*MPa/i);
    if (match) {
        try {
            return parseFloat(match[1]);
        } catch {
            return null;
        }
    }
    // also check for lowercase 'mpa' without space
    const match2 = s.match(/(\d+(?:\.\d+)?)\s*mpa/);
    if (match2) {
        try {
            return parseFloat(match2[1]);
        } catch {
            return null;
        }
    }
    return null;
}

function chooseUnit(matType: string, matId: any, matName: any): string {
    /**Return unit string per rules.*/
    if (matType === "Aggregate" || matType === "Cement") {
        return "kg/m³";
    }
    if (matType === "Admixture") {
        // ID '07' or name contains 'CNI' -> L PerHundred
        const mid = String(matId || "").trim();
        const mname = String(matName || "").toUpperCase();
        if (mid === "07" || mname.includes("CNI")) {
            return "L PerHundred";
        }
        return "mL PerHundred";
    }
    return "";
}

function safeGet(row: InputRow, col: string): any {
    /**Return value or empty string if missing.*/
    return row.hasOwnProperty(col) ? row[col] : "";
}

function isEmptyValue(val: any): boolean {
    return val === null || val === undefined || val === "" || 
           (typeof val === 'number' && isNaN(val));
}

// ---------- Main processing ----------
function run(inputPath: string, outputXlsx: string): void {
    console.log("Loading input file:", inputPath);
    const data = loadInputFile(inputPath);
    console.log("Input columns:", Object.keys(data[0] || {}));
    console.log(`Rows in input: ${data.length}`);

    // Prepare material column names expected
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

    // Verify at least Name/MixId exist
    if (!data[0] || !data[0].hasOwnProperty("MixId") || !data[0].hasOwnProperty("Name")) {
        throw new Error("Input file must contain 'MixId' and 'Name' columns.");
    }

    const outRows: OutputRow[] = [];

    // For every input mix row
    for (let idx = 0; idx < data.length; idx++) {
        const row = data[idx];
        
        const mixId = safeGet(row, "MixId");
        const nameVal = safeGet(row, "Name");
        const defaultWorkType = safeGet(row, "DefaultWorkType");
        const airFactor = safeGet(row, "AirFactor");
        const slumpVal = safeGet(row, "Slump");
        const waterTarget = row.hasOwnProperty("WaterTarget") ? safeGet(row, "WaterTarget") : null;
        const waterTargetMax = row.hasOwnProperty("WaterTargetMax") ? safeGet(row, "WaterTargetMax") : null;

        // parsed strength from Name -> MPa
        const strengthMpa = parseStrengthMpa(nameVal);

        // Max Water (L) rule: WaterTargetMax if present else WaterTarget
        let chosenWaterVal: string | number = "";
        if (!isEmptyValue(waterTargetMax)) {
            try {
                chosenWaterVal = parseFloat(String(waterTargetMax));
            } catch {
                chosenWaterVal = waterTargetMax;
            }
        } else if (!isEmptyValue(waterTarget)) {
            try {
                chosenWaterVal = parseFloat(String(waterTarget));
            } catch {
                chosenWaterVal = waterTarget;
            }
        }

        // build list of constituents from Agg/Cem/Adm blocks
        const constituents: Constituent[] = [];

        // Aggregates
        for (const [aid, aname, atarget] of aggCols) {
            const matId = safeGet(row, aid);
            const matName = safeGet(row, aname);
            const matTarget = safeGet(row, atarget);
            if (isEmptyValue(matId)) {
                continue;
            }
            constituents.push(["Aggregate", matId, matName, matTarget]);
        }

        // Cements
        for (const [cid, cname, ctarget] of cemCols) {
            const matId = safeGet(row, cid);
            const matName = safeGet(row, cname);
            const matTarget = safeGet(row, ctarget);
            if (isEmptyValue(matId)) {
                continue;
            }
            constituents.push(["Cement", matId, matName, matTarget]);
        }

        // Admixtures
        for (const [aid, aname, atarget] of admCols) {
            const matId = safeGet(row, aid);
            const matName = safeGet(row, aname);
            const matTarget = safeGet(row, atarget);
            if (isEmptyValue(matId)) {
                continue;
            }
            constituents.push(["Admixture", matId, matName, matTarget]);
        }

        // Duplicate each constituent row for every plant
        for (const mat of constituents) {
            const [matType, matId, matName, matTarget] = mat;
            const unitName = chooseUnit(matType, matId, matName);

            for (const plant of PLANTS) {
                const out: OutputRow = {
                    "Plant Code": plant,
                    "Mix Name": mixId,
                    "Description": nameVal || "",
                    "Short Description": "",
                    "Item Category": "",
                    "Strength Age (Default 28)": 28,
                    "Strength (MPa)": strengthMpa !== null ? strengthMpa : "",
                    "Design Air Content (%)": airFactor || "",
                    "Min Air Content (%)": "",
                    "Max Air Content (%)": "",
                    "Design Slump (mm)": slumpVal || "",
                    "Min Slump (in)": "",
                    "Max Slump (in)": "",
                    "Max Batch Size": "",
                    "Max Water (L)": chosenWaterVal,
                    "Max W/C+P": "",
                    "Max W/C": "",
                    "Mix Class Names, separate with semicolon": "",
                    "Mix Usage": defaultWorkType || "",
                    "Dispatch Slump Range": "",
                    "Dispatch": "",
                    "Constituent Item Code": matId,
                    "Constituent Item Description": matName || "",
                    "Quantity": matTarget || "",
                    "Unit Name": unitName
                };
                outRows.push(out);
            }
        }

        // progress indicator occasionally
        if ((idx + 1) % 100 === 0) {
            console.log(`Processed ${idx + 1} input rows...`);
        }
    }

    // Build final data in correct column order
    console.log(`Writing final XLSX to: ${outputXlsx} ...`);
    
    // Replace empty values with empty strings for Excel compatibility
    const cleanedRows = outRows.map(row => {
        const cleaned: any = {};
        for (const col of FINAL_COLUMNS) {
            cleaned[col] = row[col as keyof OutputRow] === null || 
                          row[col as keyof OutputRow] === undefined ? "" : 
                          row[col as keyof OutputRow];
        }
        return cleaned;
    });

    // Save as XLSX
    const workbook = XLSX.utils.book_new();
    const worksheet = XLSX.utils.json_to_sheet(cleanedRows, { header: FINAL_COLUMNS });
    XLSX.utils.book_append_sheet(workbook, worksheet, "Mixes");
    XLSX.writeFile(workbook, outputXlsx);

    console.log("Done. Output rows:", outRows.length);
    
    // print a small preview
    if (outRows.length > 0) {
        console.log("Preview (first 10 rows):");
        console.table(outRows.slice(0, 10));
    } else {
        console.log("No output rows produced. Check input file for constituent columns.");
    }
}

// ---------- Entry point ----------
const args = process.argv.slice(2);
const inputPath = args[0] || INPUT_FILE;
const outputPath = args[1] || OUTPUT_XLSX;
run(inputPath, outputPath);
