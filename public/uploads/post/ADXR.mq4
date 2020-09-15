//+------------------------------------------------------------------+
//| http://www.imt4.com/ |
//+------------------------------------------------------------------+
#property link "http://www.imt4.com/"
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 YellowGreen
#property indicator_color2 Wheat
#property indicator_color3 LightSeaGreen
#property indicator_color4 Red
extern int M=2;
extern int adx_period=14;
//---- buffers
double di_plus[],di_minus[],adx[],adxr[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function |
//+------------------------------------------------------------------+
int init()
{
//---- indicators
SetIndexStyle(0,DRAW_LINE,2);
SetIndexBuffer(0,di_plus);
SetIndexStyle(1,DRAW_LINE,2);
SetIndexBuffer(1,di_minus);
SetIndexStyle(2,DRAW_LINE);
SetIndexBuffer(2,adx);
SetIndexStyle(3,DRAW_LINE);
SetIndexBuffer(3,adxr);
//----
return(0);
}
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function |
//+------------------------------------------------------------------+
int deinit()
{
return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function |
//+------------------------------------------------------------------+
int start()
{
for (int i=Bars-1;i>=0;i--)
{
di_plus[i]=iADX(NULL,0,adx_period,PRICE_CLOSE,MODE_PLUSDI,i);
di_minus[i]=iADX(NULL,0,adx_period,PRICE_CLOSE,MODE_MINUSDI,i);
adx[i]=iADX(NULL,0,adx_period,PRICE_CLOSE,MODE_MAIN,i);
}
for (i=Bars-1;i>=0;i--)
{
adxr[i]=(adx[i]+adx[i+M])/2;
}
//----
return(0);
}
//+------------------------------------------------------------------+ 