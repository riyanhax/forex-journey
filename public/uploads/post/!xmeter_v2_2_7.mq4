//+-----------------------------------------------------------------------+
//|                                                !xMeter_MultiPairs.mq4 |
//|                                                                       |
//| This is an OpenSource effort collaborated by many people at TSD-Forum |
//|                                                EA Originator: FerruFx |
//|   Price Meter System™ ©GPL by Rlinac (TSD-forum) modified by jlust286 |
//|                2007/05/16 Modified by Robert Hill (IBFX mini Account) |
//|                       2008/10/20 Modified by jlust286 (Trading Rules) |
//|      2010/08/26 Modified by Miklós Kiss (generalization to any pairs) |
//|         2010/10/05 Modified by Miklós Kiss (trade logic made simpler) |
//|     2010/10/27 Modified by Miklós Kiss (bugfix, CloseTrigger romoved) |
//|         2011/01/15 Modified by FullPips (TimeFilter, more parameters) |
//|     2011/06/06 Modified by Capella (Trading hours, Stochastic filter) |
//|                          2011/07/08 Stochastic Filter bug correction  |
//+-----------------------------------------------------------------------+

//EA SETUP:
// 1. Make sure using at least MT4 build 202.
// 2. Place the !xMeter.mq4 at experts folder.
// 3. Restart your terminal.
// 4. Show All Symbols from Market watch by pressing Ctrl+M or from menu View->Market Watch.
// 5. Right click on Market Watch dialog then select Show All.
// 6. Attach EA to ONE chart.  Works on any chart, any timeframe, the results will be the same.
// 7. Select which currencies you want to trade using the EA properties and check "Allow live trading".

//TRADING RULES:
// 1. Check if current time is at PauseTrading otherwise trading is allowed.
// 2. Check EA properties if currency pair is allowed to be traded.
// 3. Enter a trade if the xMeter difference between the Major and Minor currencies is greater than TradeTrigger.
// 4. A trade may be closed 5 ways.  
//    - xMeter CloseTrigger (indicating reversal in short TF).
//    - Breakeven Stop Loss.
//    - Dynamic Trailing Stop.
//    - Dynamic Take Profit.
//    - Breakeven in Recovery Mode
// 5. If the currency's trades never reach Breakeven then they will be closed when the xMeter difference
//    between currencies is less than or equal to CloseTrigger using only last 1/3 of xMeter lookback period.
// 6. If the trade become profitable then it will place a stop at Breakeven and trail with a DynamicStop.
// 7. If the difference between currencies falls to RecoverTrigger then another trade will be opened in that
//    currency in the same direction and will open another if the currency continues to go against the trades.
//    The trades will be closed when they average breakeven.
// 8. If the trade reaches Spread+StdDev*3 it is closed by Dynamic TakeProfit.

//HOW TO BACKTEST:
// As of version 1.8 EA cannot be backtested. EA tries to meter other each currency against every other,
// however MT4 only feeds 1 symbol's data while backtesting.
// You can try to start a backtest on EA but it won't execute any trades. Do a forward test on a demo account.

//NOTES:
// 1. This tool can run on any platfrom regardless your type of account. You might need to use the 'Suffix'
//    parameter if symbol names have a common suffix at your broker (e.g.: EURUSDifx -> Suffix = "ifx")
// 2. The xMeter indicator gathers data from all availble currency pairs.  The indicator will be more reliable if 
//    you use a broker that offers more currencies. xMeter will search for all known currencies (112 as of 2010)
//    that the broker provides.
// 3. Please make any changes as needed.

//MODIFICATIONS, ADDITIONS, CHANGES, BUG FIXES:
//    Changes by jlust286 (www.stiglu.com) on 2008/10/20:
//       - Added MoneyManagment.
//       - Added PauseTrading with default set to pause Friday and allow trades beginning Monday.
//       - Added RecoverTrigger and CloseTrigger.
//       - Added BreakEven and DynamicStop.
//       - Added DynamicTakeProfit.
//       - Added TemporarySLTP feature to prevent massive account loss incase of internet disconnection.
//       - Added grid averaging with increasing lots so additional trades can be scaled in at better prices.
//       - Changed xMeter to lookback specified bars instead of Midnight of current day.
//       - Modified xMeter so the last one third of xMeterLookBackPer is weighted 33% heavier than first two thirds. 
//       - Changed xMeter to use all available currency pairs to evaluate a currency's strength.
//       - Modified EA to be backtestable.
//    Changes by Miklós Kiss (http://mikki.hu) on 2010/08/26:
//       - Removed IBFX mini parameters
//       - Generalized pair setup:
//          - automatic pair detection for strength metering
//          - special symbols might be added (SpecialPairs)
//          - any pair can be used for trading (TradePairs)
//          - added Suffix parameter to handle any kind of brokers
//       - Added SpreadLimit variable instead of automatic spread limit detection
//       - Fixed stack overflow bugs
//       - Added support for 5 digit brokers
//       - Added NormalizeDouble() calls around pricees (fix backtest issues)
//    Changes by Miklós Kiss (http://mikki.hu) on 2010/09/06:
//       - Currencies occurring in few pairs (<3) ignored
//       - Added automatic pair selection
//       - Added option to filter correlated pairs (done always in auto pair selection mode)
//       - Added option to trade only in better/positive swap direction (SwapMode: 0=don't care; 1=better; 2=positive)
//       - Opening logic separated:
//          - recovery positions are opened first (if necessary) even if pair should not be traded (but a previous position exists by EA)
//          - new positions are opened after (if margin allows) on allowed trade pairs
//       - Code fully revised (identation, minor bugs)
//    Changes by Miklós Kiss (http://mikki.hu) on 2010/09/06:
//       - paramters restructured
//       - added RecoveryPips parameter: in recovery mode aim for this many pips profit
//       - recovery TP set for breakeven level (+RecoveryPips pips), no separate position closing
//       - removed AdjustDynamicTPSL() function: not necessary any more
//       - removed ExitAllTradesNOW() function: not necessary any more
//       - code furter revised: less calculations, removed (some) unused variables
//    Changes by Miklós Kiss (http://mikki.hu) on 2010/10/27:
//       - CloseTrigger and order closing removed (grid averaging performs well)
//       - bug fixes related to suffixed brokers
//       - bug fixes related to 5 digit brokers
//    Changes by FullPips (info@fullpips.com) on 2011/01/15:
//       - added option to limit to one recovery trade per periode, M1=1, M5=5, M15=15, M30=30, 60=H1, 240=H4, 1440=Daily, 10080=Weekly, 43200=Monthly
//       - added RevRecoverTrigger parameter: allow another recovery trade in same currency only if xMeter is higher as the RecoverTrigger
//       - added Slippage parameter: Slippage
//       - added MinCurrencyPairs parameter: minimum number of pairs a currency must occur in to be tradeable
//       - added Correlation parameter: correlation limit
//       - added Martingale parameter: multiplication coefficient of the martingale
//       - added MartingaleShield parameter: number of recovery trades before apply the martingale
//       - bug fixes related to zero divide problem
//       - removed useless and redundant old code of pair selection loop. (manual selection of pairs can be made directly in the Market Watch)
//    Changes by Capella (pierre@regulus.net) on 2011/06/06:
//       - added filter for trading hours (starthours and stophours) including GMToffset
//       - added Stochastic indicator ON/OFF with settings for StoPeriod (M1, M5, M15; M30; H1, H4 or D1) and any of 3 signals
//         (1) K/D crossing beyond 20/80, (2) K crossing 20/80, (3) K moving in wanted direction. Stochastic is calculated with 14,3,3 
//    Changes by lilouFX (liloufx@live.fr) on 2011/07/08
//       - correction of M1 Stochastics which was overriding xMeter decision
//       - correction of lastTradeTime detection
//    Changes by liloufx (liloufx@live.fr) on 2011/07/09
//       - use RSX in H4 for entries instead of xMeter
//       - equity protection function
//       - fix start/stop time -> don't allow new trade but allow to continue managing existing trades
//    Changes by Capella (pierre@regulus.net) on 2011/07/21:
//       - corrections made on Stochastic signals due to multiple uploads 2011/07/08. StoCalc and StoPeriod was missing
//       - corrected default settings of starttime/endtime to 0/24, and EAversion to !xMeter
//    Changes by liloufx (liloufx@live.fr) on 2011/07/31:
//       - remove JRX
//       - correted the closeAll function. Was only able to close the trades for the graph the EA is started.
//       - renamed "usexMeterStoch" to "useStochFilter"
//       - removed "usexMeter" not needed anymore since xMeter is the base signal
//       - refactoring of Stochastic calculation: removale of unnecessary global variables
//================================================================================================================================
//================================================================================================================================

#define SWAP_DONT_CARE 0 // don't care with swaps
#define SWAP_BETTER    1 // trade pair in better swap direction only
#define SWAP_POSITIVE  2 // trade pair only in non-negative swap direction only


#define STOPLOSS 500  // safety stoploss
#define SL_MOVING 50  // stoploss moving
#define TP_MOVING 5

