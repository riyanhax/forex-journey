//+------------------------------------------------------------------+
//|                                                       Master.mq4 |
//+------------------------------------------------------------------+

#import "kernel32.dll"
#define GENERIC_READ    0x80000000
#define GENERIC_WRITE   0x40000000
#define FILE_SHARE_READ                 0x00000001
#define FILE_SHARE_WRITE                0x00000002
#define FILE_SHARE_DELETE               0x00000004
#define CREATE_NEW      1
#define CREATE_ALWAYS   2
#define OPEN_EXISTING   3
#define OPEN_ALWAYS     4
#define INVALID_HANDLE -1

extern string Location = "C:/Slave/Experts/Files/";  

string FinalName;
string FileName;
   
int CreateFileA(
      string   FileName,
      int      DesiredAccess,
      int      dwShareMode,
      int      lpSecurityAttributes,
      int      dwCreationDistribution,
      int      dwFlagsAndAttributes,
      int      hTemplateFile
);   
                    
bool WriteFile(
      int      hFile,
      string   Buffer,
      int      nNumberOfBytesToWrite,
      int     lpNumberOfBytesWritten[],
      int      lpOverlapped
);         
   
bool CloseHandle(
      int   hObject
);

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   FileName = StringConcatenate(StringSubstr(Symbol(),0,6),".CSV");
   FinalName = StringConcatenate(Location,FileName);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   WriteNewData(0.000);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   RefreshRates();
   WriteNewData((Bid+(Ask-Bid)/2));
//----
   return(0);
  }
//+------------------------------------------------------------------+

void WriteNewData(string NewMessage){
   int hFile = CreateFileA(FinalName,GENERIC_WRITE,FILE_SHARE_READ,0,OPEN_ALWAYS,0,0);           
   int FileLength = StringLen(NewMessage); 
   int BytesWritten[]={0};    
   WriteFile(hFile,NewMessage,FileLength,BytesWritten,0); 
   CloseHandle(hFile);
}