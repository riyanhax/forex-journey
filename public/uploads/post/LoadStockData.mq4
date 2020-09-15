//+------------------------------------------------------------------+
//|                                                LoadStockData.mq4 |
//|           mod by nlenz 2013: start date,symbol,detects curr date |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2011, zznbrm"
#property show_inputs

#import "user32.dll"
   int PostMessageA(int hWnd,int Msg,int wParam,int lParam);
   int RegisterWindowMessageA(string lpString);
#import
#import "wininet.dll"
int InternetOpenW(string sAgent, int lAccessType=0, string sProxyName="", string sProxyBypass="", uint lFlags=0);
int InternetOpenUrlW(int hInternetSession, string sUrl, string sHeaders="", int lHeadersLength=0, uint lFlags=0, int lContext=0);
int InternetReadFile(int hFile, uchar& sBuffer[], int lNumBytesToRead, int& lNumberOfBytesRead[]);
int InternetCloseHandle(int hInet);
#import

#define WM_COMMAND      0x0111
#define cDATA_TIME      0
#define cDATA_OPEN      1
#define cDATA_LOW       2
#define cDATA_HIGH      3
#define cDATA_CLOSE     4
#define cDATA_VOL       5
#define cHISTORY_HEADER_SIZE 148 
#define cHISTORY_RECORD_SIZE 44  

