//+------------------------------------------------------------------+
//|                                        Murrey Math_MT_All TF.mq4 |
//|                      Copyright � 2004, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Vladislav Goshkov (VG)+VAF"
#property link      "4vg@mail.ru"

#property indicator_chart_window

// ============================================================================================
// * ����� 8/8 � 0/8 (������������� �������������).
// * ��� ����� ����� ������� � ��������� ���������� ������������� � ���������.
// ============================================================================================
//* ����� 7/8  (������, ����� ��� ��������� � ���������). Weak, Stall and Reverse
//* ��� ����� �����. ���� ���� ����� ������� ������ � ������� ������ � ���� ��� ������������ ����� ���� �����, 
//* ������ ��� ����������� ������ ����. ���� ���� �� ������������ ����� ���� �����, ��� ��������� �������� ����� � 8/8.
// ============================================================================================
//* ����� 1/8  (������, ����� ��� ��������� � ���������). Weak, Stall and Reverse
//* ��� ����� �����. ���� ���� ����� ������� ������ � ������� ������ � ���� ��� ������������ ����� ���� �����, 
//* ������ ��� ����������� ������ �����. ���� ���� �� ������������ ����� ���� �����, ��� ��������� �������� ���� � 0/8.
// ============================================================================================
//* ����� 6/8 � 2/8 (��������, ��������). Pivot, Reverse
//* ��� ��� ����� �������� � ����� ���� ������ 4/8 � ����� ����������� ��������� ���������� ������� ��������.
// ============================================================================================
//* ����� 5/8 (���� ��������� ���������). Top of Trading Range
//* ���� ���� ������ ������ 40% �������, �� �������� ����� 5/8 � 3/8 �������. 
//* ���� ���� ��������� ����� ����� 5/8 � �������� ����� ��� � ������� 10-12 ����, ����� ������ ��� ������� 
//* ��������� � ���� ������������ ����, ��� � ������ ��������� ����, �� ���� ���� ��������� ��������� ���������� 
//* ���� 5/8, �� ��� � ��������� ���� ���. ����, ������, ���� ������ ���� 5/8, �� ��� ������ ����� ��������� 
//* ������ ����� �� ���������� ������ �������������.
// ============================================================================================
//* ����� 3/8 (��� ��������� ���������). Bottom of Trading Range
//* ���� ���� ���� ���� ���� � ��������� �����, �� ���� ����� ������ ������� ���� �������. 
//* ���� ��������� ����� ��� ����� � �������� ���� ��� � ������� 10-12 ����, ������ ���� ��������� ���� ���� ����� 
//* � �������� 40% ������� �������� ����� ���� ������ � 5/8 ������.
// ============================================================================================
//* ����� 4/8 (������� ����� �������������/���������). Major Support/Resistance
//* ��� ����� ������������ ���������� �������������/���������. ���� ������� �������� ������ ��� ����� ������� ��� �������. 
//* ���� ���� ��������� ���� 4/8, �� ��� ������� ������� ���������. ���� ���� ��������� ���� 4/8, �� ��� ���������� ������� 
//* �������������.
// ============================================================================================
extern int P = 200;
extern int StepBack = 0;
double   dmml = 0,    dvtl = 0,       sum = 0,        v1 = 0,
         v2 = 0,        mn = 0,        mx = 0,
         x1 = 0,        x2 = 0,        x3 = 0,        x4 = 0,        x5 = 0,        x6 = 0,
         y1 = 0,        y2 = 0,        y3 = 0,        y4 = 0,        y5 = 0,        y6 = 0,
         octave = 0,fractal= 0,     range = 0,    finalH = 0,   finalL  = 0,
         ip[9,13],
         mml[13];
string   ln_txt[13], ln_txt1[13], tf_txt[9,13], buff_str = "",      tstr="",
         sf_txt[9]={"M1","M5","M15","M30","H1","H4","D1","W1","MN1"};
