


extern string _TP = "�������� ������� ���������";
//---
extern int TICK =3;               //--- ������ ��� ���� ����������� �������� .���� =0 �� ����.
extern int TakeProfit = 26;       //--- (10 2 60)
extern int StopLoss = 120;        //--- (100 10 200)
extern bool UseStopLevels = TRUE; //--- ��������� �������� �������. ���� ���������, �� �������� ������ ����������� ����� � �����.
extern bool CloseOnlyProfit = TRUE;
//---
extern int SecureProfit = 2;      //--- (0 1 5) ����� � ���������
extern int SecureProfitTriger = 8; //--- (10 2 30)
extern int MaxLossPoints = -65;   //--- (-200 5 -20) ������������ �������� ��� �������� ������� Buy � Sell ��� ��������� ������� (��� �������� ������ �� - MaxLossPoints ��� ������ (�������� ������� 0), ����� ���������)
extern double Commis =0;
extern string _PO = "��������� �������";

extern bool MarketOrder =TRUE;
extern double OrderDOP =2;            //���� - ��������� ����������� ��������� ������ . ���� = 0 - ����.
extern double KDOP =2;           //��������� ���� ����������� ��������� ������
extern bool ModifDOP    =FALSE;
extern bool ModifTake   =FALSE;
extern double LimitOrder = 0;   //���� - ��������� ��������� ������ . ���� = 0 - ����.
extern double TimeL =11;         //����� ���������� ��������� ������
extern double KLimit =1.5;       //��������� ���� ��������� ������
extern bool DeleteLimit =  TRUE;//���� �������� ��������� ������ ��� �������� �������� � ���������
extern bool DeleteLimitU = TRUE; //���� �������� ��������� ������ ��� ���������� ������� �������� 
extern double StopOrder = 0;     //���� - ��������� ���������  ������
extern double TimeS =20;         //����� ���������� ���������  ������
extern int DOPS = 20;            //������� �������� �������� ��������� ������ ��� �������� ��������� � ���
extern double  KStop =1;         //��������� ���� ��������� ������
extern bool ModifStop = TRUE;    //���� ����������� ��������� ������ ��� ���������� ��������� �� ���� ( ���������� ��������� ��� � ����������)
extern int ReversOrder = 0;      //�������� ��������� ����������� ����������� ������������ � �������� ( ������ ) �������
extern double KRevers =2;
extern double TimeRewers =11;
//+--------------------------------------------------------------------------------------------------------------+
//| ����
//+--------------------------------------------------------------------------------------------------------------+
extern string _tral = "��������� �����";
extern double TrailingStop = 0;  // 0 -��������  ���� �����1 �� � ����� �� ������� ����. 0.25... ���� �����1 �� �������
extern double TrailingStep = 0;  // ��� �����
extern double Utral        = 10; // �������� ������� ��� ������� ���������� ����

extern string _MM = "��������� MM";
//---
extern double StartLot = 0;       // ��� ������� ������ . ���� = 0 �� =�� ���� ������ 0 �� =StartLot
extern bool   RecoveryMode = TRUE; //--- ��������� ������ �������������� �������� (���������� ���� ���� �������� ����-����)
extern double FixedLot = 0.01;     //--- ������������� ����� ����
extern double AutoMM = 10;       //--- �� ���������� ���� AutoMM > 0. ������� �����. ��� RecoveryMode = FALSE, ������ ����� ������ ��� ��������.
//--- ��� AutoMM = 20 � �������� � 1000$, ��� ����� ����� 0,2. ����� ��� ����� ������������� ������ �� ��������� �������, �� ���� ��� ��� �������� � 2000$ ��� ����� ����� 0,4.
extern double MaximalLot = 1000;
extern double AutoMM_Max = 20.0;  //--- ������������ ����
extern int    MaxAnalizCount = 50;   //--- ����� �������� ����� ������� ��� �������(������������ ��� RecoveryMode = True)
extern double Risk = 25.0;        //--- ���� �� �������� (������������ ��� RecoveryMode = True)
extern double RiskFreeMargin = 0.5;
extern double RiskMargin = 0; //���� � ����������� ����� � ��������� ��������� ��� ������� ������ ��������
extern double MultiLotPercent = 2; //--- ����������� ��������� ���� (������������ ��� RecoveryMode = True)

//+--------------------------------------------------------------------------------------------------------------+
//| ������� �����������. ���-�� ����� ��� ������� ����������.
//+--------------------------------------------------------------------------------------------------------------+

extern string _indl = "��������� ����������� LONG";

//--- ������� ����������� (���� ����� ����� ��������, ��� ��� ��� ������ ���� ����)
extern int iMA_PeriodLONG = 55; //--- (60 5 100)
extern int iCCI_PeriodLONG  = 18; //--- (10 2 30)
extern int iATR_PeriodLONG  = 14; //--- (10 2 30) 
extern int iWPR_PeriodLONG  = 11; //--- (10 1 20)
extern int iMA_LONG_Open_a = 18; //--- (4 2 20) ������ �� ��� �������� Buy � Sell (�����)
extern int iMA_LONG_Open_b = 39; //--- (14 2 50) ������ �� ��� �������� Buy � Sell (�����)
extern int iWPR_LONG_Open_a = 1; //--- (-100 1 0) ������ WPR ��� �������� Buy � Sell
extern int iWPR_LONG_Open_b = 5; //--- (-100 1 0) ������ WPR ��� �������� Buy � Sell
extern string _indsh = "��������� ����������� SHORT";
extern int iMA_PeriodShort = 55; //--- (60 5 100)
extern int iCCI_PeriodShort = 18; //--- (10 2 30)
extern int iATR_PeriodShort = 14; //--- (10 2 30) 
extern int iWPR_PeriodShort = 11; //--- (10 1 20)
extern int iMA_Short_Open_a = 15; //--- (4 2 20) ������ �� ��� �������� Buy � Sell (�����)
extern int iMA_Short_Open_b = 39; //--- (14 2 50) ������ �� ��� �������� Buy � Sell (�����)
extern int iWPR_Short_Open_a = 1; //--- (-100 1 0) ������ WPR ��� �������� Buy � Sell
extern int iWPR_Short_Open_b = 5; //--- (-100 1 0) ������ WPR ��� �������� Buy � Sell
//+--------------------------------------------------------------------------------------------------------------+
//| ��������� ����������� ��� ������ �������� � �������� �������.
//+--------------------------------------------------------------------------------------------------------------+
extern string _Add_Op = "����������� ��������� �����������";
//---
extern string _AddOpenFilters = "---";
extern int FilterATR = 6; //--- (0 1 10) �������� �� ���� �� ATR ��� Buy � Sell (if (iATR_Signal <= FilterATR * pp) return (0);) (!) ����� �� ������
extern double iCCI_OpenFilter = 150; //--- (100 10 400) ������ �� iCCI ��� Buy � Sell. ��� ����������� ��� JPY ������������ ������ �� ������� (100 50 4000)

extern string _CloseOrderFilters = "---";
//---
extern int Price_Filter_Close = 14; //--- (10 2 20) ������ ���� �������� ��� �������� Buy � Sell (�����)
extern int iWPR_Filter_Close =  90; //--- (0 1 -100) ������ WPR ��� �������� Buy � Sell

//+--------------------------------------------------------------------------------------------------------------+
//| ����������� ���������
//+--------------------------------------------------------------------------------------------------------------+

extern string _Add = "����������� ���������";
extern bool Long = TRUE; //--- ����������� ������� �������
extern bool Short = TRUE; //--- ����������� �������� �������
extern int NormalizeLot = 2; //--- ������������ ���� ���� ���.��� =0.1 �� =1 ���� �� =0.01 �� =2
extern double MaxSpread = 2;
extern double Slippage = 2;
extern int AccountBar =5;//--- ������ �������� � ���� =��
extern double Korrect =10;
extern bool AccountOrder =FALSE;//--- ���� ������� ��� ����. ��������������. ���� =true �� ��������� ������ �������� ���� =false �� ���
extern bool WriteLog = TRUE; //--- //--- ��������� ����������� ���� � ���������.
extern bool WriteDebugLog = TRUE; //--- ��������� ����������� ���� �� ������� � ���������.
extern bool PrintLogOnChart = TRUE; //--- ��������� ������������ �� ������� (��� ������������ ����������� �������������)
//+--------------------------------------------------------------------------------------------------------------+
//| ���� ������ ��������
//+--------------------------------------------------------------------------------------------------------------+
extern string News = "����� �������� �����";
extern bool   PAUSE_NEWS = FALSE;   //���� ��������� �����
extern double HOUR_START_PAUSE =14;//��� ������ �����
extern double HOUR_END_PAUSE = 1; //��� ��������� �����
extern double DEI_START_PAUSE = 5; //���� ������ �����
extern double DEI_END_PAUSE = 1;   //���� ��������� �����
extern double START_PAUSE =0;      //����� � ���� ������ ����������� �������� 
extern double END_PAUSE = 6;       //����� ��������� ����������� �������� 

extern int MagicNumber = 777;
extern int MagicNumber1 = 888;

extern color LC1=Gold;
extern color LC=Lime;
//+--------------------------------------------------------------------------------------------------------------+
//| ���� �������������� ����������
//+--------------------------------------------------------------------------------------------------------------+

double pp;
int pd,z=0,K;
double cf;
string EASymbol; //--- ������� ������
double CloseSlippage = 3; //--- ��������������� ��� �������� ������
int SP;
int CloseSP;
int MaximumTrades = 1;
double NDMaxSpread; //--- ������������ ����� ����� �������
bool CheckSpreadRule; //--- ������� ��� �������� ������ ����� ��������� (������������� ������������ ��������� � ����������� ������)
string OpenOrderComment = "WSFR";
int RandomOpenTimePercent = 0; //--- ������������ ��� ������� ������ ������� ���������, ����������� ��������� �����. ���������� � ��������.
//---

//--- ��������� ��� ��������
double MinLot = 0.01;
double MaxLot = 0.01;
double LotStep = 0.01;
int LotValue = 100000;
double FreeMargin = 1000.0;
double LotPrice = 1;
double LotSize;

//--- ��������� �� ��������

int iWPR_Filter_OpenLong_a;
int iWPR_Filter_OpenLong_b;
int iWPR_Filter_OpenShort_a;
int iWPR_Filter_OpenShort_b;

//--- ��������� �� ��������

