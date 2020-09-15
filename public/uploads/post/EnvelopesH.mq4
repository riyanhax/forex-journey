//+------------------------------------------------------------------+
//|                                                   EnvelopesH.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, zznbrm"
                          
//---- indicator settings
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 DarkGray
#property indicator_color2 DarkGray
#property indicator_color3 DarkGray
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_style1 STYLE_DOT
#property indicator_style2 STYLE_SOLID
#property indicator_style2 STYLE_SOLID

//---- input parameters
extern int eintMaPeriod = 100;
extern string estrMethod1 = "0=SMA,1=EMA,2=SMMA,3=LWMA";
extern int eintMaMethod = MODE_EMA;
extern string estrPrice1 = "0=Close,1=Open,2=High,3=Low";
extern string estrPrice2 = "4=Median,5=Typical,6=Weighted";
extern int eintMaPrice = PRICE_CLOSE;
extern int eintMaShift = 0;
extern double edblRangeMult = 0.05;

//---- indicator buffers
double gadblMid[];
double gadblUpper[];
double gadblLower[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   SetIndexBuffer( 0, gadblMid );
   SetIndexStyle( 0, DRAW_LINE, STYLE_DOT );
   SetIndexLabel( 0, "Env-Mid" );
   SetIndexEmptyValue( 0, 0.0 );
   
   SetIndexBuffer( 1, gadblUpper );
   SetIndexStyle( 1, DRAW_LINE, STYLE_SOLID );
   SetIndexLabel( 1, "Env-Upper" );
   SetIndexEmptyValue( 1, 0.0 );
   
   SetIndexBuffer( 2, gadblLower );
   SetIndexStyle( 2, DRAW_LINE, STYLE_SOLID );
   SetIndexLabel( 2, "Env-Lower" );
   SetIndexEmptyValue( 2, 0.0 );
   
   IndicatorShortName( "EnvelopesH" );
   IndicatorDigits( Digits );   
   return( 0 );
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
   return( 0 );
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int counted_bars = IndicatorCounted();
   
   if (counted_bars < 0) return (-1);
   if (counted_bars > 0) counted_bars--;
   int intLimit = Bars - counted_bars;
   
   if ( intLimit > Bars - eintMaPeriod )    intLimit = Bars - eintMaPeriod;

   double dblMA, dblDev, dblOpen, dblHigh, dblLow, dblRange;
   int intShift;

   for( int inx = intLimit; inx >= 0; inx-- )
   {
      dblMA = iMA( Symbol(), Period(), eintMaPeriod, eintMaShift, eintMaMethod, eintMaPrice, inx );
      
      intShift = iBarShift( Symbol(), PERIOD_D1, Time[inx] );
      
      dblOpen = iOpen( Symbol(), PERIOD_D1, intShift+1 );
      dblHigh = iHigh( Symbol(), PERIOD_D1, intShift+1 );
      dblLow = iLow( Symbol(), PERIOD_D1, intShift+1 );
      dblRange = dblHigh - dblLow;
            
      if ( dblOpen <= 0.0 )
      {
         gadblMid[inx] = 0.0;
         gadblUpper[inx] = 0.0;
         gadblLower[inx] = 0.0; 
      }
      else
      {     
         dblDev = ( dblRange / dblOpen ) * edblRangeMult; 
         gadblMid[inx] = dblMA;
         gadblUpper[inx] = dblMA + ( dblMA * dblDev );
         gadblLower[inx] = dblMA - ( dblMA * dblDev );   
      }   
   }   
   
   return( 0 );
}