int      bn_v1        = 0,
         bn_v2        = 0,
         OctLinesCnt  = 13,
         mml_thk      = 8,
         mml_clr[13],
         mml_shft     = 3,
         nTime        = 0,
         CurPeriod    = 0,
         nDigits      = 0,
         i            = 0,
         j            = 0,
         iTF          = 0, // ������� �� �����������
         iLC          = 0, // ������� �� ������
         TF[9] = {PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1,PERIOD_MN1},
         Lwidth[13],
         nTF=9; // ���������� � �������
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   //---- indicators
/*   ln_txt[0]  = "[-2/8] �� ����� � ����� �� ������� �������� ��� �� �1 ��� �5";// "extremely overshoot [-2/8]";// [-2/8]
   ln_txt[1]  = "[-1/8] ������ - ����� ������� ��� ����������";// "overshoot [-1/8]";// [-1/8]
   ln_txt[2]  = "[0/8] ������������� ���������-���� �� �����, �� ������� � 4/8 ";// "Ultimate Support - extremely oversold [0/8]";// [0/8]
   ln_txt[3]  = "[1/8] ������ ������, ���� ���� �� ������������, �� ���Ĩ� � 0/8 ";// "Weak, Stall and Reverse - [1/8]";// [1/8]
   ln_txt[4]  = "[2/8] ������� ������� - ���� ��Ш� �����, �� ���� 0/8 ";// "Pivot, Reverse - major [2/8]";// [2/8]
   ln_txt[5]  = "[3/8] ��������� ��������� ��������� ";// "Bottom of Trading Range - [3/8], if 10-12 bars then 40% Time. BUY Premium Zone";//[3/8]
   ln_txt[6]  = "[4/8] ��������� ����� ��� ����� ������� ��� ������� ";// "Major Support/Resistance Pivotal Point [4/8]- Best New BUY or SELL level";// [4/8]
   ln_txt[7]  = "[5/8] ���� ��������� ��������� ";// "Top of Trading Range - [5/8], if 10-12 bars then 40% Time. SELL Premium Zone";//[5/8]
   ln_txt[8]  = "[6/8] ������� ������� - ���� ��Ш� � ����, �� ���� 4/8 ";// "Pivot, Reverse - major [6/8]";// [6/8]
   ln_txt[9]  = "[7/8] ������ ������, ���� ���� �� ������������, �� ���Ĩ� � 8/8 ";// "Weak, Stall and Reverse - [7/8]";// [7/8]
   ln_txt[10] = "[8/8]������������� �������������-���� �� �����,�� ������� � 4/8 ";// "Ultimate Resistance - extremely overbought [8/8]";// [8/8]
   ln_txt[11] = "[+1/8] ������ - ����� ������� ��� ����������";// "overshoot [+1/8]";// [+1/8]
   ln_txt[12] = "[+2/8] �� ����� � ����� �� ������� �������� ��� �� �1 ��� �5";// "extremely overshoot [+2/8]";// [+2/8]
*/
   ln_txt1[0]  = "[-2/8] ";  //extremely overshoot [-2/8]";// [-2/8]
   ln_txt1[1]  = "[-1/8] ";// "overshoot [-1/8]";// [-1/8]
   ln_txt1[2]  = "SUP ";
   ln_txt1[3]  = "[1/8] ";// "Weak, Stall and Reverse - [1/8]";// [1/8]
   ln_txt1[4]  = "[2/8] ";// "Pivot, Reverse - major [2/8]";// [2/8]
   ln_txt1[5]  = "[3/8] ";// "Bottom of Trading Range - [3/8], if 10-12 bars then 40% Time. BUY Premium Zone";//[3/8]
   ln_txt1[6]  = "PIVOT ";// "Major Support/Resistance Pivotal Point [4/8]- Best New BUY or SELL level";// [4/8]
   ln_txt1[7]  = "[5/8] ";// "Top of Trading Range - [5/8], if 10-12 bars then 40% Time. SELL Premium Zone";//[5/8]
   ln_txt1[8]  = "[6/8] ";// "Pivot, Reverse - major [6/8]";// [6/8]
   ln_txt1[9]  = "[7/8] ";// "Weak, Stall and Reverse - [7/8]";// [7/8]
   ln_txt1[10] = "RES ";
   ln_txt1[11] = "[+1/8] ";// "overshoot [+1/8]";// [+1/8]
   ln_txt1[12] = "[+2/8] ";// "extremely overshoot [+2/8]";// [+2/8]
   mml_shft = 25;
   mml_thk  = 3;
   // ��������� ��������� ������ ������� ����� 
   mml_clr[0]  = Magenta;     // [-2]/8
   mml_clr[1]  = SlateGray;        // [-1]/8
   mml_clr[2]  = DodgerBlue;  //       [0]/8
   mml_clr[3]  = Orange;      //  [1]/8
   mml_clr[4]  = OrangeRed;   //             [2]/8
   mml_clr[5]  = OliveDrab;   //  [3]/8
   mml_clr[6]  = DodgerBlue;  //                   [4]/8
   mml_clr[7]  = OliveDrab;   //  [5]/8
   mml_clr[8]  = OrangeRed;   //             [6]/8
   mml_clr[9]  = Orange;      //  [7]/8
   mml_clr[10] = DodgerBlue;  //       [8]/8
   mml_clr[11] = SlateGray;        // [+1]/8
   mml_clr[12] = Magenta;     // [+2]/8
   return(0);
  }

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
   //---- TODO: add your code here
   Comment(" ");   
   for(i=0;i<OctLinesCnt;i++) 
    { buff_str = "mml"+i;       ObjectDelete(buff_str);
      buff_str = "mml_txt"+i;   ObjectDelete(buff_str);
    }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   int LD=0;
   if( (nTime != Time[0]) || (CurPeriod != Period()) )   {// ������ �������� � ��� ���������� �����
      for (iLC=0; iLC<OctLinesCnt;iLC++)   {
         ln_txt[iLC]="";
         Lwidth[iLC]=0;   // ������ ���� ����� �� ���������=0
         for (iTF=0; iTF<nTF;iTF++)   {
            ip[iTF,iLC]=0.0;
            tf_txt[iTF,iLC]="";
         }
      }
      for(iTF=nTF-1; iTF>=0; iTF--)   { //  �� ������� ����������� �� ��������
         Raschet(TF[iTF]);
         for (iLC=0; iLC<OctLinesCnt; iLC++) {
            ip[iTF,iLC]=mml[iLC];
            tf_txt[iTF,iLC]= StringConcatenate(StringTrimRight(sf_txt[iTF]),ln_txt1[iLC]);
         }
         if (TF[iTF]==Period()) break;   // ������� ���������� �� �����
      } 
      for(iTF=nTF-1; iTF>=0; iTF--){   // ����������� �������� �� ������ ���������� ������������ ��
         for (iLC=0; iLC<OctLinesCnt; iLC++) { // ���� �� ���� ������
            for (j=0; j<OctLinesCnt; j++) {
               if ((ip[iTF,iLC]<(mml[j]+(dmml/2))) && (ip[iTF,iLC]>(mml[j]-(dmml/2))) ) {// ��������� � ��������
                  tstr=StringTrimLeft(StringTrimRight(ln_txt[j])+" ");
                  ln_txt[j]=StringConcatenate(tstr, tf_txt[iTF,iLC]);
                  if ( Lwidth[j]<iTF )  Lwidth[j]=iTF;  //���  ������ �����, ��������� ����� �� ���� ��
               }   
            }   
         }
         if (TF[iTF]==Period()) break; // ������� �� �� �����
      }
      ShowLines();
      nTime    = Time[0];
      CurPeriod= Period(); // ������ �������� ������
   }
   return(0);
  }// End Start()