extern string s0 = "if index e.g. VIX -> %5EVIX";
extern string stockSymbol = "APA";
extern string s1 = "Will create the following:D1 W1";
extern int fromMonthOfYear = 1;
extern int fromDayOfMonth = 19;
extern int fromYear = 2004;
int gintHandleD1 = -1;
int gintHandleW1 = -1;
int gintHandleMN = -1;
string gastrRow[10000];
int gintCount = 0; 
string gstrURL = "";
string gstrURLD1 = "";
string gstrURLW1 = "";
string gstrURLMN = "";
//+------------------------------------------------------------------+
//| start                                                            |
//+------------------------------------------------------------------+
int start()
{     
   int inx, intEndOfRowD1 = -1, intEndOfRowW1 = -1, intEndOfRowMN = -1;
   string strWebPageD1 = "", strWebPageW1 = "", strWebPageMN = "";
   
   gstrURL =  StringConcatenate("&d=",DoubleToStr(Month()-1,0),"&e=",DoubleToStr(Day(),0),"&f=",DoubleToStr(Year(),0),"&g=");
   gstrURLD1 = StringConcatenate(gstrURL,"d");
   gstrURLW1 = StringConcatenate(gstrURL,"w");
   gstrURLMN = StringConcatenate(gstrURL,"m");
   
   gstrURL =  StringConcatenate("&a=",DoubleToStr(fromMonthOfYear-1,0),"&b=",DoubleToStr(fromDayOfMonth,0),"&c=",DoubleToStr(fromYear,0),"&ignore=.csv");//"&a=7&b=19&c=2004&ignore=.csv";
   gstrURLD1 = StringConcatenate(gstrURLD1,gstrURL);
   gstrURLW1 = StringConcatenate(gstrURLW1,gstrURL);
   gstrURLMN = StringConcatenate(gstrURLMN,gstrURL);
   
   gstrURLD1 = StringConcatenate("http://ichart.finance.yahoo.com/table.csv?s=",stockSymbol,gstrURLD1);
   gstrURLW1 = StringConcatenate("http://ichart.finance.yahoo.com/table.csv?s=",stockSymbol,gstrURLW1);
   gstrURLMN = StringConcatenate("http://ichart.finance.yahoo.com/table.csv?s=",stockSymbol,gstrURLMN);

   // Get the data from the website
   if ( !GrabWeb( gstrURLD1, strWebPageD1 ) )
   {
      Print( "Error getting data D1!!!!" );
      return( -1 );
   }
   
   if ( !GrabWeb( gstrURLW1, strWebPageW1 ) )
   {
      Print( "Error getting data W1!!!!" );
      return( -1 );
   }
   
   if ( !GrabWeb( gstrURLMN, strWebPageMN ) )
   {
      Print( "Error getting data MN!!!!" );
      return( -1 );
   }
   
   if ( strWebPageD1 == "" )   
   {
      Print( "No data daily!!!!" );
      return( -1 );
   }
   
   if ( strWebPageW1 == "" )   
   {
      Print( "No data weekly!!!!" );
      return( -1 );
   }
   
   if ( strWebPageMN == "" )   
   {
      Print( "No data monthly!!!!" );
      return( -1 );
   }
   
   Print( "Bytes received = ", StringLen( strWebPageD1 ) );
   
   Print( "Bytes received = ", StringLen( strWebPageW1 ) );
   
   Print( "Bytes received = ", StringLen( strWebPageMN ) );
        
   // Read the header row and discard
   intEndOfRowD1 = StringFind( strWebPageD1, "\n", 0 );
   
   // Read all rows and save into an array for processing   
   while ( !IsStopped() )
   {   
      inx = StringFind( strWebPageD1, "\n", intEndOfRowD1 + 1 );
   
      if ( inx == -1 )    break;
            
      gastrRow[gintCount] = StringSubstr( strWebPageD1, intEndOfRowD1, inx - intEndOfRowD1 + 1 );
      gintCount++;
      intEndOfRowD1 = inx;
   }
   
   Print( "Rows D1 = ", gintCount );
   
   gintHandleD1 = hsGetHistFileHandle( stockSymbol, PERIOD_D1, false );
   
   if ( gintHandleD1 < 0 )   return( -1 );
   
   if( hsWriteHdrRecord( stockSymbol, gintHandleD1, PERIOD_D1, 2 ) )
   {
      processData(gintHandleD1);   
      hsUpdateChartWindow( stockSymbol, PERIOD_D1 );
   }
   
   FileClose( gintHandleD1 ); 
   
   // repeat same for weekly data
   
   gintCount = 0;
   
   //ArrayInitialize(gastrRow,"");
   
   intEndOfRowW1 = StringFind( strWebPageW1, "\n", 0 );
   
   // Read all rows and save into an array for processing   
   while ( !IsStopped() )
   {   
      inx = StringFind( strWebPageW1, "\n", intEndOfRowW1 + 1 );
   
      if ( inx == -1 )    break;
            
      gastrRow[gintCount] = StringSubstr( strWebPageW1, intEndOfRowW1, inx - intEndOfRowW1 + 1 );
      gintCount++;
      intEndOfRowW1 = inx;
   }
   
   Print( "Rows W1= ", gintCount );
   
   // Open history file
      gintHandleW1 = hsGetHistFileHandle( stockSymbol, PERIOD_W1, false );
      
   
   if ( gintHandleW1 < 0 )   return( -1 );
   
   
   if( hsWriteHdrRecord( stockSymbol, gintHandleW1, PERIOD_W1, 2 ) )
   {
      processData(gintHandleW1);   
      hsUpdateChartWindow( stockSymbol, PERIOD_W1 );
   }
 
   FileClose( gintHandleW1 );  
   
   // repeat same for monthly data
   
   gintCount = 0;
   
   //ArrayInitialize(gastrRow,"");
   
   intEndOfRowMN = StringFind( strWebPageMN, "\n", 0 );
   
   // Read all rows and save into an array for processing   
   while ( !IsStopped() )
   {   
      inx = StringFind( strWebPageMN, "\n", intEndOfRowMN + 1 );
   
      if ( inx == -1 )    break;
            
      gastrRow[gintCount] = StringSubstr( strWebPageMN, intEndOfRowMN, inx - intEndOfRowMN + 1 );
      gintCount++;
      intEndOfRowMN = inx;
   }
   
   Print( "Rows MN= ", gintCount );
   
   // Open history file
      gintHandleMN = hsGetHistFileHandle( stockSymbol, PERIOD_MN1, false );
      
   
   if ( gintHandleMN < 0 )   return( -1 );
   
   
   if( hsWriteHdrRecord( stockSymbol, gintHandleMN, PERIOD_MN1, 2 ) )
   {
      processData(gintHandleMN);   
      hsUpdateChartWindow( stockSymbol, PERIOD_MN1 );
   }
   
   FileClose( gintHandleMN );  
   
   return( 0 );
}

