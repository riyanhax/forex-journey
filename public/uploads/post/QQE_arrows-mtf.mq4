//------------------------------------------------------------------
#property copyright "mladen"
#property link      "www.forex-tsd.com"
//------------------------------------------------------------------
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1  LimeGreen
#property indicator_color2  Red
#property indicator_color3  Aqua
#property indicator_color4  Magenta

extern string TimeFrame           = "Current time frame";   
extern int    SF                  = 2;
extern int    RSIPeriod           = 14;
extern double WP                  = 5.6;
extern bool   Show_Signal_Cross   = true;
extern bool   Show_Fifty_Cross    = false;
extern bool   alertsOn            = true;
extern bool   alertsOnCurrent     = true;
extern bool   alertsOnSignalCross = true;
extern bool   alertsOnLevelCross  = false;
extern bool   alertsMessage       = true;
extern bool   alertsSound         = true;
extern bool   alertsNotify        = false;
extern bool   alertsEmail         = false;
extern int    AlertLevel          = 50;
extern int    arrowSize           = 2;
extern bool   ArrowOnFirstBar     = false;

double Trend[];
double RsiMa[];
double CrossUp[];
double CrossDn[];
double FiftyUp[];
double FiftyDn[];
double trend1[];
double trend2[];

string indicatorFileName;
bool   returnBars;
int    timeFrame;

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int init()
{
   IndicatorBuffers(8);
   SetIndexBuffer(0,CrossUp);  SetIndexStyle(0,DRAW_ARROW,0,arrowSize); SetIndexArrow(0,225);
   SetIndexBuffer(1,CrossDn);  SetIndexStyle(1,DRAW_ARROW,0,arrowSize); SetIndexArrow(1,226);
   SetIndexBuffer(2,FiftyUp);  SetIndexStyle(2,DRAW_ARROW,0,arrowSize); SetIndexArrow(2,225);
   SetIndexBuffer(3,FiftyDn);  SetIndexStyle(3,DRAW_ARROW,0,arrowSize); SetIndexArrow(3,226);
   SetIndexBuffer(4,RsiMa);    SetIndexLabel(4,"QQE");
   SetIndexBuffer(5,Trend);    SetIndexLabel(5,"QQE trend");
   SetIndexBuffer(6,trend1);
   SetIndexBuffer(7,trend2);
   if (Show_Signal_Cross)
   {
      SetIndexStyle(0,DRAW_ARROW,0,1); SetIndexArrow(0,225);
      SetIndexStyle(1,DRAW_ARROW,0,1); SetIndexArrow(1,226);
   }
   else
   {
      SetIndexStyle(0,DRAW_NONE);
      SetIndexStyle(1,DRAW_NONE);
   }
   if (Show_Fifty_Cross)
   {
      SetIndexStyle(2,DRAW_ARROW,0,1); SetIndexArrow(2,225);
      SetIndexStyle(3,DRAW_ARROW,0,1); SetIndexArrow(3,226);
   }
   else
   {
      SetIndexStyle(2,DRAW_NONE);
      SetIndexStyle(3,DRAW_NONE);
   }
   indicatorFileName = WindowExpertName();
   returnBars        = TimeFrame == "returnBars";     if (returnBars)     return(0);
   timeFrame         = stringToTimeFrame(TimeFrame);              
   IndicatorShortName(timeFrameToString(timeFrame)+" QQE ("+SF+","+WP+","+TimeFrame+")");
return(0);
}

//
//
//
//
//

double emas[][3];
#define iEma 0
#define iEmm 1
#define iQqe 2

