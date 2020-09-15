
#property  indicator_separate_window

#property  indicator_buffers  7

#property  indicator_color1  DodgerBlue  // 0: Long signal
#property  indicator_color2  Crimson     // 1: Short signal
#property  indicator_color3  DodgerBlue  // 2: Long turn
#property  indicator_color4  Crimson     // 3: Short turn
#property  indicator_color5  Yellow      // 4: SMA
#property  indicator_color6  -1          // 6: Ha open
#property  indicator_color7  -1          // 7: Ha close

#property  indicator_style1  STYLE_SOLID
#property  indicator_style2  STYLE_SOLID
#property  indicator_style3  STYLE_SOLID
#property  indicator_style4  STYLE_SOLID
#property  indicator_style5  STYLE_SOLID
#property  indicator_style6  STYLE_SOLID
#property  indicator_style7  STYLE_SOLID

#property  indicator_width1  1
#property  indicator_width2  1
#property  indicator_width3  0
#property  indicator_width4  0
#property  indicator_width5  1
#property  indicator_width6  1
#property  indicator_width7  1

//---- defines
#define DarkDodgerBlue  0x80481e
#define DarkCrimson     0x1e0a6e

//---- indicator parameters
extern int    nAve        = 13;     // iMA(), period
extern int    stoK        = 21;     // iStochastic(), K%
extern int    stoD        = 3;      // iStochastic(), D%
extern int    stoSlowing  = 3;      // iStochastic(), slowing
extern int    nHiLoRange  = 10;     // number of bars to check hi/lo range
extern double thRange     = 10;     // active hi/lo range, ex. 10(pips) moved in 10(min)
extern int    nMaxBars    = 2000;   // max number of bars to calculate
extern bool   bAlert      = false;  // alert using PlaySound()

//---- indicator buffers
double BufferLongTrigger[];   // 0: Long trigger
double BufferShortTrigger[];  // 1: Short trigger
double BufferLongTurn[];      // 2: Long turn
double BufferShortTurn[];     // 3: Short turn
double BufferAve[];           // 4: MA
double BufferHaOpen[];        // 5: Ha open
double BufferHaClose[];       // 6: Ha close

//---- vars
string   sIndicatorName = "Tetsujin Suzuki";
string   sPrefix;
int      g_window;
int      markLongTrigger  = 233;
int      markLongTurn     = 167;
int      markShortTrigger = 234;
int      markShortTurn    = 167;
bool     bDecorate        = true;  // draw HeikinAshi
datetime tAlertEntry;
datetime tAlertExit;

//----------------------------------------------------------------------
void init()
{
    sIndicatorName = sIndicatorName + "(" + nAve + "," + stoK + "," + stoD + "," + stoSlowing + ")";
    sPrefix = sIndicatorName;
    
    IndicatorShortName(sIndicatorName);
    
    SetIndexBuffer(0, BufferLongTrigger);
    SetIndexBuffer(1, BufferShortTrigger);
    SetIndexBuffer(2, BufferLongTurn);
    SetIndexBuffer(3, BufferShortTurn);
    SetIndexBuffer(4, BufferAve);
    SetIndexBuffer(5, BufferHaOpen);
    SetIndexBuffer(6, BufferHaClose);
    
    SetIndexLabel(0, "Long trigger");
    SetIndexLabel(1, "Short trigger");
    SetIndexLabel(2, "Long turn");
    SetIndexLabel(3, "Short turn");
    SetIndexLabel(4, "Ave");
    SetIndexLabel(5, "Ha open");
    SetIndexLabel(6, "Ha close");
    
    SetIndexStyle(0, DRAW_ARROW);
    SetIndexStyle(1, DRAW_ARROW);
    SetIndexStyle(2, DRAW_ARROW);
    SetIndexStyle(3, DRAW_ARROW);
    SetIndexStyle(4, DRAW_LINE);
    SetIndexStyle(5, DRAW_LINE);
    SetIndexStyle(6, DRAW_LINE);
    
    SetIndexArrow(0, markLongTrigger);
    SetIndexArrow(1, markShortTrigger);
    SetIndexArrow(2, markLongTurn);
    SetIndexArrow(3, markShortTurn);
    
    SetIndexDrawBegin(0, nAve);
    SetIndexDrawBegin(1, nAve);
    SetIndexDrawBegin(2, nAve);
    SetIndexDrawBegin(3, nAve);
    SetIndexDrawBegin(4, nAve);
    SetIndexDrawBegin(5, nAve);
    SetIndexDrawBegin(6, nAve);
}

