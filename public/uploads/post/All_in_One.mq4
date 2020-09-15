//+------------------------------------------------------------------+
//|                                                       Trendy.mq4 |
//|                               Copyright © 2007, Nondisclosure007 |
//|                                               http://no.link.yet |
//+------------------------------------------------------------------+
/*
   
   

*/
#property copyright "Copyright © 2007, Nondisclosure007"
#property link      "http://no.link.yet"

#property indicator_separate_window
#property indicator_minimum 1
#property indicator_maximum 100
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red

//---- input parameters

int  TimeFrame   = 0;
int  shift       = 0;

//-->Moving Average settings<--
int      FastMAPeriod   = 5;
int      MediumMAPeriod = 10;
int      SlowMAPeriod   = 20;
int      MAMethod       = MODE_SMMA;
int      MAPrice        = PRICE_CLOSE;

//-->ADX settings<---
int      ADXPeriod      = 14;
int      ADXPrice       = PRICE_CLOSE;

//-->Bollinger Bands settings<--
int      BolPeriod      = 14;
int      BolDeviation   = 2;
int      BolShift       = 0;
int      BolPrice       = PRICE_CLOSE;

//-->CCI settings<---
int      CCIPeriod      = 14;
int      CCIPrice       = PRICE_CLOSE;

//-->Parabolic SAR<--
double   SARStep        = 0.02;
double   SARMaximum     = 0.2;

//-->MACD<--
int      MACDFast       = 12;
int      MACDSlow       = 26;
int      MACDSignal     = 9;
int      MACDPrice      = PRICE_CLOSE;

//-->Stochastic<--
int      STOKPeriod     = 5;
int      STODPeriod     = 3;
int      STOSlowing     = 3;
int      STOPrice       = PRICE_CLOSE;

//-->Stoch2<--
int      STO2KPeriod    = 14;
int      STO2DPeriod    = 3;
int      STO2Slowing    = 3;
int      STO2Price      = PRICE_CLOSE;

//-->RSI<--
int      RSIPeriod      = 14;

//-->Force<--
int      FIPeriod       = 14;
int      FIMethod       = MODE_SMA;
int      FIPrice        = PRICE_CLOSE;

//-->Momentum<--
int      MOMPeriod      = 14;
int      MOMPrice       = PRICE_CLOSE;

//-->DeMarker<--
int      DEMPeriod      = 14;

//-->RVI<--
int      RVIPeriod      = 10;

//-->Williams Percent Range<--
int      WPRRange       = 14;
// Use iCustom(NULL,TF,"WPR",WPRRange,0,shift);

//-->Accelerator/Decelerator<--
//use iAC(NULL, 0, shift)

//-->Wattah Attar Explosion<--
//use iCustom(NULL,0,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift)

//---- buffers
double UpBuffer[];
double DownBuffer[];
double indietotal=18;
//int   handle;

int init()
  {

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,UpBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,DownBuffer);
   SetIndexLabel(0,"Up %");
   SetIndexLabel(1,"Down %");
   return(0);
  }

int deinit()
  {


   return(0);
  }