int start()
{
   int r,counted_bars=IndicatorCounted();
      if(counted_bars<0) return(-1);
      if(counted_bars>0) counted_bars--;
           int limit=MathMin(Bars-counted_bars,Bars-1);
           if (returnBars) { CrossUp[0] = limit+1; return(0); }
   
            if (timeFrame!=Period())
            {
               int shift = -1; if (ArrowOnFirstBar) shift=1;
               limit = MathMax(limit,MathMin(Bars-1,iCustom(NULL,timeFrame,indicatorFileName,"returnBars",0,0)*timeFrame/Period()));
               for (int i=limit; i>=0; i--)
               {
                  int y = iBarShift(NULL,timeFrame,Time[i]);   
                  int x = iBarShift(NULL,timeFrame,Time[i+shift]);            
                  if (x!=y)
                  {
                     CrossUp[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",SF,RSIPeriod,WP,Show_Signal_Cross,Show_Fifty_Cross,alertsOn,alertsOnCurrent,alertsOnSignalCross,alertsOnLevelCross,alertsMessage,alertsSound,alertsNotify,alertsEmail,AlertLevel,arrowSize,0,y);
                     CrossDn[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",SF,RSIPeriod,WP,Show_Signal_Cross,Show_Fifty_Cross,alertsOn,alertsOnCurrent,alertsOnSignalCross,alertsOnLevelCross,alertsMessage,alertsSound,alertsNotify,alertsEmail,AlertLevel,arrowSize,1,y);
                     FiftyUp[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",SF,RSIPeriod,WP,Show_Signal_Cross,Show_Fifty_Cross,alertsOn,alertsOnCurrent,alertsOnSignalCross,alertsOnLevelCross,alertsMessage,alertsSound,alertsNotify,alertsEmail,AlertLevel,arrowSize,2,y);
                     FiftyDn[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",SF,RSIPeriod,WP,Show_Signal_Cross,Show_Fifty_Cross,alertsOn,alertsOnCurrent,alertsOnSignalCross,alertsOnLevelCross,alertsMessage,alertsSound,alertsNotify,alertsEmail,AlertLevel,arrowSize,3,y);
                  }
               }
               return(0);
            }

   //
   //
   //
   //
   //

   double alpha1 = 2.0/(SF+1.0);
   double alpha2 = 2.0/(RSIPeriod*2.0);
   if (ArrayRange(emas,0) != Bars) ArrayResize(emas,Bars);
   for (i=limit, r=Bars-i-1; i>=0; i--,r++)
   {  
      RsiMa[i]   = RsiMa[i+1] + alpha1*(iRSI(NULL,0,RSIPeriod,PRICE_CLOSE,i) - RsiMa[i+1]);
      emas[r][iEma] = emas[r-1][iEma] + alpha2*(MathAbs(RsiMa[i+1]-RsiMa[i]) - emas[r-1][iEma]);
      emas[r][iEmm] = emas[r-1][iEmm] + alpha2*(emas[r][iEma] - emas[r-1][iEmm]);

      //
      //
      //
      //
      //

         double rsi0 = RsiMa[i];
         double rsi1 = RsiMa[i+1];
         double dar  = emas[r  ][iEmm]*WP;
         double tr   = emas[r-1][iQqe];
         double dv   = tr;
   
            if (rsi0 < tr) { tr = rsi0 + dar; if ((rsi1 < dv) && (tr > dv)) tr = dv; }
            if (rsi0 > tr) { tr = rsi0 - dar; if ((rsi1 > dv) && (tr < dv)) tr = dv; }

         Trend[i]      = tr;
         emas[r][iQqe] = tr;
         
         trend1[i] = trend1[i+1];
            if(RsiMa[i]>Trend[i]) trend1[i] = 1;
            if(RsiMa[i]<Trend[i]) trend1[i] =-1;
            
            //
            //
            //
            //
            //
      
            CrossUp[i] = EMPTY_VALUE;
            CrossDn[i] = EMPTY_VALUE;
            if (trend1[i] !=trend1[i+1])
            if (trend1[i] == 1)
                  CrossUp[i] = Low[i] - iATR(NULL,0,20,i)/1.0;
            else  CrossDn[i] = High[i]+ iATR(NULL,0,20,i)/1.0;
         
         //
         //
         //
         //
         //
            
         trend2[i] = trend2[i+1];
            if(RsiMa[i]>AlertLevel) trend2[i] = 1;
            if(RsiMa[i]<AlertLevel) trend2[i] =-1;
            
            //
            //
            //
            //
            //
      
            FiftyUp[i] = EMPTY_VALUE;
            FiftyDn[i] = EMPTY_VALUE;
            if (trend2[i] != trend2[i+1])
            if (trend2[i] == 1)
                  FiftyUp[i] = Low[i] - iATR(NULL,0,20,i)/1.0;
            else  FiftyDn[i] = High[i]+ iATR(NULL,0,20,i)/1.0;
         
   }
   manageAlerts();    
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

void manageAlerts()
{
   if (alertsOn)
   {
      if (alertsOnCurrent)
           int whichBar = 0;
      else     whichBar = 1; 
      
      //
      //
      //
      //
      //
      
      static datetime time1 = 0;
      static string   mess1 = "";
         if (alertsOnSignalCross && trend1[whichBar] != trend1[whichBar+1])
         {
            if (trend1[whichBar] ==  1) doAlert(time1,mess1,whichBar," QQE BUY");
            if (trend1[whichBar] == -1) doAlert(time1,mess1,whichBar," QQE SELL");
         }            
      static datetime time2 = 0;
      static string   mess2 = "";
         if (alertsOnLevelCross && trend2[whichBar] != trend2[whichBar+1])
         {
            if (trend2[whichBar] ==  1) doAlert(time2,mess2,whichBar," QQE crossed fifty level up");
            if (trend2[whichBar] == -1) doAlert(time2,mess2,whichBar," QQE crossed fifty level down");
         }            
   }
}   

//
//
//
//
//

void doAlert(datetime& previousTime, string& previousAlert, int forBar, string doWhat)
{
   string message;
   
      if (previousAlert != doWhat || previousTime != Time[forBar]) {
          previousAlert  = doWhat;
          previousTime   = Time[forBar];

          //
          //
          //
          //
          //

          message =  StringConcatenate(Symbol()," M",Period()," - " ,doWhat);
             if (alertsMessage) Alert(message);
             if (alertsNotify)  SendNotification(StringConcatenate(Symbol(), Period() ," QQE " +" "+message));
             if (alertsEmail)   SendMail(StringConcatenate(Symbol()," QQE "),message);
             if (alertsSound)   PlaySound("alert2.wav");
      }
}

//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
//
//
//
//
//

string sTfTable[] = {"M1","M10","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,10,15,30,60,240,1440,10080,43200};

//
//
//
//
//

int stringToTimeFrame(string tfs)
{
   tfs = stringUpperCase(tfs);
   for (int i=ArraySize(iTfTable)-1; i>=0; i--)
         if (tfs==sTfTable[i] || tfs==""+iTfTable[i]) return(MathMax(iTfTable[i],Period()));
                                                      return(Period());
}
string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

//
//
//
//
//

string stringUpperCase(string str)
{
   string   s = str;

   for (int length=StringLen(str)-1; length>=0; length--)
   {
      int tchar = StringGetChar(s, length);
         if((tchar > 96 && tchar < 123) || (tchar > 223 && tchar < 256))
                     s = StringSetChar(s, length, tchar - 32);
         else if(tchar > -33 && tchar < 0)
                     s = StringSetChar(s, length, tchar + 224);
   }
   return(s);
}