//---- Trade parameters
extern string    EAversion           = "!xMeter v2.2.7";
extern string    label_0             = "=== Trade parameters ===";
extern int       MaxUsedMargin       =            10; // maximum used margin to open a trade (don't open new if used margin is above this)
extern double    AccountRiskPercent  =           0.1; // lotsize as Balance / 10000 * AccountRiskPercent; 
extern double    MaxInitialLotSize   =           3.2; // maximum lot size for non-recovery orders
extern int       SwapMode            = SWAP_POSITIVE; // 0: don't care; 1: only in 'better' direction; 2: only positive
extern int       PauseStartTime      =         52300; // PauseTrading DayofWeek,Hour,Minute. example input: 50700 will pause trading on friday at 7:00 am.  Current trades will continue until CloseTrigger reached or stopped out. Set to 0 to disable.
extern int       PauseEndTime        =         10000; // End pause trading.  example input: 10800 will allow trading after 8:00am on monday.
extern int       BreakEvenPips       =             3; // normal breakeven level (breakeven + BreakEvenPips)
extern bool      AllowNewTrades      =          true; // allow opening of new trades (doesn't affect recovery positions)
extern int       Slippage            =             2; // Slippage 
extern double    EquityProtection    =            70; // Percentage of Equity DrowDown allowed max before all trades are closed and trading stopped
extern int       MagicNumber         =        821962;

extern string    label_1             = "=== Pairs Selection ===";
extern int       MinCurrencyPairs    =             3; // minimum number of pairs a currency must occur in to be tradeable
extern double    Correlation         =          0.75; // correlation limit
extern string    Suffix              =            ""; // common (broker specific) suffix for symbols (e.g.: "m", "ifx", etc.)
extern string    SpecialPairs        =            ""; // list here all other pairs that should be watched (but auto config doesn't find because of special name)
extern int       SpreadLimit         =            35; // do not trade a pair if it's current spread is > SpreadLimit

extern string    label_2             = "=== Signals ===";
extern int       xMeterLookBackPer   =            84; // How many hours should we look back to calculate High and Low for xMeter?
extern double    TradeTrigger        =           3.5; // Value must be greater than RecoverTrigger and less than 9.  Will enter trade when currencies xMeter difference is greater than TradeTrigger.
extern double    ReverseTrigger      =           5.0; // enter trade in the trend between TradeTrigger and ReverseTrigger. Above ReverseTrigger enter a counter trend trade

extern string    label_3             = "=== Recover ===";
extern int       RecoveryPips        =             3; // recovery exit at this many pips profit (relative to average price)
extern double    RecoverTrigger      =             0; // Will allow another trade in same currency if xMeter falls below RecoverTrigger then goes back up to TradeTrigger.
extern bool      RevRecoverTrigger   =         false; // Will allow another trade in same currency if xMeter is higher as the  RecoverTrigger.
extern int       TimeFilter          =             1; // Will limit to one trade per periode, M1=1, M5=5, M15=15, M30=30, 60=H1, 240=H4, 1440=Daily, 10080=Weekly, 43200=Monthly 
extern int       GridSpacing         =            30; // Minimum distance between grid elements
extern double    Martingale          =           1.5; // Multiplication coefficient of the martingale
extern int       MartingaleShield    =             4; // Number of trades before apply the martingale

extern string    label_4             = "=== Hours ===";
extern double    DailyStartTime           =          0.00; // Allowed start time for trading
extern double    DailyEndTime             =         24.00; // Allowed end tiome for trading  
extern int       GMToffset           =             0; // Difference in hours between Broker server time and GMT/UTC

extern string    label_5             = "=== Signals ON/OFF ===";
extern bool      useStochFilter      =         false; // If TRUE, then only enter trade when Stoch M1 (14,3,3) K/D crosses below/above 20/80
extern string    StoPeriod           =          "M1"; // Choice of period (M1, M5, M5, M30, H1, H4 or D1) for Stochastic
extern int       StoCalc             =             1; // 1 = K/D crossing, 2 = K crossing 20/80, 3 = K direction for Stochastic


//Internal Variables
int       PipMultiplier       = 1; // pip value multiplier for 5 digit adjustments

//================================================================================================================================
//================================================================================================================================
//---- !xMeter indicator settings
#define TABSIZE  10                     // scale of currency's power !!!DON'T CHANGE THIS NUMBER!!!
#define ORDER    2                      // available type of order !!!DON'T CHANGE THIS NUMBER!!!

int CurrencyCount;  // number of currencies
int PairCount;      // number of pairs

int TradeCountBuy;      // number of pairs allowed to trade (buy)
int TradeCountSell;     // number of pairs allowed to trade (sell)
string TradePairBuy[];  // pairs usable for trade (buy)
string TradePairSell[]; // pairs usable for trade (sell)

string aPair[];     // pairs to be watched
string aMajor[];    // currencies being watched
string aOrder[ORDER] = {"BUY ","SELL "};

double aMeter[];
double aHigh[];
double aLow[];
double aBid[];
double aAsk[];
double aRatio[];
double aRange[];
double aMajorSymb[];
double aMinorSymb[];

double bMeter[];
double bHigh[];
double bLow[];
double bBid[];
double bAsk[];
double bRatio[];
double bRange[];
double bMajorSymb[];
double bMinorSymb[];
double bRatioWeighted[];

int    Divisor[];
int    CurrPairs[];

//--- info on open positions ---
string OpenSymbol[];   // symbol name and direction
double OpenAvgPrice[]; // average price of open orders
double OpenLots[];     // sum of open position lots
double OpenProfit[];   // total profit (in deposit currency) of open positions
int    OpenCount[];    // number of open positions
string OpenCorrel[];   // list of correlating symbols

int    index;
double tempTP, tempSL, sl, tp, lot, InitialLotSize, lotPrecision, WeightedAverage, LastErrorTime;
int    RecoveryAmount, direction, cycle, tick, dot, cnt;
bool   PauseTrading, Initialized = false, Alert1 = false, AlertNOW;
string message, dots, symb, a = "!", pausetime;

int    NextPairSelectionTime = 0;

bool   StopTrading = FALSE;

#define NL "\n"

//-------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() 
{
   //--- Correct 0-24 time span and check so that end-time is larger than start-time ---
   DailyStartTime += GMToffset;
   DailyEndTime += GMToffset;
   if (DailyStartTime < 0)
      DailyStartTime += 24;
   if (DailyStartTime > 24)
      DailyStartTime -= 24;
   if (DailyEndTime < 0)
      DailyEndTime += 24;
   if (DailyEndTime > 24)
      DailyEndTime -= 24;
      
   //----- Check to see that the input StoPeriod is a working option. If not valid, then force to M1.
   if (StringFind ("M1 M5 M15 M30 H1 H4 D1", StoPeriod, 0) == -1)
      StoPeriod = "M1";
	  
   StopTrading = FALSE;

   for(int cnt = 0; cnt < OrdersTotal(); cnt++) 
   {
      if (!OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)) continue;
      if (OrderMagicNumber() == MagicNumber) {
         AlertNOW = True;
         LastErrorTime = TimeCurrent();
      }
   }      

   //--- compose list of possible currencies ---
   string CRRY[112] = {"AFN","ALL","ANG","ARS","AUD","AWG","AZN","BAM","BBD","BGN","BMD","BND","BOB","BRL","BSD","BWP","BYR","BZD","CAD","CHF","CLP","CNY","COP","CRC","CUP","CZK","DKK","DOP","EEK","EGP","EUR","FJD","FKP","GBP","GGP","GHC","GIP","GTQ","GYD","HKD","HNL","HRK","HUF","IDR","ILS","IMP","INR","IRR","ISK","JEP","JMD","JPY","KGS","KHR","KPW","KYD","KZT","LAK","LBP","LKR","LRD","LTL","LVL","MKD","MNT","MUR","MXN","MYR","MZN","NAD","NGN","NIO","NOK","NPR","NZD","OMR","PAB","PEN","PHP","PKR","PLN","PYG","QAR","RON","RSD","RUB","SAR","SBD","SCR","SEK","SGD","SHP","SOS","SRD","SVC","SYP","THB","TRL","TRY","TTD","TVD","TWD","UAH","USD","UYU","UZS","VEF","VND","XCD","YER","ZAR","ZWD"};

   //--- compose list of currencies being watched ---
   string list;
   string pair;
   int pos;
   PairCount = 0;
   for (int A = 0; A != 112; A++)
      for (int B = 0; B != 112; B++) {
         if (A == B) continue;
         pair = CRRY[A] + CRRY[B];
         //--- check if pair is available ---
         double ask = MarketInfo(pair + Suffix, MODE_ASK);
         if (ask != 0) { // broker supports pair
            PairCount++;
            ArrayResize(aPair, PairCount);
            aPair[PairCount - 1] = pair;
         }
      }
   list = SpecialPairs + ",";
   while (True) {
      pos = StringFind(list, ",");
      if (pos <= 0) break;
      pair = StringTrimLeft(StringTrimRight(StringSubstr(list, 0, pos)));
      if (pair == "") break;
      ask = MarketInfo(pair + Suffix, MODE_ASK);
      if (ask == 0) { //if broker does not offer currency pair then exclude from xMeter averaging
         Alert("Unknown special pair: ", pair + Suffix, ", pair ignored." + NL + "Check if broker provides symbol and it is visible in Market Watch.");
      }
      else {
         PairCount++;
         ArrayResize(aPair, PairCount);
         aPair[PairCount - 1] = pair;
      }
      list = StringSubstr(list, pos + 1);
   }
   Comment("Initializing EA, waiting for ticks...");
      
   //--- compose currency list ---
   CurrencyCount = 0;
   for (int i = 0; i != PairCount; i++) {
      //--- major part of pair --
      string currency = StringSubstr(aPair[i], 0, 3);
      pos = ID(currency);
      if (pos == -1) {
         CurrencyCount++;
         ArrayResize(aMajor, CurrencyCount);
         aMajor[CurrencyCount - 1] = currency;
      }
      //--- minor part of pair ---
      currency = StringSubstr(aPair[i], 3, 3);
      pos = ID(currency);
      if (pos == -1) {
         CurrencyCount++;
         ArrayResize(aMajor, CurrencyCount);
         aMajor[CurrencyCount - 1] = currency;
      }
   }
   
   TradeCountBuy = 0;
   TradeCountSell = 0;

   //--- allocate other arrays ---
   ArrayResize(aHigh, PairCount);
   ArrayResize(aLow, PairCount);
   ArrayResize(aBid, PairCount);
   ArrayResize(aAsk, PairCount);
   ArrayResize(aRatio, PairCount);
   ArrayResize(aRange, PairCount);
   ArrayResize(aMajorSymb, PairCount);
   ArrayResize(aMinorSymb, PairCount);
   ArrayResize(bHigh, PairCount);
   ArrayResize(bLow, PairCount);
   ArrayResize(bBid, PairCount);
   ArrayResize(bAsk, PairCount);
   ArrayResize(bRatio, PairCount);
   ArrayResize(bRange, PairCount);
   ArrayResize(bMajorSymb, PairCount);
   ArrayResize(bMinorSymb, PairCount);
   ArrayResize(bRatioWeighted, PairCount);
   ArrayResize(bMeter, CurrencyCount);
   ArrayResize(aMeter, CurrencyCount);
   ArrayResize(Divisor, CurrencyCount);
   ArrayResize(CurrPairs, CurrencyCount);

   CalculateLotPrecision();
   tick = Volume[0];
   GlobalVariableSet(a + "xMeter_Initialized", 1);
   cycle = 1;
   
   pausetime = PauseToStr(PauseStartTime) + " .. " + PauseToStr(PauseEndTime);
   
   int digit = MarketInfo(Symbol(), MODE_DIGITS);
   if (digit == 3 || digit == 5)
      PipMultiplier = 10;

   switch (TimeFilter) {
      case 1: 
      case 5: 
      case 15:
      case 30:
      case 60:
      case 240:
      case 1440:
      case 10080:
      case 43200: break;
      default:
         TimeFilter = 1; break;
   }  
