import * as XLSX from "xlsx";

/**
 * Command Series Mix Converter
 * 
 * Logic:
 * 1. Reads source data starting from Row 1 (Index 1), skipping Row 0 (Header).
 * 2. Maps columns based on the flat table structure of the 'Mixes' sheet.
 * 3. Implements "Fill Down" logic just in case, but primarily relies on direct mapping.
 * 4. Filters out duplicate "Air" rows.
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

  // START PROCESSING FROM ROW 1 (Index 1) - Skipping Header Row 0
  // The 'Mixes' sheet is a flat table starting at Row 0
  const START_ROW_INDEX = 1;

  console.log(`Command Series Converter: Processing ${sourceData.length} rows, starting at index ${START_ROW_INDEX}`);

  // State for "Fill Down" logic
  let lastPlantCode = null;
  let lastMixName = null;
  let lastDescription = null;
  let lastStrength = null;
  let lastDesignAir = null;
  let lastAirRange = null;
  let lastDesignSlump = null;
  let lastSlumpRange = null;

  for (let i = START_ROW_INDEX; i < sourceData.length; i++) {
    const row = sourceData[i];
    
    // Skip completely empty rows
    if (!row || row.length === 0) continue;

    // Check for Summary/Total rows in Column A
    const colA = row[0] ? String(row[0]) : "";
    if (colA.includes("Total") || colA.includes("Sum of")) {
      continue;
    }

    // Extract current row values
    let plantCode = row[0];
    let mixName = row[2]; // Source Col C
    
    // FILL DOWN LOGIC
    // If Plant Code and Mix Name are present, update "last" values
    if (plantCode && mixName && String(plantCode) !== "(blank)" && String(mixName) !== "(blank)") {
      lastPlantCode = plantCode;
      lastMixName = mixName;
      lastDescription = row[3]; // Source Col D
      lastStrength = row[7]; // Source Col H
      lastDesignAir = row[9]; // Source Col J
      lastAirRange = row[10]; // Source Col K
      lastDesignSlump = row[11]; // Source Col L
      lastSlumpRange = row[12]; // Source Col M
    } 
    
    // Ensure we have a valid mix context
    if (!lastPlantCode || !lastMixName) continue;

    const newRow = new Array(25).fill(null);

    // Map Mix-Level Data (using cached values)
    newRow[0] = lastPlantCode;
    newRow[1] = lastMixName;
    newRow[2] = lastDescription;
    newRow[6] = lastStrength;
    newRow[7] = lastDesignAir;

    // Split Air Range
    const [minAir, maxAir] = parseRange(lastAirRange);
    newRow[8] = minAir;
    newRow[9] = maxAir;

    newRow[10] = lastDesignSlump;

    // Split Slump Range
    const [minSlump, maxSlump] = parseRange(lastSlumpRange);
    newRow[11] = minSlump;
    newRow[12] = maxSlump;

    // Map Component-Level Data (from CURRENT row)
    newRow[21] = row[14]; // Item Code (Source Col O)
    newRow[22] = row[15]; // Item Desc (Source Col P)
    newRow[23] = row[18]; // Quantity (Source Col S)
    newRow[24] = row[19]; // Unit (Source Col T)

    // Only add row if it has a component (Item Code or Description)
    // OR if it's the first row of a mix (to ensure mix exists even without components)
    if (newRow[21] || newRow[22] || (plantCode && mixName)) {
      outputData.push(newRow);
    }
  }

  // FILTER OUT "AIR" COMPONENT ROWS
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