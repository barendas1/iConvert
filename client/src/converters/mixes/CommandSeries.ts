import * as XLSX from "xlsx";

/**
 * Command Series Mix Converter
 * 
 * Logic:
 * 1. Reads source data starting from Row 5 (index 4) to skip the 4-row header.
 * 2. Maps columns based on the specific Command Series layout.
 * 3. Splits Air and Slump ranges.
 * 4. Filters out rows where both Constituent Code and Description are "Air".
 * 5. Outputs a file with a SINGLE header row.
 */

export const convertCommandSeries = (sourceData: any[]): any[][] => {
  // Define the SINGLE header row for the output file
  const headers = [
    'Plant Code',
    'Mix Name',
    'Description',
    'Short Description',
    'Item Category',
    'Strength Age (Default 28)',
    'Strength (PSI)',
    'Design Air Content (%)',
    'Min Air Content (%)',
    'Max Air Content (%)',
    'Design Slump (in)',
    'Min Slump (in)',
    'Max Slump (in)',
    'Max Batch Size',
    'Max Water Gallons',
    'Max W/C+P',
    'Max W/C',
    'Mix Class Names, separate with semicolon',
    'Mix Usage',
    'Dispatch Slump Range',
    'Dispatch',
    'Constituent Item Code',
    'Constituent Item Description',
    'Quantity',
    'Unit Name'
  ];

  const outputData: any[][] = [headers];

  // Helper to parse range "10-20"
  const parseRange = (rangeStr: any) => {
    if (!rangeStr) return [null, null];
    const str = String(rangeStr).trim();
    const match = str.match(/^(\d+\.?\d*)\s*-\s*(\d+\.?\d*)$/);
    if (match) {
      return [parseFloat(match[1]), parseFloat(match[2])];
    }
    return [null, null];
  };

  // START PROCESSING FROM ROW 5 (Index 4)
  // The first 4 rows (0-3) are headers in the source file.
  const START_ROW_INDEX = 4;

  console.log(`Command Series Converter: Processing ${sourceData.length} rows, starting at index ${START_ROW_INDEX}`);

  for (let i = START_ROW_INDEX; i < sourceData.length; i++) {
    const row = sourceData[i];
    
    // Skip empty rows
    if (!row || row.length === 0) continue;

    // Skip summary rows (e.g., "Grand Total", "Sum of Quantity")
    // Check Column A (Index 0)
    const colA = row[0] ? String(row[0]) : "";
    if (colA.includes("Total") || colA.includes("Sum of") || colA === "(blank)") {
      continue;
    }

    const newRow = new Array(25).fill(null);

    // MAPPING LOGIC (0-indexed based on source file)
    // A(0) -> Plant Code (Output Col 0)
    // C(2) -> Mix Name (Output Col 1)
    // D(3) -> Description (Output Col 2)
    // H(7) -> Strength (Output Col 6)
    // J(9) -> Design Air (Output Col 7)
    // K(10) -> Air Range (Output Cols 8 & 9)
    // L(11) -> Design Slump (Output Col 10)
    // M(12) -> Slump Range (Output Cols 11 & 12)
    // O(14) -> Item Code (Output Col 21)
    // P(15) -> Item Desc (Output Col 22)
    // S(18) -> Quantity (Output Col 23)
    // T(19) -> Unit (Output Col 24)

    newRow[0] = row[0]; // Plant Code
    newRow[1] = row[2]; // Mix Name (Source Col C)
    newRow[2] = row[3]; // Description (Source Col D)
    newRow[6] = row[7]; // Strength (Source Col H)
    newRow[7] = row[9]; // Design Air (Source Col J)

    // Split Air Range (Source Col K)
    const [minAir, maxAir] = parseRange(row[10]);
    newRow[8] = minAir;
    newRow[9] = maxAir;

    newRow[10] = row[11]; // Design Slump (Source Col L)

    // Split Slump Range (Source Col M)
    const [minSlump, maxSlump] = parseRange(row[12]);
    newRow[11] = minSlump;
    newRow[12] = maxSlump;

    newRow[21] = row[14]; // Item Code (Source Col O)
    newRow[22] = row[15]; // Item Desc (Source Col P)
    newRow[23] = row[18]; // Quantity (Source Col S)
    newRow[24] = row[19]; // Unit (Source Col T)

    outputData.push(newRow);
  }

  // FILTER OUT "AIR" COMPONENT ROWS
  // Remove rows where both Item Code (Col 21) and Item Desc (Col 22) are "Air"
  // But keep the header row (index 0)
  const filteredData = outputData.filter((row, index) => {
    if (index === 0) return true; // Keep header

    const itemCode = row[21] ? String(row[21]).trim().toUpperCase() : "";
    const itemDesc = row[22] ? String(row[22]).trim().toUpperCase() : "";

    if (itemCode === "AIR" && itemDesc === "AIR") {
      return false;
    }
    return true;
  });

  console.log(`Command Series Converter: Finished. Output rows: ${filteredData.length}`);
  return filteredData;
};