int iWPR_Filter_CloseLong;
int iWPR_Filter_CloseShort;

//---
color OpenBuyColor = Green;
color OpenSellColor = Red;
color CloseBuyColor = DodgerBlue;
color CloseSellColor = DeepPink;
//---
bool SoundAlert = TRUE; //--- �������� ���������� �� ��������/�������� ������
string SoundFileAtOpen = "alert.wav";
string SoundFileAtClose = "alert.wav";
int Dist = 1; //--- �������������� ������ �������� ���� ����� �������� ������.
bool OpenAddOrderRule = FALSE; //--- ��� ��������� ������ �������� ����� ������ �� ����� �� ����� �����������. ���������� ���� �� ������ ���������� ��������, �� �� ������ ����� �������� ����� �������� �� ������.
///////////////////////////////////////////

//+--------------------------------------------------------------------------------------------------------------+
//| INIT. ������������� ��������� ����������, �������� �������� �� �������.
//+--------------------------------------------------------------------------------------------------------------+
void init() {
//+--------------------------------------------------------------------------------------------------------------+
   //---
   if (IsTesting() && !IsVisualMode()) PrintLogOnChart = FALSE; //--- ���� ���������, �� ����������� ����������� �� �������
   if (!PrintLogOnChart) Comment("");
   //---
   EASymbol = Symbol(); //--- ������������� �������� �������
   //---
   if (Digits < 4) {
      pp = 0.01;
      pd = 2;
      cf = 0.009;
      
   } else {
      pp = 0.0001;
      pd = 4;
      cf = 0.00009;
   }
   if (Digits == 4)K=1;
   if (Digits == 5)K=10;
   if (Digits == 3)K=Korrect;
   if (Digits == 2)K=Korrect/10;
   //---
   SP = Slippage * MathPow(10, Digits - pd); //--- ������ ��������������� ���� ��� ���������
   CloseSP = CloseSlippage * MathPow(10, Digits - pd);
   NDMaxSpread = NormalizeDouble(MaxSpread * pp, pd + 1); //--- �������������� �������� MaxSpread � ������
   
   //--- ������������� ���������� ��� MM
   
   MinLot = MarketInfo(Symbol(), MODE_MINLOT);
   MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   if(MaxLot > MaximalLot)MaxLot = MaximalLot;
   LotValue = MarketInfo(Symbol(), MODE_LOTSIZE);
   LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   FreeMargin = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
   
   //--- ��������� �������� ��������� ���� ����������� ������� ������ �� ���������� ������ �������.
   double SymbolBid = 0;
   if (StringSubstr(AccountCurrency(), 0, 3) == "JPY") {
      SymbolBid = MarketInfo("USDJPY" + StringSubstr(Symbol(), 6), MODE_BID);
      if (SymbolBid > 0.1) LotPrice = SymbolBid;
      else LotPrice = 84;
   }
   //---
   if (StringSubstr(AccountCurrency(), 0, 3) == "GBP") {
      SymbolBid = MarketInfo("GBPUSD" + StringSubstr(Symbol(), 6), MODE_BID);
      if (SymbolBid > 0.1) LotPrice = 1 / SymbolBid;
      else LotPrice = 0.6211180124;
   }
   //---
   if (StringSubstr(AccountCurrency(), 0, 3) == "EUR") {
      SymbolBid = MarketInfo("EURUSD" + StringSubstr(Symbol(), 6), MODE_BID);
      if (SymbolBid > 0.1) LotPrice = 1 / SymbolBid;
      else LotPrice = 0.7042253521;
   }
   

       //--- ��������� �� ��������
   
   iWPR_Filter_OpenLong_a = iWPR_LONG_Open_a;
   iWPR_Filter_OpenLong_b = iWPR_LONG_Open_b;
   iWPR_Filter_OpenShort_a = 100 - iWPR_Short_Open_a;
   iWPR_Filter_OpenShort_b = 100 - iWPR_Short_Open_b;

   //--- ��������� �� ��������
   
   iWPR_Filter_CloseLong = iWPR_Filter_Close;
   iWPR_Filter_CloseShort = 100 - iWPR_Filter_Close;
   //---
   return (0);
   
}

//+--------------------------------------------------------------------------------------------------------------+
//| DEINIT. �������� �������� �� �������.
//+--------------------------------------------------------------------------------------------------------------+
int deinit() {
//+--------------------------------------------------------------------------------------------------------------+

   if (ObjectFind("BKGR") >= 0) ObjectDelete("BKGR");
   if (ObjectFind("BKGR2") >= 0) ObjectDelete("BKGR2");
   if (ObjectFind("BKGR3") >= 0) ObjectDelete("BKGR3");
   if (ObjectFind("BKGR4") >= 0) ObjectDelete("BKGR4");
   if (ObjectFind("LV") >= 0) ObjectDelete("LV");
   //---
   return (0);
   
}

//+--------------------------------------------------------------------------------------------------------------+
//| START. �������� �� ������, � ����� ����� ������� Scalper.
//+--------------------------------------------------------------------------------------------------------------+
int start() {
//+--------------------------------------------------------------------------------------------------------------+
 // �����......................................................
  int pa =0;
  if(Hour()>= START_PAUSE&&Hour()<END_PAUSE&& START_PAUSE>0)
    {pa=1;}
  if(DayOfWeek()>=DEI_START_PAUSE&&Hour()>=HOUR_START_PAUSE && PAUSE_NEWS == true)
    {pa=1;}
  if(DayOfWeek()<=DEI_END_PAUSE&&Hour()<=HOUR_END_PAUSE && PAUSE_NEWS == true )
    {pa=1;}
   if( pa==1)
    {
    ObjectCreate("P", OBJ_LABEL, 0, 0, 0, 0, 0);
    ObjectSet("P", OBJPROP_CORNER, 2);
    ObjectSet("P", OBJPROP_YDISTANCE, 75);
    ObjectSet("P", OBJPROP_XDISTANCE, 10);
    ObjectSetText("P", "�������! " , 20, "Tahoma", Red);  
    }  
    if( pa==0) ObjectDelete("P"); 
   CloseOrders(); //--- ������������� �������
   ModifyOrders(); //--- ����� � ���������
   if(OrderDOP > 0)Dmarket(pa);
   if(LimitOrder > 0)Dlimit(pa);
   if(StopOrder > 0)Dstop(pa);
   if(ModifDOP == TRUE)Grafik();
   if((Ask-Bid)>MaxSpread*Point*K)
   {
    ObjectCreate("Spread", OBJ_LABEL, 0, 0, 0, 0, 0);
    ObjectSet("Spread", OBJPROP_CORNER, 2);
    ObjectSet("Spread", OBJPROP_YDISTANCE, 45);
    ObjectSet("Spread", OBJPROP_XDISTANCE, 10);
    ObjectSetText("Spread", "Spread ! " + DoubleToStr((Ask - Bid) / Point, 0), 20, "Tahoma", Red);  
   }
   if((Ask-Bid)<MaxSpread*Point*K)ObjectDelete("Spread");
   if (TICK>0&&iVolume(Symbol(),1,0)>TICK)return(0);
   //--- ������������� ������ �����
   if (AutoMM > 0.0 && (!RecoveryMode)) LotSize = MathMax(MinLot, MathMin(MaxLot, MathCeil(MathMin(AutoMM_Max, AutoMM) / LotPrice / 100.0 * AccountFreeMargin() / LotStep / (LotValue / 100)) * LotStep));
   if (AutoMM > 0.0 && RecoveryMode) LotSize = CalcLots(); //--- ���� ������� RecoveryMode ���������� CalcLots
   if (AutoMM == 0.0) LotSize = FixedLot;
   
   //--- �������� ������� ������������ ������ ��� ���������� M15
   //if(iBars(Symbol(), PERIOD_M15) < iMA_Period || iBars(Symbol(), PERIOD_M15) < iWPR_Period || iBars(Symbol(), PERIOD_M15) < iATR_Period || iBars(Symbol(), PERIOD_M15) < iCCI_Period)
   //{
      //Print("������������ ������������ ������ ��� ��������");
     // return;
   // }
   //---
   if (DayOfWeek() == 1 && iVolume(NULL, PERIOD_D1, 0) < 5.0) return (0);
   if (StringLen(EASymbol) < 6) return (0);   
   //---
   if ((!IsTesting()) && IsStopped()) return (0);
   if ((!IsTesting()) && !IsTradeAllowed()) return (0);
   if ((!IsTesting()) && IsTradeContextBusy()) return (0);
   //---
   HideTestIndicators(FALSE);
   //---���������_���������_1==TRUE&&0.03
   //if(iATR(Symbol(),15,3,0)>iATR(Symbol(),15,3,3)&&iATR(Symbol(),1440,1,0)>0.001)//||(iATR(Symbol(),15,2,0)<0.001&&iATR(Symbol(),1440,1,0)>iATR(Symbol(),1440,1,1)))
  // {
   if(pa==0)Scalper();
  // }
   //---
//////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////   
   return (0);
}

//+--------------------------------------------------------------------------------------------------------------+
//| Scalper. �������� �������. ������� ������������ �������� ������, ����� �������� �������� �� ����.
//+--------------------------------------------------------------------------------------------------------------+
void Scalper() {
//+--------------------------------------------------------------------------------------------------------------+
    
   //--- ��������� � ����������� ������
   if (MaxSpreadFilter()) {
      if (!CheckSpreadRule && WriteDebugLog) {
         //---
         Print("�������� ������ �������� ��-�� �������� ������.");
         Print("������� ����� = ", DoubleToStr((Ask - Bid) / pp, 1), ",  MaxSpread = ", DoubleToStr(MaxSpread, 1));
         Print("������� ����� ��������� �����, ����� ����� ������ ����������.");
         }
         //---
      CheckSpreadRule = TRUE;
      //---
      } else {
      //---
      CheckSpreadRule = FALSE;
      if (OpenLongSignal() && OpenTradeCount() && Long) OpenPosition(OP_BUY);
      if (OpenShortSignal() && OpenTradeCount() && Short) OpenPosition(OP_SELL);
      
   } //--- �������� if (MaxSpreadFilter)
  return (0);
}