//+------------------------------------------------------------------+
void Raschet(int pTF)  {
   bn_v1 = iLowest( NULL, pTF,MODE_LOW, P+StepBack,0);
   bn_v2 = iHighest(NULL, pTF,MODE_HIGH,P+StepBack,0);
   v1    = iLow(NULL,pTF,bn_v1);
   v2    = iHigh(NULL,pTF,bn_v2);
   //determine fractal.....
   if( v2<=250000 && v2>25000 )                 fractal  =  100000;
   else if( v2<=25000 && v2>2500 )              fractal  =   10000;
    else if( v2<=2500 && v2>250 )               fractal  =    1000;
     else if( v2<=250 && v2>25 )                fractal  =     100;
      else if( v2<=25 && v2>12.5 )              fractal  =      12.5;
       else if( v2<=12.5 && v2>6.25)            fractal  =      12.5;
        else if( v2<=6.25 && v2>3.125 )         fractal  =       6.25;
         else if( v2<=3.125 && v2>1.5625 )      fractal  =       3.125;
          else if( v2<=1.5625 && v2>0.390625 )  fractal  =       1.5625;
           else if( v2<=0.390625 && v2>0)       fractal  =       0.1953125;
   range    =(v2-v1);
   sum      =MathFloor(MathLog(fractal/range)/MathLog(2));
   octave   =fractal*(MathPow(0.5,sum));
   mn       =MathFloor(v1/octave)*octave;
   if( (mn+octave)>v2 )
      mx=mn+octave; 
   else
      mx=mn+(2*octave);
   // calculating xx
   if( (v1>=(3*(mx-mn)/16+mn)) && (v2<=(9*(mx-mn)/16+mn)))              x2=mn+(mx-mn)/2;  else x2=0;
   if( (v1>=(mn-(mx-mn)/8))    && (v2<=(5*(mx-mn)/8+mn)) && (x2==0))    x1=mn+(mx-mn)/2;  else x1=0;
   if( (v1>=(mn+7*(mx-mn)/16)) && (v2<=(13*(mx-mn)/16+mn)))             x4=mn+3*(mx-mn)/4;else x4=0;
   if( (v1>=(mn+3*(mx-mn)/8))  && (v2<=(9*(mx-mn)/8+mn))&& (x4==0))     x5=mx;            else x5=0;
   if( (v1>=(mn+(mx-mn)/8))    && (v2<=(7*(mx-mn)/8+mn))&&(x1==0)
                               &&(x2==0)&&(x4==0)&&(x5==0))             x3=mn+3*(mx-mn)/4;else x3=0;
   if( (x1+x2+x3+x4+x5) ==0 )    x6=mx;                                                   else x6=0;
   finalH = x1+x2+x3+x4+x5+x6;
   // calculating yy
   if( x1>0 )    y1=mn;               else y1=0;
   if( x2>0 )    y2=mn+(mx-mn)/4;     else y2=0;
   if( x3>0 )    y3=mn+(mx-mn)/4;     else y3=0;
   if( x4>0 )    y4=mn+(mx-mn)/2;     else y4=0;
   if( x5>0 )    y5=mn+(mx-mn)/2;     else y5=0;
   if( (finalH>0) && ((y1+y2+y3+y4+y5)==0) )    y6=mn;     else y6=0;
   finalL = y1+y2+y3+y4+y5+y6;
   for( i=0; i<OctLinesCnt; i++) {mml[i] = 0;}
   dmml = (finalH-finalL)/8;
   mml[0] =(finalL-dmml*2); //-2/8
   for( i=1; i<OctLinesCnt; i++) {mml[i] = mml[i-1] + dmml;}
   return(0);
  }
