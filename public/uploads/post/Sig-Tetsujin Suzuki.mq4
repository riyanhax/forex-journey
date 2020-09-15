
#property  indicator_chart_window

#property  indicator_buffers  2

#property  indicator_color1  DodgerBlue
#property  indicator_color2  Crimson

#property  indicator_width1  1
#property  indicator_width2  1

//---- defines

//---- indicator parameters
extern int    nStopLossRange   = 1;   // draw S/L line in last N bars min/max
extern int    nBarAfterSignal  = 3;  // length of S/L line
extern double takeProfit       = 10;
extern double stopLossMax      = 10;
//
/*extern*/ string sHelp0 = "--- params for \"Tetsujin Suzuki\"";
/*extern*/ string sIndTetsujinSuzuki  = "Tetsujin Suzuki";
extern int    nAve        = 13;     // iMA(), period
extern int    stoK        = 21;     // iStochastic(), K%
extern int    stoD        = 3;      // iStochastic(), D%
extern int    stoSlowing  = 3;      // iStochastic(), slowing
extern int    nHiLoRange  = 10;     // number of bars to check hi/lo range
extern double thRange     = 10;     // active hi/lo range, ex. 10(pips) moved in 10(min)
extern int    nMaxBars    = 2000;   // max number of bars to calculate
extern bool   bAlert      = false;  // alert using PlaySound()
/*extern*/ string sHelp1 = "--- end of params for \"Tetsujin Suzuki\"";
//
/*extern*/ color  colLong       = DodgerBlue;  // color for long lines
/*extern*/ color  colShort      = Crimson;     // color for short lines
/*extern*/ color  colLongDark   = 0x80481e;    // color for long lines
/*extern*/ color  colShortDark  = 0x1e0a6e;    // color for short lines

//---- indicator buffers
double BufferLong[];   // 0: long signal
double BufferShort[];  // 2: short signal

//---- vars
string sIndicatorName  = "Sig-TetsujinSuzuki";
string sPrefix;
double point;
int    markLong   = 233;
int    markShort  = 234;

//----------------------------------------------------------------------
void init()
{
    sPrefix = sIndicatorName;
    
    IndicatorShortName(sIndicatorName);
    
    SetIndexBuffer(0, BufferLong);
    SetIndexBuffer(1, BufferShort);
    
    SetIndexLabel(0, "Long signal");
    SetIndexLabel(1, "Short signal");
    
    SetIndexStyle(0, DRAW_ARROW);
    SetIndexStyle(1, DRAW_ARROW);
    
    SetIndexArrow(0, markLong);
    SetIndexArrow(1, markShort);
    
    if (point == 0.0) {
	point = Point;
    }
    
    takeProfit *= point;
    stopLossMax *= point;
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
void objLine(string sName, datetime ts, double ps, datetime te, double pe, color col,
	     int width = 1, int style = STYLE_SOLID, bool bBack = true, bool bRay = false)
{
    ObjectCreate(sName, OBJ_TREND, 0, 0, 0, 0);
    ObjectSet(sName, OBJPROP_TIME1,  ts);
    ObjectSet(sName, OBJPROP_PRICE1, ps);
    ObjectSet(sName, OBJPROP_TIME2,  te);
    ObjectSet(sName, OBJPROP_PRICE2, pe);
    ObjectSet(sName, OBJPROP_COLOR, col);
    ObjectSet(sName, OBJPROP_WIDTH, width);
    ObjectSet(sName, OBJPROP_STYLE, style);
    ObjectSet(sName, OBJPROP_BACK, bBack);
    ObjectSet(sName, OBJPROP_RAY, bRay);
}	    

//----------------------------------------------------------------------
void start()
{
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
    
    double ofst = 3 * point;
    
    // clear beyond limits
    for (int i = limit0 - 1; i >= limit; i--) {
	BufferLong[i]  = EMPTY_VALUE;
	BufferShort[i] = EMPTY_VALUE;
    }
    
    for (i = limit - 1; i >= 0; i--) {
	BufferLong[i]  = EMPTY_VALUE;
	BufferShort[i] = EMPTY_VALUE;
	
	double bufLong  = iCustom(NULL, 0, sIndTetsujinSuzuki, nAve, stoK, stoD, stoSlowing, nHiLoRange, thRange, nMaxBars, bAlert, 0, i);
	double bufShort = iCustom(NULL, 0, sIndTetsujinSuzuki, nAve, stoK, stoD, stoSlowing, nHiLoRange, thRange, nMaxBars, bAlert, 1, i);
	
	bool bLong = false;
	bool bShort = false;
	
	// long
	if (bufLong != EMPTY_VALUE) {
	    bLong = true;
	    BufferLong[i] = Low[i] - ofst;
	}
	
	// short
	if (bufShort != EMPTY_VALUE) {
	    bShort = true;
	    BufferShort[i] = High[i] + ofst;
	}
	
	if (bLong || bShort) {
	    if (nStopLossRange >= 0) {
		string sNameStopLossH = sPrefix + Time[i] + " SL H";
		string sNameStopLossV = sPrefix + Time[i] + " SL V";
		string sNameTakeProfit0 = sPrefix + Time[i] + " TP0";
		string sNameTakeProfit1 = sPrefix + Time[i] + " TP1";
		datetime t0 = Time[i];
		datetime t1 = t0 + 1 * Period() * 60;
		datetime t2 = t0 + 5 * Period() * 60;
		datetime ts = Time[i + nStopLossRange];
		datetime te = Time[i] + nBarAfterSignal * Period() * 60;
		double o = Open[i];
		if (bLong) {
		    double p;
		    if (nStopLossRange > 0) {
			p = MathMax(Low[iLowest(NULL, 0, MODE_LOW, nStopLossRange, i + 1)], o - stopLossMax);
		    } else {
			p = o - stopLossMax;
		    }
		    objLine(sNameStopLossH, ts, p, te, p, colLongDark);
		    objLine(sNameStopLossV, t0, p, t0, p + 3 * Point, colLong);
		    objLine(sNameTakeProfit0, t0, o, t1, o + takeProfit, colLong);
		    objLine(sNameTakeProfit1, t1, o + takeProfit, t2, o + takeProfit, colLong);
		} else {
		    if (nStopLossRange > 0) {
			p = MathMin(High[iHighest(NULL, 0, MODE_HIGH, nStopLossRange, i + 1)], o + stopLossMax);
		    } else {
			p = o + stopLossMax;
		    }
		    objLine(sNameStopLossH, ts, p, te, p, colShortDark);
		    objLine(sNameStopLossV, t0, p, t0, p - 3 * Point, colShort);
		    objLine(sNameTakeProfit0, t0, o, t1, o - takeProfit, colShort);
		    objLine(sNameTakeProfit1, t1, o - takeProfit, t2, o - takeProfit, colShort);
		}
	    }
	}
    }
    
    WindowRedraw();
}