//+--------------------------------------------------------------------------------------------------------------+
//| OpenPosition. ������� �������� �������.
//+--------------------------------------------------------------------------------------------------------------+
int OpenPosition(int OpType) {
//+--------------------------------------------------------------------------------------------------------------+
   int bl=0,sl=0,bs=0,ss=0,rb=0,rs=0;
   for (int i = OrdersTotal() - 1; i >= 0; i--)
    {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()) 
    {    
    if (OrderType()==OP_BUYLIMIT&&OrderMagicNumber()==MagicNumber)bl=1;
    if (OrderType()==OP_SELLLIMIT&&OrderMagicNumber()==MagicNumber)sl=1;
    if (OrderType()==OP_SELLSTOP&&OrderMagicNumber()==MagicNumber)ss=1;
    if (OrderType()==OP_BUYSTOP&&OrderMagicNumber()==MagicNumber)bs=1;
    //if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber&&100<TimeCurrent()-OrderOpenTime())rb=1;
    //if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber&&100<TimeCurrent()-OrderOpenTime())rs=1;
    }
    }
   int B=0,S=0;
   int RandomOpenTime; //--- �������� �� ������� �� ��������
   double DistLevel; //--- ���� ������� ��� �������. ���������� ��� �������� ��������� ��������
   color OpenColor; //--- ���� �������� �������. ���� Buy �� �������, ���� Sell �� �������
   int OpenOrder; //--- �������� �������
   int OpenOrderError; //--- ������ ��������
   string OpTypeString; //--- �������������� ���� ������� � ��������� ��������
   double OpenPrice; //--- ���� ��������
   //---
   double TP, SL;
   double OrderTP = NormalizeDouble (TakeProfit * pp , pd); //--- ����������� ����-������ � ��� Points
   double OrderSL = NormalizeDouble (StopLoss * pp , pd); //--- ����������� ����-���� � ��� Points
     
   //--- �������� � �������� ����� ����������
   if (RandomOpenTimePercent > 0) {
      MathSrand(TimeLocal());
      RandomOpenTime = MathRand() % RandomOpenTimePercent;
      
      if (WriteLog) {
      Print("DelayRandomiser: �������� ", RandomOpenTime, " ������.");
      }
      
      Sleep(1000 * RandomOpenTime);
   } //--- �������� if (RandomOpenTimePerc
   
   double OpenLotSize = LotSize; //--- ������ ������ �������
   if (StartLot>0)OpenLotSize=StartLot;
   //--- ���� �� ������ �������, ���������� ������
   if (AccountFreeMarginCheck(EASymbol, OpType, OpenLotSize) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) {
      //---
      if (WriteDebugLog) {
      //---
         Print("��� �������� ������ ������������ ��������� �����.");
         Comment("��� �������� ������ ������������ ��������� �����.");
      //---
      }
      return (-1);
   } //--- �������� if (AccountFreeMarginCheck  
   
   RefreshRates();
   
   //--- ���� ������� �������, ��
   if (OpType == OP_BUY) {
      B=1;
      OpenPrice = NormalizeDouble(Ask, Digits);
      OpenColor = OpenBuyColor;
      
      //---
      if (UseStopLevels) { //--- ���� �������� ����-������ (����-���� � ����-������)
      
      TP = NormalizeDouble(OpenPrice + OrderTP, Digits); //--- �� ����������� ����-������
      SL = NormalizeDouble(OpenPrice - OrderSL, Digits); //--- � ����-����
      //---
      } else {TP = 0; SL = 0;}
   
   //--- ���� �������� �������, ��   
   } else {
      S=1;
      OpenPrice = NormalizeDouble(Bid, Digits);
      OpenColor = OpenSellColor;
      
      //---
      if (UseStopLevels) {
       
      TP = NormalizeDouble(OpenPrice - OrderTP, Digits);
      SL = NormalizeDouble(OpenPrice + OrderSL, Digits);
      }
      //---
      else {TP = 0; SL = 0;}
   }
   
   int MaximumTradesCount = MaximumTrades; //--- ������� �������� �������
   while (MaximumTradesCount > 0 && OpenTradeCount()) { //--- ���� MaximumTrades ����� ������ 1-��, �� ���������� ��������
      //---OpenOrder =
      if (MarketOrder==TRUE&&B==1)OrderSend(EASymbol, OP_BUY, OpenLotSize, NormalizeDouble(Ask, Digits), SP, 0, 0, OpenOrderComment, MagicNumber, 0, OpenColor);
      if (MarketOrder==TRUE&&S==1)OrderSend(EASymbol, OP_SELL, OpenLotSize, NormalizeDouble(Bid, Digits), SP, 0, 0, OpenOrderComment, MagicNumber, 0, OpenColor);
      if (LimitOrder>0&&B==1&&bl==0)OrderSend(EASymbol, OP_BUYLIMIT, OpenLotSize, NormalizeDouble(Bid-LimitOrder*Point*K, Digits), SP, 0, 0, OpenOrderComment, MagicNumber, 0, OpenColor);
      if (LimitOrder>0&&S==1&&sl==0)OrderSend(EASymbol, OP_SELLLIMIT, OpenLotSize, NormalizeDouble(Ask+LimitOrder*Point*K, Digits), SP, 0, 0, OpenOrderComment, MagicNumber, 0, OpenColor);
      if (ReversOrder>0&&B==1&&ss==0)OrderSend(EASymbol, OP_SELLSTOP, KRevers*OpenLotSize, NormalizeDouble(Bid-ReversOrder*Point*K, Digits), SP, 0, 0,"R" , MagicNumber, TimeCurrent()+60*TimeRewers, OpenColor);
      if (ReversOrder>0&&S==1&&bs==0)OrderSend(EASymbol, OP_BUYSTOP, KRevers*OpenLotSize, NormalizeDouble(Ask+ReversOrder*Point*K, Digits), SP, 0, 0, "R", MagicNumber, TimeCurrent()+60*TimeRewers, OpenColor);

      //---&&rs==0 &&rb==0
      Sleep(MathRand() / 1000); //--- �������� � ��������� ������ ����� ��������
      //---
      if (OpenOrder < 0) { //--- ���� ����� �� ��������, ��
         OpenOrderError = GetLastError(); //--- ���������� ������
         //---
         if (WriteDebugLog) {
            if (OpType == OP_BUY) OpTypeString = "OP_BUY";
            else OpTypeString = "OP_SELL";
            Print("��������: OrderSend(", OpTypeString, ") ������ = ", ErrorDescription(OpenOrderError)); //--- ��� ������ �� �������
         } //--- �������� if (WriteDebugLog)
         
         //---
         if (OpenOrderError != 136/* OFF_QUOTES */) break; //--- ���� ��� ���, �� ���������� ����
         if (!(OpenAddOrderRule)) break; //--- ���� ��� ���������� �� �������� �������, �� ���������� ����
         //---
         Sleep(6000); //--- ������ �����
         RefreshRates(); //--- � ��������� ���������
         //---
         if (OpType == OP_BUY) DistLevel = NormalizeDouble(Ask, Digits); //--- �������� ����� ���� ������� � �������
         else DistLevel = NormalizeDouble(Bid, Digits);
         //---
         if (NormalizeDouble(MathAbs((DistLevel - OpenPrice) / pp), 0) > Dist) break; //--- ������� ���������� ���������� �������� ������� ����� ������� ������ � ����� ��������, ����� ���������� ���������� � �������� �� ��������� ���������� Dist
         //---
         OpenPrice = DistLevel; //--- �������� ����� �������� OpenPrice
         MaximumTradesCount--; //--- � �������� -1 �� �������� MaximumTrades
         
         //--- ���� ������� ������ ����, �� ������ ��������� � ���, ��� ����� ������� �����.
         if (MaximumTradesCount > 0) {
            if (WriteLog) {
            Print("... �������� ������� �����.");
         } } //--- �������� if (MaximumTradesCount
         //---
         } //--- �������� if (OpenOrder < 0)
         
         //--- �, ���� �� OpenOrder > 0, �� 
         else {
         if (OrderSelect(OpenOrder, SELECT_BY_TICKET)) OpenPrice = OrderOpenPrice();
         //---
         if (!(SoundAlert)) break; //--- ������������� �����, ���� �� �������
         PlaySound(SoundFileAtOpen);
         break;
      } //--- �������� else { ��� OpenOrder > 0
   } //--- �������� ����� while (MaximumTradesCount > 0)
   //---
   return (OpenOrder);
}

