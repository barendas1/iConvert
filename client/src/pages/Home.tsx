import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { cn } from "@/lib/utils";
import { AlertCircle, CheckCircle2, Download, FileSpreadsheet, Loader2, Upload, UploadCloud } from "lucide-react";
import { useCallback, useState } from "react";
import { useDropzone } from "react-dropzone";
import * as XLSX from "xlsx";
import { saveAs } from "file-saver";
import { convertCommandSeries } from "../converters/mixes/CommandSeries";

// Dispatch system options
const DISPATCH_OPTIONS = [
  "BCMI", 
  "Command Cloud", 
  "Command Series", 
  "Integra", 
  "Jonel", 
  "MPAQ", 
  "Simma", 
  "SysDyne", 
  "WMC"
];

export default function Home() {
  const [activeTab, setActiveTab] = useState("mixes");
  const [selectedDispatch, setSelectedDispatch] = useState<string>("");
  const [file, setFile] = useState<File | null>(null);
  const [isProcessing, setIsProcessing] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);
  const [convertedData, setConvertedData] = useState<any>(null);

  // File drop handler
  const onDrop = useCallback((acceptedFiles: File[]) => {
    setError(null);
    setSuccess(false);
    setConvertedData(null);
    
    if (acceptedFiles.length > 0) {
      const uploadedFile = acceptedFiles[0];
      // Check if it's an Excel file
      if (uploadedFile.name.endsWith('.xlsx') || uploadedFile.name.endsWith('.xls')) {
        setFile(uploadedFile);
      } else {
        setError("Please upload a valid Excel file (.xlsx or .xls)");
      }
    }
  }, []);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({ 
    onDrop,
    accept: {
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': ['.xlsx'],
      'application/vnd.ms-excel': ['.xls']
    },
    maxFiles: 1
  });

  // Conversion logic
  const handleConvert = async () => {
    if (!file || !selectedDispatch) return;
    
    setIsProcessing(true);
    setError(null);

    try {
      // Read the uploaded file
      const reader = new FileReader();
      reader.onload = async (e) => {
        try {
          const data = new Uint8Array(e.target?.result as ArrayBuffer);
          const workbook = XLSX.read(data, { type: 'array' });
          
          // Get the first sheet
          const sheetName = workbook.SheetNames[0];
          const worksheet = workbook.Sheets[sheetName];
          
          // Convert to JSON for processing
          // header: 1 returns array of arrays, which is safer for column indexing
          const jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1 });
          
          console.log("Source data loaded:", jsonData.length, "rows");
          
          let processedData: any[][] = [];

          // Select the appropriate converter
          if (activeTab === "mixes") {
            if (selectedDispatch === "Command Series") {
              processedData = convertCommandSeries(jsonData);
            } else {
              throw new Error(`Converter for ${selectedDispatch} is not yet implemented.`);
            }
          } else {
             throw new Error("Material imports are not yet supported.");
          }
          
          // Create a new workbook with the processed data
          const newWb = XLSX.utils.book_new();
          const newWs = XLSX.utils.aoa_to_sheet(processedData);
          XLSX.utils.book_append_sheet(newWb, newWs, "Mix Import");
          
          setConvertedData(newWb);
          setSuccess(true);
        } catch (err: any) {
          console.error("Conversion error:", err);
          setError(err.message || "Error processing file. Please check the file format.");
        } finally {
          setIsProcessing(false);
        }
      };
      reader.readAsArrayBuffer(file);
    } catch (err) {
      console.error(err);
      setError("An unexpected error occurred.");
      setIsProcessing(false);
    }
  };

  const handleDownload = () => {
    if (!convertedData) return;
    
    // Generate Excel file
    const wbout = XLSX.write(convertedData, { bookType: 'xlsx', type: 'array' });
    const blob = new Blob([wbout], { type: 'application/octet-stream' });
    saveAs(blob, 'MixImport-US_Converted.xlsx');
  };

  return (
    <div className="min-h-screen bg-background pb-20">
      {/* Header */}
      <header className="bg-white border-b border-border sticky top-0 z-10">
        <div className="container py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center text-white font-bold text-xl shadow-sm">
              iC
            </div>
            <h1 className="text-2xl font-bold text-dark tracking-tight">iConvert</h1>
          </div>
          <div className="text-sm text-muted-foreground font-medium">
            Data Migration Tool
          </div>
        </div>
      </header>

      <main className="container mt-8">
        <div className="max-w-4xl mx-auto">
          <div className="mb-8 text-center">
            <h2 className="text-3xl font-bold text-dark mb-2">Import & Convert Data</h2>
            <p className="text-muted-foreground">
              Upload your customer mix designs and convert them to the standard import format.
            </p>
          </div>

          <Tabs defaultValue="mixes" value={activeTab} onValueChange={setActiveTab} className="w-full">
            <TabsList className="grid w-full grid-cols-2 mb-8 p-1 bg-secondary/5 border border-border rounded-xl h-14">
              <TabsTrigger 
                value="mixes" 
                className="rounded-lg text-base font-medium data-[state=active]:bg-white data-[state=active]:text-primary data-[state=active]:shadow-sm h-12 transition-all"
              >
                Mix Imports
              </TabsTrigger>
              <TabsTrigger 
                value="materials" 
                disabled
                className="rounded-lg text-base font-medium h-12 opacity-50 cursor-not-allowed"
              >
                Material Imports (Coming Soon)
              </TabsTrigger>
            </TabsList>

            <TabsContent value="mixes" className="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
              <Card className="border-border shadow-sm overflow-hidden">
                <CardHeader className="bg-secondary/5 border-b border-border pb-6">
                  <CardTitle className="text-xl text-secondary">Configuration</CardTitle>
                  <CardDescription>Select the source dispatch system for your data.</CardDescription>
                </CardHeader>
                <CardContent className="pt-6">
                  <div className="space-y-2">
                    <label className="text-sm font-medium text-dark">Dispatch System</label>
                    <Select value={selectedDispatch} onValueChange={setSelectedDispatch}>
                      <SelectTrigger className="w-full h-12 text-base bg-white border-border focus:ring-primary/20">
                        <SelectValue placeholder="Select Dispatch System" />
                      </SelectTrigger>
                      <SelectContent>
                        {DISPATCH_OPTIONS.map((option) => (
                          <SelectItem 
                            key={option} 
                            value={option}
                            disabled={option !== "Command Series"}
                            className="cursor-pointer py-3"
                          >
                            <span className={cn(option !== "Command Series" && "opacity-50")}>
                              {option} {option !== "Command Series" && "(Coming Soon)"}
                            </span>
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                </CardContent>
              </Card>

              <Card className="border-border shadow-sm overflow-hidden">
                <CardHeader className="bg-secondary/5 border-b border-border pb-6 flex flex-row items-center justify-between">
                  <div>
                    <CardTitle className="text-xl text-secondary">File Upload</CardTitle>
                    <CardDescription>Upload the Excel file containing mix designs.</CardDescription>
                  </div>
                  
                  <div className="flex gap-2">
                    <input
                      type="file"
                      id="file-upload"
                      className="hidden"
                      accept=".xlsx,.xls"
                      onChange={(e) => {
                        if (e.target.files && e.target.files.length > 0) {
                          onDrop([e.target.files[0]]);
                        }
                      }}
                    />
                    <Button 
                      variant="outline" 
                      className="border-primary text-primary hover:bg-primary/5 hover:text-primary-hover"
                      onClick={() => document.getElementById('file-upload')?.click()}
                    >
                      <Upload className="mr-2 h-4 w-4" />
                      Select File
                    </Button>
                  </div>
                </CardHeader>
                
                <CardContent className="pt-6 space-y-6">
                  <div 
                    {...getRootProps()} 
                    className={cn(
                      "border-2 border-dashed rounded-xl p-10 text-center cursor-pointer transition-all duration-200 flex flex-col items-center justify-center gap-4 min-h-[200px]",
                      isDragActive ? "border-primary bg-primary/5 scale-[0.99]" : "border-border hover:border-primary/50 hover:bg-secondary/5",
                      file ? "bg-secondary/5 border-secondary/30" : ""
                    )}
                  >
                    <input {...getInputProps()} />
                    
                    {file ? (
                      <>
                        <div className="w-16 h-16 rounded-full bg-success/10 flex items-center justify-center text-success mb-2">
                          <FileSpreadsheet className="h-8 w-8" />
                        </div>
                        <div>
                          <p className="text-lg font-semibold text-dark">{file.name}</p>
                          <p className="text-sm text-muted-foreground">{(file.size / 1024).toFixed(2)} KB</p>
                        </div>
                        <Button 
                          variant="ghost" 
                          size="sm" 
                          className="text-destructive hover:text-destructive hover:bg-destructive/10 mt-2"
                          onClick={(e) => {
                            e.stopPropagation();
                            setFile(null);
                            setSuccess(false);
                            setConvertedData(null);
                          }}
                        >
                          Remove File
                        </Button>
                      </>
                    ) : (
                      <>
                        <div className="w-16 h-16 rounded-full bg-secondary/10 flex items-center justify-center text-secondary mb-2">
                          <UploadCloud className="h-8 w-8" />
                        </div>
                        <div>
                          <p className="text-lg font-medium text-dark">Drag & drop your file here</p>
                          <p className="text-sm text-muted-foreground mt-1">or click to browse from your computer</p>
                        </div>
                        <p className="text-xs text-muted-foreground/70 mt-4">Supported formats: .xlsx, .xls</p>
                      </>
                    )}
                  </div>

                  {error && (
                    <div className="bg-destructive/10 border border-destructive/20 rounded-lg p-4 flex items-start gap-3 text-destructive animate-in fade-in slide-in-from-top-2">
                      <AlertCircle className="h-5 w-5 mt-0.5 shrink-0" />
                      <div>
                        <p className="font-medium">Error</p>
                        <p className="text-sm opacity-90">{error}</p>
                      </div>
                    </div>
                  )}

                  {success && (
                    <div className="bg-success/10 border border-success/20 rounded-lg p-4 flex items-start gap-3 text-success animate-in fade-in slide-in-from-top-2">
                      <CheckCircle2 className="h-5 w-5 mt-0.5 shrink-0" />
                      <div>
                        <p className="font-medium">Conversion Successful!</p>
                        <p className="text-sm opacity-90">Your file has been processed and is ready for download.</p>
                      </div>
                    </div>
                  )}

                  <div className="flex items-center justify-end gap-4 pt-2">
                    {success ? (
                      <Button 
                        size="lg" 
                        className="bg-success hover:bg-success2 text-white shadow-md hover:shadow-lg transition-all w-full sm:w-auto"
                        onClick={handleDownload}
                      >
                        <Download className="mr-2 h-5 w-5" />
                        Download Converted File
                      </Button>
                    ) : (
                      <Button 
                        size="lg" 
                        className={cn(
                          "bg-primary hover:bg-primary-hover text-white shadow-md hover:shadow-lg transition-all w-full sm:w-auto",
                          (!file || !selectedDispatch) && "opacity-50 cursor-not-allowed"
                        )}
                        disabled={!file || !selectedDispatch || isProcessing}
                        onClick={handleConvert}
                      >
                        {isProcessing ? (
                          <>
                            <Loader2 className="mr-2 h-5 w-5 animate-spin" />
                            Processing...
                          </>
                        ) : (
                          <>
                            Convert Data
                          </>
                        )}
                      </Button>
                    )}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
            
            <TabsContent value="materials">
              <div className="flex flex-col items-center justify-center py-20 text-center opacity-50">
                <div className="w-20 h-20 bg-muted rounded-full flex items-center justify-center mb-6">
                  <FileSpreadsheet className="h-10 w-10 text-muted-foreground" />
                </div>
                <h3 className="text-2xl font-bold text-dark">Coming Soon</h3>
                <p className="text-muted-foreground mt-2 max-w-md">
                  Material import functionality is currently under development. Please check back later.
                </p>
              </div>
            </TabsContent>
          </Tabs>
        </div>
      </main>
    </div>
  );
}