//+------------------------------------------------------------------+
//| processData                                                      |
//+------------------------------------------------------------------+
void processData(int gintHandle)
{
   int intStart = 0;
   int intEnd = 0;
   string dt;
   double adblData[6];
   
   for ( int inx = gintCount-1; inx >= 0; inx-- )
   {
      // Get the date
      intStart = 1;
      intEnd = StringFind( gastrRow[inx], "-", intStart );
      dt=StringSubstr( gastrRow[inx], intStart, intEnd - intStart );
      intStart=intEnd+1;
      intEnd=intStart+2;
      dt=dt+"."+StringSubstr( gastrRow[inx], intStart, intEnd - intStart );
      intStart=intEnd+1;
      intEnd=intStart+2;
      dt=dt+"."+StringSubstr( gastrRow[inx], intStart, intEnd - intStart );
      adblData[cDATA_TIME] = StrToTime(dt);// StringSubstr( gastrRow[inx], intStart, intEnd - intStart ) );
      
      // Get the Open 
      intStart = intEnd + 1;
      intEnd = StringFind( gastrRow[inx], ",", intStart );
      adblData[cDATA_OPEN] = StrToDouble( StringSubstr( gastrRow[inx], intStart, intEnd - intStart ) );
      
      // Get the High 
      intStart = intEnd + 1;
      intEnd = StringFind( gastrRow[inx], ",", intStart );
      adblData[cDATA_HIGH] = StrToDouble( StringSubstr( gastrRow[inx], intStart, intEnd - intStart ) );
      
      // Get the Low 
      intStart = intEnd + 1;
      intEnd = StringFind( gastrRow[inx], ",", intStart );
      adblData[cDATA_LOW] = StrToDouble( StringSubstr( gastrRow[inx], intStart, intEnd - intStart ) );
      
      // Get the Close 
      intStart = intEnd + 1;
      intEnd = StringFind( gastrRow[inx], ",", intStart );
      adblData[cDATA_CLOSE] = StrToDouble( StringSubstr( gastrRow[inx], intStart, intEnd - intStart ) );
      
      // Get the Volume 
      intStart = intEnd + 1;
      intEnd = StringFind( gastrRow[inx], ",", intStart );
      adblData[cDATA_VOL] = StrToDouble( StringSubstr( gastrRow[inx], intStart, intEnd - intStart ) );
      
      if ( !hsWriteHistRecord( adblData, gintHandle, 0 ) )   break;
   }
}

//+------------------------------------------------------------------+
//| hsGetHistFileHandle                                              |
//+------------------------------------------------------------------+
int hsGetHistFileHandle( string strSymbol, int intTF, bool blnAppend )
{
   string strFileName = strSymbol + intTF + ".hst";
   int intHandle, intDelimiter;
   
   if ( blnAppend )   intDelimiter = FILE_BIN | FILE_READ | FILE_WRITE;
   else               intDelimiter = FILE_BIN | FILE_WRITE;
   
   intHandle = FileOpenHistory( strFileName, intDelimiter );
   
   if ( intHandle < 0 )   
      Print( "Error opening file: " + strFileName );
   
   return( intHandle );
}