//+--------------------------------------------------------------------------------------------------------------+
//| ModifyOrders. ����������� ������� � ���������.
//+--------------------------------------------------------------------------------------------------------------+
void ModifyOrders() {
//+--------------------------------------------------------------------------------------------------------------+

   bool TicketModify; //--- �������� ������
   int total = OrdersTotal() - 1;
   int ModifyError ;
   int ModifyTicketID ;
   string ModifyOrderType ;
   //---
   for (int i = total; i >= 0; i--) { //--- ������� �������� �������
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
     // ModifyTicketID = OrderTicket();
     // ModifyOrderType = OrderType();
      if (OrderType() == OP_BUY) {
         if (OrderMagicNumber() == MagicNumber||OrderMagicNumber() == MagicNumber1 && OrderSymbol() == EASymbol&&OrderStopLoss()==0&&OrderTakeProfit()==0) {
             TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()- StopLoss*Point*K,Digits), NormalizeDouble(OrderOpenPrice()+TakeProfit*Point*K,Digits), 0, Blue);
           }
           }
      if (OrderType() == OP_SELL) {
         if (OrderMagicNumber() == MagicNumber||OrderMagicNumber() == MagicNumber1 && OrderSymbol() == EASymbol&&OrderStopLoss()==0&&OrderTakeProfit()==0) {
             TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+ StopLoss*Point*K,Digits), NormalizeDouble(OrderOpenPrice()-TakeProfit*Point*K,Digits), 0, Blue);
           }
           }
 //----------------------------------------------------------------------------------------------------------------------------------------------------
      if (OrderType() == OP_BUY) {
         if (OrderMagicNumber() == MagicNumber||OrderMagicNumber() == MagicNumber1 && OrderSymbol() == EASymbol&&OrderStopLoss()==0&&OrderTakeProfit()!=0) {
             TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()- StopLoss*Point*K,Digits), OrderTakeProfit(), 0, Blue);
           }
           }
      if (OrderType() == OP_SELL) {
         if (OrderMagicNumber() == MagicNumber||OrderMagicNumber() == MagicNumber1 && OrderSymbol() == EASymbol&&OrderStopLoss()==0&&OrderTakeProfit()!=0) {
             TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+ StopLoss*Point*K,Digits), OrderTakeProfit(), 0, Blue);
           }
           }
      if (OrderType() == OP_BUY) {
         if (OrderMagicNumber() == MagicNumber||OrderMagicNumber() == MagicNumber1 && OrderSymbol() == EASymbol&&OrderStopLoss()!=0&&OrderTakeProfit()==0) {
             TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(),OrderStopLoss(), NormalizeDouble(OrderOpenPrice()+TakeProfit*Point*K,Digits), 0, Blue);
           }
           }
      if (OrderType() == OP_SELL) {
         if (OrderMagicNumber() == MagicNumber||OrderMagicNumber() == MagicNumber1 && OrderSymbol() == EASymbol&&OrderStopLoss()!=0&&OrderTakeProfit()==0) {
             TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(),OrderStopLoss(), NormalizeDouble(OrderOpenPrice()-TakeProfit*Point*K,Digits), 0, Blue);
           }
           }
      
 //----------------------------------------------------------------------------------------------------------------------------------------------------
      //--- ����������� ������ �� �������
      if (OrderType() == OP_BUY) {
         if (OrderMagicNumber() == MagicNumber||OrderMagicNumber() == MagicNumber1 && OrderSymbol() == EASymbol) {
            if (Bid - OrderOpenPrice() > SecureProfitTriger * pp && MathAbs(OrderOpenPrice() + SecureProfit * pp - OrderStopLoss()) >= Point
             &&NormalizeDouble(OrderOpenPrice() + SecureProfit * pp, Digits)-Point>=OrderStopLoss()) {
            //--- ������������ �����
            TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + SecureProfit * pp, Digits), OrderTakeProfit(), 0, Blue);
              if (!TicketModify){
              ModifyError = GetLastError();
              if (WriteDebugLog) Print("��������� ������ �� ����� ����������� ������ (", ModifyOrderType, ",", ModifyTicketID, "). �������: ", ErrorDescription(ModifyError));
              }
            }
          }
        } //--- �������� if (OrderType() == OP_BUY)
      
      //--- ����������� ������ �� �������
      if (OrderType() == OP_SELL) {
         if (OrderMagicNumber() == MagicNumber||OrderMagicNumber() == MagicNumber1 && OrderSymbol() == EASymbol) {
            if (OrderOpenPrice() - Ask > SecureProfitTriger * pp && MathAbs(OrderOpenPrice() - SecureProfit * pp - OrderStopLoss()) >= Point
            &&NormalizeDouble(OrderOpenPrice() - SecureProfit * pp, Digits)+Point<=OrderStopLoss()) {
            //--- ������������ �����
            TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - SecureProfit * pp, Digits), OrderTakeProfit(), 0, Red);
              if (!TicketModify){
              ModifyError = GetLastError();
              if (WriteDebugLog) Print("��������� ������ �� ����� ����������� ������ (", ModifyOrderType, ",", ModifyTicketID, "). �������: ", ErrorDescription(ModifyError));
              }
            }
          }
        } //--- �������� if (OrderType() == OP_SELL)
   
//................................................................................................
    if(TrailingStop>1&&(OrderMagicNumber()== MagicNumber||OrderMagicNumber()== MagicNumber1))
    {
      if(OrderType() == OP_SELL&&OrderOpenPrice() - Ask > Utral*Point*K)
      {
        if(TrailingStop> 0&&TrailingStop > 1)
        {
          if(OrderOpenPrice() - Ask >  TrailingStop * Point*K)
          {            
            if(OrderStopLoss()-Point* TrailingStep*K > (Ask + Point* TrailingStop*K)&&Ask + Point * TrailingStop*K<=OrderStopLoss()-Point)
            {           
              OrderModify(OrderTicket(), OrderOpenPrice(), Ask + Point * TrailingStop*K,
               OrderTakeProfit(),0, CLR_NONE);
              // return(0);
            }
          }
        }
      }
      else
        if(OrderType() == OP_BUY&&Bid - OrderOpenPrice() > Utral*Point*K)//||OrderMagicNumber()== MAGIC1)
        {
          if(TrailingStop > 0&&TrailingStop > 1)         
          {
            if(Bid - OrderOpenPrice() > TrailingStop * Point*K)
            {
              if(OrderStopLoss()+Point* TrailingStep*K < (Bid - Point * TrailingStop*K)&&Bid - Point * TrailingStop*K>=OrderStopLoss()+Point)
              {
                OrderModify(OrderTicket(), OrderOpenPrice(), Bid - Point * TrailingStop*K,
                  OrderTakeProfit() ,0, CLR_NONE);
                //  return(0);
              }
            }
          }
        }
      }
//-----------------------------------------------------------------------------       
     if(TrailingStop<1&&(OrderMagicNumber()== MagicNumber||OrderMagicNumber()== MagicNumber1))
     {
      if(OrderType() == OP_SELL&&TrailingStop < 1)
      {
        if(TrailingStop> 0)
        {
          if(OrderOpenPrice() - Ask > Utral*Point*K)
          {            
            if(OrderStopLoss()-Point* TrailingStep*K > Ask + (OrderOpenPrice()-Ask)*TrailingStop&& Ask + (OrderOpenPrice()-Ask)*TrailingStop<=OrderStopLoss()-Point)
            {           
              OrderModify(OrderTicket(), OrderOpenPrice(), Ask + (OrderOpenPrice()-Ask)*TrailingStop,
               OrderTakeProfit(),0, CLR_NONE);
              // return(0);
            }
          }
        }
      }
      else
        if(OrderType() == OP_BUY)
        {
          if(TrailingStop > 0&&TrailingStop < 1)         
          {
            if(Bid - OrderOpenPrice() > Utral*Point*K)
            {
              if(OrderStopLoss()+Point* TrailingStep*K  < Bid - (Bid - OrderOpenPrice())*TrailingStop&&Bid - (Bid - OrderOpenPrice())*TrailingStop>=OrderStopLoss()+Point)
              {
                OrderModify(OrderTicket(), OrderOpenPrice(), Bid - (Bid - OrderOpenPrice())*TrailingStop ,
                  OrderTakeProfit() ,0, CLR_NONE);
                  
              }
            }
          }
        }
      }
//'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    }
  } //--- �������� for (int i = total - 1; i >= 0; i--)
  return ;
}

//+--------------------------------------------------------------------------------------------------------------+
//| CloseTrades. ����������� ����-������ � ����-����.
//| ���� �������� ������� UseStopLevels, �� ������������ ��� ������� ���������� ��������.
//+--------------------------------------------------------------------------------------------------------------+
void CloseOrders() {
//+--------------------------------------------------------------------------------------------------------------+
   int c =0,c1=0;
   bool TicketClose; //--- �������� ������
   int total = OrdersTotal() - 1;
   int OpenLongOrdersCount = 0;
   int OpenShortOrdersCount = 0;
   int MaxCount = 3;
   int CloseError ;
   int CloseTicketID ;
   string CloseOrderType ;
   int MinCount;
   //---
   for (int i = total; i >= 0; i--) { //--- ������� �������� �������
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      CloseTicketID = OrderTicket();
      CloseOrderType = OrderType();
      //--- �������� �� ������� ��� ����� ������� �� �������
      if (OrderMagicNumber() == MagicNumber||OrderMagicNumber() == MagicNumber1)
      {
      if (OrderType() == OP_BUY&&OrderSymbol() == EASymbol) {
      OpenLongOrdersCount++;
               if ( CloseOnlyProfit==FALSE)
               {
               if (Bid >= OrderOpenPrice() + TakeProfit * pp || Bid <= OrderOpenPrice() - StopLoss * pp || CloseLongSignal(OrderOpenPrice(), ExistPosition())) 
               {
               for ( MinCount = 1; MinCount <= MathMax(1, MaxCount); MinCount++) 
               {
               RefreshRates();
               if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), CloseSP, CloseBuyColor)) 
               {
               OpenLongOrdersCount--; //--- �������� �������
               break;       
               } 
               else 
               {
               CloseError = GetLastError();
               if (WriteDebugLog) Print("��������� ������ �� ����� �������� ������ (",CloseOrderType, ",", CloseTicketID, "). �������: ", ErrorDescription(CloseError));
               }
               }
            }
         }
         if ( CloseOnlyProfit==TRUE)
               {
               if (Bid>=OrderOpenPrice()+K*Point&&(Bid >= OrderOpenPrice() + TakeProfit * pp || Bid <= OrderOpenPrice() - StopLoss * pp || CloseLongSignal(OrderOpenPrice(), ExistPosition()))) 
               {
               for ( MinCount = 1; MinCount <= MathMax(1, MaxCount); MinCount++) 
               {
               RefreshRates();
               if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), CloseSP, CloseBuyColor)) 
               {
               OpenLongOrdersCount--; //--- �������� �������
               break;       
               } 
               else 
               {
               CloseError = GetLastError();
               if (WriteDebugLog) Print("��������� ������ �� ����� �������� ������ (",CloseOrderType, ",", CloseTicketID, "). �������: ", ErrorDescription(CloseError));
               }
               }
            }
         }
      } //--- �������� if (OrderType() == OP_BUY)
      
      //--- �������� �� ������� ��� ����� ������� �� �������
      if (OrderType() == OP_SELL&&OrderSymbol() == EASymbol) {
      OpenShortOrdersCount++;
            if (CloseOnlyProfit==FALSE ) 
               {
            if (Ask <= OrderOpenPrice() - TakeProfit * pp || Ask >= OrderOpenPrice() + StopLoss * pp || CloseShortSignal(OrderOpenPrice(), ExistPosition())) 
               {
               for (MinCount = 1; MinCount <= MathMax(1, MaxCount); MinCount++)
               {
               RefreshRates();
               if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), CloseSP, CloseSellColor)) 
               {
               OpenShortOrdersCount--; //--- �������� �������
               break;
               } 
               else {
               CloseError = GetLastError();
               if (WriteDebugLog) Print("��������� ������ �� ����� �������� ������ (",CloseOrderType, ",", CloseTicketID, "). �������: ", ErrorDescription(CloseError));
                }
              }
            }
          }
          if (CloseOnlyProfit==TRUE ) 
               {
            if (Ask<=OrderOpenPrice()-K*Point&&(Ask <= OrderOpenPrice() - TakeProfit * pp || Ask >= OrderOpenPrice() + StopLoss * pp || CloseShortSignal(OrderOpenPrice(), ExistPosition()))) 
               {
               for (MinCount = 1; MinCount <= MathMax(1, MaxCount); MinCount++)
               {
               RefreshRates();
               if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), CloseSP, CloseSellColor)) 
               {
               OpenShortOrdersCount--; //--- �������� �������
               break;
               } 
               else {
               CloseError = GetLastError();
               if (WriteDebugLog) Print("��������� ������ �� ����� �������� ������ (",CloseOrderType, ",", CloseTicketID, "). �������: ", ErrorDescription(CloseError));
                }
              }
            }
          }
        } //--- �������� if (OrderType() == OP_SELL)
      } 
   } //--- �������� for (int i = total - 1; i >= 0; i--) {
}
return ;
}