//-------------------------------------------------------------------+
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {
   GlobalVariableDel(a+"xMeter_Initialized");
   return(0);
}
  
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() 
{   
   if (StopTrading) {
      Comment("Trading stopped following Equity Protection. Reset EA to restart trading.");
      return;
   }

   if (!IsTesting()) 
   { //alert if EA running on another chart
      if (GlobalVariableGet(a + "xMeter_Initialized") == 1 && cycle == 1) 
      {
         GlobalVariableSet(a + "xMeter_Initialized", 2);
         cycle = 2;
      }
      else if (GlobalVariableGet(a + "xMeter_Initialized") == 2 && cycle == 2) 
      {
         GlobalVariableSet(a + "xMeter_Initialized", 1);
         cycle = 1;
      }
      else
         Alert1 = true;
      if (Alert1) 
      {
         Alert("!xMeter EA is already trading on a different chart.");
         GlobalVariableSet(a + "xMeter_Initialized", 1);
         cycle = 1;
         Alert1 = false;
      }
   }   
   if (tick + 25 < Volume[0] || IsTesting())
      Initialized = true; //give xMeter 3 ticks from start to gather all currency data before allowing trade.
   InitialLotSize = AutoLot();
   PauseAtTime(PauseStartTime, PauseEndTime); 

   int i;
   string pair;
   int ID;
   double OverallProfit = 0.0;

   //--- collect existing trades ---
   ArrayResize(OpenSymbol, 0);
   ArrayResize(OpenAvgPrice, 0);
   ArrayResize(OpenLots, 0);
   ArrayResize(OpenProfit, 0);
   ArrayResize(OpenCount, 0);
   double OpenFees[]; // swaps and commission
   ArrayResize(OpenFees, 0);
   int total = OrdersTotal();
   for (i = 0; i != total; i++) 
   {
      if (!OrderSelect(i, SELECT_BY_POS)) 
         continue;
      if (OrderMagicNumber() == MagicNumber) 
      {
         if (OrderType() == OP_BUY) 
            pair = OrderSymbol() + "(+)";
         else if (OrderType() == OP_SELL) 
            pair = OrderSymbol() + "(-)";
         else 
            continue;
         ID = FindSymbol(OpenSymbol, pair);
         if (ID == -1) 
         {
            //--- add symbol ---
            ID = ArraySize(OpenSymbol);
            ArrayResize(OpenSymbol, ID + 1);
            ArrayResize(OpenAvgPrice, ID + 1);
            ArrayResize(OpenLots, ID + 1);
            ArrayResize(OpenProfit, ID + 1);
            ArrayResize(OpenCount, ID + 1);
            ArrayResize(OpenFees, ID + 1);
            OpenSymbol[ID] = pair;
            OpenAvgPrice[ID] = OrderOpenPrice() * OrderLots();
            OpenLots[ID] = OrderLots();
            OpenProfit[ID] = (OrderProfit() + OrderSwap() + OrderCommission());
            OverallProfit += (OrderProfit() + OrderSwap() + OrderCommission());
            OpenCount[ID] = 1;
            OpenFees[ID] = (OrderSwap() + OrderCommission());
         }
         else 
         {
            OpenAvgPrice[ID] += (OrderOpenPrice() * OrderLots());
            OpenLots[ID] += OrderLots();
            OpenProfit[ID] += (OrderProfit() + OrderSwap() + OrderCommission());
            OverallProfit += (OrderProfit() + OrderSwap() + OrderCommission());
            OpenCount[ID]++;
            OpenFees[ID] += (OrderSwap() + OrderCommission());
         }
      }
   }
   
   //--- check for Equity protection
   double currentEquity = NormalizeDouble(100.0*(AccountBalance()+OverallProfit)/AccountBalance(), 2);
   if (currentEquity<EquityProtection) {
      Print("Equity protection triggered: ", currentEquity," below ", EquityProtection);
      while( !CloseAll())Sleep(2000);
      StopTrading = TRUE;
   }
   
   //--- calculate average prices (accumulated swap and commission values modify average price!) ---
   for (i = 0; i != ArraySize(OpenSymbol); i++) 
   {
      double tickval = MarketInfo(StringSubstr(OpenSymbol[i], 0, StringLen(OpenSymbol[i]) - 3), MODE_TICKVALUE) * OpenLots[i];
      double pnt = MarketInfo(StringSubstr(OpenSymbol[i], 0, StringLen(OpenSymbol[i]) - 3), MODE_POINT);
      //--- weighted average of open prices (weight = lot size) ---
      OpenAvgPrice[i] = OpenAvgPrice[i] / OpenLots[i];
      //--- modify average based on swap & commission ---
      if (StringSubstr(OpenSymbol[i], StringLen(OpenSymbol[i]) - 3, 3) == "(+)")
         //--- buy ---
         OpenAvgPrice[i] -= (OpenFees[i] / tickval) * pnt;
      else
         //--- sell ---
         OpenAvgPrice[i] += (OpenFees[i] / tickval) * pnt;
   }

   //--- !xMeter calculation ---
   for (index = 0; index != PairCount; index++) 
   {// initialize all pairs required value 
      RefreshRates();// refresh all currencies
      symb = aPair[index] + Suffix;
      double ask   = MarketInfo(symb, MODE_ASK);
      double bid   = MarketInfo(symb, MODE_BID);
      double point = MarketInfo(symb, MODE_POINT) * PipMultiplier;
      int    sprd  = MarketInfo(symb, MODE_SPREAD);
      int    digit = MarketInfo(symb, MODE_DIGITS);
      
      //--- Get point info for symbol for shorter lookback period for entry confirmation and exit trigger ---
      int ahighBar  = iHighest(symb, 60, MODE_HIGH, xMeterLookBackPer / 3, 0); //--- Find highest bar during the last one third of lookback period ---
      int alowBar   = iLowest(symb, 60, MODE_LOW, xMeterLookBackPer / 3, 0); //--- Find lowest bar during the last one third of lookback period ---
      aHigh[index]  = iHigh(symb, 60, ahighBar); //--- Set high
      aLow[index]   = iLow(symb, 60, alowBar); //--- Set low 
      aAsk[index]   = iClose(symb, 60, 0); //--- Set close
      aRange[index] = MathMax((aHigh[index] - aLow[index]) / point, 1); //--- Calculate range
      aRatio[index] = (aAsk[index] - aLow[index]) / aRange[index] / point; //--- Calculate pair's ratio and inverse ratio

      //--- Get point info for symbol
      int bhighBar          = iHighest(symb, 60, MODE_HIGH, xMeterLookBackPer, 0); //--- Find highest bar during the lookback period
      int blowBar           = iLowest(symb, 60, MODE_LOW, xMeterLookBackPer, 0); //--- Find lowest bar during the lookback period
      bHigh[index]          = iHigh(symb, 60, bhighBar); //--- Set high
      bLow[index]           = iLow(symb, 60, blowBar); //--- Set low
      bAsk[index]           = iClose(symb, 60, 0); //--- Set close
      bRange[index]         = MathMax((bHigh[index] - bLow[index]) / point, 1); //--- Calculate range
      bRatio[index]         = (bAsk[index] - bLow[index]) / bRange[index] / point; //--- Calculate pair's ratio and inverse ratio
      bRatioWeighted[index] = (bRatio[index] * 2 + aRatio[index]) / 3; //--- Weight xMeter so the last one third of LookBackPeriod is weighted 33% heavier than first two thirds.
      
      //--- grade table for entry confirmationa and exit trigger
      int aTable[TABSIZE] = {0, 3, 10, 25, 40, 50, 60, 75, 90, 97};
      if      (aRatio[index] * 100 <= aTable[0]) aMajorSymb[index] = 0.001;
      else if (aRatio[index] * 100 <  aTable[1]) aMajorSymb[index] = 0.001;
      else if (aRatio[index] * 100 <  aTable[2]) aMajorSymb[index] = 1;
      else if (aRatio[index] * 100 <  aTable[3]) aMajorSymb[index] = 2;
      else if (aRatio[index] * 100 <  aTable[4]) aMajorSymb[index] = 3;
      else if (aRatio[index] * 100 <  aTable[5]) aMajorSymb[index] = 4;
      else if (aRatio[index] * 100 <  aTable[6]) aMajorSymb[index] = 5;
      else if (aRatio[index] * 100 <  aTable[7]) aMajorSymb[index] = 6;
      else if (aRatio[index] * 100 <  aTable[8]) aMajorSymb[index] = 7;
      else if (aRatio[index] * 100 <  aTable[9]) aMajorSymb[index] = 8;
      else                                       aMajorSymb[index] = 9;
      aMinorSymb[index] = 9 - aMajorSymb[index]; //--- Set a pair's grade and inverse grade

      //--- grade table for currency's power
      int bTable[TABSIZE] = {0, 3, 10, 25, 40, 50, 60, 75, 90, 97};
      if      (bRatioWeighted[index] * 100 <= bTable[0]) bMajorSymb[index] = 0.001;
      else if (bRatioWeighted[index] * 100 <  bTable[1]) bMajorSymb[index] = 0.001;
      else if (bRatioWeighted[index] * 100 <  bTable[2]) bMajorSymb[index] = 1;
      else if (bRatioWeighted[index] * 100 <  bTable[3]) bMajorSymb[index] = 2;
      else if (bRatioWeighted[index] * 100 <  bTable[4]) bMajorSymb[index] = 3;
      else if (bRatioWeighted[index] * 100 <  bTable[5]) bMajorSymb[index] = 4;
      else if (bRatioWeighted[index] * 100 <  bTable[6]) bMajorSymb[index] = 5;
      else if (bRatioWeighted[index] * 100 <  bTable[7]) bMajorSymb[index] = 6;
      else if (bRatioWeighted[index] * 100 <  bTable[8]) bMajorSymb[index] = 7;
      else if (bRatioWeighted[index] * 100 <  bTable[9]) bMajorSymb[index] = 8;
      else                                               bMajorSymb[index] = 9;
      bMinorSymb[index] = 9 - bMajorSymb[index]; //--- Set a pair's grade and inverse grade

      double LowestBuy = 1000, LowestSell = 1000, BuyProfits = 0, SellProfits = 0;
      int Orders = 0, sellorders = 0, buyorders = 0;

      //--- calculate buy orders ---
      ID = FindSymbol(OpenSymbol, symb + "(+)");
      if (ID != -1) 
      {
         Orders += OpenCount[ID];
         buyorders = OpenCount[ID];
         BuyProfits = OpenProfit[ID];
      }
      //--- calculate sell orders ---
      ID = FindSymbol(OpenSymbol, symb + "(-)");
      if (ID != -1) 
      {
         Orders += OpenCount[ID];
         sellorders = OpenCount[ID];
         SellProfits = OpenProfit[ID];
      }

      //--- check recovery close (if TP couldn't be set - e.g. order too close to market or price within freeze level, etc.) ---
      if (buyorders == 0) GlobalVariableSet(a + "xMeter_" + symb + "buy", 1);
      if (sellorders == 0) GlobalVariableSet(a + "xMeter_" + symb + "sell", 1);
      
      //--- adjust TP and SL ---
      DynamicBuyTP(symb, buyorders, point, sprd, digit, OpenAvgPrice[FindSymbol(OpenSymbol, symb + "(+)")]);
      DynamicSellTP(symb, sellorders, point, sprd, digit, OpenAvgPrice[FindSymbol(OpenSymbol, symb + "(-)")]);
      DynamicBuySL(symb, buyorders, bid, point, sprd, digit);
      DynamicSellSL(symb, sellorders, ask, point, sprd, digit);
   } //--- for
   
   //---- calculate divisors for averaging
   string currency;
   for (i = 0; i != CurrencyCount; i++) 
   {
      currency = aMajor[i];
      Divisor[i] = 0;
      CurrPairs[i] = 0;
      for (int j = 0; j != PairCount; j++)
         if (StringSubstr(aPair[j], 0, 3) == currency) 
         {
            CurrPairs[i]++;
            if (aMajorSymb[j] > 0)
               Divisor[i]++;
         }
         else if (StringSubstr(aPair[j], 3, 3) == currency) 
         {
            CurrPairs[i]++;
            if (aMinorSymb[j] > 0)
               Divisor[i]++;
         }
   }
   
   //---- calculate all currencies meter
   for (i = 0; i != CurrencyCount; i++) 
   {
      currency = aMajor[i];
      aMeter[i] = 0;
      if (Divisor[i] != 0) 
      {
         for (j = 0; j != PairCount; j++) 
         {
            if (StringSubstr(aPair[j], 0, 3) == currency)
               aMeter[i] += aMajorSymb[j];
            else if (StringSubstr(aPair[j], 3, 3) == currency)
               aMeter[i] += aMinorSymb[j];
         }
         aMeter[i] = NormalizeDouble(aMeter[i] / Divisor[i], 1);

         bMeter[i] = 0;
         for (j = 0; j != PairCount; j++)
            if (StringSubstr(aPair[j], 0, 3) == currency)
               bMeter[i] += bMajorSymb[j];
            else if (StringSubstr(aPair[j], 3, 3) == currency)
               bMeter[i] += bMinorSymb[j];
         bMeter[i] = NormalizeDouble(bMeter[i] / Divisor[i], 1);
      }
   }

   //--- common variables for trading ---
   int C1;
   int C2;
   double aCurr1;
   double bCurr1;
   double aCurr2;
   double bCurr2;
   int BPC, SPC;

   //--- open recovery positions if necessary or close open ones ---
   for (i = 0; i != ArraySize(OpenSymbol); i++) 
   {
      //--- extract currencies ---
      pair = OpenSymbol[i];
      pair = StringSubstr(pair, 0, StringLen(pair) - 3);
      C1 = ID(StringSubstr(pair, 0, 3));
      C2 = ID(StringSubstr(pair, 3, 3));
      
      //--- pair might be traded, check trading conditions ---
      aCurr1 = aMeter[C1];
      bCurr1 = bMeter[C1];
      aCurr2 = aMeter[C2];
      bCurr2 = bMeter[C2];

      //--- if xMeter falls to RecoverTrigger then allow another trade in same currency pair ---
      if (bCurr1 > 0 && bCurr2 > 0) 
      {
         digit = MarketInfo(pair, MODE_DIGITS);
         if (((aCurr1 - aCurr2 <= RecoverTrigger && RevRecoverTrigger == false) || (aCurr1 - aCurr2 >= RecoverTrigger && RevRecoverTrigger == true)) && GlobalVariableGet(a + "xMeter_" + pair + "buy") == 2)
            ManageBuy(pair, digit, "[" + DoubleToStr(aCurr1, 1) + "|" + DoubleToStr(aCurr2, 1) + "]");
         if (((aCurr2 - aCurr1 <= RecoverTrigger && RevRecoverTrigger == false) || (aCurr2 - aCurr1 >= RecoverTrigger && RevRecoverTrigger == true)) && GlobalVariableGet(a + "xMeter_" + pair + "sell") == 2)
            ManageSell(pair, digit, "[" + DoubleToStr(aCurr1, 1) + "|" + DoubleToStr(aCurr2, 1) + "]");
      }
   }

   //--- open new positions ---
   if (TimeLocal() > NextPairSelectionTime) 
   {
      NextPairSelectionTime = TimeLocal() + 60; //recalculate every minute
      SelectTradePairs();
      FilterBySwap();
   
      //--- iterate over all allowed trade pairs in their priority ---
      int PairID = 0;
      while (PairID < TradeCountBuy || PairID < TradeCountSell) 
      {
         if (PairID < TradeCountBuy) {
            //--- check buying of PairID pair ---
            pair = TradePairBuy[PairID];
         
            //--- get currency IDs ---
            C1 = ID(StringSubstr(pair, 0, 3));
            C2 = ID(StringSubstr(pair, 3, 3));
            if (CurrPairs[C1] >= MinCurrencyPairs && CurrPairs[C2] >= MinCurrencyPairs) 
            { // do not use currency with too few data
               //--- get meter valules ---
               aCurr1 = aMeter[C1];
               bCurr1 = bMeter[C1];
               aCurr2 = aMeter[C2];
               bCurr2 = bMeter[C2];

               //--- if xMeter reaches TradeTrigger then enter the trade ---
               if (bCurr1 > 0 && bCurr2 > 0) {
                  digit = MarketInfo(pair, MODE_DIGITS);
                  
                  if ((bCurr1 - bCurr2 >= TradeTrigger) && (bCurr1 - bCurr2 < ReverseTrigger)) {
                     if (ManageBuy(pair, digit, "[" + DoubleToStr(bCurr1, 1) + "|" + DoubleToStr(bCurr2, 1) + "|" + DoubleToStr(bCurr2-bCurr1, 1) + "]")) {
                        BPC = TradeCountBuy;
                        SPC = TradeCountSell;
                        //remove correlated currencies from the tradeable list
                        SelectTradePairs();
                        FilterBySwap();
                        if (BPC != TradeCountBuy || SPC != TradeCountSell) 
                        {
                           //--- restart pair selection loop ---
                           PairID = 0;
                           continue;
                        }
                     }
                  } else if ((bCurr1 - bCurr2 > ReverseTrigger)) {
                     if (ManageSell(pair, digit, "[" + DoubleToStr(bCurr1, 1) + "|" + DoubleToStr(bCurr2, 1) + "|" + DoubleToStr(bCurr2-bCurr1, 1)+"]*")) 
                     {
                        BPC = TradeCountBuy;
                        SPC = TradeCountSell;
                        //remove correlated currencies from the tradeable list
                        SelectTradePairs();
                        FilterBySwap();
                        if (BPC != TradeCountBuy || SPC != TradeCountSell) 
                        {
                           //--- restart pair selection loop ---
                           PairID = 0;
                           continue;
                        }
                     }                   
                  }
               }
            }
         }
      
         if (PairID < TradeCountSell) 
         {
            //--- check buying of PairID pair ---
            pair = TradePairSell[PairID];
         
            //--- get currency IDs ---
            C1 = ID(StringSubstr(pair, 0, 3));
            C2 = ID(StringSubstr(pair, 3, 3));
            if (CurrPairs[C1] >= MinCurrencyPairs && CurrPairs[C2] >= MinCurrencyPairs) { // do not use currency with too few data
               //--- get meter valules ---
               aCurr1 = aMeter[C1];
               bCurr1 = bMeter[C1];
               aCurr2 = aMeter[C2];
               bCurr2 = bMeter[C2];

               //--- if xMeter reaches TradeTrigger then enter the trade ---
               if (bCurr1 > 0 && bCurr2 > 0) 
               {
                  digit = MarketInfo(pair, MODE_DIGITS);
                  
                  if ((bCurr2 - bCurr1 >= TradeTrigger) && (bCurr1 - bCurr2 < ReverseTrigger)) {
                     if (ManageSell(pair, digit, "[" + DoubleToStr(bCurr1, 1) + "|" + DoubleToStr(bCurr2, 1) + "|" + DoubleToStr(bCurr2-bCurr1, 1) + "]")) 
                     {
                        BPC = TradeCountBuy;
                        SPC = TradeCountSell;
                        //remove correlated currencies from the tradeable list
                        SelectTradePairs();
                        FilterBySwap();
                        if (BPC != TradeCountBuy || SPC != TradeCountSell) 
                        {
                           //--- restart pair selection loop ---
                           PairID = 0;
                           continue;
                        }
                     }
                  } else if ((bCurr1 - bCurr2 > ReverseTrigger)) {
                     if (ManageBuy(pair, digit, "[" + DoubleToStr(bCurr1, 1) + "|" + DoubleToStr(bCurr2, 1) + "|" + DoubleToStr(bCurr2-bCurr1, 1)+"]*")) 
                     {
                        BPC = TradeCountBuy;
                        SPC = TradeCountSell;
                        //remove correlated currencies from the tradeable list
                        SelectTradePairs();
                        FilterBySwap();
                        if (BPC != TradeCountBuy || SPC != TradeCountSell) 
                        {
                           //--- restart pair selection loop ---
                           PairID = 0;
                           continue;
                        }
                     }
                  }
               }
            }
         }

         PairID++;
      }
   }
   
   Comments(OverallProfit);
} //---- int start()