//+------------------------------------------------------------------+
void ShowLines()  { 
   for( i=0; i<OctLinesCnt; i++ ){
      buff_str = "mml"+i;
      if(ObjectFind(buff_str) == -1) {
         ObjectCreate(buff_str, OBJ_HLINE, 0, Time[0], mml[i]);
//         ObjectSet(buff_str, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet(buff_str, OBJPROP_COLOR, mml_clr[i]);
       }
      ShowTipLines(Lwidth[i], mml[i]);
      buff_str = "mml_txt"+i;
      if(ObjectFind(buff_str) == -1) {
         ObjectCreate(buff_str, OBJ_TEXT, 0, Time[mml_shft], mml_shft);
         ObjectSetText(buff_str, ln_txt[i], 8, "Arial", mml_clr[i]);
         ObjectMove(buff_str, 0, Time[mml_shft],  mml[i]);
        }
      else {ObjectMove(buff_str, 0, Time[mml_shft],  mml[i]);}
//      ObjectSetText(buff_str, ln_txt[i]+DoubleToStr(Lwidth[i],0), 8, "Arial", mml_clr[i]);
      ObjectSetText(buff_str, ln_txt[i], 8, "Arial", mml_clr[i]);
    } // for( i=1; i<=OctLinesCnt; i++ ){
   return(0);
  }// End ShowLines()
  
//+------------------------------------------------------------------+
void ShowTipLines(int pS, double pCoord)
  {int wi=1, st=STYLE_SOLID;
   ObjectMove(buff_str, 0, Time[0],   pCoord);
   if (pS==0){wi=0; st=STYLE_DOT;         }//M1  
   if (pS==1){wi=0; st=STYLE_DOT;         }//M5  
   if (pS==2){wi=0; st=STYLE_DASHDOTDOT;  }//M15 
   if (pS==3){wi=0; st=STYLE_DASHDOTDOT;  }//M30 
   if (pS==4){wi=1; st=STYLE_DASHDOT;     }//H1   
   if (pS==5){wi=1; st=STYLE_DASH;        }//H4  
   if (pS==6){wi=1; st=STYLE_SOLID;       }//D1  
   if (pS==7){wi=2; st=STYLE_SOLID;       }//W1
   if (pS==8){wi=3; st=STYLE_SOLID;       }//MN1
   ObjectSet(buff_str, OBJPROP_WIDTH, wi); 
   ObjectSet(buff_str, OBJPROP_STYLE, st);
  }    
// End of Program  