//+--------------------------------------------------------------------------------------------------------------+
//| OpenLongSignal. ������ �� �������� ������� �������.
//+--------------------------------------------------------------------------------------------------------------+
bool OpenLongSignal() {
//+--------------------------------------------------------------------------------------------------------------+
int zp = 0;
bool result = false;
bool result1 = false;
bool result2 = false;
bool result3 = false;

//--- ������ �������� �������� �� ����
double iClose_Signal = iClose(NULL,PERIOD_M15, 1);
double iMA_Signal = iMA(NULL, PERIOD_M15, iMA_PeriodLONG, 0, MODE_SMMA, PRICE_HIGH, 1);
double iWPR_Signal = iStochastic(NULL, PERIOD_M15,iWPR_PeriodLONG,1,1, MODE_SMA, 0, MODE_MAIN,1);//iWPR(NULL, PERIOD_M15, iWPR_Period, 1);
double iATR_Signal = iATR(NULL, PERIOD_M15, iATR_PeriodLONG, 1);
double iCCI_Signal = iCCI(NULL,PERIOD_M15 , iCCI_PeriodLONG, PRICE_TYPICAL, 1);
//---
double iMA_Filter_a = NormalizeDouble(iMA_LONG_Open_a*pp,pd);
double iMA_Filter_b = NormalizeDouble(iMA_LONG_Open_b*pp,pd);
double BidPrice = Bid; //--- (iClose_Signal >= BidPrice) ��������� ��� ������ � Bid (� �� � Ask, ��� ������ ����), ��� ��� ���� �������� ����� iClose_Signal ����������� �� ��������� �������� Bid
//---
double W  = iWPR(NULL,1,11,0);
double W1  = iWPR(NULL,1,11,1);
double V  = iWPR(NULL,1,11,0);
double V1  = iWPR(NULL,1,11,1);
double CC  = iCCI(NULL,1,18,0,0);
double CC1  = iCCI(NULL,5,18,0,0);
//--- ������� ������ �� ��� � ��� ��������
if (iATR_Signal <= FilterATR * pp) return (0);
//---
if (iClose_Signal - iMA_Signal > iMA_Filter_a && iClose_Signal - BidPrice >= - cf && iWPR_Filter_OpenLong_a > iWPR_Signal) result1 = true;
else result1 = false;
//---
if (iClose_Signal - iMA_Signal > iMA_Filter_b && iClose_Signal - BidPrice >= - cf && - iCCI_OpenFilter > iCCI_Signal) result2 = true;
else result2 = false;
//---
if (iClose_Signal - iMA_Signal > iMA_Filter_b && iClose_Signal - BidPrice >= - cf && iWPR_Filter_OpenLong_b > iWPR_Signal) result3 = true;
else result3 = false;
//---
if ((W<-70&&V<-60)||(CC<-150&&CC1<-150)&&(result1 == true || result2 == true || result3 == true)) result = true;
else result = false;
//---
return (result);

}

//+--------------------------------------------------------------------------------------------------------------+
//| OpenShortSignal. ������ �� �������� �������� �������.
//+--------------------------------------------------------------------------------------------------------------+
bool OpenShortSignal() {
//+--------------------------------------------------------------------------------------------------------------+
int zp = 0;
bool result = false;
bool result1 = false;
bool result2 = false;
bool result3 = false;

//--- ������ �������� �������� �� ����
double iClose_Signal = iClose(NULL,PERIOD_M15 , 1);
double iMA_Signal = iMA(NULL, PERIOD_M15, iMA_PeriodShort, 0, MODE_SMMA, PRICE_LOW, 1);
double iWPR_Signal = iStochastic(NULL, PERIOD_M15,iWPR_PeriodShort,1,1, MODE_SMA, 0, MODE_MAIN,1);//iWPR(NULL, PERIOD_M15, iWPR_Period, 1);
double iATR_Signal = iATR(NULL, PERIOD_M15, iATR_PeriodShort, 1);
double iCCI_Signal = iCCI(NULL, PERIOD_M15, iCCI_PeriodShort, PRICE_TYPICAL, 1);
//---
double iMA_Filter_a = NormalizeDouble(iMA_Short_Open_a*pp,pd);
double iMA_Filter_b = NormalizeDouble(iMA_Short_Open_b*pp,pd);
double BidPrice = Bid;
//---
double W  = iWPR(NULL,1,11,0);
double W1  = iWPR(NULL,1,11,1);
double V  = iWPR(NULL,1,11,0);
double V1  = iWPR(NULL,1,11,1);
double CC  = iCCI(NULL,1,18,0,0);
double CC1  = iCCI(NULL,5,18,0,0);
//--- ������� ������ �� ��� � ��� ��������
if (iATR_Signal <= FilterATR * pp) return (0);
//---
if (iMA_Signal - iClose_Signal > iMA_Filter_a && iClose_Signal - BidPrice <= cf && iWPR_Signal > iWPR_Filter_OpenShort_a) result1 = true;
else result1 = false;
//---
if (iMA_Signal - iClose_Signal > iMA_Filter_b && iClose_Signal - BidPrice <= cf && iCCI_Signal > iCCI_OpenFilter) result2 = true;
else result2 = false;
//---
if (iMA_Signal - iClose_Signal > iMA_Filter_b && iClose_Signal - BidPrice <= cf && iWPR_Signal > iWPR_Filter_OpenShort_b) result3 = true;
else result3 = false;
//---
if ((W>-30&&V>-40)||(CC>150&&CC1>150)&&(result1 == true || result2 == true || result3 == true)) result = true;
else result = false;
//---
return (result);

}

//+--------------------------------------------------------------------------------------------------------------+
//| CloseLongSignal. ������ �� �������� ������� �������.
//+--------------------------------------------------------------------------------------------------------------+
bool CloseLongSignal(double OrderPrice, int CheckOrders) {
//+--------------------------------------------------------------------------------------------------------------+

bool result = false;
bool result1 = false;
bool result2 = false;
//---
double iWPR_Signal = iStochastic(NULL, 15,iWPR_PeriodLONG,1,1, MODE_SMA, 0, MODE_SIGNAL,1);//iWPR(NULL, PERIOD_M15, iWPR_Period, 1);
double iClose_Signal = iClose(NULL, PERIOD_M15, 1);
double iOpen_CloseSignal = iOpen(NULL, PERIOD_M1, 1);
double iClose_CloseSignal = iClose(NULL, PERIOD_M1, 1);
//---
double MaxLoss = NormalizeDouble(-MaxLossPoints * pp,pd);
//---
double Price_Filter = NormalizeDouble(Price_Filter_Close*pp,pd);
double BidPrice = Bid;
//---

//---
if (OrderPrice - BidPrice <= MaxLoss && iClose_Signal - BidPrice <= cf && iWPR_Signal > iWPR_Filter_CloseLong && CheckOrders == 1) result1 = true;
else result1 = false;
//---
if (iOpen_CloseSignal > iClose_CloseSignal && BidPrice - OrderPrice >= Price_Filter && CheckOrders == 1) result2 = true;
else result2 = false;
//---
if (result1 == true || result2 == true) result = true;
else result = false;
//---
return (result);

}

//+--------------------------------------------------------------------------------------------------------------+
//| CloseShortSignal. ������ �� �������� �������� �������.
//+--------------------------------------------------------------------------------------------------------------+
bool CloseShortSignal(double OrderPrice, int CheckOrders) {
//+--------------------------------------------------------------------------------------------------------------+

bool result = false;
bool result1 = false;
bool result2 = false;
//---
double iWPR_Signal = iStochastic(NULL, 15,iWPR_PeriodShort,1,1, MODE_SMA, 0, MODE_SIGNAL,1);//iWPR(NULL, PERIOD_M15, iWPR_Period, 1);
double iClose_Signal = iClose(NULL, PERIOD_M15, 1);
double iOpen_CloseSignal = iOpen(NULL, PERIOD_M1, 1);
double iClose_CloseSignal = iClose(NULL, PERIOD_M1, 1);
//---
double MaxLoss = NormalizeDouble(-MaxLossPoints*pp,pd);
//---
double Price_Filter = NormalizeDouble(Price_Filter_Close*pp,pd);
double BidPrice = Bid;
double AskPrice = Ask;
//---

//---
if (AskPrice - OrderPrice <= MaxLoss && iClose_Signal - BidPrice >= - cf && iWPR_Signal < iWPR_Filter_CloseShort && CheckOrders == 1) result1 = true;
else result1 = false;
//---
if (iOpen_CloseSignal < iClose_CloseSignal && OrderPrice - AskPrice >= Price_Filter && CheckOrders == 1) result2 = true;
else result2 = false;
//---
if (result1 == true || result2 == true) result = true;
else result = false;
//---
return (result);

}