//----------------------------------------------------------------------
void deinit()
{
    int n = ObjectsTotal();
    for (int i = n - 1; i >= 0; i--) {
	string sName = ObjectName(i);
	if (StringFind(sName, sPrefix) == 0) {
	    ObjectDelete(sName);
	}
    }
}

//----------------------------------------------------------------------
void objLine(string sName, datetime ts, double ps, datetime te, double pe, color col, int width = 1, bool ray = false)
{
    sName = sPrefix + sName;
    
    if (g_window >= 0) {
	ObjectCreate(sName, OBJ_TREND, g_window, 0, 0);
	ObjectSet(sName, OBJPROP_TIME1, ts);
	ObjectSet(sName, OBJPROP_PRICE1, ps);
	ObjectSet(sName, OBJPROP_TIME2, te);
	ObjectSet(sName, OBJPROP_PRICE2, pe);
	ObjectSet(sName, OBJPROP_COLOR, col);
	ObjectSet(sName, OBJPROP_WIDTH, width);
	ObjectSet(sName, OBJPROP_RAY, ray);
    }
}

//----------------------------------------------------------------------
void start()
{
    g_window = WindowFind(sIndicatorName);
    
    int limit;
    int counted_bars = IndicatorCounted();
    
    if (counted_bars > 0) {
	counted_bars--;
    }
    
    limit = Bars - counted_bars;
    int limit0 = limit;
    if (nMaxBars > 0) {
	limit = MathMin(limit, nMaxBars);
    }
    
    // clear beyond limits
    for (int i = limit0 - 1; i >= limit; i--) {
	BufferLongTrigger[i]  = EMPTY_VALUE;  // 0: Long trigger
	BufferShortTrigger[i] = EMPTY_VALUE;  // 1: Short trigger
	BufferLongTurn[i]     = EMPTY_VALUE;  // 2: Long turn
	BufferShortTurn[i]    = EMPTY_VALUE;  // 3: Short turn
	BufferAve[i]          = EMPTY_VALUE;  // 4: ave
	BufferHaOpen[i]       = EMPTY_VALUE;  // 5: Ha open
	BufferHaClose[i]      = EMPTY_VALUE;  // 6: Ha close
    }
    
    double vLong;
    double vShort;
    double ofst = Point * 5;
    
    for (i = limit - 1; i >= 0; i--) {
	BufferAve[i] = iMA(NULL, 0, nAve, 0, MODE_SMA, PRICE_CLOSE, i);
	BufferHaOpen[i]  = (BufferHaOpen[i + 1] + BufferHaClose[i + 1]) / 2;
	BufferHaClose[i] = (Open[i] + Close[i] + High[i] + Low[i]) / 4;
	
	double ave2 = BufferAve[i + 2];
	double ave1 = BufferAve[i + 1];
	
	double haOpen2 = BufferHaOpen[i + 2];
	double haOpen1 = BufferHaOpen[i + 1];
	
	double haClose2 = BufferHaClose[i + 2];
	double haClose1 = BufferHaClose[i + 1];
	
	double haDir2 = haClose2 - haOpen2;
	double haDir1 = haClose1 - haOpen1;
	
	double stoK2 = iStochastic(NULL, 0, stoK, stoD, stoSlowing, MODE_SMA, PRICE_CLOSE, MODE_MAIN, i + 2);
	double stoK1 = iStochastic(NULL, 0, stoK, stoD, stoSlowing, MODE_SMA, PRICE_CLOSE, MODE_MAIN, i + 1);
	
	double stoD2 = iStochastic(NULL, 0, stoK, stoD, stoSlowing, MODE_SMA, PRICE_CLOSE, MODE_SIGNAL, i + 2);
	double stoD1 = iStochastic(NULL, 0, stoK, stoD, stoSlowing, MODE_SMA, PRICE_CLOSE, MODE_SIGNAL, i + 1);
	
	double range1 = High[iHighest(NULL, 0, MODE_HIGH, nHiLoRange, i + 1)] - Low[iLowest(NULL, 0, MODE_LOW, nHiLoRange, i + 1)];
	
	// check trigger
	if (range1 >= thRange * Point) {
	    bool bEntry = false;
	    bool bExit = false;
	    BufferLongTrigger[i]  = EMPTY_VALUE;
	    BufferShortTrigger[i] = EMPTY_VALUE;
	    
	    // check long trigger
	    if (BufferLongTurn[i + 1] == EMPTY_VALUE) {
		bool bHa = (haDir1 >= 0 && haClose1 >= ave1);
		bool bSto = (stoK1 >= stoK2);
		bool bAve = (ave1 >= ave2);
		if (bHa && bSto && bAve) {
		    if (haOpen1 < ave1 || haDir2 < 0 || BufferLongTurn[i + 1] == EMPTY_VALUE) {
			
			if (BufferLongTurn[i + 1] == EMPTY_VALUE) {
			    vLong = ave1 - ofst;
			}
			bEntry = true;
			BufferLongTrigger[i] = ave1 - ofst;
			BufferLongTurn[i] = vLong;
		    }
		}
	    }
	    
	    // check short trigger
	    if (BufferShortTurn[i + 1] == EMPTY_VALUE) {
		bHa = (haDir1 < 0 && haClose1 < ave1);
		bSto = (stoK1 < stoK2);
		bAve = (ave1 < ave2);
		if (bHa && bSto && bAve) {
		    if (haOpen1 >= ave1 || haDir2 >= 0 || BufferShortTurn[i + 1] == EMPTY_VALUE) {
			
			if (BufferShortTurn[i + 1] == EMPTY_VALUE) {
			    vShort = ave1 + ofst;
			}
			bEntry = true;
			BufferShortTrigger[i] = ave1 + ofst;
			BufferShortTurn[i] = vShort;
		    }
		}
	    }
	}
	
	// check turn continue
	{
	    // check long turn
	    if (BufferLongTrigger[i + 1] != EMPTY_VALUE || BufferLongTurn[i + 1] != EMPTY_VALUE) {
		if (haDir1 < 0 || (stoK2 >= stoD2 && stoK1 < stoD1)) {
		    bExit = true;
		    BufferLongTurn[i] = EMPTY_VALUE;
		} else {
		    BufferLongTurn[i] = BufferLongTurn[i + 1];
		}
	    }
	    
	    // check short turn
	    if (BufferShortTrigger[i + 1] != EMPTY_VALUE || BufferShortTurn[i + 1] != EMPTY_VALUE) {
		if (haDir1 >= 0 || (stoK2 < stoD2 && stoK1 >= stoD1)) {
		    bExit = true;
		    BufferShortTurn[i] = EMPTY_VALUE;
		} else {
		    BufferShortTurn[i] = BufferShortTurn[i + 1];
		}
	    }
	}
    }
    
    if (bAlert) {
	datetime t0 = Time[0];
	if (bEntry && t0 != tAlertEntry) {
	    PlaySound("alert.wav");
	    tAlertEntry = t0;
	}
	if (bExit && t0 != tAlertExit) {
	    PlaySound("alert2.wav");
	    tAlertExit = t0;
	}
    }
    
    if (bDecorate) {
	// HeikinAshi
	for (i = nMaxBars - 1; i >= 0; i--) {
	    int w = 3;
	    datetime ts = Time[i];
	    datetime te = Time[i];
	    double ps = BufferHaOpen[i];
	    double pe = BufferHaClose[i];
	    color col;
	    if (pe >= ps) {
		col = DarkDodgerBlue;
	    } else {
		col = DarkCrimson;
	    }
	    objLine("line" + i, ts, ps, te, pe, col, w);
	}
	
	WindowRedraw();
    }
}