//+------------------------------------------------------------------+
//| hsWriteHdrRecord()                                               |
//+------------------------------------------------------------------+
bool hsWriteHdrRecord( string strSymbol, int intHnd, int intTF, int intDigits = 5 )
{
   int    intBytes = 0;
   int    i_unused[13];
   string c_copyright="(C)opyright 2010, MetaQuotes Software Corp.";
   
   intBytes += FileWriteInteger( intHnd, 400, LONG_VALUE );
   intBytes += FileWriteString( intHnd, c_copyright, 64 );
   intBytes += FileWriteString( intHnd, strSymbol, 12 );
   intBytes += FileWriteInteger( intHnd, intTF, LONG_VALUE );
   intBytes += FileWriteInteger( intHnd, intDigits, LONG_VALUE );
   intBytes += FileWriteInteger( intHnd, 50, LONG_VALUE );      
   intBytes += FileWriteInteger( intHnd, 0, LONG_VALUE );       
   intBytes += FileWriteArray( intHnd, i_unused, 0, 13 );
   
   return( true ); 
}

//+------------------------------------------------------------------+
//| hsWriteHistRecord                                                |
//+------------------------------------------------------------------+
bool hsWriteHistRecord( double& adblD[], int intHnd, int intBack )
{
   int intBytes = 0;
   int intPos = intBack * cHISTORY_RECORD_SIZE * (-1);
   
   if ( !FileSeek( intHnd, intPos, SEEK_END ) )
   {
      Print( "writeHistRecord() - File Seek Failed: " + GetLastError() );
      return( false );
   }
   
   if ( FileTell( intHnd ) < cHISTORY_HEADER_SIZE )
   {
      Print( "writeHistRecord() - File Pointer invalid: " + FileTell( intHnd ) );
      return( false );
   }
   
   intBytes += FileWriteInteger( intHnd, adblD[cDATA_TIME], LONG_VALUE );
   intBytes += FileWriteDouble( intHnd, adblD[cDATA_OPEN], DOUBLE_VALUE );
   intBytes += FileWriteDouble( intHnd, adblD[cDATA_LOW], DOUBLE_VALUE );
   intBytes += FileWriteDouble( intHnd, adblD[cDATA_HIGH], DOUBLE_VALUE );
   intBytes += FileWriteDouble( intHnd, adblD[cDATA_CLOSE], DOUBLE_VALUE );
   intBytes += FileWriteDouble( intHnd, adblD[cDATA_VOL], DOUBLE_VALUE );
   
   FileFlush( intHnd );
   
   if ( intBytes != cHISTORY_RECORD_SIZE )   
   {
      Print( "writeHistRecord() - Error writing to Hist File: " + GetLastError() );
      return( false );
   }
   
   return( true );
}

//+------------------------------------------------------------------+
//| hsUpdateChartWindow                                              |
//+------------------------------------------------------------------+
bool hsUpdateChartWindow( string strSymbol, int intTF ) 
{
   bool blnResult = false;   
   int intWindow = WindowHandle( strSymbol, intTF );
   static int intMT4MsgID = 0;
		
   if( intWindow > 0 ) 
   {
      // Send update (refresh) command to offline chart
      if ( PostMessageA( intWindow, WM_COMMAND, 33324, 0 ) == 0 )
         Print( strSymbol + "-" + intTF + " Chart window update failed!!!!" );
      else
         blnResult = true;
            
      // Send simulated tick to offline chart
      if ( intMT4MsgID == 0 )
         intMT4MsgID = RegisterWindowMessageA("MetaTrader4_Internal_Message");         
         
      if ( PostMessageA( intWindow, intMT4MsgID, 2, 1 ) == 0 )
      {
         Print( strSymbol + "-" + intTF + " Chart window sim tick failed!!!!" );
         intMT4MsgID = 0;
      }
   }
   
   return( blnResult );
}