//+------------------------------------------------------------------+
//| Calculate allowed lot precision                                  |
//+------------------------------------------------------------------+
void CalculateLotPrecision() {
   double lotstep = MarketInfo(Symbol(), MODE_LOTSTEP);
   if (lotstep >= 1) lotPrecision = 0;
   else if (lotstep >= 0.1) lotPrecision = 1;
   else if (lotstep >= 0.01) lotPrecision = 2;
   else lotPrecision = 3;
}

//+------------------------------------------------------------------+
//| Calculate lot size based on account balance and risk settings    |
//+------------------------------------------------------------------+
double AutoLot() {
   double lot;
   lot = MathMin(NormalizeDouble((AccountBalance() + AccountCredit()) / 10000 * AccountRiskPercent, lotPrecision), MaxInitialLotSize);
   if (lot < MarketInfo(Symbol(), MODE_MINLOT)) lot = MarketInfo(Symbol(), MODE_MINLOT);
   return(lot);
}

//+------------------------------------------------------------------+
//| Open new buy order (recovery if possible or normal)              |
//| Returns true if order successfully opened false otherwise        |
//+------------------------------------------------------------------+
bool ManageBuy(string symb, int digit, string meters) 
{
   double ask   = MarketInfo(symb, MODE_ASK);
   double point = MarketInfo(symb, MODE_POINT) * PipMultiplier;
   double sprd  = MarketInfo(symb, MODE_SPREAD);
   bool   BuyOK = false;
   if (!Initialized) 
      return(false);
   if (sprd <= SpreadLimit * PipMultiplier) 
   {         
      int buyorders = 0, sellorders = 0, BuyProfits = 0;
      double lt, LowestBuy = 1000, LastTradeOpenTimeBuy = 1000;
      for (int j = 0; j < OrdersTotal(); j++) 
	  {
         if (!OrderSelect(j, SELECT_BY_POS, MODE_TRADES)) 
		    continue;
         if(OrderMagicNumber() == MagicNumber && OrderSymbol() == symb && OrderType() == OP_SELL) 
		    sellorders ++;
         if(OrderMagicNumber() == MagicNumber && OrderSymbol() == symb && OrderType() == OP_BUY) {
            if ((buyorders == 0) || (buyorders>0 && OrderOpenTime()>LastTradeOpenTimeBuy)) LastTradeOpenTimeBuy = OrderOpenTime();
            if (OrderOpenPrice() < LowestBuy) {
               LowestBuy = OrderOpenPrice();
            }  
            buyorders++;
         }
      }
      double sdv = sprd / PipMultiplier * point * 3 + MathPow(iStdDev(symb, 15, 6, 0, 0, 0, 0), 0.9);
      if (sdv < GridSpacing * point) 
	     sdv = GridSpacing * point;//Set minimum of 20 for grid 
      if (!PauseTrading && buyorders == 0 && GlobalVariableGet(a + "xMeter_" + symb + "buy") == 1) 
      { //---- we can go trading
         lt = InitialLotSize;
         if ((1 - (AccountFreeMarginCheck(symb, OP_BUY, lt) / (AccountBalance() + AccountCredit()))) * 100 > MaxUsedMargin) //Do not open new cycle of trades if current trades are using more than allowed margin.
            return(false);
         BuyOK = true;
      }
      else if (buyorders > 0 && ask <= LowestBuy - sdv && GlobalVariableGet(a + "xMeter_" + symb + "buy") == 2 && (iBarShift(symb,TimeFilter,LastTradeOpenTimeBuy,false)>0)) { //---- we can go trading
         if (buyorders >= MartingaleShield) lt = NormalizeDouble(MathPow(Martingale, buyorders - 2) * InitialLotSize, lotPrecision);
         else lt = NormalizeDouble(InitialLotSize, lotPrecision);
         BuyOK = true;
      }   
	  
      //---- Check 
      if(BuyOK && useStochFilter)
      {
         BuyOK = Stochastic(symb, OP_BUY);
      }
	  
      if (!BuyOK) 
	     return(false);
      buyorders++;
      int Retry = 0, ticket = 0;
      while (Retry < 5 && !IsTradeAllowed()) {
         Retry++;
         Sleep(2000);
      }
      ticket = OrderSend(symb, OP_BUY, lt, NormalizeDouble(ask, digit), Slippage, 0, 0, EAversion + " #" + buyorders + " " + meters, MagicNumber, 0, Blue);
      Sleep(1000);
      if (ticket > 0) {
         if (OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) {
            GlobalVariableSet(a + "xMeter_" + symb + "buy", 2);
            Print("BUY order opened: ", symb, " at ", OrderOpenPrice());
            return(true);
         }
      }
      else
         Print("Error opening ", symb, " BUY order - Error#: ", GetLastError());
   }
   else
      Print("Error opening ", symb, " BUY order - Error#: BigSpread");
   return(false);
}
   
