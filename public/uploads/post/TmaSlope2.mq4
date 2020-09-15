//+------------------------------------------------------------------+
//|                                                    TmaSlope2.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, zznbrm"
                          
//---- indicator settings
#property indicator_separate_window
//#property  indicator_buffers 8 
#property  indicator_buffers 6 
#property indicator_color1 Lime
#property indicator_color2 Green
#property indicator_color3 IndianRed
#property indicator_color4 FireBrick
#property indicator_color5 White
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 2

//---- input parameters
extern int eintPeriod = 56;
extern double edblHigh1 = 0.25;
extern double edblHigh2 = 0.5;
extern double edblLow1 = -0.25;
extern double edblLow2 = -0.5;
extern bool eblnNormalize = false;

//---- indicator buffers
double gadblUp1[];
double gadblUp2[];
double gadblDn1[];
double gadblDn2[];
double gadblExt[];
double gadblSlope[];
//double gadblTma[];
//double gadblPrev[];

double gdblTruePoint;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{          
   //IndicatorBuffers( 8 );    
   IndicatorBuffers( 6 );
   IndicatorDigits( 5 );
   IndicatorShortName( "TmaSlope2" );
   gdblTruePoint = genTruePoint();
         
   SetIndexBuffer( 0, gadblUp1 );    SetIndexLabel( 0, NULL );       SetIndexStyle( 0, DRAW_HISTOGRAM );
   SetIndexBuffer( 1, gadblUp2 );    SetIndexLabel( 1, NULL );       SetIndexStyle( 1, DRAW_HISTOGRAM );
   SetIndexBuffer( 2, gadblDn1 );    SetIndexLabel( 2, NULL );       SetIndexStyle( 2, DRAW_HISTOGRAM );
   SetIndexBuffer( 3, gadblDn2 );    SetIndexLabel( 3, NULL );       SetIndexStyle( 3, DRAW_HISTOGRAM );
   SetIndexBuffer( 4, gadblExt );    SetIndexLabel( 4, NULL );       SetIndexStyle( 4, DRAW_HISTOGRAM );
   SetIndexBuffer( 5, gadblSlope );  SetIndexLabel( 5, "TMA Slope" );    SetIndexStyle( 5, DRAW_NONE );
   //SetIndexBuffer( 6, gadblTma );    SetIndexLabel( 6, "TMA Curr" );       SetIndexStyle( 6, DRAW_NONE ); 
   //SetIndexBuffer( 7, gadblPrev );   SetIndexLabel( 7, "TMA Prev" );       SetIndexStyle( 7, DRAW_NONE ); 
      
   SetIndexEmptyValue( 0, 0.0 );
   SetIndexEmptyValue( 1, 0.0 );
   SetIndexEmptyValue( 2, 0.0 );
   SetIndexEmptyValue( 3, 0.0 );
   SetIndexEmptyValue( 4, 0.0 );
          
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
   if ( counted_bars < 0 ) return(-1);
   if ( counted_bars > 0 ) counted_bars--;
               
   int intLimit = MathMin( Bars - 1, Bars - counted_bars );
   
   double dblTma, dblPrev, dblAtr, dblAtr15;
   int int15;
   
   for( int inx = intLimit; inx >= 0; inx-- )
   {   
      //gadblTma[inx] = calcTma( inx );
      //gadblPrev[inx] = calcPrev( inx );
      //gadblSlope[inx] = ( gadblTma[inx] - gadblPrev[inx] ) / gdblTruePoint;
      dblTma = calcTma( inx );
      dblPrev = calcPrev( inx );
      
      if ( eblnNormalize )
      {
         dblAtr = iATR( Symbol(), Period(), 100, inx );
         
         int15 = iBarShift( Symbol(), PERIOD_M15, Time[inx] );
         dblAtr15 = iATR( Symbol(), PERIOD_M15, 100, int15 );
         
         if ( dblAtr == 0.0 )   continue;
         if ( dblAtr15 == 0.0 ) continue;
         
         gadblSlope[inx] = ( dblAtr15 / dblAtr ) * ( dblTma - dblPrev ) / gdblTruePoint;
      }
      else
      {
         gadblSlope[inx] = ( dblTma - dblPrev ) / gdblTruePoint;
      }
      
      gadblUp1[inx] = 0.0;
      gadblUp2[inx] = 0.0;
      gadblDn1[inx] = 0.0;
      gadblDn2[inx] = 0.0;
      gadblExt[inx] = 0.0;
      
      if ( gadblSlope[inx] >= edblHigh2 )      gadblExt[inx] = gadblSlope[inx]; 
      else if ( gadblSlope[inx] >= edblHigh1 ) gadblUp2[inx] = gadblSlope[inx];
      else if ( gadblSlope[inx] >= 0.0 )       gadblUp1[inx] = gadblSlope[inx];
      else if ( gadblSlope[inx] <= edblLow2 )  gadblExt[inx] = gadblSlope[inx];
      else if ( gadblSlope[inx] <= edblLow1 )  gadblDn2[inx] = gadblSlope[inx];
      else                                     gadblDn1[inx] = gadblSlope[inx];
   }
   
   return( 0 );
}

//+------------------------------------------------------------------+
//| genTruePoint()                                                   |
//+------------------------------------------------------------------+
double genTruePoint( string strPair="" )
{
   int intDigits;
   double dblPoint;
   
   if ( strPair == "" || strPair == Symbol() )    intDigits = Digits;
   else                                           intDigits = MarketInfo( strPair, MODE_DIGITS );
      
   // Reset point value for 5 digit brokers
   switch( intDigits )
   {
      case 5:
      case 4:     dblPoint = 0.0001;   break;
      case 3:
      case 2:     dblPoint = 0.01;     break;
      case 1:     dblPoint = 0.1;      break;
      case 0:     dblPoint = 0.0;      break;
      default:    dblPoint = 0.0001;
   }
   
   return( dblPoint );
}

//+------------------------------------------------------------------+
//| calcTma()                                                        |
//+------------------------------------------------------------------+
double calcTma( int inx )
{
   return( iMA( Symbol(), Period(), eintPeriod+1, 0, MODE_LWMA, PRICE_CLOSE, inx ) );
}

//+------------------------------------------------------------------+
//| calcPrev()                                                       |
//+------------------------------------------------------------------+
double calcPrev( int inx )
{
   double dblSum  = (eintPeriod+1)*Close[inx+1];
   double dblSumw = (eintPeriod+1);
   int jnx, knx;
   
   // Add in the current (inx) bar
   dblSum  += ( eintPeriod * Close[inx] );
   dblSumw += eintPeriod;
         
   for ( jnx = 1, knx = eintPeriod; jnx <= eintPeriod; jnx++, knx-- )
   {
      dblSum  += ( knx * Close[inx+1+jnx] );
      dblSumw += knx;
   }
   
   return( dblSum / dblSumw );
}
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 



   


