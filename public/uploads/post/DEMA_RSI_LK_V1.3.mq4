//+------------------------------------------------------------------+
//|                                                  DEMA_RSI_LK.mq4 |
//|                                 Copyright © 2009, Leif Karlsson. |
//|                                        Leffemannen1973@telia.com |
//+------------------------------------------------------------------+
//| Please feel free to copy, modify and / or redistribute this      |
//| software / source code in any way you see fit.                   |
//+------------------------------------------------------------------+
//+ ********************* Shameless Ad. **************************** +
//+ * I do custom programing jobs in Java, C, X86 Assembler & MQL4 * +
//+ ***** Pleace do not hesitate to get in contact if you nead ***** +
//+ ***** something special: EA, indicator or somthing else. ******* +
//+ ****************** Leffemannen1973@telia.com ******************* +
//+ **************************************************************** +
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Leif Karlsson"
#property link      "mailto://Leffemannen1973@telia.com"
//+------------------------------------------------------------------+
#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  Yellow
#property  indicator_color2  Red
#property  indicator_width1  1
//+------------------------------------------------------------------+
extern int DEMAPeriod = 30;
extern int RSIPeriod = 30;
extern string AppliedPriceText1 = "Close: 0, Open: 1, High: 2, Low: 3";
extern string AppliedPriceText2 = "Median: 4, Typical: 5, Weighted: 6";
extern int AppliedPrice = 4;
extern int PriceShift = 0;
extern double UpLevel = 70;
extern double DownLevel = 30;
extern bool InvFish = false;
extern int MaxBars = 4000;
//+------------------------------------------------------------------+
double UpBuffer[];
double DwBuffer[];
double EmaRsi1[];
double EmaRsi2[];
double Alpha = 0.0;
bool FirstRun = true;
//+------------------------------------------------------------------+
int init() {

   	IndicatorDigits(Digits+1);
   	
   	IndicatorBuffers(4);
   	
   	SetIndexStyle(0, DRAW_LINE);
   	SetIndexStyle(1, DRAW_LINE);
   	SetIndexBuffer(0, UpBuffer);
   	SetIndexBuffer(1, DwBuffer);
   	SetIndexBuffer(2, EmaRsi1);
   	SetIndexBuffer(3, EmaRsi2);
   	
   	SetLevelValue(0, UpLevel);
   	SetLevelValue(1, DownLevel);
   	   	   	
   	IndicatorShortName("DEMA_RSI, DEMAPeriod: " + DEMAPeriod + ", RSIPeriod: " + RSIPeriod + " ");
   	
   	Alpha = 2.0/(DEMAPeriod + 1.0);
   	
   	return(0);
}
//+------------------------------------------------------------------+
int start() {
	int i = IndicatorCounted();
	if(i < 0) return(-1);
	i = Bars - i;
	if(i > MaxBars || FirstRun) {
		FirstRun = false;
		i = MaxBars;
		ArrayInitialize(UpBuffer, EMPTY_VALUE);
		ArrayInitialize(DwBuffer, EMPTY_VALUE);
		ArrayInitialize(EmaRsi1, EMPTY_VALUE);
		ArrayInitialize(EmaRsi2, EMPTY_VALUE);
	}
			
	while(i >= 0) {
	
		double Rsi = iRSI(NULL, 0, RSIPeriod, AppliedPrice, PriceShift+i)-50.0;
		
		if(EmaRsi1[i+1] != EMPTY_VALUE) EmaRsi1[i] = (1.0-Alpha)*EmaRsi1[i+1] + Alpha*Rsi;
		else EmaRsi1[i] = Rsi;
		if(EmaRsi2[i+1] != EMPTY_VALUE) EmaRsi2[i] = (1.0-Alpha)*EmaRsi2[i+1] + Alpha*EmaRsi1[i];
		else EmaRsi2[i] = Rsi;
		
		double DEmaRsi = 2.0*EmaRsi1[i] - EmaRsi2[i];
		double OldDEmaRsi = 2.0*EmaRsi1[i+1] - EmaRsi2[i+1];
		if(EmaRsi1[i+1] == EMPTY_VALUE || EmaRsi2[i+1] == EMPTY_VALUE) OldDEmaRsi = DEmaRsi;
		
		if(InvFish) {
			DEmaRsi = (1.0-MathExp(-0.2*DEmaRsi)) / (1.0+MathExp(-0.2*DEmaRsi));
			OldDEmaRsi = (1.0-MathExp(-0.2*OldDEmaRsi)) / (1.0+MathExp(-0.2*OldDEmaRsi));
		}
		else {
			DEmaRsi = DEmaRsi + 50.0;
			OldDEmaRsi = OldDEmaRsi + 50.0;
		}
		
		if(DEmaRsi > OldDEmaRsi) {
			UpBuffer[i] = DEmaRsi;
			DwBuffer[i] = EMPTY_VALUE;
			if(UpBuffer[i+1] == EMPTY_VALUE) UpBuffer[i+1] = OldDEmaRsi;
		}
		else {
			DwBuffer[i] = DEmaRsi;
			UpBuffer[i] = EMPTY_VALUE;
			if(DwBuffer[i+1] == EMPTY_VALUE) DwBuffer[i+1] = OldDEmaRsi;
		}
		i--;
	}	

   	return(0);
}