//+------------------------------------------------------------------+
//| Open new sell order (recovery if possible or normal)             |
//| Returns true if order successfully opened false otherwise        |
//+------------------------------------------------------------------+
bool ManageSell(string symb, int digit, string meters) 
{
   double bid    = MarketInfo(symb, MODE_BID);
   double point  = MarketInfo(symb, MODE_POINT) * PipMultiplier;
   double sprd   = MarketInfo(symb, MODE_SPREAD);
   bool   SellOK = false;
   if (!Initialized) 
      return(false);
   if (sprd <= SpreadLimit * PipMultiplier) 
   {
      int buyorders = 0, sellorders = 0, SellProfits = 0;
      double lt, HighestSell = 0, LastTradeOpenTimeSell = 1000;
      for (int j = 0; j < OrdersTotal(); j++) 
	  {
         if (!OrderSelect(j, SELECT_BY_POS, MODE_TRADES)) 
		    continue;
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == symb && OrderType() == OP_BUY) 
		    buyorders++;
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == symb && OrderType() == OP_SELL)  {
            if ((sellorders == 0) || (sellorders>0 && OrderOpenTime()>LastTradeOpenTimeSell)) LastTradeOpenTimeSell = OrderOpenTime();
            sellorders++;
            if (OrderOpenPrice() > HighestSell) { 
               HighestSell = OrderOpenPrice();
            }  
         }
      }                                          
      double sdv = sprd / PipMultiplier * point * 3 + MathPow(iStdDev(symb, 15, 6, 0, 0, 0, 0), 0.9);
      if (sdv < GridSpacing * point) sdv = GridSpacing * point; //Set minimum of 20 for grid spacing
      if (!PauseTrading && sellorders == 0 && GlobalVariableGet(a + "xMeter_" + symb + "sell") == 1) { //---- we can go trading
         lt = InitialLotSize;
         if ((1 - (AccountFreeMarginCheck(symb, OP_SELL, lt) / (AccountBalance() + AccountCredit()))) * 100 > MaxUsedMargin) //Do not open new cycle of trades if current trades are using more than allowed margin.
            return(false);
         SellOK = true;
      }
      else if (sellorders > 0 && bid >= HighestSell + sdv && GlobalVariableGet(a + "xMeter_" + symb + "sell") == 2 && (iBarShift(symb,TimeFilter,LastTradeOpenTimeSell,false)>0)) 
	  { //---- we can go trading
         if (sellorders >= MartingaleShield) 
		    lt = NormalizeDouble(MathPow(Martingale, sellorders - 2) * InitialLotSize, lotPrecision);
         else 
		    lt = NormalizeDouble(InitialLotSize, lotPrecision);
         SellOK = true;
      }

      //---- Check Stochastic
      if (SellOK && useStochFilter)
      {
         SellOK = Stochastic(symb, OP_SELL);
      }	  	  
	  
      if (!SellOK) 
         return(false);
      sellorders++;
      int Retry = 0, ticket = 0;
      while (Retry < 5 && !IsTradeAllowed()) 
	  {
         Retry++;
         Sleep(2000);
      }
      ticket = OrderSend(symb, OP_SELL, lt, NormalizeDouble(bid, digit), Slippage, 0, 0, EAversion + " #" + sellorders + " " + meters, MagicNumber, 0, Red);
      Sleep(1000);
      if (ticket > 0) 
	  {
         if (OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) 
		 {
            GlobalVariableSet(a + "xMeter_" + symb + "sell", 2);
            Print("SELL order opened : ", symb, " at ",OrderOpenPrice());
            return(true);
         }
      }
      else
         Print("Error opening ", symb, " SELL order : ", GetLastError());
   }
   else
      Print("Error opening ", symb, " SELL order - Error#: BigSpread");
   return(false);
}

