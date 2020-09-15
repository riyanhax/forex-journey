//------------------------------------------------------------------
#property copyright "www.forex-station.com"
#property link      "www.forex-station.com"
//------------------------------------------------------------------
#property indicator_chart_window
#property strict

extern int MaxSpread = 20;  // Maximal spread (points)

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int OnInit()
{
   if (!IsDllsAllowed())
   {
      Alert("Please enable dll imports in the indicators properties");
      Alert("This indicator needs to have dll import option allowed in order to work");
      return(INIT_FAILED);
   }      
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int Des) { }
int OnCalculate(const int rates_total,const int prev_calculated, const datetime &time[], const double &open[], const double &high[], const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[]  )
{
   int ispread = (int)((Ask-Bid)/_Point);
      if (ispread> MaxSpread) enableAutoTrading(false);
      if (ispread<=MaxSpread) enableAutoTrading(true);
   return(0);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

#import "user32.dll"
   int GetAncestor(int hWnd, int gaFlags);
   int PostMessageW(int hWnd,int Msg,int wParam,int lParam);
#import
#define WM_COMMAND 0x0111

//
//
//
//
//

void enableAutoTrading(bool enable)
{
   if (!enable &&   IsExpertEnabled())  { int hwnd = GetAncestor(WindowHandle(Symbol(),Period()),2); PostMessageW(hwnd,WM_COMMAND,33020,1); }
   if ( enable &&  !IsExpertEnabled())  { int hwnd = GetAncestor(WindowHandle(Symbol(),Period()),2); PostMessageW(hwnd,WM_COMMAND,33020,1); }
   if (IsExpertEnabled())
         Comment("experts enabled");
   else  Comment("experts disabled");
}