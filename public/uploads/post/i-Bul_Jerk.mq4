//+----------------------------------------------------------------------------+
//|                                                            i-Bul_Jerk.mq4  |
//|                                                                            |
//|  ����������������: ��� ����� �. aka KimIV  [http://www.kimiv.ru]           |
//|                                                                            |
//|  29.06.2013  ��������� �������� ��������.                                  |
//+----------------------------------------------------------------------------+
#property copyright "��� ����� �. aka KimIV"
#property link      "http://www.kimiv.ru"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LightBlue
#property indicator_color2 Salmon
#property indicator_width1 1
#property indicator_width2 1

//------- ������� ��������� ���������� -----------------------------------------
extern int NumberOfBars  = 100;  // ���������� ����� ������� (0-���)
extern int NumbOfBars    = 10;     // ���������� ���������� �����
extern int PriceDistance = 80;    // ���������� � �������

//------- ���������� ���������� ------------------------------------------------

//------- ������ ���������� ----------------------------------------------------
double dBuf0[], dBuf1[];

//------- ���������� ������� ������� -------------------------------------------


//+----------------------------------------------------------------------------+
//|                                                                            |
//|  ����������˨���� �������                                                  |
//|                                                                            |
//+----------------------------------------------------------------------------+
//|  Custom indicator initialization function                                  |
//+----------------------------------------------------------------------------+
void init() {
  SetIndexArrow     (0, 233);
  SetIndexBuffer    (0, dBuf0);
  SetIndexEmptyValue(0, EMPTY_VALUE);
  SetIndexStyle     (0, DRAW_ARROW);

  SetIndexArrow     (1, 234);
  SetIndexBuffer    (1, dBuf1);
  SetIndexEmptyValue(1, EMPTY_VALUE);
  SetIndexStyle     (1, DRAW_ARROW);

  Comment("");
}

//+----------------------------------------------------------------------------+
//|  Custom indicator deinitialization function                                |
//+----------------------------------------------------------------------------+
void deinit() { Comment(""); }

//+----------------------------------------------------------------------------+
//|  Custom indicator iteration function                                       |
//+----------------------------------------------------------------------------+
void start() {
  int bs, LoopBegin, sh;
  int ArrowInterval=(WindowPriceMax()-WindowPriceMin())/100*5/Point;

 	if (NumberOfBars==0) LoopBegin=Bars-50;
  else LoopBegin=NumberOfBars;
  LoopBegin=MathMin(Bars-50, LoopBegin);

  for (sh=LoopBegin; sh>=0; sh--) {
    bs=GetSignal(sh);
    if (bs>0) dBuf0[sh]=Low [sh]-ArrowInterval*Point;
    if (bs<0) dBuf1[sh]=High[sh]+ArrowInterval*Point;
  }
}

//+----------------------------------------------------------------------------+
//|                                                                            |
//|  ���������������� �������                                                  |
//|                                                                            |
//+----------------------------------------------------------------------------+
//|  �����    : ��������� ��������, al22bag@live.com.au                        |
//|           : http://ruforum.mt5.com/members/11292-al22bag                   |
//+----------------------------------------------------------------------------+
//|  ������   : 29.06.2013                                                     |
//|  �������� : ��������� � ���������� �������� ������.                        |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    nb - ����� ����                 (0 - ������� ���)                       |
//+----------------------------------------------------------------------------+
//|  ������������ ��������:                                                    |
//|     1 - �������                                                            |
//|     0 - ����, ���� ������                                                  |
//|    -1 - ��������                                                           |
//+----------------------------------------------------------------------------+
int GetSignal(int nb=0) {
  int bs=0;
  double hi=NormalizeDouble(High[iHighest(NULL,0,MODE_HIGH,NumbOfBars,nb+1)], Digits);
  double lo=NormalizeDouble(Low [iLowest (NULL,0,MODE_LOW ,NumbOfBars,nb+1)], Digits);
  
  if(NormalizeDouble((Close[nb]-lo)/Point, 0)>=PriceDistance) bs=-1;
  if(NormalizeDouble((hi-Close[nb])/Point, 0)>=PriceDistance) bs=1;

  return(bs);
}
//+----------------------------------------------------------------------------+