//+------------------------------------------------------------------+
//| If trade is in profit greater than breakeven then set breakeven  |
//| stop or adjust DynamicStop.                                      |
//+------------------------------------------------------------------+
void DynamicBuySL(string symb, int buyorders, double bid, double point, int sprd, int digit) {
   double sdv = (sprd * point * 3) + iStdDev(symb, 15, 6, 0, 0, 0, 0) * 1.5; //Use Spread+StdDev to set SL 
   if (sdv < 25 * point) sdv = 25 * point; //Set minimum of 25 for trailing stop
   double Breakeven = sdv / 1.5;
   for (int cnt = 0; cnt < OrdersTotal(); cnt++) {
      if (!OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)) continue;
      if (OrderMagicNumber() == MagicNumber && OrderSymbol() == symb && OrderType() == OP_BUY) {
         if (buyorders == 1) {
            if (bid - OrderOpenPrice() + BreakEvenPips * point >= Breakeven && OrderStopLoss() < OrderOpenPrice())
               OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + BreakEvenPips * point, digit), OrderTakeProfit(), 0, Red);
            sl = NormalizeDouble(bid - sdv, digit);
            if (sl > 0 && sl - OrderOpenPrice() > 0 && sl - OrderStopLoss() > TP_MOVING * point) // adjust trailing stop in 5 pip increments
               OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(sl, digit), OrderTakeProfit(), 0, Red);
         }
         if (OrderStopLoss() == 0 || OrderStopLoss() < OrderOpenPrice()) {
            sl = NormalizeDouble(bid - STOPLOSS * point, digit);
            if (MathAbs(OrderStopLoss() - sl) > SL_MOVING * point)
               OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), 0, Red);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| If trade is in profit greater than breakeven then set breakeven  |
//| stop or adjust DynamicStop.                                      |
//+------------------------------------------------------------------+
void DynamicSellSL(string symb, int sellorders, double ask, double point, int sprd, int digit) {
   double sdv = (sprd * point * 3) + iStdDev(symb, 15, 6, 0, 0, 0, 0) * 1.5; //Use Spread+StdDev to set SL 
   if (sdv < 25 * point) sdv = 25 * point; //Set minimum of 25 for trailing stop
   double Breakeven = sdv / 1.5;
   for (int cnt = 0; cnt < OrdersTotal(); cnt++) {
      if (!OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)) continue;
      if (OrderMagicNumber() == MagicNumber && OrderSymbol() == symb && OrderType() == OP_SELL) {
         if (sellorders == 1) {
            if (OrderOpenPrice() - BreakEvenPips * point - ask >= Breakeven && (OrderStopLoss() > OrderOpenPrice() || OrderStopLoss() == 0))
               OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - BreakEvenPips * point, digit), OrderTakeProfit(), 0, Red);
            sl = NormalizeDouble(ask + sdv, digit);
            if (sl > 0 && OrderOpenPrice() - sl > 0 && OrderStopLoss() - sl > TP_MOVING * point) //Adjust in 5 pip increments
               OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(sl, digit), OrderTakeProfit(), 0, Red);
         }
         if (OrderStopLoss() == 0 || OrderStopLoss() > OrderOpenPrice()) {
            sl = NormalizeDouble(ask + STOPLOSS * point, digit);
            if (MathAbs(OrderStopLoss() - sl) > SL_MOVING * point)
               OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), 0, Red);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Adjust takeprofit as three times the Standard Deviation          |
//+------------------------------------------------------------------+
void DynamicBuyTP(string symb, int buyorders, double point, int sprd, int digit, double avgprice) {
   int cnt;
   if (buyorders == 1) {
      for (cnt = 0; cnt < OrdersTotal(); cnt++) {
         if (!OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)) continue;
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == symb && OrderType() == OP_BUY) {
            double sdv = (sprd / PipMultiplier * point * 3) + iStdDev(OrderSymbol(), 15, 6, 0, 0, 0, 0) * 3; //Use Spread+StdDev to set TP
            if (sdv < 30 * point) sdv = 30 * point;
            tp = OrderOpenPrice() + sdv;
            if (MathAbs(OrderTakeProfit() - tp) > TP_MOVING * point) //Adjust in 5 pip increments
               OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), NormalizeDouble(tp, digit), 0, Blue);
         }
      }
   }
   else if (buyorders > 1) {
      avgprice = NormalizeDouble(MathCeil(avgprice / Point) * Point + RecoveryPips * point, digit);
      for (cnt = 0; cnt < OrdersTotal(); cnt++) {
         if (!OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)) continue;
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == symb && OrderType() == OP_BUY && OrderTakeProfit() != avgprice)
            OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), avgprice, 0, CLR_NONE);
      }
   }
}
   
//+------------------------------------------------------------------+
//| Adjust takeprofit as three times the Standard Deviation          |
//+------------------------------------------------------------------+
void DynamicSellTP(string symb, int sellorders, double point, int sprd, int digit, double avgprice) {
   int cnt;
   if (sellorders == 1) {
      for (cnt = 0; cnt < OrdersTotal(); cnt++) {
         if (!OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)) continue;
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == symb && OrderType() == OP_SELL) {
            double sdv = (sprd / PipMultiplier * point * 3) + iStdDev(OrderSymbol(), 15, 6, 0, 0, 0, 0) * 3; //Use Spread+StdDev to set TP
            if (sdv < 30 * point) sdv = 30 * point;
            tp = OrderOpenPrice() - sdv;
            if (MathAbs(OrderTakeProfit() - tp) > TP_MOVING * point) //Adjust in 5 pip increments
               OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), NormalizeDouble(tp, digit), 0, Blue);
         }
      }
   }
   else if (sellorders > 1) {
      avgprice = NormalizeDouble(MathFloor(avgprice / Point) * Point - RecoveryPips * point, digit);
      for (cnt = 0; cnt < OrdersTotal(); cnt++) {
         if (!OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)) continue;
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == symb && OrderType() == OP_SELL && OrderTakeProfit() != avgprice)
            OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), avgprice, 0, CLR_NONE);
      }
   }
}
   
//+------------------------------------------------------------------+
//| Will pause trading between startime and endtime.                 |
//+------------------------------------------------------------------+
int PauseAtTime(int pStartTime, int pEndTime) {
   //evaluation of the weekly trading session
   if (pStartTime != 0) {
      int t = DayOfWeek() * 10000 + TimeHour(TimeCurrent()) * 100 + TimeMinute(TimeCurrent());
      if (t >= pStartTime || t <= pEndTime)
         PauseTrading = true;
      else
         PauseTrading = false; //Allow current cycle of trades to continue until all are closed by EA then pause
   }
   //evaluation of the daily trading session
   if (!PauseTrading && (Hour() >= DailyStartTime && Hour() <= DailyEndTime))
   {    
      PauseTrading = !AllowNewTrades;
   } else {
      PauseTrading = TRUE;
   }
}