//=================================================================================================
//=================================================================================================
//====================================   GrabWeb Functions   ======================================
//=================================================================================================
//=================================================================================================
// Main Webscraping function
// ~~~~~~~~~~~~~~~~~~~~~~~~~
// bool GrabWeb(string strUrl, string& strWebPage)
// returns the text of any webpage. Returns false on timeout or other error
// 
// Parsing functions
// ~~~~~~~~~~~~~~~~~
// string GetData(string strWebPage, int nStart, string strLeftTag, string strRightTag, int& nPos)
// obtains the text between two tags found after nStart, and sets nPos to the end of the second tag
//
// void Goto(string strWebPage, int nStart, string strTag, int& nPos)
// Sets nPos to the end of the first tag found after nStart 

bool bWinInetDebug = false;

int hSession_IEType;
int hSession_Direct;
int Internet_Open_Type_Preconfig = 0;
int Internet_Open_Type_Direct = 1;
int Internet_Open_Type_Proxy = 3;
int Buffer_LEN = 80;


#define INTERNET_FLAG_PRAGMA_NOCACHE    0x00000100 // Forces the request to be resolved by the origin server, even if a cached copy exists on the proxy.
#define INTERNET_FLAG_NO_CACHE_WRITE    0x04000000 // Does not add the returned entity to the cache. 
#define INTERNET_FLAG_RELOAD            0x80000000 // Forces a download of the requested file, object, or directory listing from the origin server, not from the cache.



int hSession(bool Direct)
{
	string InternetAgent;
	if (hSession_IEType == 0)
	{
		InternetAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Q312461)";
		hSession_IEType = InternetOpenW(InternetAgent, Internet_Open_Type_Preconfig, "0", "0", 0);
		hSession_Direct = InternetOpenW(InternetAgent, Internet_Open_Type_Direct, "0", "0", 0);
	}
	if (Direct) 
	{ 
		return(hSession_Direct); 
	}
	else 
	{
		return(hSession_IEType); 
	}
}


bool GrabWeb(string strUrl, string& strWebPage)
{
	int 	hInternet;
	int		iResult;
	int 	lReturn[]	= {1};
	uchar 	sBuffer[256];//		= "                                                                                                                                                                                                                                                               ";	// 255 spaces
	int 	bytes;
	
	uint flags=INTERNET_FLAG_NO_CACHE_WRITE | INTERNET_FLAG_PRAGMA_NOCACHE | INTERNET_FLAG_RELOAD;
	hInternet = InternetOpenUrlW(hSession(FALSE), strUrl, NULL, 0, 
								flags);
								
	if (bWinInetDebug) 
		Log("hInternet: " + hInternet);   
	if (hInternet == 0) 
		return(false);

	Print("Reading URL: " + strUrl);	   //added by MN	
	iResult = InternetReadFile(hInternet, sBuffer, Buffer_LEN, lReturn);
	
	if (bWinInetDebug) 
		Log("iResult: " + iResult);
	if (bWinInetDebug) 
		Log("lReturn: " + lReturn[0]);
	if (bWinInetDebug) 
		Log("iResult: " + iResult);
	//if (bWinInetDebug) 
		///Log("sBuffer: " +  sBuffer);
	if (iResult == 0) 
		return(false);
	bytes = lReturn[0];

	strWebPage = CharArrayToString(sBuffer, 0, lReturn[0]);//, CP_ACP);//StringSubstr(sBuffer, 0, lReturn[0]);
	
	// If there's more data then keep reading it into the buffer
	while (lReturn[0] != 0)
	{
		iResult = InternetReadFile(hInternet, sBuffer, Buffer_LEN, lReturn);
		if (lReturn[0]==0) 
			break;
		bytes = bytes + lReturn[0];
		strWebPage = strWebPage + CharArrayToString(sBuffer, 0, lReturn[0]);//, CP_ACP);
	}

	Print("Closing URL web connection");   //added by MN
	iResult = InternetCloseHandle(hInternet);
	if (iResult == 0) 
		return(false);
		
	return(true);
}

//=================================================================================================
//=================================================================================================
//===================================   LogUtils Functions   ======================================
//=================================================================================================
//=================================================================================================
void Log(string msg)
{
	return;
}





