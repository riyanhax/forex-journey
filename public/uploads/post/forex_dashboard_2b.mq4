#property copyright "code mod by inko dot gnito at gmx dot net"

#property indicator_chart_window

extern string RUSOpenTime = "02:00";
extern string RUSCloseTime = "00:00";
extern string FTSEOpenTime = "09:00";
extern string FTSECloseTime = "22:00";
extern string DAXOpenTime = "08:00";
extern string DAXCloseTime = "22:00";
extern string EUXOpenTime = "08:00";
extern string EUXCloseTime = "22:00";
extern string CACOpenTime = "09:00";
extern string CACCloseTime = "17:30";
extern string SMIOpenTime = "09:00";
extern string SMICloseTime = "17:30";
extern string a1="-----------------------------------------------------------------------";
extern string a2="Non-Forex Symbols:";
extern string a3="adjust to your brokers label (case-sensitive)";
extern string US_ES="Usa500Sep10";
extern string US_YM="UsaIndSep10";
extern string US_NQ="UsaTecSep10";
extern string US_ER2="UsaRusSep10";
extern string Ger_DAX="Ger30Sep10";
extern string Eur_FESX="Euro50Sep10";
extern string Fra_CAC="Fra40Aug10";
extern string CH_SMI="Swi20Sep10";
extern string UK_FTSE="UK100Sep10";
extern string Gold_Symbol="GOLD";
extern string Silver_Symbol="SILVER";
extern string Oil_Symbol="LCrudeSep10";
extern string Copper_Symbol="CopperSep10";
extern string a4="-----------------------------------------------------------------------";
extern string a5="Buy/Sell Levels";
extern int buy_level = 90;
extern int sell_level = 10;
extern string a6="-----------------------------------------------------------------------";
extern string a7="Force Refresh of data";
extern bool   ForceRefresh=FALSE;
int g_corner_188 = 0;
int gi_192 = 0;
int gi_196 = 0;
bool gi_200 = FALSE;
bool gi_204 = FALSE;
int fontsize_small=10;
int fontsize_fxlabel=10;

int init() {
   initGraph();
   return (0);
}

int deinit() {
   ObjectsDeleteAll(0, OBJ_LABEL);
   return (0);
}