//+------------------------------------------------------------------+
//| Display information                                              |
//+------------------------------------------------------------------+
void Comments(double OverallProfit) {
   double currentEquity = NormalizeDouble(100.0*(AccountBalance()+OverallProfit)/AccountBalance(), 2);

   //--- account properties ---
   message = "Account properties:" + NL +
      "   Leverage                 : " + AccountLeverage() + ":1" + NL +
      "   Lot (min / max / step): " + DoubleToStr(MarketInfo(Symbol(), MODE_MINLOT), 2) + " / " + DoubleToStr(MarketInfo(Symbol(), MODE_MAXLOT), 2) + " / " + DoubleToStr(MarketInfo(Symbol(), MODE_LOTSTEP), 2) + NL + NL +
      "Settings:" + NL +
      "   AccountRisk     : " + DoubleToStr(AccountRiskPercent, 4) + " (" + DoubleToStr(AutoLot(), 2) + " lots; limit: " + DoubleToStr(MaxInitialLotSize, 2) + " lots)" + NL +
      "   Equity Pct    : " + DoubleToStr(currentEquity, 2) + " / " + DoubleToStr(EquityProtection, 2) + NL +
      "   SwapMode      : " + SwapMode + " (";
   switch (SwapMode) {
      case 0: message = message + "don't care"; break;
      case 1: message = message + "better direction"; break;
      default:
         message = message + "non-negative direction"; break;
   }
   message = message + ")" + NL;
   
   message = message +
      "   TimeFilter        : ";
   switch (TimeFilter) {
      case 1: message = message + "M1"; break;
      case 5: message = message + "M5"; break;
      case 15: message = message + "M5"; break;
      case 30: message = message + "M30"; break;
      case 60: message = message + "H1"; break;
      case 240: message = message + "H4"; break;
      case 1440: message = message + "Daily"; break;
      case 10080: message = message + "Weekly"; break;
      case 43200: message = message + "Monthly"; break;
      default:
         message = message + "error in TimeFilter definition"; break;
   }  
//   message = message + NL;
   
   message = message +
      " --- RecoverTrigger : ";
   switch (RevRecoverTrigger) {
      case 1: message = message + "reversed"; break;
      case 0: message = message + "normal"; break;
   }  
   message = message + NL;
   
   message = message +
      "   SpreadLimit      : " + SpreadLimit;
   switch (PipMultiplier) {
      case 1: message = message + " (4 digit broker detected)"; break;
      case 10: message = message + " (5 digit broker detected)"; break;
   }
   //--- trading hours ---
   message = message + NL + 
      "   Trading hours: " + DoubleToStr(NormalizeDouble(DailyStartTime,2),2) + " - " + DoubleToStr(NormalizeDouble(DailyEndTime,2),2);   
   message = message + 
      " --- Weekend pause: " + pausetime;

   //--- signal in use ----
   message = message + NL + 
      "   signal used: - ";
   if (useStochFilter) {
      message = message + "!xMeter filtered with Stochastic - ";
   } else {
      message = message + "!xMeter - ";
   }

   message = message + NL + NL;

   //--- meters ---
   message = message + "Currency strengths: (" + TimeToStr(TimeCurrent()) + ")" + NL;
   for (int i = 0; i != CurrencyCount; i++)
      if (CurrPairs[i] >= MinCurrencyPairs)
         message = message + "   [" + CurrencyStrength(i) + "]  " + DoubleToStr(bMeter[i], 1) + "  " + aMajor[i] + NL;

   message = message + NL + "Allowed pairs for new orders & directions in priority order:" + NL;
   if (!PauseTrading) {
      message = message + "   buy: ";
      int count;
      int spread;
      count = 0;
      for (i = 0; i < TradeCountBuy; i++) {
         spread = MarketInfo(TradePairBuy[i], MODE_SPREAD);
         if (spread <= SpreadLimit * PipMultiplier) {
            if (count > 0) {
               message = message + "; ";
               if (count % 10 == 0) message = message + NL + "           ";
            }
            message = message + StringSubstr(TradePairBuy[i], 0, 6);
            count++;
         }
      }
      message = message + NL + "   sell : ";
      count = 0;
      for (i = 0; i < TradeCountSell; i++) {
         spread = MarketInfo(TradePairSell[i], MODE_SPREAD);
         if (spread <= SpreadLimit * PipMultiplier) {
            if (count > 0) {
               message = message + "; ";
               if (count % 10 == 0) message = message + NL + "           ";
            }
            message = message + StringSubstr(TradePairSell[i], 0, 6);
            count++;
         }
      }
   }
   else
      message = message + "   No new trades are allowed (AllowNewTrades = FALSE) except for recovery positions!";
   
   //--- active trades ---
   int items = ArraySize(OpenSymbol);
   message = message + NL + NL + "Working pairs (used margin: " + DoubleToStr((1 - AccountFreeMargin() / (AccountBalance() + AccountCredit())) * 100, 1) + "%; limit: " + MaxUsedMargin + "%):" + NL;
   if (items > 0) {
      for (i = 0; i != items; i++) {
         message = message + "   " + OpenCount[i] + "× " + StringSubstr(OpenSymbol[i], 0, 6) + StringSubstr(OpenSymbol[i], StringLen(OpenSymbol[i]) - 3) + ": " + DoubleToStr(OpenProfit[i], 2);
         if (i < ArraySize(OpenCorrel))
            if (OpenCorrel[i] != "") message = message + "   correlated pairs: " + OpenCorrel[i] + NL;
            else message = message + NL;
         else
            message = message + NL;
      }
   }
   else
      message = message + "   (none)"; 
   
   Comment(message);
}

//+------------------------------------------------------------------+
//| Return currency array ID for currency name                       |
//+------------------------------------------------------------------+
int ID(string currency) {
   for (int i = 0; i != CurrencyCount; i++)
      if (aMajor[i] == currency)
         return(i);
   return(-1);
}

//+------------------------------------------------------------------+
//| Return currency strength as a string                             |
//+------------------------------------------------------------------+
string CurrencyStrength(int index) {
   int value = MathRound(2.0 * bMeter[index] - 0.5);
   if (value > 18) value = 18;
   switch (value) {
      case 0:  return("                                    ");
      case 18: return("i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!");
      default: return(StringSubstr("i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!", 0, MathRound(value * 3)) +
                      StringSubstr("                                    ", 0, 36 - MathRound(2 * value)));
   }
}

//+------------------------------------------------------------------+
//| Select uncorrelated pairs and order them by current spread       |
//+------------------------------------------------------------------+
void SelectTradePairs() {
   int i;
   int j;
   //--- collect active pairs ---
   int ActiveBuyCount = 0;
   int ActiveSellCount = 0;
   string ActiveBuy[];
   string ActiveSell[];
   ArrayResize(ActiveBuy, 0);
   ArrayResize(ActiveSell, 0);

   for (i = 0; i != OrdersTotal(); i++) {
      if (!OrderSelect(i, SELECT_BY_POS)) continue;
      if (OrderMagicNumber() == MagicNumber) {
         bool found;
         if (OrderType() == OP_BUY) {
            found = false;
            for (j = 0; j != ActiveBuyCount; j++)
               if (ActiveBuy[j] == OrderSymbol()) {
                  found = true;
                  break;
               }
            if (!found) {
               ActiveBuyCount++;
               ArrayResize(ActiveBuy, ActiveBuyCount);
               ActiveBuy[ActiveBuyCount - 1] = OrderSymbol();
            }
         }
         else if (OrderType() == OP_SELL) {
            found = false;
            for (j = 0; j != ActiveSellCount; j++)
               if (ActiveSell[j] == OrderSymbol()) {
                  found = true;
                  break;
               }
            if (!found) {
               ActiveSellCount++;
               ArrayResize(ActiveSell, ActiveSellCount);
               ActiveSell[ActiveSellCount - 1] = OrderSymbol();
            }
         }
      }
   }
   //--- query all symbols and their spreads ---
   int TradeableCount = 0;
   string Symbols[];
   ArrayResize(Symbols, 0);
   for (i = 0; i != PairCount; i++) {
      int C1 = ID(StringSubstr(aPair[i], 0, 3));
      int C2 = ID(StringSubstr(aPair[i], 3, 3));
      if (CurrPairs[C1] >= MinCurrencyPairs && CurrPairs[C2] >= MinCurrencyPairs) { // do not use currency with too few data
         TradeableCount++;
         ArrayResize(Symbols, TradeableCount);
         int spread = 1000 + MarketInfo(aPair[i] + Suffix, MODE_SPREAD);
         Symbols[TradeableCount - 1] = DoubleToStr(spread, 0) + aPair[i] + Suffix; // put spread in string for sorting
      }
   }
   
   Sort(Symbols);
   for (i = 0; i != TradeableCount; i++) // remove spread from name
      Symbols[i] = StringSubstr(Symbols[i], 4);

   //--- allow everything at first ---
   TradeCountBuy = TradeableCount;
   TradeCountSell = TradeableCount;
   ArrayResize(TradePairBuy, TradeCountBuy);
   ArrayResize(TradePairSell, TradeCountSell);
   for (i = 0; i != TradeableCount; i++) {
      TradePairBuy[i] = Symbols[i];
      TradePairSell[i] = Symbols[i];
   }

   //--- calculate correlations for existing pairs ---
   //         correlation >= 0.75   ->  only reverse direction allowed
   //         correlation <= -0.75  ->  only same direction allowed
   // -0.75 < correlation <  0.75   ->  any entry allowed
   string pair1;
   string pair2;
   double correl;
   int pos;
   int k;
   int items = ArraySize(OpenSymbol);
   ArrayResize(OpenCorrel, items);
   for (i = 0; i != items; i++)
      OpenCorrel[i] = "";
   for (i = TradeableCount - 1; i >= 0; i--) {
      pair1 = Symbols[i];
      for (j = 0; j != ActiveBuyCount; j++) {
         pair2 = ActiveBuy[j];
         //--- find pair index ---
         pos = FindSymbol(OpenSymbol, pair2 + "(+)");
         //calculate correlation between pair1 and pair2
         correl = Correlation(pair1, pair2);
         if (correl >= Correlation) {
            //--- existing pair1 and pair2 (existing buy) correlate in same direction ---
            //--- deny buying pair1 ---
            RemoveSymbol(TradePairBuy, pair1, TradeCountBuy);
            if (pos > -1 && pair1 != pair2)
               if (OpenCorrel[pos] == "")
                  OpenCorrel[pos] = StringSubstr(pair1, 0, 6) + "(+)";
               else
                  OpenCorrel[pos] = OpenCorrel[pos] + "; " + StringSubstr(pair1, 0, 6) + "(+)";
         }
         else if (correl <= -Correlation) {
            //--- existing pair1 and pair2 (existing buy) correlate in same direction ---
            //--- deny selling pair1 ---
            RemoveSymbol(TradePairSell, pair1, TradeCountSell);
            if (pos > -1 && pair1 != pair2)
               if (OpenCorrel[pos] == "")
                  OpenCorrel[pos] = StringSubstr(pair1, 0, 6) + "(-)";
               else
                  OpenCorrel[pos] = OpenCorrel[pos] + "; " + StringSubstr(pair1, 0, 6) + "(-)";
         }
      }
      for (j = 0; j != ActiveSellCount; j++) {
         pair2 = ActiveSell[j];
         //--- find pair index ---
         pos = FindSymbol(OpenSymbol, pair2 + "(-)");
         //calculate correlation between pair1 and pair2
         correl = Correlation(pair1, pair2);
         if (correl >= Correlation) {
            //--- existing pair1 and pair2 (existing sell) correlate in same direction ---
            //--- deny selling pair1 ---
            RemoveSymbol(TradePairSell, pair1, TradeCountSell);
            if (pos > -1 && pair1 != pair2)
               if (OpenCorrel[pos] == "")
                  OpenCorrel[pos] = StringSubstr(pair1, 0, 6) + "(+)";
               else
                  OpenCorrel[pos] = OpenCorrel[pos] + "; " + StringSubstr(pair1, 0, 6) + "(+)";
         }
         else if (correl <= -Correlation) {
            //--- existing pair1 and pair2 (existing sell) correlate in same direction ---
            //--- deny buying pair1 ---
            RemoveSymbol(TradePairBuy, pair1, TradeCountBuy);
            if (pos > -1 && pair1 != pair2)
               if (OpenCorrel[pos] == "")
                  OpenCorrel[pos] = StringSubstr(pair1, 0, 6) + "(-)";
               else
                  OpenCorrel[pos] = OpenCorrel[pos] + "; " + StringSubstr(pair1, 0, 6) + "(-)";
         }
      }
   }

   //--- remove symbols that cannot be bought or sold ---
   for (i = TradeableCount - 1; i >= 0; i--) {
      found = false;
      for (j = 0; j != TradeCountBuy; j++)
         if (Symbols[i] == TradePairBuy[j]) {
            found = true;
            break;
         }
      if (!found)
         for (j = 0; j != TradeCountSell; j++)
            if (Symbols[i] == TradePairSell[j]) {
               found = true;
               break;
            }
      if (!found) {
         //--- remove symbol ---
         RemoveSymbol(Symbols, Symbols[i], TradeableCount);
      }
   }
}