//+--------------------------------------------------------------------------------------------------------------+
//| CalcLots. ������� ������� ������ ����.
//| ��� AutoMM > 0.0 && RecoveryMode ������� CalcLots ����������� ����� ���� ������������ ��������� �������.
//| 
//| ����� ������ ���� ������������� ������ �� ����� �������� � ������� �������. �� ���� ���������� ���� ������
//| ������� �� ������ �� ��������� �������, �� � �� ����� �������� � ������� ���������� �������.
//| 
//| ������ �������� ��, ������� ������������ ��� ������ �� ������������ ����� ����-������ ��� ����������
//| ��������� RecoveryMode, �� ����, ��� ������� ����� �������� ����� �������������� ��������.
//+--------------------------------------------------------------------------------------------------------------+
double CalcLots() {
//+--------------------------------------------------------------------------------------------------------------+

   double SumProfit; //--- ��������� ������
   int OldOrdersCount; //--- ������� ���-�� �������� ���������� �������
   double loss; //--- ��������
   int LossOrdersCount; //--- ����� ����� � �������
   double pr; //--- ������
   int ProfitOrdersCount; //--- ���-�� ���������� ������� � �������
   double LastPr; //--- ���������� �������� ������
   int LastCount; //--- ���������� �������� �������� �������
   double MultiLot = 1; //---  ��������� �������� ��������� ����
   //---
   
   //--- ���� �� �������, ��
   if (MultiLotPercent > 0.0 && AutoMM > 0.0) {
      
      //--- �������� ��������
      SumProfit = 0;
      OldOrdersCount = 0;
      loss = 0;
      LossOrdersCount = 0;
      pr = 0;
      ProfitOrdersCount = 0;
      //---
      
      //--- �������� �������� ����� ������
      for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
               OldOrdersCount++; //--- ������� ������
               SumProfit += OrderProfit(); //--- � ��������� ������
               
               //--- ���� ��������� ������ ������ pr (��� ������ ������ 0)
               if (SumProfit > pr) {
                  //--- �������������� ������ � ������� ���������� �������
                  pr = SumProfit;
                  ProfitOrdersCount = OldOrdersCount;
               }
               //--- ���� ��������� ������ ������ loss (��� ������ ������ 0)
               if (SumProfit < loss) {
                  //--- �������������� �������� � ������� ��������� �������
                  loss = SumProfit;
                  LossOrdersCount = OldOrdersCount;
               }
               //--- ���� ������� ���-�� ������������ ������� ������ ��� ����� MaxAnalizCount (50), �� � ������� ������� ������ ���������� ������ � ������ ��������.
               if (OldOrdersCount >= MaxAnalizCount) break;
            }
         }
      } //--- �������� for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
      
      
      //--- ���� ����� ���������� ������� ������ ��� ����� ����� �����, �� ����������� �������� ��������� ���� MultiLot
      if (ProfitOrdersCount <= LossOrdersCount) MultiLot = MathPow(MultiLotPercent, LossOrdersCount);
      
      //--- ���� ���, ��
      else {
         
         //--- �������������� ��������� �� �������
         SumProfit = pr;
         OldOrdersCount = ProfitOrdersCount;
         LastPr = pr;
         LastCount = ProfitOrdersCount;
         
         //--- �������� �������� ����� ������ (����� ����� ���������� �������)
         for (i = OrdersHistoryTotal() - ProfitOrdersCount - 1; i >= 0; i--) {
            if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
                  //--- ���� ������� ����� 50 ������� ����������� ��������
                  if (OldOrdersCount >= MaxAnalizCount) break;
                  //---
                  OldOrdersCount++; //--- ������� ���-�� �������
                  SumProfit += OrderProfit(); //--- � ������
                  
                  //--- ���� ����� ������ ������ ����������� (LastPr), ��
                  if (SumProfit < LastPr) {
                     //--- ������������������ �������� ������� � ���-�� �������
                     LastPr = SumProfit;
                     LastCount = OldOrdersCount;
                  }
               }
            }
         } //--- �������� for (i = OrdersHistoryTotal() - ProfitOrdersCount - 1; i >= 0; i--) {
         
         //--- ���� �������� �������� LastCount ����� �������� ���������� ������� ��� ������� ������ ����� �������, ��
         if (LastCount == ProfitOrdersCount || LastPr == pr) MultiLot = MathPow(MultiLotPercent, LossOrdersCount); //--- ����������� �������� ��������� ���� MultiLot
         
         //--- ���� ���, ��
         else {
            //--- ����� ������������� (loss - pr) �� ������������� (LastPr - pr) � ���������� � ������, ����� ����������� ��������� ���� MultiLot
            if (MathAbs(loss - pr) / MathAbs(LastPr - pr) >= (Risk + 100.0) / 100.0) MultiLot = MathPow(MultiLotPercent, LossOrdersCount);
            else MultiLot = MathPow(MultiLotPercent, LastCount);
         }
      }
   } //--- �������� if (MultiLotPercent > 0.0 && AutoMM > 0.0) {
   
   //--- �������� ��������� ����� ����, ������ �� ����������� ���� ��������
   for (double OpLot = MathMax(MinLot, MathMin(MaxLot, MathCeil(MathMin(AutoMM_Max, MultiLot * AutoMM) / 100.0 * AccountFreeMargin() / LotStep / (LotValue / 100)) * LotStep)); OpLot >= 2.0 * MinLot &&
      1.05 * (OpLot * FreeMargin) >= AccountFreeMargin(); OpLot -= MinLot) {
   }
   return (OpLot);
}

//+--------------------------------------------------------------------------------------------------------------+
//| MaxSpreadFilter. ������� ��� ������� ������� ������ � ��������� ��� �� ��������� MaxSpread.
//| ���� ������� ����� ��������, �� ���������� TRUE.
//+--------------------------------------------------------------------------------------------------------------+
bool MaxSpreadFilter() {
//+--------------------------------------------------------------------------------------------------------------+

   RefreshRates();
   if (NormalizeDouble(Ask - Bid, Digits) > NDMaxSpread) return (TRUE);
   //---
   else return (FALSE);
}

//+--------------------------------------------------------------------------------------------------------------+
//| ExistPosition. ������� �������� �������� �������.
//| ���� ������ ����� ���������� True, ���� ���, ���� ���������� (False, 0) �� ��������.
//+--------------------------------------------------------------------------------------------------------------+
int ExistPosition() {
//+--------------------------------------------------------------------------------------------------------------+

   int trade = OrdersTotal() - 1;
   for (int i = trade; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if ((OrderType() == OP_BUY||OrderType() == OP_SELL)&&(OrderMagicNumber() == MagicNumber||OrderMagicNumber() == MagicNumber1)) {
            if (OrderSymbol() == EASymbol)
               if (OrderType() <= OP_SELL) return (1);
         }
      }
   }
   //---
   return (0);
}

//+--------------------------------------------------------------------------------------------------------------+
//| OpenTradeCount. ������� �������� �������. ���� ����� �������� ������� ������ ��� ����� MaximumTrades, ��
//| ���� ������ �� ��������.
//+--------------------------------------------------------------------------------------------------------------+
bool OpenTradeCount() {
//+--------------------------------------------------------------------------------------------------------------+

   int count = 0;
   int trade = OrdersTotal() - 1;
   for (int i = trade; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         if (OrderComment()!= "R"&&((OrderType() == OP_BUY||OrderType() == OP_SELL)&&(OrderMagicNumber() == MagicNumber||OrderMagicNumber() == MagicNumber1)&& OrderSymbol() == EASymbol)) count++;
   }
   //---
   if (count >= MaximumTrades) return (False);
   else return (True);
}
/////////////////////////////////////////////////////////
//+--------------------------------------------------------------------------------------------------------------+
//| Dmarket ������� �������� �������������� �������� �������
//+--------------------------------------------------------------------------------------------------------------+

void Dmarket(int PA) {
int bm=0,sm=0,bmd=0,smd=0,bms=0,sms=0,LBD=0,LSD=0,NB=0,NS=0,Z=0,MB=0,MS=0,zb=0,zs=0,ZP=0;
double PRB,PRS,drb,drs,L,LOT,LOTD,LS,LL,LD,LOTS;

for (int i = OrdersTotal() - 1; i >= 0; i--)
     {
    if (!(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) || OrderSymbol() != Symbol()) 
         continue;
    
    if (OrderType()==OP_BUY||OrderType()==OP_SELL&&OrderOpenTime()>=iTime(Symbol(),AccountBar,0))Z=1;
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1||OrderMagicNumber()==MagicNumber&&Ask>OrderOpenPrice()-OrderDOP*Point*K)zb=1;
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1||OrderMagicNumber()==MagicNumber&&Bid<OrderOpenPrice()+OrderDOP*Point*K)zs=1;
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1){MB=1;PRB=OrderOpenPrice();}
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1){MS=1;PRS=OrderOpenPrice();} 
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber){NB=1;drb=OrderOpenPrice();}
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber){NS=1;drs=OrderOpenPrice();}    
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber&&OrderStopLoss()>OrderOpenPrice())LBD=1;
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber&&OrderStopLoss()<OrderOpenPrice())LSD=1;    
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber&&Ask<OrderOpenPrice()-OrderDOP*Point*K){bmd=1;LOTD=OrderLots();}
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber&&Bid>OrderOpenPrice()+OrderDOP*Point*K){smd=1;LOTD=OrderLots();} 
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber&&Ask<OrderOpenPrice()-DOPS*Point*K){bms=1;LOTS=OrderLots();}
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber&&Bid>OrderOpenPrice()+DOPS*Point*K){sms=1;LOTS=OrderLots();} 
    
    if (AccountOrder == FALSE){
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1)NB=1;
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1)NS=1;    
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1&&OrderStopLoss()>OrderOpenPrice())LBD=1;
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1&&OrderStopLoss()<OrderOpenPrice())LSD=1;    
   
   
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1&&Ask<OrderOpenPrice()-OrderDOP*Point*K){bmd=1;LOTD=OrderLots();}
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1&&Bid>OrderOpenPrice()+OrderDOP*Point*K){smd=1;LOTD=OrderLots();} 
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1&&Ask<OrderOpenPrice()-DOPS*Point*K){bms=1;LOTS=OrderLots();}
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1&&Bid>OrderOpenPrice()+DOPS*Point*K){sms=1;LOTS=OrderLots();} 
    }
    if (ModifDOP == TRUE&&MB==1&&OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber&&OrderTakeProfit()>OrderOpenPrice()+1*Point+Commis*Point*K&&PRB<OrderOpenPrice()&&OrderProfit()<0)
        OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()+Commis*Point*K,0,CLR_NONE);
    if (ModifDOP == TRUE&&MS==1&&OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber&&OrderTakeProfit()<OrderOpenPrice()-1*Point-Commis*Point*K&&PRS>OrderOpenPrice()&&OrderProfit()<0)
        OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()-Commis*Point*K,0,CLR_NONE);
    }
    if (StartLot>0){LOT=LotSize;LOTD=LotSize;LOTS=LotSize;}
    for (int y = OrdersTotal() - 1; y >= 0; y--)
     {
    if (OrderSelect(y, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()&&(OrderMagicNumber()==MagicNumber1||OrderMagicNumber()==MagicNumber)) 
         {
         if (RiskMargin>0&&RiskMargin*AccountFreeMargin()<AccountMargin())ZP=1;
         }
      }
 //...........................DOP................................................
        double ML;
        int m;
        double MG=AccountFreeMargin()*RiskFreeMargin;
        double Min = MarketInfo(Symbol(), MODE_LOTSTEP);
        m=MG/MarketInfo (Symbol(), MODE_MARGINREQUIRED)/Min;
        ML = m*Min; 
        if(ML>MaxLot)ML= MaxLot; 
          
        if(Z==0&&ZP==0)
        {
        if(PA==0&&bmd==1&&OpenLongSignal()==true&&zb==0
        )          
        {
         LD=NormalizeDouble(KDOP*LOTD,NormalizeLot); 
         if(LD>MaxLot)LD=MaxLot;
         if(LD>ML)LD=ML;
         OrderSend(Symbol(),0,LD,Ask,2,0,0,NULL,MagicNumber1,0,Blue);       
        }     
        if(PA==0&&smd==1&&OpenShortSignal()==true&&zs==0
        )           
        { 
        LD=NormalizeDouble(KDOP*LOTD,NormalizeLot);
        if(LD>MaxLot)LD=MaxLot;
        if(LD>ML)LD=ML;
        OrderSend(Symbol(),1,LD,Bid,2,0,0,NULL,MagicNumber1,0,Magenta);
        }  
        }
   return;
}
//+--------------------------------------------------------------------------------------------------------------+
//| Dlimit ������� �������� �������������� �������� �������
//+--------------------------------------------------------------------------------------------------------------+

