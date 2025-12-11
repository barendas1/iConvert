import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { X } from "lucide-react";
import * as XLSX from "xlsx";

interface PreviewSectionProps {
  workbook: XLSX.WorkBook | null;
  title: string;
  onClose: () => void;
}

export function PreviewSection({ workbook, title, onClose }: PreviewSectionProps) {
  if (!workbook) return null;

  // Get the first sheet from the workbook
  const sheetName = workbook.SheetNames[0];
  const worksheet = workbook.Sheets[sheetName];
  
  // Convert to 2D array
  const data: any[][] = XLSX.utils.sheet_to_json(worksheet, { header: 1 });
  
  // Get headers (first row) and rows (rest)
  const headers = data[0] || [];
  const rows = data.slice(1, 51); // Show first 50 rows for preview
  const totalRows = data.length - 1;

  return (
    <Card className="border-border shadow-sm overflow-hidden animate-in fade-in slide-in-from-bottom-4 duration-500">
      <CardHeader className="bg-secondary/1 border-b border-border pb-6 flex flex-row items-center justify-between">
        <div>
          <CardTitle className="text-xl text-secondary">{title}</CardTitle>
          <CardDescription>
            Showing {Math.min(rows.length, 50)} of {totalRows} rows
          </CardDescription>
        </div>
        <Button 
          variant="ghost" 
          size="sm"
          onClick={onClose}
          className="text-muted-foreground hover:text-destructive"
        >
          <X className="h-4 w-4" />
        </Button>
      </CardHeader>
      
      <CardContent className="pt-6">
        <div className="h-[400px] w-full rounded-lg border overflow-auto">
          <div className="inline-block min-w-full">
          <Table>
            <TableHeader className="bg-secondary/10 sticky top-0 z-10">
              <TableRow>
                {headers.map((header: any, index: number) => (
                  <TableHead key={index} className="font-semibold text-dark whitespace-nowrap">
                    {header || `Column ${index + 1}`}
                  </TableHead>
                ))}
              </TableRow>
            </TableHeader>
            <TableBody>
              {rows.map((row: any[], rowIndex: number) => (
                <TableRow key={rowIndex} className="hover:bg-secondary/5">
                  {headers.map((_: any, colIndex: number) => (
                    <TableCell key={colIndex} className="whitespace-nowrap">
                      {row[colIndex] !== undefined && row[colIndex] !== null 
                        ? String(row[colIndex]) 
                        : ''}
                    </TableCell>
                  ))}
                </TableRow>
              ))}
            </TableBody>
          </Table>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}