//+------------------------------------------------------------------+
//| calculate correlation between the two symbols                    |
//+------------------------------------------------------------------+
double Correlation(string Symbol1, string Symbol2) {
   int TimeFrame = PERIOD_H1;
   double Count = xMeterLookBackPer;
   
   double sum_xy = 0;
   double sum_x  = 0;
   double sum_y  = 0;
   double sum_xx = 0;
   double sum_yy = 0;
   double divider = 0;
   
   for (int i = 0; i != Count; i++) {
      double x = iClose(Symbol1, TimeFrame, i + 1);
      double y = iClose(Symbol2, TimeFrame, i + 1);
      
      sum_x += x;
      sum_y += y;
      sum_xy += (x * y);
      sum_xx += (x * x);
      sum_yy += (y * y);
   }
   divider = MathSqrt((Count * sum_xx - (sum_x * sum_x)) * (Count * sum_yy - (sum_y * sum_y)));
   if (divider==0) divider=1;
   return((Count * sum_xy - sum_x * sum_y) / divider);
}

//+------------------------------------------------------------------+
//| Filter allowed trade pairs based on selected swap mode           |
//+------------------------------------------------------------------+
void FilterBySwap() {
   if (SwapMode == SWAP_DONT_CARE) return;
   int i;
   double swap;
   string pair;
   //--- handle buys ---
   for (i = TradeCountBuy - 1; i >= 0; i--) {
      pair = TradePairBuy[i];
      swap = MarketInfo(pair, MODE_SWAPLONG);
      if (SwapMode == SWAP_BETTER) {
         if (swap < MarketInfo(pair, MODE_SWAPSHORT)) {
            //long has a worse swap rate than short, remove long
            RemoveSymbol(TradePairBuy, pair, TradeCountBuy);
         }
      }
      else if (SwapMode == SWAP_POSITIVE) {
         if (swap < 0) {
            //long has a negative swap rate, remove long
            RemoveSymbol(TradePairBuy, pair, TradeCountBuy);
         }
      }
   }
   //--- handle sells ---
   for (i = TradeCountSell - 1; i >= 0; i--) {
      pair = TradePairSell[i];
      swap = MarketInfo(pair, MODE_SWAPSHORT);
      if (SwapMode == SWAP_BETTER) {
         if (swap < MarketInfo(pair, MODE_SWAPLONG)) {
            //short has a worse swap rate than long, remove short
            RemoveSymbol(TradePairSell, pair, TradeCountSell);
         }
      }
      else if (SwapMode == SWAP_POSITIVE) {
         if (swap < 0) {
            //short has a negative swap rate, remove short
            RemoveSymbol(TradePairSell, pair, TradeCountSell);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| remove symbol from array                                         |
//+------------------------------------------------------------------+
void RemoveSymbol(string &SymbolArray[], string Symb, int &Count) {
   int total = ArraySize(SymbolArray);
   for (int i = 0; i != total; i++)
      if (SymbolArray[i] == Symb) {
         for (int j = i + 1; j != total; j++)
            SymbolArray[j - 1] = SymbolArray[j];
         ArrayResize(SymbolArray, total - 1);
         Count--;
         break;
      }  
}

//+------------------------------------------------------------------+
//| sort string array                                                |
//+------------------------------------------------------------------+
void Sort(string &StrArray[]) {
   int total = ArraySize(StrArray);
   if (total > 0) {
      int i;
      int j;
      for (i = 0; i != total - 1; i++)
         for (j = i + 1; j != total; j++) {
            if (StrArray[j] < StrArray[i]) {
               //--- swap [i] and [j] ---
               string s = StrArray[j];
               StrArray[j] = StrArray[i];
               StrArray[i] = s;
            }
         }
   }
}

//+------------------------------------------------------------------+
//| find item in specified symbol array                              |
//+------------------------------------------------------------------+
int FindSymbol(string &SymbolArray[], string ToFind) {
   for (int j = 0; j < ArraySize(SymbolArray); j++)
      if (SymbolArray[j] == ToFind)
         return(j);
   return(-1);
}

//+------------------------------------------------------------------+
//| pause time to string                                             |
//+------------------------------------------------------------------+
string PauseToStr(int ptime) {
   string dayname[7] = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
   string hour = ((ptime / 100) % 100);
   if (StringLen(hour) == 1) hour = "0" + hour;
   string min = (ptime % 100);
   if (StringLen(min) == 1) min = "0" + min;
   return(dayname[ptime / 10000] + " " + hour + ":" + min);
}

//+------------------------------------------------------------------+
//| stochastic indicator                                             |
//+------------------------------------------------------------------+
bool Stochastic(string symbol, int operation)
{
   bool result = FALSE;
   
   double Sto_K0 = iStochastic (symbol, StoPeriod, 14, 3, 3, MODE_SMA, 0, MODE_MAIN, 0);
   double Sto_K1 = iStochastic (symbol, StoPeriod, 14, 3, 3, MODE_SMA, 0, MODE_MAIN, 1);
   double Sto_D0 = iStochastic (symbol, StoPeriod, 14, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 0);
   double Sto_D1 = iStochastic (symbol, StoPeriod, 14, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 1);

   if (operation == OP_BUY) {
      if (StoCalc == 1)
         if (Sto_K0 <= 20 && Sto_K0 > Sto_K1 && Sto_K1 < Sto_D1 && Sto_K0 > Sto_D0)  
            result = true;
      else if (StoCalc == 2)
         if (Sto_K1 <= 20 && Sto_K0 >= 20)
            result = true;
      else if (StoCalc == 3)
         if (Sto_K0 > Sto_K1)
            result = true;
   } else if (operation == OP_SELL) {
      if (StoCalc == 1)
         if (Sto_K0 >= 80 && Sto_K0 < Sto_K1 && Sto_K1 > Sto_D1 && Sto_K0 < Sto_D0)  
            result = true;
      else if (StoCalc == 2)
         if (Sto_K0 <= 80 && Sto_K1 >= 80)
            result = true;
      else if (StoCalc == 3)
         if (Sto_K0 < Sto_K1)
            result = true;
   } else {
      result = FALSE;
   }
   return(result);
}

//+------------------------------------------------------------------+
//| closes all trades managed by this EA                             |
//+------------------------------------------------------------------+
bool CloseAll(string symbole="") {
   for (int l_pos_0 = OrdersTotal() - 1; l_pos_0 >= 0; l_pos_0--) {
      if (!OrderSelect(l_pos_0, SELECT_BY_POS)) continue;
      if ((symbole=="" || symbole==OrderSymbol()) && OrderMagicNumber() == MagicNumber) {
         Print("close #" + OrderTicket());
         if (!OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), MarketInfo(Symbol(), MODE_SPREAD), White)) {
            return (FALSE);
         }
      }
   }
   return(TRUE);
}

