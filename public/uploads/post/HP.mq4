//+------------------------------------------------------------------+
//|                                                         HP_2.mq4 |
//|                                        AP-Алексадр Пак, Алма-Ата |
//|                                                   ekr-ap@mail.ru |
//| Hendrick-Prescot indi перевод с VB Excell                        |
//+------------------------------------------------------------------+

//http://forum.mql4.com/ru/18404 - форум
//http://en.wikipedia.org/wiki/Hodrick-Prescott_filter - wiki
//http://www.web-reg.de/hp_addin.html#  - программа VB Excell
//при использовании кода сообщать автору программы VB Excell
#property copyright "AP"
#property link      "ekr-ap@mail.ru"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Black

//Input parameters
extern int nobs   =1000; //Number of bars to smooth
extern int lambda =1600; //Higher lambda leads to the smoother data

//Indicator buffers
double hpf[];

int init()
{
   SetIndexBuffer(0,hpf);
   SetIndexStyle(0,DRAW_LINE,EMPTY,2);
   return(0);
}
//+----------------------------------------------------------------------------------------+
int start()
{
   HPF(nobs,lambda,hpf);
   return(0);
}
// Hodrick-Prescott Filter-----------------------------------------------------------------+
void HPF(int nobs, int lambda, double& output[])
{
   double a[],b[],c[],H1,H2,H3,H4,H5,HH1,HH2,HH3,HH4,HH5,HB,HC,Z;
   ArrayResize(a,nobs);
   ArrayResize(b,nobs);
   ArrayResize(c,nobs);
   for(int i=0;i<nobs;i++) output[i]=Close[i];
        
   a[0]=1.0+lambda;
   b[0]=-2.0*lambda;
   c[0]=lambda;
   for(i=1;i<nobs-2;i++)
   {
      a[i]=6.0*lambda+1.0;
      b[i]=-4.0*lambda;
      c[i]=lambda;
   }
   a[1]=5.0*lambda+1;
   a[nobs-1]=1.0+lambda;
   a[nobs-2]=5.0*lambda+1.0;
   b[nobs-2]=-2.0*lambda;
   b[nobs-1]=0.0;
   c[nobs-2]=0.0;
   c[nobs-1]=0.0;
   
   //Forward
   for(i=0;i<nobs;i++)
   {
      Z=a[i]-H4*H1-HH5*HH2;
      HB=b[i];
      HH1=H1;
      H1=(HB-H4*H2)/Z;
      b[i]=H1;
      HC=c[i];
      HH2=H2;
      H2=HC/Z;
      c[i]=H2;
      a[i]=(output[i]-HH3*HH5-H3*H4)/Z;
      HH3=H3;
      H3=a[i];
      H4=HB-H5*HH1;
      HH5=H5;
      H5=HC;
   }
   
   //Backward 
   H2=0;
   H1=a[nobs-1];
   output[nobs-1]=H1;
   for(i=nobs-2;i>=0;i--)
   {
      output[i]=a[i]-b[i]*H1-c[i]*H2;
      H2=H1;
      H1=output[i];
   }
}