int start() {
   double ld_336;
   double ld_344;
   double ld_352;
   double ld_360;
   double ld_368;
   double ld_376;
   double ld_384;
   double ld_392;
   double ld_400;
   double ld_408;
   double ld_416;
   double ld_424;
   double ld_432;
   double ld_440;
   double ld_448;
   double ld_456;
   double ld_464;
   double ld_472;
   double ld_480;
   double ld_488;
   double ld_496;
   double ld_504;
   double ld_512;
   double ld_520;
   double ld_528;
   double ld_536;
   double ld_544;
   double ld_552;
   double ld_560;
   double ld_568;
   double ld_576;
   double ld_584;
   double ld_592;
   double ld_600;
   double ld_608;
   double ld_616;
   double ld_624;
   double ld_632;
   double ld_640;
   double ld_648;
   double ld_656;
   double Strength_CH_SMI;
   double Strength_Silver;
   double Strength_Copper;
   ObjectDelete("title2");
   ObjectDelete("audjpy");
   ObjectDelete("audnzd");
   ObjectDelete("audusd");
   ObjectDelete("cadchf");
   ObjectDelete("cadjpy");
   ObjectDelete("chfjpy");
   ObjectDelete("euraud");
   ObjectDelete("eurchf");
   ObjectDelete("eurgbp");
   ObjectDelete("eurjpy");
   ObjectDelete("eurnzd");
   ObjectDelete("eurusd");
   ObjectDelete("gbpchf");
   ObjectDelete("gbpjpy");
   ObjectDelete("nzdjpy");
   ObjectDelete("nzdusd");
   ObjectDelete("usdcad");
   ObjectDelete("usdchf");
   ObjectDelete("usdhkd");
   ObjectDelete("usdjpy");
   double ld_0 = iHigh("AUDJPY", PERIOD_D1, 0) - iLow("AUDJPY", PERIOD_D1, 0);
   double ld_8 = iHigh("AUDNZD", PERIOD_D1, 0) - iLow("AUDNZD", PERIOD_D1, 0);
   double ld_16 = iHigh("AUDUSD", PERIOD_D1, 0) - iLow("AUDUSD", PERIOD_D1, 0);
   double ld_24 = iHigh("AUDEUR", PERIOD_D1, 0) - iLow("AUDEUR", PERIOD_D1, 0);
   double ld_32 = iHigh("GBPAUD", PERIOD_D1, 0) - iLow("GBPAUD", PERIOD_D1, 0);
   double ld_40 = iHigh("AUDCHF", PERIOD_D1, 0) - iLow("AUDCHF", PERIOD_D1, 0);
   double ld_48 = iHigh("AUDCAD", PERIOD_D1, 0) - iLow("AUDCAD", PERIOD_D1, 0);
   double ld_56 = iHigh("CHFJPY", PERIOD_D1, 0) - iLow("CHFJPY", PERIOD_D1, 0);
   double ld_64 = iHigh("NZDCHF", PERIOD_D1, 0) - iLow("NZDCHF", PERIOD_D1, 0);
   double ld_72 = iHigh("USDCHF", PERIOD_D1, 0) - iLow("USDCHF", PERIOD_D1, 0);
   double ld_80 = iHigh("EURCHF", PERIOD_D1, 0) - iLow("EURCHF", PERIOD_D1, 0);
   double ld_88 = iHigh("GBPCHF", PERIOD_D1, 0) - iLow("GBPCHF", PERIOD_D1, 0);
   double ld_96 = iHigh("CADCHF", PERIOD_D1, 0) - iLow("CADCHF", PERIOD_D1, 0);
   double ld_104 = iHigh("CADJPY", PERIOD_D1, 0) - iLow("CADJPY", PERIOD_D1, 0);
   double ld_112 = iHigh("NZDCAD", PERIOD_D1, 0) - iLow("NZDCAD", PERIOD_D1, 0);
   double ld_120 = iHigh("USDCAD", PERIOD_D1, 0) - iLow("USDCAD", PERIOD_D1, 0);
   double ld_128 = iHigh("EURCAD", PERIOD_D1, 0) - iLow("EURCAD", PERIOD_D1, 0);
   double ld_136 = iHigh("GBPCAD", PERIOD_D1, 0) - iLow("GBPCAD", PERIOD_D1, 0);
   double ld_144 = iHigh("EURJPY", PERIOD_D1, 0) - iLow("EURJPY", PERIOD_D1, 0);
   double ld_152 = iHigh("EURNZD", PERIOD_D1, 0) - iLow("EURNZD", PERIOD_D1, 0);
   double ld_160 = iHigh("EURUSD", PERIOD_D1, 0) - iLow("EURUSD", PERIOD_D1, 0);
   double ld_168 = iHigh("EURGBP", PERIOD_D1, 0) - iLow("EURGBP", PERIOD_D1, 0);
   double ld_176 = iHigh("EURAUD", PERIOD_D1, 0) - iLow("EURAUD", PERIOD_D1, 0);
   double ld_184 = iHigh("GBPJPY", PERIOD_D1, 0) - iLow("GBPJPY", PERIOD_D1, 0);
   double ld_192 = iHigh("GBPNZD", PERIOD_D1, 0) - iLow("GBPNZD", PERIOD_D1, 0);
   double ld_200 = iHigh("GBPUSD", PERIOD_D1, 0) - iLow("GBPUSD", PERIOD_D1, 0);
   double ld_208 = iHigh("USDJPY", PERIOD_D1, 0) - iLow("USDJPY", PERIOD_D1, 0);
   double ld_216 = iHigh("NZDJPY", PERIOD_D1, 0) - iLow("NZDJPY", PERIOD_D1, 0);
   double ld_224 = iHigh("NZDJPY", PERIOD_D1, 0) - iLow("NZDJPY", PERIOD_D1, 0);
   double ld_232 = iHigh("USDZAR", PERIOD_D1, 0) - iLow("USDZAR", PERIOD_D1, 0);
   double ld_240 = iHigh("USDHKD", PERIOD_D1, 0) - iLow("USDHKD", PERIOD_D1, 0);
   double ld_256 = iHigh(Oil_Symbol, PERIOD_D1, 0) - iLow(Oil_Symbol, PERIOD_D1, 0);
   double ld_248 = iHigh(Gold_Symbol, PERIOD_D1, 0) - iLow(Gold_Symbol, PERIOD_D1, 0);
   double DayRange_Silver = iHigh(Silver_Symbol, PERIOD_D1, 0) - iLow(Silver_Symbol, PERIOD_D1, 0);
   double DayRange_Copper = iHigh(Copper_Symbol, PERIOD_D1, 0) - iLow(Copper_Symbol, PERIOD_D1, 0);
   double ld_264 = iHigh(US_ES, PERIOD_D1, 0) - iLow(US_ES, PERIOD_D1, 0);
   double ld_272 = iHigh(US_NQ, PERIOD_D1, 0) - iLow(US_NQ, PERIOD_D1, 0);
   double ld_280 = iHigh(US_YM, PERIOD_D1, 0) - iLow(US_YM, PERIOD_D1, 0);
   double ld_288 = iHigh(US_ER2, PERIOD_D1, 0) - iLow(US_ER2, PERIOD_D1, 0);
   double ld_296 = iHigh(UK_FTSE, PERIOD_D1, 0) - iLow(UK_FTSE, PERIOD_D1, 0);
   double ld_304 = iHigh(Ger_DAX, PERIOD_D1, 0) - iLow(Ger_DAX, PERIOD_D1, 0);
   double ld_312 = iHigh(Eur_FESX, PERIOD_D1, 0) - iLow(Eur_FESX, PERIOD_D1, 0);
   double ld_320 = iHigh(Fra_CAC, PERIOD_D1, 0) - iLow(Fra_CAC, PERIOD_D1, 0);
   double DayRange_CH_SMI = iHigh(CH_SMI, PERIOD_D1, 0) - iLow(CH_SMI, PERIOD_D1, 0);
   if (ld_0 != 0.0) ld_336 = 100.0 * ((iClose("AUDJPY", PERIOD_D1, 0) - iLow("AUDJPY", PERIOD_D1, 0)) / ld_0);
   else ld_336 = 0;
   if (ld_8 != 0.0) ld_344 = 100.0 * ((iClose("AUDNZD", PERIOD_D1, 0) - iLow("AUDNZD", PERIOD_D1, 0)) / ld_8);
   else ld_344 = 0;
   if (ld_16 != 0.0) ld_352 = 100.0 * ((iClose("AUDUSD", PERIOD_D1, 0) - iLow("AUDUSD", PERIOD_D1, 0)) / ld_16);
   else ld_352 = 0;
   if (ld_24 != 0.0) ld_360 = 100.0 * ((iClose("AUDEUR", PERIOD_D1, 0) - iLow("AUDEUR", PERIOD_D1, 0)) / ld_24);
   else ld_360 = 0;
   if (ld_32 != 0.0) ld_368 = 100.0 * ((iClose("GBPAUD", PERIOD_D1, 0) - iLow("GBPAUD", PERIOD_D1, 0)) / ld_32);
   else ld_368 = 0;
   if (ld_40 != 0.0) ld_376 = 100.0 * ((iClose("AUDCHF", PERIOD_D1, 0) - iLow("AUDCHF", PERIOD_D1, 0)) / ld_40);
   else ld_376 = 0;
   if (ld_48 != 0.0) ld_384 = 100.0 * ((iClose("AUDCAD", PERIOD_D1, 0) - iLow("AUDCAD", PERIOD_D1, 0)) / ld_48);
   else ld_384 = 0;
   if (ld_56 != 0.0) ld_392 = 100.0 * ((iClose("CHFJPY", PERIOD_D1, 0) - iLow("CHFJPY", PERIOD_D1, 0)) / ld_56);
   else ld_392 = 0;
   if (ld_64 != 0.0) ld_400 = 100.0 * ((iClose("NZDCHF", PERIOD_D1, 0) - iLow("NZDCHF", PERIOD_D1, 0)) / ld_64);
   else ld_400 = 0;
   if (ld_72 != 0.0) ld_408 = 100.0 * ((iClose("USDCHF", PERIOD_D1, 0) - iLow("USDCHF", PERIOD_D1, 0)) / ld_72);
   else ld_408 = 0;
   if (ld_80 != 0.0) ld_416 = 100.0 * ((iClose("EURCHF", PERIOD_D1, 0) - iLow("EURCHF", PERIOD_D1, 0)) / ld_80);
   else ld_416 = 0;
   if (ld_88 != 0.0) ld_424 = 100.0 * ((iClose("GBPCHF", PERIOD_D1, 0) - iLow("GBPCHF", PERIOD_D1, 0)) / ld_88);
   else ld_424 = 0;
   if (ld_96 != 0.0) ld_432 = 100.0 * ((iClose("CADCHF", PERIOD_D1, 0) - iLow("CADCHF", PERIOD_D1, 0)) / ld_96);
   else ld_432 = 0;
   if (ld_104 != 0.0) ld_440 = 100.0 * ((iClose("CADJPY", PERIOD_D1, 0) - iLow("CADJPY", PERIOD_D1, 0)) / ld_104);
   else ld_440 = 0;
   if (ld_112 != 0.0) ld_448 = 100.0 * ((iClose("NZDCAD", PERIOD_D1, 0) - iLow("NZDCAD", PERIOD_D1, 0)) / ld_112);
   else ld_448 = 0;
   if (ld_120 != 0.0) ld_456 = 100.0 * ((iClose("USDCAD", PERIOD_D1, 0) - iLow("USDCAD", PERIOD_D1, 0)) / ld_120);
   else ld_456 = 0;
   if (ld_128 != 0.0) ld_464 = 100.0 * ((iClose("EURCAD", PERIOD_D1, 0) - iLow("EURCAD", PERIOD_D1, 0)) / ld_128);
   else ld_464 = 0;
   if (ld_136 != 0.0) ld_472 = 100.0 * ((iClose("GBPCAD", PERIOD_D1, 0) - iLow("GBPCAD", PERIOD_D1, 0)) / ld_136);
   else ld_472 = 0;
   if (ld_144 != 0.0) ld_480 = 100.0 * ((iClose("EURJPY", PERIOD_D1, 0) - iLow("EURJPY", PERIOD_D1, 0)) / ld_144);
   else ld_480 = 0;
   if (ld_152 != 0.0) ld_488 = 100.0 * ((iClose("EURNZD", PERIOD_D1, 0) - iLow("EURNZD", PERIOD_D1, 0)) / ld_152);
   else ld_488 = 0;
   if (ld_160 != 0.0) ld_496 = 100.0 * ((iClose("EURUSD", PERIOD_D1, 0) - iLow("EURUSD", PERIOD_D1, 0)) / ld_160);
   else ld_496 = 0;
   if (ld_168 != 0.0) ld_504 = 100.0 * ((iClose("EURGBP", PERIOD_D1, 0) - iLow("EURGBP", PERIOD_D1, 0)) / ld_168);
   else ld_504 = 0;
   if (ld_176 != 0.0) ld_512 = 100.0 * ((iClose("EURAUD", PERIOD_D1, 0) - iLow("EURAUD", PERIOD_D1, 0)) / ld_176);
   else ld_512 = 0;
   if (ld_184 != 0.0) ld_520 = 100.0 * ((iClose("GBPJPY", PERIOD_D1, 0) - iLow("GBPJPY", PERIOD_D1, 0)) / ld_184);
   else ld_520 = 0;
   if (ld_192 != 0.0) ld_528 = 100.0 * ((iClose("GBPNZD", PERIOD_D1, 0) - iLow("GBPNZD", PERIOD_D1, 0)) / ld_192);
   else ld_528 = 0;
   if (ld_200 != 0.0) ld_536 = 100.0 * ((iClose("GBPUSD", PERIOD_D1, 0) - iLow("GBPUSD", PERIOD_D1, 0)) / ld_200);
   else ld_536 = 0;
   if (ld_216 != 0.0) ld_544 = 100.0 * ((iClose("NZDJPY", PERIOD_D1, 0) - iLow("NZDJPY", PERIOD_D1, 0)) / ld_216);
   else ld_544 = 0;
   if (ld_208 != 0.0) ld_552 = 100.0 * ((iClose("USDJPY", PERIOD_D1, 0) - iLow("USDJPY", PERIOD_D1, 0)) / ld_208);
   else ld_552 = 0;
   if (ld_224 != 0.0) ld_560 = 100.0 * ((iClose("NZDJPY", PERIOD_D1, 0) - iLow("NZDJPY", PERIOD_D1, 0)) / ld_224);
   else ld_560 = 0;
   if (ld_232 != 0.0) ld_568 = 100.0 * ((iClose("USDZAR", PERIOD_D1, 0) - iLow("USDZAR", PERIOD_D1, 0)) / ld_232);
   else ld_568 = 0;
   if (ld_240 != 0.0) ld_576 = 100.0 * ((iClose("USDHKD", PERIOD_D1, 0) - iLow("USDHKD", PERIOD_D1, 0)) / ld_240);
   else ld_576 = 0;
   if (ld_256 != 0.0) ld_592 = 100.0 * ((iClose(Oil_Symbol, PERIOD_D1, 0) - iLow(Oil_Symbol, PERIOD_D1, 0)) / ld_256);
   else ld_592 = 0;
   if (ld_248 != 0.0) ld_584 = 100.0 * ((iClose(Gold_Symbol, PERIOD_D1, 0) - iLow(Gold_Symbol, PERIOD_D1, 0)) / ld_248);
   else ld_584 = 0;
   if (DayRange_Silver!= 0.0) Strength_Silver = 100.0 * ((iClose(Silver_Symbol, PERIOD_D1, 0) - iLow(Silver_Symbol, PERIOD_D1, 0)) / DayRange_Silver);
   else Strength_Silver = 0;
   if (DayRange_Copper!= 0.0) Strength_Copper = 100.0 * ((iClose(Copper_Symbol, PERIOD_D1, 0) - iLow(Copper_Symbol, PERIOD_D1, 0)) / DayRange_Copper);
   else Strength_Copper = 0;
   if (ld_264 != 0.0) ld_600 = 100.0 * ((iClose(US_ES, PERIOD_D1, 0) - iLow(US_ES, PERIOD_D1, 0)) / ld_264);
   else ld_600 = 0;
   if (ld_272 != 0.0) ld_608 = 100.0 * ((iClose(US_NQ, PERIOD_D1, 0) - iLow(US_NQ, PERIOD_D1, 0)) / ld_272);
   else ld_608 = 0;
   if (ld_280 != 0.0) ld_616 = 100.0 * ((iClose(US_YM, PERIOD_D1, 0) - iLow(US_YM, PERIOD_D1, 0)) / ld_280);
   else ld_616 = 0;
   if (ld_288 != 0.0) ld_624 = 100.0 * ((iClose(US_ER2, PERIOD_D1, 0) - iLow(US_ER2, PERIOD_D1, 0)) / ld_288);
   else ld_624 = 0;
   if (ld_296 != 0.0) ld_632 = 100.0 * ((iClose(UK_FTSE, PERIOD_D1, 0) - iLow(UK_FTSE, PERIOD_D1, 0)) / ld_296);
   else ld_632 = 0;
   if (ld_304 != 0.0) ld_640 = 100.0 * ((iClose(Ger_DAX, PERIOD_D1, 0) - iLow(Ger_DAX, PERIOD_D1, 0)) / ld_304);
   else ld_640 = 0;
   if (ld_312 != 0.0) ld_648 = 100.0 * ((iClose(Eur_FESX, PERIOD_D1, 0) - iLow(Eur_FESX, PERIOD_D1, 0)) / ld_312);
   else ld_648 = 0;
   if (ld_320 != 0.0) ld_656 = 100.0 * ((iClose(Fra_CAC, PERIOD_D1, 0) - iLow(Fra_CAC, PERIOD_D1, 0)) / ld_320);
   else ld_656 = 0;
   if (DayRange_CH_SMI != 0.0) Strength_CH_SMI = 100.0 * ((iClose(CH_SMI, PERIOD_D1, 0) - iLow(CH_SMI, PERIOD_D1, 0)) / DayRange_CH_SMI);
   else Strength_CH_SMI = 0;
   if (!IsTradingTime(RUSOpenTime, RUSCloseTime)) {
      Print("aaa");
      ld_624 = 0;
   }
   //if (!IsTradingTime(FTSEOpenTime, FTSECloseTime)) ld_632 = 0;
   //if (!IsTradingTime(DAXOpenTime, DAXCloseTime)) ld_640 = 0;
   //if (!IsTradingTime(EUXOpenTime, EUXCloseTime)) ld_648 = 0;
   //if (!IsTradingTime(CACOpenTime, CACCloseTime)) ld_656 = 0;
   //if (!IsTradingTime(SMIOpenTime, SMICloseTime)) Strength_CH_SMI = 0;
   double ld_672 = (ld_336 + ld_344 + ld_352 + ld_360 + (100 - ld_368) + ld_376 + ld_384) / 7.0;
   double ld_680 = (ld_392 + (100 - ld_400) + (100 - ld_408) + (100 - ld_416) + (100 - ld_424) + (100 - ld_376) + (100 - ld_432)) / 7.0;
   double ld_688 = (ld_440 + (100 - ld_448) + (100 - ld_456) + (100 - ld_464) + (100 - ld_472) + (100 - ld_384) + (100 - ld_432)) / 7.0;
   double ld_696 = (ld_480 + ld_488 + ld_496 + ld_464 + ld_504 + ld_512 + ld_416) / 7.0;
   double ld_704 = (ld_520 + ld_528 + ld_536 + ld_472 + (100 - ld_504) + ld_368 + ld_424) / 7.0;
   double ld_712 = (100 - ld_336 + (100 - ld_392) + (100 - ld_440) + (100 - ld_480) + (100 - ld_520) + (100 - ld_544) + (100 - ld_552)) / 7.0;
   double ld_720 = (ld_544 + (100 - ld_528) + ld_560 + ld_448 + (100 - ld_488) + (100 - ld_344) + ld_400) / 7.0;
   double ld_728 = (100 - ld_352 + ld_408 + ld_456 + (100 - ld_496) + (100 - ld_536) + ld_552 + (100 - ld_560)) / 7.0;
   objectBlank();
   paint("AUD", ld_672);
   paint("CHF", ld_680);
   paint("CAD", ld_688);
   paint("EUR", ld_696);
   paint("GBP", ld_704);
   paint("JPY", ld_712);
   paint("NZD", ld_720);
   paint("USD", ld_728);
   paint("OIL", ld_592);
   paint("GOLD", ld_584);
   paint("SILVER", Strength_Silver);
   paint("COPPER", Strength_Copper);
   paint(US_ES, ld_600);
   paint(US_NQ, ld_608);
   paint(US_YM, ld_616);
   paint(US_ER2, ld_624);
   paint(UK_FTSE, ld_632);
   paint(Ger_DAX, ld_640);
   paint(Eur_FESX, ld_648);
   paint(Fra_CAC, ld_656);
   paint(CH_SMI, Strength_CH_SMI);
   string l_text_736 = "AUDJPY: " + DoubleToStr(ld_336, 0) + "%";
   string l_text_744 = "AUDNZD: " + DoubleToStr(ld_344, 0) + "%";
   string l_text_752 = "AUDUSD: " + DoubleToStr(ld_352, 0) + "%";
   string l_text_760 = "CADCHF: " + DoubleToStr(ld_432, 0) + "%";
   string l_text_768 = "CADJPY: " + DoubleToStr(ld_440, 0) + "%";
   string l_text_776 = "CHFJPY: " + DoubleToStr(ld_392, 0) + "%";
   string l_text_784 = "EURAUD: " + DoubleToStr(ld_512, 0) + "%";
   string l_text_792 = "EURCHF: " + DoubleToStr(ld_416, 0) + "%";
   string l_text_800 = "EURCAD: " + DoubleToStr(ld_464, 0) + "%";
   string l_text_808 = "EURGBP: " + DoubleToStr(ld_504, 0) + "%";
   string l_text_816 = "EURJPY: " + DoubleToStr(ld_480, 0) + "%";
   string l_text_824 = "EURNZD: " + DoubleToStr(ld_488, 0) + "%";
   string l_text_832 = "EURUSD: " + DoubleToStr(ld_496, 0) + "%";
   string l_text_840 = "GBPAUD: " + DoubleToStr(ld_368, 0) + "%";
   string l_text_848 = "GBPCAD: " + DoubleToStr(ld_472, 0) + "%";
   string l_text_856 = "GBPCHF: " + DoubleToStr(ld_424, 0) + "%";
   string l_text_864 = "GBPJPY: " + DoubleToStr(ld_520, 0) + "%";
   string l_text_872 = "GBPUSD: " + DoubleToStr(ld_536, 0) + "%";
   string l_text_880 = "NZDCAD: " + DoubleToStr(ld_448, 0) + "%";
   string l_text_888 = "NZDCHF: " + DoubleToStr(ld_400, 0) + "%";
   string l_text_896 = "NZDJPY: " + DoubleToStr(ld_544, 0) + "%";
   string l_text_904 = "NZDUSD: " + DoubleToStr(ld_560, 0) + "%";
   string l_text_912 = "USDCAD: " + DoubleToStr(ld_456, 0) + "%";
   string l_text_920 = "USDCHF: " + DoubleToStr(ld_408, 0) + "%";
   string l_text_928 = "USDHKD: " + DoubleToStr(ld_576, 0) + "%";
   string l_text_936 = "USDJPY: " + DoubleToStr(ld_552, 0) + "%";
   string l_text_944 = "USDZAR: " + DoubleToStr(ld_568, 0) + "%";
   ObjectCreate("Overalltitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Overalltitle", "OVERALL CURRENCY STRENGTHS", 12, "Segoe UI", Yellow);
   ObjectSet("Overalltitle", OBJPROP_CORNER, g_corner_188);
   ObjectSet("Overalltitle", OBJPROP_XDISTANCE, gi_192 + 24);
   ObjectSet("Overalltitle", OBJPROP_YDISTANCE, gi_196 + 30);
   ObjectCreate("Commtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Commtitle", "COMMODITIES", 12, "Segoe UI", Yellow);
   ObjectSet("Commtitle", OBJPROP_CORNER, g_corner_188);
   ObjectSet("Commtitle", OBJPROP_XDISTANCE, gi_192 + 340);
   ObjectSet("Commtitle", OBJPROP_YDISTANCE, gi_196 + 30);
   ObjectCreate("USAtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("USAtitle", "USA", 12, "Segoe UI", Yellow);
   ObjectSet("USAtitle", OBJPROP_CORNER, g_corner_188);
   ObjectSet("USAtitle", OBJPROP_XDISTANCE, gi_192 + 568);
   ObjectSet("USAtitle", OBJPROP_YDISTANCE, gi_196 + 30);
   ObjectCreate("EURtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("EURtitle", "EUROPE", 12, "Segoe UI", Yellow);
   ObjectSet("EURtitle", OBJPROP_CORNER, g_corner_188);
   ObjectSet("EURtitle", OBJPROP_XDISTANCE, gi_192 + 740);
   ObjectSet("EURtitle", OBJPROP_YDISTANCE, gi_196 + 30);
   ObjectCreate("Stocktitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Stocktitle", "STOCK INDICES", 12, "Segoe UI", Yellow);
   ObjectSet("Stocktitle", OBJPROP_CORNER, g_corner_188);
   ObjectSet("Stocktitle", OBJPROP_XDISTANCE, gi_192 + 625);
   ObjectSet("Stocktitle", OBJPROP_YDISTANCE, gi_196 + 10);
   ObjectCreate("goldoilavgtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("goldoilavgtitle", DoubleToStr((ld_592 + ld_584 + Strength_Silver + Strength_Copper) / 4.0, 0) + "%", 14, "Segoe UI", White);
   ObjectSet("goldoilavgtitle", OBJPROP_CORNER, g_corner_188);
   ObjectSet("goldoilavgtitle", OBJPROP_XDISTANCE, gi_192 + 370);
   ObjectSet("goldoilavgtitle", OBJPROP_YDISTANCE, gi_196 + 220);
   ObjectCreate("USavgtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("USavgtitle", DoubleToStr((ld_600 + ld_608 + ld_616 + ld_624) / 4.0, 0) + "%", 14, "Segoe UI", White);
   ObjectSet("USavgtitle", OBJPROP_CORNER, g_corner_188);
   ObjectSet("USavgtitle", OBJPROP_XDISTANCE, gi_192 + 562);
   ObjectSet("USavgtitle", OBJPROP_YDISTANCE, gi_196 + 220);
   ObjectCreate("EURavgtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("EURavgtitle", DoubleToStr((ld_632 + ld_640 + ld_648 + ld_656 + Strength_CH_SMI) / 5.0, 0) + "%", 14, "Segoe UI", White);
   ObjectSet("EURavgtitle", OBJPROP_CORNER, g_corner_188);
   ObjectSet("EURavgtitle", OBJPROP_XDISTANCE, gi_192 + 750);
   ObjectSet("EURavgtitle", OBJPROP_YDISTANCE, gi_196 + 220);
   ObjectCreate("Stocksavgtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Stocksavgtitle", DoubleToStr(((ld_600 + ld_608 + ld_616 + ld_624) / 4.0 + (ld_632 + ld_640 + ld_648 + ld_656 + Strength_CH_SMI) / 5.0) / 2.0, 0) + "%", 14, "Segoe UI", White);
   ObjectSet("Stocksavgtitle", OBJPROP_CORNER, g_corner_188);
   ObjectSet("Stocksavgtitle", OBJPROP_XDISTANCE, gi_192 + 665);
   ObjectSet("Stocksavgtitle", OBJPROP_YDISTANCE, gi_196 + 240);
   int li_952 = 280;
   ObjectCreate("audjpy", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audjpyRange", OBJ_LABEL, 0, 0, 0);
   if (ld_336 >= buy_level) ObjectSetText("audjpy", l_text_736, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_336 <= sell_level) ObjectSetText("audjpy", l_text_736, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("audjpy", l_text_736, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("audjpy", "AUDJPY", 20, li_952);
   ObjectCreate("audnzdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audnzdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audnzd", OBJ_LABEL, 0, 0, 0);
   if (ld_344 >= buy_level) ObjectSetText("audnzd", l_text_744, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_344 <= sell_level) ObjectSetText("audnzd", l_text_744, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("audnzd", l_text_744, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("audnzd", "AUDNZD", 125, li_952);
   ObjectCreate("audusdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audusdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audusd", OBJ_LABEL, 0, 0, 0);
   if (ld_352 >= buy_level) ObjectSetText("audusd", l_text_752, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_352 <= sell_level) ObjectSetText("audusd", l_text_752, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("audusd", l_text_752, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("audusd", "AUDUSD", 230, li_952);
   ObjectCreate("cadchfRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("cadchfBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("cadchf", OBJ_LABEL, 0, 0, 0);
   if (ld_432 >= buy_level) ObjectSetText("cadchf", l_text_760, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_432 <= sell_level) ObjectSetText("cadchf", l_text_760, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("cadchf", l_text_760, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("cadchf", "CADCHF", 335, li_952);
   ObjectCreate("cadjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("cadjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("cadjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_440 >= buy_level) ObjectSetText("cadjpy", l_text_768, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_440 <= sell_level) ObjectSetText("cadjpy", l_text_768, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("cadjpy", l_text_768, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("cadjpy", "CADJPY", 440, li_952);
   ObjectCreate("chfjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("chfjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("chfjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_392 >= buy_level) ObjectSetText("chfjpy", l_text_776, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_392 <= sell_level) ObjectSetText("chfjpy", l_text_776, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("chfjpy", l_text_776, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("chfjpy", "CHFJPY", 545, li_952);
   ObjectCreate("euraudRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("euraudBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("euraud", OBJ_LABEL, 0, 0, 0);
   if (ld_512 >= buy_level) ObjectSetText("euraud", l_text_784, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_512 <= sell_level) ObjectSetText("euraud", l_text_784, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("euraud", l_text_784, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("euraud", "EURAUD", 650, li_952);
   ObjectCreate("eurcadRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurcadBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurcad", OBJ_LABEL, 0, 0, 0);
   if (ld_464 >= buy_level) ObjectSetText("eurcad", l_text_800, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_464 <= sell_level) ObjectSetText("eurcad", l_text_800, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("eurcad", l_text_800, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("eurcad", "EURCAD", 755, li_952);

   ObjectCreate("eurgbpRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurgbpBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurgbp", OBJ_LABEL, 0, 0, 0);
   if (ld_504 >= buy_level) ObjectSetText("eurgbp", l_text_808, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_504 <= sell_level) ObjectSetText("eurgbp", l_text_808, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("eurgbp", l_text_808, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("eurgbp", "EURGBP", 20, li_952 + 75);

   ObjectCreate("eurnzdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurnzdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurnzd", OBJ_LABEL, 0, 0, 0);
   if (ld_488 >= buy_level) ObjectSetText("eurnzd", l_text_824, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_488 <= sell_level) ObjectSetText("eurnzd", l_text_824, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("eurnzd", l_text_824, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("eurnzd", "EURNZD", 230, li_952 + 75);

   ObjectCreate("eurusdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurusdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurusd", OBJ_LABEL, 0, 0, 0);
   if (ld_496 >= buy_level) ObjectSetText("eurusd", l_text_832, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_496 <= sell_level) ObjectSetText("eurusd", l_text_832, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("eurusd", l_text_832, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("eurusd", "EURUSD", 335, li_952 + 75);

   ObjectCreate("gbpaudRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpaudBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpaud", OBJ_LABEL, 0, 0, 0);
   if (ld_368 >= buy_level) ObjectSetText("gbpaud", l_text_840, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_368 <= sell_level) ObjectSetText("gbpaud", l_text_840, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("gbpaud", l_text_840, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("gbpaud", "GBPAUD", 440, li_952 + 75);

   ObjectCreate("gbpcadRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpcadBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpcad", OBJ_LABEL, 0, 0, 0);
   if (ld_472 >= buy_level) ObjectSetText("gbpcad", l_text_848, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_472 <= sell_level) ObjectSetText("gbpcad", l_text_848, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("gbpcad", l_text_848, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("gbpcad", "GBPCAD", 545, li_952 + 75);

   ObjectCreate("eurjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_480 >= buy_level) ObjectSetText("eurjpy", l_text_816, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_480 <= sell_level) ObjectSetText("eurjpy", l_text_816, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("eurjpy", l_text_816, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("eurjpy", "EURJPY", 650, li_952 + 75);

   ObjectCreate("gbpjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_520 >= buy_level) ObjectSetText("gbpjpy", l_text_864, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_520 <= sell_level) ObjectSetText("gbpjpy", l_text_864, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("gbpjpy", l_text_864, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("gbpjpy", "GBPJPY", 125, li_952 + 75);

   ObjectCreate("nzdcadRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdcadBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdcad", OBJ_LABEL, 0, 0, 0);
   if (ld_448 >= buy_level) ObjectSetText("nzdcad", l_text_880, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_448 <= sell_level) ObjectSetText("nzdcad", l_text_880, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("nzdcad", l_text_880, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("nzdcad", "NZDCAD", 20, li_952 + 150);

   ObjectCreate("nzdchfRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdchfBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdchf", OBJ_LABEL, 0, 0, 0);
   if (ld_400 >= buy_level) ObjectSetText("nzdchf", l_text_888, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_400 <= sell_level) ObjectSetText("nzdchf", l_text_888, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("nzdchf", l_text_888, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("nzdchf", "NZDCHF", 125, li_952 + 150);

   ObjectCreate("nzdjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_544 >= buy_level) ObjectSetText("nzdjpy", l_text_896, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_544 <= sell_level) ObjectSetText("nzdjpy", l_text_896, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("nzdjpy", l_text_896, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("nzdjpy", "NZDJPY", 230, li_952 + 150);

   ObjectCreate("nzdusdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdusdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdusd", OBJ_LABEL, 0, 0, 0);
   if (ld_560 >= buy_level) ObjectSetText("nzdusd", l_text_904, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_560 <= sell_level) ObjectSetText("nzdusd", l_text_904, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("nzdusd", l_text_904, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("nzdusd", "NZDUSD", 335, li_952 + 150);

   ObjectCreate("usdcadRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdcadBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdcad", OBJ_LABEL, 0, 0, 0);
   if (ld_456 >= buy_level) ObjectSetText("usdcad", l_text_912, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_456 <= sell_level) ObjectSetText("usdcad", l_text_912, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("usdcad", l_text_912, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("usdcad", "USDCAD", 440, li_952 + 150);
   ObjectCreate("usdchfRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdchfBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdchf", OBJ_LABEL, 0, 0, 0);
   if (ld_408 >= buy_level) ObjectSetText("usdchf", l_text_920, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_408 <= sell_level) ObjectSetText("usdchf", l_text_920, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("usdchf", l_text_920, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("usdchf", "USDCHF", 545, li_952 + 150);
   ObjectCreate("usdhkdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdhkdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdhkd", OBJ_LABEL, 0, 0, 0);
   if (ld_576 >= buy_level) ObjectSetText("usdhkd", l_text_928, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_576 <= sell_level) ObjectSetText("usdhkd", l_text_928, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("usdhkd", l_text_928, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("usdhkd", "USDHKD", 650, li_952 + 150);

   ObjectCreate("usdjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_552 >= buy_level) ObjectSetText("usdjpy", l_text_936, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_552 <= sell_level) ObjectSetText("usdjpy", l_text_936, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("usdjpy", l_text_936, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("usdjpy", "USDJPY", 755, li_952 + 75);

   ObjectCreate("gbpchfRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpchfBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpchf", OBJ_LABEL, 0, 0, 0);
   if (ld_424 >= buy_level) ObjectSetText("gbpchf", l_text_856, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_424 <= sell_level) ObjectSetText("gbpchf", l_text_856, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("gbpchf", l_text_856, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("gbpchf", "GBPCHF", 20, li_952 + 225);

   ObjectCreate("eurchfRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurchfBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurchf", OBJ_LABEL, 0, 0, 0);
   if (ld_416 >= buy_level) ObjectSetText("eurchf", l_text_792, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_416 <= sell_level) ObjectSetText("eurchf", l_text_792, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("eurchf", l_text_792, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("eurchf", "EURCHF", 125, li_952 + 225);

   ObjectCreate("gbpusdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpusdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpusd", OBJ_LABEL, 0, 0, 0);
   if (ld_536 >= buy_level) ObjectSetText("gbpusd", l_text_872, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_536 <= sell_level) ObjectSetText("gbpusd", l_text_872, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("gbpusd", l_text_872, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("gbpusd", "GBPUSD", 755, li_952 + 150);

   ObjectCreate("usdzarRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdzarBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdzar", OBJ_LABEL, 0, 0, 0);
   if (ld_568 >= buy_level) ObjectSetText("usdzar", l_text_944, fontsize_fxlabel, "Segoe UI", Lime);
   else {
      if (ld_568 <= sell_level) ObjectSetText("usdzar", l_text_944, fontsize_fxlabel, "Segoe UI", Red);
      else ObjectSetText("usdzar", l_text_944, fontsize_fxlabel, "Segoe UI", White);
   }
   ObjSettxt("usdzar", "USDZAR", 230, li_952 + 225);
   return (0);
}

void ObjSettxt(string a_name_0, string a_symbol_8, int ai_16, int ai_20) {
   ObjectSetText(a_name_0 + "Bid", "Bid: " + DoubleToStr(MarketInfo(a_symbol_8, MODE_BID), MarketInfo(a_symbol_8, MODE_DIGITS)), 8, "Segoe UI", White);
   ObjectSet(a_name_0 + "Bid", OBJPROP_CORNER, g_corner_188);
   ObjectSet(a_name_0 + "Bid", OBJPROP_XDISTANCE, gi_192 + ai_16);
   ObjectSet(a_name_0 + "Bid", OBJPROP_YDISTANCE, gi_196 + ai_20 + 20);
   ObjectSetText(a_name_0 + "Range", "Range: " + DoubleToStr((iHigh(a_symbol_8, PERIOD_D1, 0) - iLow(a_symbol_8, PERIOD_D1, 0)) / MarketInfo(a_symbol_8, MODE_POINT), 0), 8, "Segoe UI", White);
   ObjectSet(a_name_0 + "Range", OBJPROP_CORNER, g_corner_188);
   ObjectSet(a_name_0 + "Range", OBJPROP_XDISTANCE, gi_192 + ai_16);
   ObjectSet(a_name_0 + "Range", OBJPROP_YDISTANCE, gi_196 + ai_20 + 35);
   ObjectSet(a_name_0, OBJPROP_CORNER, g_corner_188);
   ObjectSet(a_name_0, OBJPROP_XDISTANCE, gi_192 + ai_16);
   ObjectSet(a_name_0, OBJPROP_YDISTANCE, gi_196 + ai_20);

   if (ForceRefresh) { RefreshRates(); }
}

void objectCreate(string a_name_0, int a_x_8, int a_y_12, string a_text_16 = "-", int a_fontsize_24 = 60, string a_fontname_28 = "Arial", color a_color_36 = -1) {
   ObjectCreate(a_name_0, OBJ_LABEL, 0, 0, 0);
   ObjectSet(a_name_0, OBJPROP_CORNER, 0);
   ObjectSet(a_name_0, OBJPROP_COLOR, a_color_36);
   ObjectSet(a_name_0, OBJPROP_XDISTANCE, a_x_8);
   ObjectSet(a_name_0, OBJPROP_YDISTANCE, a_y_12);
   ObjectSetText(a_name_0, a_text_16, a_fontsize_24, a_fontname_28, a_color_36);
}

void initGraph() {
   ObjectsDeleteAll(0, OBJ_LABEL);
   int li_0 = 110;
   int li_4 = 20;
   int li_8 = li_0;
   for (int li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("aud_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("audtxt", li_4, li_0 + 85, "AUD", fontsize_small, "Arial Narrow", White);
   objectCreate("audp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("chf_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("chftxt", li_4, li_0 + 85, "CHF", fontsize_small, "Arial Narrow", White);
   objectCreate("chfp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("cad_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("cadtxt", li_4, li_0 + 85, "CAD", fontsize_small, "Arial Narrow", White);
   objectCreate("cadp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("eur_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("eurtxt", li_4, li_0 + 85, "EUR", fontsize_small, "Arial Narrow", White);
   objectCreate("eurp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("gbp_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("gbptxt", li_4, li_0 + 85, "GBP", fontsize_small, "Arial Narrow", White);
   objectCreate("gbpp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("jpy_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("jpytxt", li_4, li_0 + 85, "JPY", fontsize_small, "Arial Narrow", White);
   objectCreate("jpyp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("nzd_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("nzdtxt", li_4, li_0 + 85, "NZD", fontsize_small, "Arial Narrow", White);
   objectCreate("nzdp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("usd_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("usdtxt", li_4, li_0 + 85, "USD", fontsize_small, "Arial Narrow", White);
   objectCreate("usdp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
   
   li_4 = 330;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("oil_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("oiltxt", li_4, li_0 + 85, "OIL", fontsize_small, "Arial Narrow", White);
   objectCreate("oilp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);

   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("gold_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("goldtxt", li_4, li_0 + 85, "GLD", fontsize_small, "Arial Narrow", White);
   objectCreate("goldp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);

   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("silver_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("silvertxt", li_4, li_0 + 85, "SIL", fontsize_small, "Arial Narrow", White);
   objectCreate("silverp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
  
   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("copper_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("coppertxt", li_4, li_0 + 85, "COP", fontsize_small, "Arial Narrow", White);
   objectCreate("copperp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
   
   li_4= 500;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("sp_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("sptxt", li_4, li_0 + 85, "S&P", fontsize_small, "Arial Narrow", White);
   objectCreate("spp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
   
   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("nasdq_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("nasdqtxt", li_4, li_0 + 85, "NDQ", fontsize_small, "Arial Narrow", White);
   objectCreate("nasdqp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);

   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("dow_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("dowtxt", li_4, li_0 + 85, "DOW", fontsize_small, "Arial Narrow", White);
   objectCreate("dowp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);

   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("russel_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("russeltxt", li_4, li_0 + 85, "RUS", fontsize_small, "Arial Narrow", White);
   objectCreate("russelp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);

   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("fse_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("fsetxt", li_4, li_0 + 85, "FSE", fontsize_small, "Arial Narrow", White);
   objectCreate("fsep", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);

   li_4 = 710;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("dax_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("daxtxt", li_4, li_0 + 85, "DAX", fontsize_small, "Arial Narrow", White);
   objectCreate("daxp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);

   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("eux_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("euxtxt", li_4, li_0 + 85, "EUX", fontsize_small, "Arial Narrow", White);
   objectCreate("euxp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);

   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("cac_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("cactxt", li_4, li_0 + 85, "CAC", fontsize_small, "Arial Narrow", White);
   objectCreate("cacp", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);

   li_4+= 35;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("smi_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("smitxt", li_4, li_0 + 85, "SMI", fontsize_small, "Arial Narrow", White);
   objectCreate("smip", li_4, li_0 + 65, DoubleToStr(9, 1), fontsize_small, "Arial Narrow", White);
}

void objectBlank() {
   for (int li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("usd_" + li_0);
   ObjectSet("usdtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("usdp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("aud_" + li_0);
   ObjectSet("audtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("audp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("chf_" + li_0);
   ObjectSet("chftxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("chfp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("cad_" + li_0);
   ObjectSet("cadtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("cadp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("eur_" + li_0);
   ObjectSet("eurtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("eurp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("gbp_" + li_0);
   ObjectSet("gbptxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("gbpp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("jpy_" + li_0);
   ObjectSet("jpytxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("jpyp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("nzd_" + li_0);
   ObjectSet("nzdtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("nzdp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("oil_" + li_0);
   ObjectSet("oiltxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("oilp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("gold_" + li_0);
   ObjectSet("goldtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("goldp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("gold_" + li_0);
   ObjectSet("silvertxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("silverp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("copper_" + li_0);
   ObjectSet("coppertxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("copperp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("sp_" + li_0);
   ObjectSet("sptxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("spp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("nasdq_" + li_0);
   ObjectSet("nasdqtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("nasdqp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("dow_" + li_0);
   ObjectSet("dowtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("dowp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("russel_" + li_0);
   ObjectSet("russeltxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("russelp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("fse_" + li_0);
   ObjectSet("fsetxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("fsep", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("dax_" + li_0);
   ObjectSet("daxtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("daxp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("eux_" + li_0);
   ObjectSet("euxtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("euxp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("cac_" + li_0);
   ObjectSet("cactxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("cacp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("smi_" + li_0);
   ObjectSet("smitxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("smip", OBJPROP_COLOR, CLR_NONE);
}

void ObjectSetBlank(string a_name_0) {
   ObjectSet(a_name_0, OBJPROP_COLOR, CLR_NONE);
}

void paint(string as_0, double ad_8) {
   string ls_16 = "";
   if (as_0 == "AUD") ls_16 = "aud";
   if (as_0 == "CHF") ls_16 = "chf";
   if (as_0 == "CAD") ls_16 = "cad";
   if (as_0 == "EUR") ls_16 = "eur";
   if (as_0 == "GBP") ls_16 = "gbp";
   if (as_0 == "JPY") ls_16 = "jpy";
   if (as_0 == "NZD") ls_16 = "nzd";
   if (as_0 == "USD") ls_16 = "usd";
   if (as_0 == "OIL") ls_16 = "oil";
   if (as_0 == "GOLD") ls_16 = "gold";
   if (as_0 == "SILVER") ls_16 = "silver";
   if (as_0 == "COPPER") ls_16 = "copper";
   if (as_0 == US_ES) ls_16 = "sp";
   if (as_0 == US_NQ) ls_16 = "nasdq";
   if (as_0 == US_YM) ls_16 = "dow";
   if (as_0 == US_ER2) ls_16 = "russel";
   if (as_0 == UK_FTSE) ls_16 = "fse";
   if (as_0 == Ger_DAX) ls_16 = "dax";
   if (as_0 == Eur_FESX) ls_16 = "eux";
   if (as_0 == Fra_CAC) ls_16 = "cac";
   if (as_0 == CH_SMI) ls_16 = "smi";
   if (ad_8 > 0.0) ObjectSet(ls_16 + "_1", OBJPROP_COLOR, Red);
   if (ad_8 > 2.0) ObjectSet(ls_16 + "_2", OBJPROP_COLOR, Red);
   if (ad_8 > 4.0) ObjectSet(ls_16 + "_3", OBJPROP_COLOR, Red);
   if (ad_8 > 6.0) ObjectSet(ls_16 + "_4", OBJPROP_COLOR, Red);
   if (ad_8 > 8.0) ObjectSet(ls_16 + "_5", OBJPROP_COLOR, Red);
   if (ad_8 > 10.0) ObjectSet(ls_16 + "_6", OBJPROP_COLOR, Red);
   if (ad_8 > 12.0) ObjectSet(ls_16 + "_7", OBJPROP_COLOR, Red);
   if (ad_8 > 14.0) ObjectSet(ls_16 + "_8", OBJPROP_COLOR, Red);
   if (ad_8 > 16.0) ObjectSet(ls_16 + "_9", OBJPROP_COLOR, Red);
   if (ad_8 > 18.0) ObjectSet(ls_16 + "_10", OBJPROP_COLOR, Red);
   if (ad_8 > 20.0) ObjectSet(ls_16 + "_11", OBJPROP_COLOR, Orange);
   if (ad_8 > 22.0) ObjectSet(ls_16 + "_12", OBJPROP_COLOR, Orange);
   if (ad_8 > 24.0) ObjectSet(ls_16 + "_13", OBJPROP_COLOR, Orange);
   if (ad_8 > 26.0) ObjectSet(ls_16 + "_14", OBJPROP_COLOR, Orange);
   if (ad_8 > 28.0) ObjectSet(ls_16 + "_15", OBJPROP_COLOR, Orange);
   if (ad_8 > 30.0) ObjectSet(ls_16 + "_16", OBJPROP_COLOR, Orange);
   if (ad_8 > 31.0) ObjectSet(ls_16 + "_17", OBJPROP_COLOR, Orange);
   if (ad_8 > 32.0) ObjectSet(ls_16 + "_18", OBJPROP_COLOR, Orange);
   if (ad_8 > 34.0) ObjectSet(ls_16 + "_19", OBJPROP_COLOR, Orange);
   if (ad_8 > 36.0) ObjectSet(ls_16 + "_20", OBJPROP_COLOR, Orange);
   if (ad_8 > 38.0) ObjectSet(ls_16 + "_21", OBJPROP_COLOR, Orange);
   if (ad_8 > 40.0) ObjectSet(ls_16 + "_22", OBJPROP_COLOR, Gold);
   if (ad_8 > 42.0) ObjectSet(ls_16 + "_23", OBJPROP_COLOR, Gold);
   if (ad_8 > 44.0) ObjectSet(ls_16 + "_24", OBJPROP_COLOR, Gold);
   if (ad_8 > 46.0) ObjectSet(ls_16 + "_25", OBJPROP_COLOR, Gold);
   if (ad_8 > 48.0) ObjectSet(ls_16 + "_26", OBJPROP_COLOR, Gold);
   if (ad_8 > 50.0) ObjectSet(ls_16 + "_27", OBJPROP_COLOR, Gold);
   if (ad_8 > 52.0) ObjectSet(ls_16 + "_28", OBJPROP_COLOR, Gold);
   if (ad_8 > 54.0) ObjectSet(ls_16 + "_29", OBJPROP_COLOR, Gold);
   if (ad_8 > 56.0) ObjectSet(ls_16 + "_30", OBJPROP_COLOR, Gold);
   if (ad_8 > 58.0) ObjectSet(ls_16 + "_31", OBJPROP_COLOR, Gold);
   if (ad_8 > 60.0) ObjectSet(ls_16 + "_32", OBJPROP_COLOR, YellowGreen);
   if (ad_8 > 62.0) ObjectSet(ls_16 + "_33", OBJPROP_COLOR, YellowGreen);
   if (ad_8 > 64.0) ObjectSet(ls_16 + "_34", OBJPROP_COLOR, YellowGreen);
   if (ad_8 > 66.0) ObjectSet(ls_16 + "_35", OBJPROP_COLOR, YellowGreen);
   if (ad_8 > 68.0) ObjectSet(ls_16 + "_36", OBJPROP_COLOR, YellowGreen);
   if (ad_8 > 70.0) ObjectSet(ls_16 + "_37", OBJPROP_COLOR, YellowGreen);
   if (ad_8 > 72.0) ObjectSet(ls_16 + "_38", OBJPROP_COLOR, YellowGreen);
   if (ad_8 > 74.0) ObjectSet(ls_16 + "_39", OBJPROP_COLOR, YellowGreen);
   if (ad_8 > 76.0) ObjectSet(ls_16 + "_40", OBJPROP_COLOR, YellowGreen);
   if (ad_8 > 78.0) ObjectSet(ls_16 + "_41", OBJPROP_COLOR, YellowGreen);
   if (ad_8 > 80.0) ObjectSet(ls_16 + "_42", OBJPROP_COLOR, Lime);
   if (ad_8 > 82.0) ObjectSet(ls_16 + "_43", OBJPROP_COLOR, Lime);
   if (ad_8 > 84.0) ObjectSet(ls_16 + "_44", OBJPROP_COLOR, Lime);
   if (ad_8 > 86.0) ObjectSet(ls_16 + "_45", OBJPROP_COLOR, Lime);
   if (ad_8 > 88.0) ObjectSet(ls_16 + "_46", OBJPROP_COLOR, Lime);
   if (ad_8 > 90.0) ObjectSet(ls_16 + "_47", OBJPROP_COLOR, Lime);
   if (ad_8 > 92.0) ObjectSet(ls_16 + "_48", OBJPROP_COLOR, Lime);
   if (ad_8 > 94.0) ObjectSet(ls_16 + "_49", OBJPROP_COLOR, Lime);
   if (ad_8 > 96.0) ObjectSet(ls_16 + "_50", OBJPROP_COLOR, Lime);
   if (ad_8 > 98.0) ObjectSet(ls_16 + "_51", OBJPROP_COLOR, Lime);
   if (ad_8 <= sell_level) {
      ObjectSet(ls_16 + "txt", OBJPROP_COLOR, Red);
      ObjectSetText(ls_16 + "p", DoubleToStr(ad_8, 0) + "%", 12, "Arial Narrow", Red);
      return;
   }
   if (ad_8 >= buy_level) {
      ObjectSet(ls_16 + "txt", OBJPROP_COLOR, Lime);
      ObjectSetText(ls_16 + "p", DoubleToStr(ad_8, 0) + "%", 12, "Arial Narrow", Lime);
      return;
   }
   ObjectSet(ls_16 + "txt", OBJPROP_COLOR, White);
   ObjectSetText(ls_16 + "p", DoubleToStr(ad_8, 0) + "%", 12, "Arial Narrow", White);
}

bool IsTradingTime(string as_0, string as_8) {
   int l_str2time_16 = StrToTime(Year() + "." + Month() + "." + Day() + " " + as_0);
   int li_20 = StrToTime(Year() + "." + Month() + "." + Day() + " " + as_8);
   if (l_str2time_16 > li_20) li_20 += 86400;
   if (TimeCurrent() > l_str2time_16 && TimeCurrent() < li_20) return (TRUE);
   return (FALSE);
}