void Dlimit(int PA) {
int bm=0,sm=0,bmd=0,smd=0,bms=0,sms=0,LBD=0,LSD=0,NB=0,NS=0,Z=0,MB=0,MS=0,zb=0,zs=0,BL=0,SL=0,ZP=0;
double PRB,PRS,drb,drs,L,LOT,LOTD,LS,LL,LD,LOTS;
for (int i = OrdersTotal() - 1; i >= 0; i--)
     {
    if (!(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) || OrderSymbol() != Symbol()) 
         continue;
    
    if (DeleteLimitU == TRUE&&OrderType()==OP_BUYLIMIT&&OrderMagicNumber()==MagicNumber1&&OpenLongSignal()!=true)OrderDelete(OrderTicket());
    if (DeleteLimitU == TRUE&&OrderType()==OP_SELLLIMIT&&OrderMagicNumber()==MagicNumber1&&OpenShortSignal()!=true)OrderDelete(OrderTicket());
    if (OrderType()==OP_BUYLIMIT&&OrderMagicNumber()==MagicNumber1)BL=1;
    if (OrderType()==OP_SELLLIMIT&&OrderMagicNumber()==MagicNumber1)SL=1; 
    if (OrderType()==OP_BUY||OrderType()==OP_SELL&&OrderOpenTime()>=iTime(Symbol(),AccountBar,0))Z=1;
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1||OrderMagicNumber()==MagicNumber&&Ask>OrderOpenPrice()-OrderDOP*Point*K)zb=1;
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1||OrderMagicNumber()==MagicNumber&&Bid<OrderOpenPrice()+OrderDOP*Point*K)zs=1;
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1){MB=1;PRB=OrderOpenPrice();}
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1){MS=1;PRS=OrderOpenPrice();} 
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber){NB=1;drb=OrderOpenPrice();}
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber){NS=1;drs=OrderOpenPrice();}    
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber&&OrderStopLoss()>OrderOpenPrice())LBD=1;
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber&&OrderStopLoss()<OrderOpenPrice())LSD=1;    
    if (DeleteLimit == TRUE&&OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber&&OrderStopLoss()<OrderOpenPrice()){bm=1;LOT=OrderLots();}
    if (DeleteLimit == TRUE&&OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber&&OrderStopLoss()>OrderOpenPrice()){sm=1;LOT=OrderLots();}
    if (DeleteLimit == FALSE&&OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber){bm=1;LOT=OrderLots();}
    if (DeleteLimit == FALSE&&OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber){sm=1;LOT=OrderLots();}
       
    if (AccountOrder == FALSE){
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1)NB=1;
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1)NS=1;    
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1&&OrderStopLoss()>OrderOpenPrice())LBD=1;
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1&&OrderStopLoss()<OrderOpenPrice())LSD=1;    
   
    if (DeleteLimit == TRUE&&OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1&&OrderStopLoss()<OrderOpenPrice()){bm=1;LOT=OrderLots();}
    if (DeleteLimit == TRUE&&OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1&&OrderStopLoss()>OrderOpenPrice()){sm=1;LOT=OrderLots();}
    if (DeleteLimit == FALSE&&OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1){bm=1;LOT=OrderLots();}
    if (DeleteLimit == FALSE&&OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1){sm=1;LOT=OrderLots();}
    }
    if(DeleteLimit == TRUE&&OrderType()==OP_BUYLIMIT&&LBD==1||NB==0)OrderDelete(OrderTicket());
    if(DeleteLimit == TRUE&&OrderType()==OP_SELLLIMIT&&LSD==1||NS==0)OrderDelete(OrderTicket());
         
    }
     for (int y = OrdersTotal() - 1; y >= 0; y--)
     {
    if (OrderSelect(y, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()&&(OrderMagicNumber()==MagicNumber1||OrderMagicNumber()==MagicNumber)) 
         {
         if (RiskMargin>0&&RiskMargin*AccountFreeMargin()<AccountMargin())ZP=1;
         }
      }    
        double ML;
        int m;
        double MG=AccountFreeMargin()*RiskFreeMargin;
        double Min = MarketInfo(Symbol(), MODE_LOTSTEP);
        m=MG/MarketInfo (Symbol(), MODE_MARGINREQUIRED)/Min;
        ML = m*Min; 
        if(ML>MaxLot)ML= MaxLot; 
          
 //...........................LIMIT................................................
        
        if(PA==0&&bm==1&&BL==0&&OpenLongSignal()==true&&ZP==0
        )          
        {
         LL=NormalizeDouble(KLimit*LOT,NormalizeLot); 
         if(LL>MaxLot)LL=MaxLot;
         if(LL>ML)LL=ML;
         OrderSend(Symbol(),2,LL,Bid - LimitOrder*Point*K ,2,0,0,NULL,MagicNumber1,TimeCurrent()+TimeL*60,Lime);       
        }     
        if(PA==0&&sm==1&&SL==0&&OpenShortSignal()==true&&ZP==0
        )           
        { 
        LL=NormalizeDouble(KLimit*LOT,NormalizeLot);
        if(LL>MaxLot)LL=MaxLot;
        if(LL>ML)LL=ML;        
        OrderSend(Symbol(),3,LL,Ask + LimitOrder*Point*K ,2,0,0,NULL,MagicNumber1,TimeCurrent()+TimeL*60,Orange);
        }
     return;   
}
//+--------------------------------------------------------------------------------------------------------------+
//| Dstop ������� �������� �������������� �������� �������
//+--------------------------------------------------------------------------------------------------------------+

void Dstop(int PA) {
int bm=0,sm=0,bmd=0,smd=0,bms=0,sms=0,LBD=0,LSD=0,NB=0,NS=0,Z=0,MB=0,MS=0,zb=0,zs=0,BS=0,SS=0,ZP=0;
double PRB,PRS,drb,drs,L,LOT,LOTD,LS,LL,LD,LOTS;
for (int i = OrdersTotal() - 1; i >= 0; i--)
     {
    if (!(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) || OrderSymbol() != Symbol()) 
         continue;
    if (OrderType()==OP_BUYSTOP)BS=1;
    if (OrderType()==OP_SELLSTOP)SS=1;
   
    if (OrderType()==OP_BUY||OrderType()==OP_SELL&&OrderOpenTime()>=iTime(Symbol(),AccountBar,0))Z=1;
      
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber&&Ask<OrderOpenPrice()-DOPS*Point*K){bms=1;LOTS=OrderLots();}
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber&&Bid>OrderOpenPrice()+DOPS*Point*K){sms=1;LOTS=OrderLots();} 
    
    if (AccountOrder == FALSE){
        
    if (OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1&&Ask<OrderOpenPrice()-DOPS*Point*K){bms=1;LOTS=OrderLots();}
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1&&Bid>OrderOpenPrice()+DOPS*Point*K){sms=1;LOTS=OrderLots();} 
    }
    
   
    if(ModifStop == TRUE&&OrderType()==OP_BUYSTOP&&OrderOpenPrice()-Ask>StopOrder*Point*K)OrderModify(OrderTicket(),Ask+StopOrder*Point*K,0,0,OrderExpiration(),CLR_NONE);
    if(ModifStop == TRUE&&OrderType()==OP_SELLSTOP&&Bid-OrderOpenPrice()>StopOrder*Point*K)OrderModify(OrderTicket(),Bid-StopOrder*Point*K,0,0,OrderExpiration(),CLR_NONE);
    } 
    if (StartLot>0){LOT=LotSize;LOTD=LotSize;LOTS=LotSize;}   
    for (int y = OrdersTotal() - 1; y >= 0; y--)
     {
    if (OrderSelect(y, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()&&(OrderMagicNumber()==MagicNumber1||OrderMagicNumber()==MagicNumber)) 
         {
         if (RiskMargin>0&&RiskMargin*AccountFreeMargin()<AccountMargin())ZP=1;
         }
      }    
        double ML;
        int m;
        double MG=AccountFreeMargin()*RiskFreeMargin;
        double Min = MarketInfo(Symbol(), MODE_LOTSTEP);
        m=MG/MarketInfo (Symbol(), MODE_MARGINREQUIRED)/Min;
        ML = m*Min; 
        if(ML>MaxLot)ML= MaxLot; 
 //...........................STOP................................................

        if(PA==0&&bms==1&&BS==0&&OpenLongSignal()==true&&ZP==0
        )          
        {
         LS=NormalizeDouble(KStop*LOTS,NormalizeLot); 
         if(LS>MaxLot)LS=MaxLot;
         if(LS>ML)LS=ML;         
         OrderSend(Symbol(),4,LS,Ask + StopOrder*Point*K ,2,0,0,NULL,MagicNumber1,TimeCurrent()+TimeS*60,Aqua);       
        }     
        if(PA==0&&sms==1&&SS==0&&OpenShortSignal()==true&&ZP==0
        )           
        { 
        LS=NormalizeDouble(KStop*LOTS,NormalizeLot);
        if(LS>MaxLot)LS=MaxLot;
        if(LS>ML)LS=ML;         
        OrderSend(Symbol(),5,LS,Bid - StopOrder*Point*K ,2,0,0,NULL,MagicNumber1,TimeCurrent()+TimeS*60,Yellow);
        } 
    return;
}
//+--------------------------------------------------------------------------------------------------------------+
//| Grafik.
//+--------------------------------------------------------------------------------------------------------------+
void Grafik()
{
int b=0,s=0;

for (int i = OrdersTotal() - 1; i >= 0; i--)
     {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)&& OrderSymbol() == Symbol()) 
      {
   
    if (OrderMagicNumber()==MagicNumber)
    {
    if (OrderType()==OP_BUY)b=1;//else b=0;
    if (OrderType()==OP_SELL)s=1;//else s=0;

    if (OrderType()==OP_BUY)
      {
      if(ObjectFind("NP")==-1)
      {
        ObjectCreate("NP",OBJ_HLINE,0,0,OrderOpenPrice());
        ObjectSet("NP",OBJPROP_COLOR,LC);
      }
      }

   
    if (OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber)
      {
      if(ObjectFind("NP1")==-1)
      {
        ObjectCreate("NP1",OBJ_HLINE,0,0,OrderOpenPrice());
        ObjectSet("NP1",OBJPROP_COLOR,LC1);
      }
      }

    }
    double P= ObjectGet( "NP", OBJPROP_PRICE1);
    double p = NormalizeDouble(P,Digits);
    double P1= ObjectGet( "NP1", OBJPROP_PRICE1);
    double p1 = NormalizeDouble(P1,Digits);
    if (ModifTake == FALSE&&ModifDOP == TRUE&&ObjectFind("NP")!=-1&&b==1&&OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1&&OrderTakeProfit()<p-Point)
        OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),p,0,CLR_NONE);
    if (ModifTake == FALSE&&ModifDOP == TRUE&&ObjectFind("NP1")!=-1&&s==1&&OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1&&OrderTakeProfit()>p1+Point)
        OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),p1,0,CLR_NONE);