int start()
  {
   int    counted_bars=IndicatorCounted(); int limit; double uptotal, downtotal;
   if(counted_bars<0) return(-1); 
      
   limit=Bars-counted_bars-1;

   for(int shift=0; shift<limit; shift++)
   {   
      uptotal=0; downtotal=0; 

      double MAFastCurrent=iMA(NULL,TimeFrame,FastMAPeriod,0,MAMethod,MAPrice,shift);
      double MAFastLast=iMA(NULL,TimeFrame,FastMAPeriod,0,MAMethod,MAPrice,shift+1);
      if (MAFastCurrent>MAFastLast) {uptotal=uptotal+1;}
      if (MAFastCurrent<MAFastLast) {downtotal=downtotal+1;}

      double MAMediumCurrent=iMA(NULL,TimeFrame,MediumMAPeriod,0,MAMethod,MAPrice,shift);
      double MAMediumLast=iMA(NULL,TimeFrame,MediumMAPeriod,0,MAMethod,MAPrice,shift+1);
      if (MAMediumCurrent>MAMediumLast) {uptotal=uptotal+1;}
      if (MAMediumCurrent<MAMediumLast) {downtotal=downtotal+1;}
      
      double MASlowCurrent=iMA(NULL,TimeFrame,SlowMAPeriod,0,MAMethod,MAPrice,shift);
      double MASlowLast=iMA(NULL,TimeFrame,SlowMAPeriod,0,MAMethod,MAPrice,shift+1);
      if (MASlowCurrent>MASlowLast) {uptotal=uptotal+1;}
      if (MASlowCurrent<MASlowLast) {downtotal=downtotal+1;}

      double ADX_plus=iADX(NULL,TimeFrame,ADXPeriod,ADXPrice,MODE_PLUSDI,shift);
      double ADX_minus=iADX(NULL,TimeFrame,ADXPeriod,ADXPrice,MODE_MINUSDI,shift);
      if (ADX_plus>ADX_minus) {uptotal=uptotal+1;}
      else if (ADX_plus<ADX_minus) {downtotal=downtotal+1;}
      
      double bolUp=iBands(NULL,TimeFrame,BolPeriod,BolDeviation,BolShift,BolPrice,MODE_UPPER,shift);
      double bolDown=iBands(NULL,TimeFrame,BolPeriod,BolDeviation,BolShift,BolPrice,MODE_LOWER,shift);
      double bolUplast=iBands(NULL,TimeFrame,BolPeriod,BolDeviation,BolShift,BolPrice,MODE_UPPER,shift+1);
      double bolDownlast=iBands(NULL,TimeFrame,BolPeriod,BolDeviation,BolShift,BolPrice,MODE_LOWER,shift+1);
      if (bolUp-bolDown>bolUplast-bolDownlast) {uptotal=uptotal+1;downtotal=downtotal+1;}
      
      double cci=iCCI(NULL,TimeFrame,CCIPeriod,CCIPrice,shift);
      if (cci>0) {uptotal=uptotal+1;}
      if (cci<0) {downtotal=downtotal+1;}      

      double sar=iSAR(NULL,TimeFrame,SARStep,SARMaximum,shift);
      if (sar>High[shift]) {downtotal=downtotal+1;}
      if (sar<Low[shift]) {uptotal=uptotal+1;}
      
      double macdline=iMACD(NULL,TimeFrame,MACDFast,MACDSlow,MACDSignal,MACDPrice,MODE_MAIN,shift);
      double macdsignal=iMACD(NULL,TimeFrame,MACDFast,MACDSlow,MACDSignal,MACDPrice,MODE_SIGNAL,shift);
      if (macdline>macdsignal) {uptotal=uptotal+1;}
      if (macdline<macdsignal) {downtotal=downtotal+1;}

      double stochmain=iStochastic(NULL,TimeFrame,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,STOPrice,MODE_MAIN,shift);
      double stochsignal=iStochastic(NULL,TimeFrame,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,STOPrice,MODE_SIGNAL,shift);
      if (stochmain>stochsignal) {uptotal=uptotal+1;}
      if (stochmain<stochsignal) {downtotal=downtotal+1;}
      
      double sto2main=iStochastic(NULL,TimeFrame,STO2KPeriod,STO2DPeriod,STO2Slowing,MODE_SMA,STO2Price,MODE_MAIN,shift);
      double sto2signal=iStochastic(NULL,TimeFrame,STO2KPeriod,STO2DPeriod,STO2Slowing,MODE_SMA,STO2Price,MODE_SIGNAL,shift);
      if (sto2main>sto2signal) {uptotal=uptotal+1;}
      if (sto2main<sto2signal) {downtotal=downtotal+1;}
      
      double rsi=iRSI(NULL,TimeFrame,RSIPeriod,PRICE_CLOSE,shift);
      if (rsi>50) {uptotal=uptotal+1;}
      if (rsi<50) {downtotal=downtotal+1;}     

      double force=iForce(NULL,TimeFrame,FIPeriod,FIMethod,FIPrice,shift);
      if (force>0) {uptotal=uptotal+1;}
      if (force<0) {downtotal=downtotal+1;} 
      
      double momentum=iMomentum(NULL,TimeFrame,MOMPeriod,MOMPrice,shift);
      if (momentum>100) {uptotal=uptotal+1;}
      if (momentum<100) {downtotal=downtotal+1;} 

      double demarker_current=iDeMarker(NULL,TimeFrame,DEMPeriod,shift);
      double demarker_last=iDeMarker(NULL,TimeFrame,DEMPeriod,shift+1);
      if (demarker_current>demarker_last) {uptotal=uptotal+1;}
      if (demarker_current<demarker_last) {downtotal=downtotal+1;} 
           
      double rvimain=iRVI(NULL,TimeFrame,RVIPeriod,MODE_MAIN,shift);
      double rvisignal=iRVI(NULL,TimeFrame,RVIPeriod,MODE_SIGNAL,shift);
      if (rvimain>rvisignal) {uptotal=uptotal+1;}
      if (rvimain<rvisignal) {downtotal=downtotal+1;} 
      
      double wpr=iCustom(NULL,TimeFrame,"WPR",WPRRange,0,shift);
      if (wpr>-20) {uptotal=uptotal+1;}
      if (wpr<-80) {downtotal=downtotal+1;} 
      
      double ac1=iAC(NULL, TimeFrame, shift);
      double ac2=iAC(NULL, TimeFrame, shift+1);
      double ac3=iAC(NULL, TimeFrame, shift+2);
      double ac4=iAC(NULL, TimeFrame, shift+3);
      if ((ac1>ac2 && ac2>ac3 && ac1>0 && ac2>0 && ac3>0)||(ac1>ac2 && ac2>ac3 && ac3>ac4 && ac1<0 && ac2<0 && ac3<0 && ac4<0)) {uptotal=uptotal+1;}
      if ((ac1<ac2 && ac2<ac3 && ac1>0 && ac2>0 && ac3>0)||(ac1<ac2 && ac2<ac3 && ac3<ac4 && ac1<0 && ac2<0 && ac3<0 && ac4<0)) {downtotal=downtotal+1;} 

      //Period used to be PERIOD_M1.  changed to 0.
      double wae_histo_up_1_0 = iCustom(NULL,TimeFrame,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift);
      double wae_histo_up_1_1 = iCustom(NULL,TimeFrame,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift+1);
      double wae_histo_down_1_0 = iCustom(NULL,TimeFrame,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift);
      double wae_histo_down_1_1 = iCustom(NULL,TimeFrame,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift+1);
      if (wae_histo_up_1_0 > wae_histo_up_1_1 || wae_histo_down_1_0 < wae_histo_down_1_1) {uptotal=uptotal+1;}
      if (wae_histo_up_1_0 < wae_histo_up_1_1 || wae_histo_down_1_0 > wae_histo_down_1_1) {downtotal=downtotal+1;}


      UpBuffer[shift]=NormalizeDouble(uptotal/indietotal,6)*100; 
      DownBuffer[shift]=NormalizeDouble(downtotal/indietotal,6)*100;
           
            
   }

   return(0);
  }