//.....................................................................................................................
    if (ModifTake == TRUE&&ObjectFind("NP")!=-1&&b==1&&OrderType()==OP_BUY&&OrderMagicNumber()==MagicNumber1&&OrderOpenPrice()<p-(Ask-Bid))
        OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),p,0,CLR_NONE);
    if (ModifTake == TRUE&&ObjectFind("NP1")!=-1&&s==1&&OrderType()==OP_SELL&&OrderMagicNumber()==MagicNumber1&&OrderOpenPrice()>p1+(Ask-Bid))
        OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),p1,0,CLR_NONE);
   
//.....................................................................................................................
  
    }
   }
    if (b==0)ObjectDelete("NP");
    if (s==0)ObjectDelete("NP1");
}

//+--------------------------------------------------------------------------------------------------------------+
//| ErrorDescription. ���������� �������� ������ �� � ������.
//+--------------------------------------------------------------------------------------------------------------+
string ErrorDescription(int error) {
//+--------------------------------------------------------------------------------------------------------------+

   string ErrorNumber;
   //---
   switch (error) {
   case 0:
   case 1:     ErrorNumber = "��� ������, �� ��������� ����������";                        break;
   case 2:     ErrorNumber = "����� ������";                                               break;
   case 3:     ErrorNumber = "������������ ���������";                                     break;
   case 4:     ErrorNumber = "�������� ������ �����";                                      break;
   case 5:     ErrorNumber = "������ ������ ����������� ���������";                        break;
   case 6:     ErrorNumber = "��� ����� � �������� ��������";                              break;
   case 7:     ErrorNumber = "������������ ����";                                          break;
   case 8:     ErrorNumber = "������� ������ �������";                                     break;
   case 9:     ErrorNumber = "������������ �������� ���������� ���������������� �������";  break;
   case 64:    ErrorNumber = "���� ������������";                                          break;
   case 65:    ErrorNumber = "������������ ����� �����";                                   break;
   case 128:   ErrorNumber = "����� ���� �������� ���������� ������";                      break;
   case 129:   ErrorNumber = "������������ ����";                                          break;
   case 130:   ErrorNumber = "������������ �����";                                         break;
   case 131:   ErrorNumber = "������������ �����";                                         break;
   case 132:   ErrorNumber = "����� ������";                                               break;
   case 133:   ErrorNumber = "�������� ���������";                                         break;
   case 134:   ErrorNumber = "������������ ����� ��� ���������� ��������";                 break;
   case 135:   ErrorNumber = "���� ����������";                                            break;
   case 136:   ErrorNumber = "��� ���";                                                    break;
   case 137:   ErrorNumber = "������ �����";                                               break;
   case 138:   ErrorNumber = "����� ���� - ������";                                        break;
   case 139:   ErrorNumber = "����� ������������ � ��� ��������������";                    break;
   case 140:   ErrorNumber = "��������� ������ �������";                                   break;
   case 141:   ErrorNumber = "������� ����� ��������";                                     break;
   case 145:   ErrorNumber = "����������� ���������, ��� ��� ����� ������� ������ � �����";break;
   case 146:   ErrorNumber = "���������� �������� ������";                                 break;
   case 147:   ErrorNumber = "������������� ���� ��������� ������ ��������� ��������";     break;
   case 148:   ErrorNumber = "���������� �������� � ���������� ������� �������� ������� "; break;
   //---- 
   case 4000:  ErrorNumber = "��� ������";                                                 break;
   case 4001:  ErrorNumber = "������������ ��������� �������";                             break;
   case 4002:  ErrorNumber = "������ ������� - ��� ���������";                             break;
   case 4003:  ErrorNumber = "��� ������ ��� ����� �������";                               break;
   case 4004:  ErrorNumber = "������������ ����� ����� ������������ ������";               break;
   case 4005:  ErrorNumber = "�� ����� ��� ������ ��� �������� ����������";                break;
   case 4006:  ErrorNumber = "��� ������ ��� ���������� ���������";                        break;
   case 4007:  ErrorNumber = "��� ������ ��� ��������� ������";                            break;
   case 4008:  ErrorNumber = "�������������������� ������";                                break;
   case 4009:  ErrorNumber = "�������������������� ������ � �������";                      break;
   case 4010:  ErrorNumber = "��� ������ ��� ���������� �������";                          break;
   case 4011:  ErrorNumber = "������� ������� ������";                                     break;
   case 4012:  ErrorNumber = "������� �� ������� �� ����";                                 break;
   case 4013:  ErrorNumber = "������� �� ����";                                            break;
   case 4014:  ErrorNumber = "����������� �������";                                        break;
   case 4015:  ErrorNumber = "������������ �������";                                       break;
   case 4016:  ErrorNumber = "�������������������� ������";                                break;
   case 4017:  ErrorNumber = "������ DLL �� ���������";                                    break;
   case 4018:  ErrorNumber = "���������� ��������� ����������";                            break;
   case 4019:  ErrorNumber = "���������� ������� �������";                                 break;
   case 4020:  ErrorNumber = "������ ������� ������������ ������� �� ���������";           break;
   case 4021:  ErrorNumber = "������������ ������ ��� ������, ������������ �� �������";    break;
   case 4022:  ErrorNumber = "������� ������";                                             break;
   case 4050:  ErrorNumber = "������������ ���������� ���������� �������";                 break;
   case 4051:  ErrorNumber = "������������ �������� ��������� �������";                    break;
   case 4052:  ErrorNumber = "���������� ������ ��������� �������";                        break;
   case 4053:  ErrorNumber = "������ �������";                                             break;
   case 4054:  ErrorNumber = "������������ ������������� �������-���������";               break;
   case 4055:  ErrorNumber = "������ ����������������� ����������";                        break;
   case 4056:  ErrorNumber = "������� ������������";                                       break;
   case 4057:  ErrorNumber = "������ ��������� ����������� ����������";                    break;
   case 4058:  ErrorNumber = "���������� ���������� �� ����������";                        break;
   case 4059:  ErrorNumber = "������� �� ��������� � �������� ������";                     break;
   case 4060:  ErrorNumber = "������� �� ������������";                                    break;
   case 4061:  ErrorNumber = "������ �������� �����";                                      break;
   case 4062:  ErrorNumber = "��������� �������� ���� string";                             break;
   case 4063:  ErrorNumber = "��������� �������� ���� integer";                            break;
   case 4064:  ErrorNumber = "��������� �������� ���� double";                             break;
   case 4065:  ErrorNumber = "� �������� ��������� ��������� ������";                      break;
   case 4066:  ErrorNumber = "����������� ������������ ������ � ��������� ����������";     break;
   case 4067:  ErrorNumber = "������ ��� ���������� �������� ��������";                    break;
   case 4099:  ErrorNumber = "����� �����";                                                break;
   case 4100:  ErrorNumber = "������ ��� ������ � ������";                                 break;
   case 4101:  ErrorNumber = "������������ ��� �����";                                     break;
   case 4102:  ErrorNumber = "������� ����� �������� ������";                              break;
   case 4103:  ErrorNumber = "���������� ������� ����";                                    break;
   case 4104:  ErrorNumber = "������������� ����� ������� � �����";                        break;
   case 4105:  ErrorNumber = "�� ���� ����� �� ������";                                    break;
   case 4106:  ErrorNumber = "����������� ������";                                         break;
   case 4107:  ErrorNumber = "������������ �������� ���� ��� �������� �������";            break;
   case 4108:  ErrorNumber = "�������� ����� ������";                                      break;
   case 4109:  ErrorNumber = "�������� �� ���������";                                      break;
   case 4110:  ErrorNumber = "������� ������� �� ���������";                               break;
   case 4111:  ErrorNumber = "�������� ������� �� ���������";                              break;
   case 4200:  ErrorNumber = "������ ��� ����������";                                      break;
   case 4201:  ErrorNumber = "��������� ����������� �������� �������";                     break;
   case 4202:  ErrorNumber = "������ �� ����������";                                       break;
   case 4203:  ErrorNumber = "����������� ��� �������";                                    break;
   case 4204:  ErrorNumber = "��� ����� �������";                                          break;
   case 4205:  ErrorNumber = "������ ��������� �������";                                   break;
   case 4206:  ErrorNumber = "�� ������� ��������� �������";                               break;
   case 4207:  ErrorNumber = "������ ��� ������ � ��������";                               break;
   default:    ErrorNumber = "����������� ������";
   }
   //---
   return (ErrorNumber);
}