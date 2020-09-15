
#property copyright "Copyright © 2009, Forex Wealth"
#property link      "http://www.forexwealth.blogspot.com/"

#property indicator_chart_window

extern int FontSize = 8;
extern string RUSOpenTime = "02:00";
extern string RUSCloseTime = "00:00";
extern string FTSEOpenTime = "09:00";
extern string FTSECloseTime = "22:00";
extern string DAXOpenTime = "09:00";
extern string DAXCloseTime = "21:30";
extern string EUXOpenTime = "08:00";
extern string EUXCloseTime = "22:00";
extern string CACOpenTime = "09:00";
extern string CACCloseTime = "17:30";
extern string SMIOpenTime = "09:00";
extern string SMICloseTime = "17:30";
extern int buy_level = 90;
extern int sell_level = 10;
string g_symbol_184 = "BRN_CONT";
int g_corner_192 = 0;
int gi_196 = 0;
int gi_200 = 0;
double gd_204;
double gd_212;
double gd_220;
double gd_228;
double gd_236;
bool gi_unused_244 = FALSE;
bool gi_unused_248 = FALSE;

int init() {
   initGraph();
   return (0);
}

int deinit() {
   ObjectsDeleteAll(0, OBJ_LABEL);
   return (0);
}

int start() {
   double ld_0;
   double ld_8;
   double ld_16;
   double ld_24;
   double ld_32;
   double ld_40;
   double ld_48;
   double ld_56;
   double ld_64;
   double ld_72;
   double ld_80;
   double ld_88;
   double ld_96;
   double ld_104;
   double ld_112;
   double ld_120;
   double ld_128;
   double ld_136;
   double ld_144;
   double ld_152;
   double ld_160;
   double ld_168;
   double ld_176;
   double ld_184;
   double ld_192;
   double ld_200;
   double ld_208;
   double ld_216;
   double ld_224;
   double ld_232;
   double ld_240;
   double ld_248;
   double ld_256;
   double ld_264;
   double ld_272;
   double ld_280;
   double ld_288;
   double ld_296;
   double ld_304;
   double ld_312;
   double ld_320;
   double ld_328;
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
   double ld_336 = iHigh("AUDJPY", PERIOD_D1, 0) - iLow("AUDJPY", PERIOD_D1, 0);
   double ld_344 = iHigh("AUDNZD", PERIOD_D1, 0) - iLow("AUDNZD", PERIOD_D1, 0);
   double ld_352 = iHigh("AUDUSD", PERIOD_D1, 0) - iLow("AUDUSD", PERIOD_D1, 0);
   double ld_360 = iHigh("AUDEUR", PERIOD_D1, 0) - iLow("AUDEUR", PERIOD_D1, 0);
   double ld_368 = iHigh("GBPAUD", PERIOD_D1, 0) - iLow("GBPAUD", PERIOD_D1, 0);
   double ld_376 = iHigh("AUDCHF", PERIOD_D1, 0) - iLow("AUDCHF", PERIOD_D1, 0);
   double ld_384 = iHigh("AUDCAD", PERIOD_D1, 0) - iLow("AUDCAD", PERIOD_D1, 0);
   double ld_392 = iHigh("CHFJPY", PERIOD_D1, 0) - iLow("CHFJPY", PERIOD_D1, 0);
   double ld_400 = iHigh("NZDCHF", PERIOD_D1, 0) - iLow("NZDCHF", PERIOD_D1, 0);
   double ld_408 = iHigh("USDCHF", PERIOD_D1, 0) - iLow("USDCHF", PERIOD_D1, 0);
   double ld_416 = iHigh("EURCHF", PERIOD_D1, 0) - iLow("EURCHF", PERIOD_D1, 0);
   double ld_424 = iHigh("GBPCHF", PERIOD_D1, 0) - iLow("GBPCHF", PERIOD_D1, 0);
   double ld_432 = iHigh("CADCHF", PERIOD_D1, 0) - iLow("CADCHF", PERIOD_D1, 0);
   double ld_440 = iHigh("CADJPY", PERIOD_D1, 0) - iLow("CADJPY", PERIOD_D1, 0);
   double ld_448 = iHigh("NZDCAD", PERIOD_D1, 0) - iLow("NZDCAD", PERIOD_D1, 0);
   double ld_456 = iHigh("USDCAD", PERIOD_D1, 0) - iLow("USDCAD", PERIOD_D1, 0);
   double ld_464 = iHigh("EURCAD", PERIOD_D1, 0) - iLow("EURCAD", PERIOD_D1, 0);
   double ld_472 = iHigh("GBPCAD", PERIOD_D1, 0) - iLow("GBPCAD", PERIOD_D1, 0);
   double ld_480 = iHigh("EURJPY", PERIOD_D1, 0) - iLow("EURJPY", PERIOD_D1, 0);
   double ld_488 = iHigh("EURNZD", PERIOD_D1, 0) - iLow("EURNZD", PERIOD_D1, 0);
   double ld_496 = iHigh("EURUSD", PERIOD_D1, 0) - iLow("EURUSD", PERIOD_D1, 0);
   double ld_504 = iHigh("EURGBP", PERIOD_D1, 0) - iLow("EURGBP", PERIOD_D1, 0);
   double ld_512 = iHigh("EURAUD", PERIOD_D1, 0) - iLow("EURAUD", PERIOD_D1, 0);
   double ld_520 = iHigh("GBPJPY", PERIOD_D1, 0) - iLow("GBPJPY", PERIOD_D1, 0);
   double ld_528 = iHigh("GBPNZD", PERIOD_D1, 0) - iLow("GBPNZD", PERIOD_D1, 0);
   double ld_536 = iHigh("GBPUSD", PERIOD_D1, 0) - iLow("GBPUSD", PERIOD_D1, 0);
   double ld_544 = iHigh("USDJPY", PERIOD_D1, 0) - iLow("USDJPY", PERIOD_D1, 0);
   double ld_552 = iHigh("NZDJPY", PERIOD_D1, 0) - iLow("NZDJPY", PERIOD_D1, 0);
   double ld_560 = iHigh("NZDJPY", PERIOD_D1, 0) - iLow("NZDJPY", PERIOD_D1, 0);
   double ld_568 = iHigh("USDZAR", PERIOD_D1, 0) - iLow("USDZAR", PERIOD_D1, 0);
   double ld_576 = iHigh("USDHKD", PERIOD_D1, 0) - iLow("USDHKD", PERIOD_D1, 0);
   double ld_584 = iHigh("XAUUSD", PERIOD_D1, 0) - iLow("XAUUSD", PERIOD_D1, 0);
   double ld_592 = iHigh("USOil", PERIOD_D1, 0) - iLow("USOil", PERIOD_D1, 0);
   double ld_600 = iHigh("SPX500", PERIOD_D1, 0) - iLow("SPX500", PERIOD_D1, 0);
   double ld_608 = iHigh("NAS100", PERIOD_D1, 0) - iLow("NAS100", PERIOD_D1, 0);
   double ld_616 = iHigh("US30", PERIOD_D1, 0) - iLow("US30", PERIOD_D1, 0);
   double ld_624 = iHigh("ER2_CONT", PERIOD_D1, 0) - iLow("ER2_CONT", PERIOD_D1, 0);
   double ld_632 = iHigh("UK100", PERIOD_D1, 0) - iLow("UK100", PERIOD_D1, 0);
   double ld_640 = iHigh("GER30", PERIOD_D1, 0) - iLow("GER30", PERIOD_D1, 0);
   double ld_648 = iHigh("FESX_CONT", PERIOD_D1, 0) - iLow("FESX_CONT", PERIOD_D1, 0);
   double ld_656 = iHigh("FRA40", PERIOD_D1, 0) - iLow("FRA40", PERIOD_D1, 0);
   double ld_664 = iHigh("SUI30", PERIOD_D1, 0) - iLow("SUI30", PERIOD_D1, 0);
   if (ld_336 != 0.0) ld_0 = 100.0 * ((iClose("AUDJPY", PERIOD_D1, 0) - iLow("AUDJPY", PERIOD_D1, 0)) / ld_336);
   else ld_0 = 0;
   if (ld_344 != 0.0) ld_8 = 100.0 * ((iClose("AUDNZD", PERIOD_D1, 0) - iLow("AUDNZD", PERIOD_D1, 0)) / ld_344);
   else ld_8 = 0;
   if (ld_352 != 0.0) ld_16 = 100.0 * ((iClose("AUDUSD", PERIOD_D1, 0) - iLow("AUDUSD", PERIOD_D1, 0)) / ld_352);
   else ld_16 = 0;
   if (ld_360 != 0.0) ld_24 = 100.0 * ((iClose("AUDEUR", PERIOD_D1, 0) - iLow("AUDEUR", PERIOD_D1, 0)) / ld_360);
   else ld_24 = 0;
   if (ld_368 != 0.0) ld_32 = 100.0 * ((iClose("GBPAUD", PERIOD_D1, 0) - iLow("GBPAUD", PERIOD_D1, 0)) / ld_368);
   else ld_32 = 0;
   if (ld_376 != 0.0) ld_40 = 100.0 * ((iClose("AUDCHF", PERIOD_D1, 0) - iLow("AUDCHF", PERIOD_D1, 0)) / ld_376);
   else ld_40 = 0;
   if (ld_384 != 0.0) ld_48 = 100.0 * ((iClose("AUDCAD", PERIOD_D1, 0) - iLow("AUDCAD", PERIOD_D1, 0)) / ld_384);
   else ld_48 = 0;
   if (ld_392 != 0.0) ld_56 = 100.0 * ((iClose("CHFJPY", PERIOD_D1, 0) - iLow("CHFJPY", PERIOD_D1, 0)) / ld_392);
   else ld_56 = 0;
   if (ld_400 != 0.0) ld_64 = 100.0 * ((iClose("NZDCHF", PERIOD_D1, 0) - iLow("NZDCHF", PERIOD_D1, 0)) / ld_400);
   else ld_64 = 0;
   if (ld_408 != 0.0) ld_72 = 100.0 * ((iClose("USDCHF", PERIOD_D1, 0) - iLow("USDCHF", PERIOD_D1, 0)) / ld_408);
   else ld_72 = 0;
   if (ld_416 != 0.0) ld_80 = 100.0 * ((iClose("EURCHF", PERIOD_D1, 0) - iLow("EURCHF", PERIOD_D1, 0)) / ld_416);
   else ld_80 = 0;
   if (ld_424 != 0.0) ld_88 = 100.0 * ((iClose("GBPCHF", PERIOD_D1, 0) - iLow("GBPCHF", PERIOD_D1, 0)) / ld_424);
   else ld_88 = 0;
   if (ld_432 != 0.0) ld_96 = 100.0 * ((iClose("CADCHF", PERIOD_D1, 0) - iLow("CADCHF", PERIOD_D1, 0)) / ld_432);
   else ld_96 = 0;
   if (ld_440 != 0.0) ld_104 = 100.0 * ((iClose("CADJPY", PERIOD_D1, 0) - iLow("CADJPY", PERIOD_D1, 0)) / ld_440);
   else ld_104 = 0;
   if (ld_448 != 0.0) ld_112 = 100.0 * ((iClose("NZDCAD", PERIOD_D1, 0) - iLow("NZDCAD", PERIOD_D1, 0)) / ld_448);
   else ld_112 = 0;
   if (ld_456 != 0.0) ld_120 = 100.0 * ((iClose("USDCAD", PERIOD_D1, 0) - iLow("USDCAD", PERIOD_D1, 0)) / ld_456);
   else ld_120 = 0;
   if (ld_464 != 0.0) ld_128 = 100.0 * ((iClose("EURCAD", PERIOD_D1, 0) - iLow("EURCAD", PERIOD_D1, 0)) / ld_464);
   else ld_128 = 0;
   if (ld_472 != 0.0) ld_136 = 100.0 * ((iClose("GBPCAD", PERIOD_D1, 0) - iLow("GBPCAD", PERIOD_D1, 0)) / ld_472);
   else ld_136 = 0;
   if (ld_480 != 0.0) ld_144 = 100.0 * ((iClose("EURJPY", PERIOD_D1, 0) - iLow("EURJPY", PERIOD_D1, 0)) / ld_480);
   else ld_144 = 0;
   if (ld_488 != 0.0) ld_152 = 100.0 * ((iClose("EURNZD", PERIOD_D1, 0) - iLow("EURNZD", PERIOD_D1, 0)) / ld_488);
   else ld_152 = 0;
   if (ld_496 != 0.0) ld_160 = 100.0 * ((iClose("EURUSD", PERIOD_D1, 0) - iLow("EURUSD", PERIOD_D1, 0)) / ld_496);
   else ld_160 = 0;
   if (ld_504 != 0.0) ld_168 = 100.0 * ((iClose("EURGBP", PERIOD_D1, 0) - iLow("EURGBP", PERIOD_D1, 0)) / ld_504);
   else ld_168 = 0;
   if (ld_512 != 0.0) ld_176 = 100.0 * ((iClose("EURAUD", PERIOD_D1, 0) - iLow("EURAUD", PERIOD_D1, 0)) / ld_512);
   else ld_176 = 0;
   if (ld_520 != 0.0) ld_184 = 100.0 * ((iClose("GBPJPY", PERIOD_D1, 0) - iLow("GBPJPY", PERIOD_D1, 0)) / ld_520);
   else ld_184 = 0;
   if (ld_528 != 0.0) ld_192 = 100.0 * ((iClose("GBPNZD", PERIOD_D1, 0) - iLow("GBPNZD", PERIOD_D1, 0)) / ld_528);
   else ld_192 = 0;
   if (ld_536 != 0.0) ld_200 = 100.0 * ((iClose("GBPUSD", PERIOD_D1, 0) - iLow("GBPUSD", PERIOD_D1, 0)) / ld_536);
   else ld_200 = 0;
   if (ld_552 != 0.0) ld_208 = 100.0 * ((iClose("NZDJPY", PERIOD_D1, 0) - iLow("NZDJPY", PERIOD_D1, 0)) / ld_552);
   else ld_208 = 0;
   if (ld_544 != 0.0) ld_216 = 100.0 * ((iClose("USDJPY", PERIOD_D1, 0) - iLow("USDJPY", PERIOD_D1, 0)) / ld_544);
   else ld_216 = 0;
   if (ld_560 != 0.0) ld_224 = 100.0 * ((iClose("NZDJPY", PERIOD_D1, 0) - iLow("NZDJPY", PERIOD_D1, 0)) / ld_560);
   else ld_224 = 0;
   if (ld_568 != 0.0) ld_232 = 100.0 * ((iClose("USDZAR", PERIOD_D1, 0) - iLow("USDZAR", PERIOD_D1, 0)) / ld_568);
   else ld_232 = 0;
   if (ld_576 != 0.0) ld_240 = 100.0 * ((iClose("USDHKD", PERIOD_D1, 0) - iLow("USDHKD", PERIOD_D1, 0)) / ld_576);
   else ld_240 = 0;
   if (ld_584 != 0.0) ld_248 = 100.0 * ((iClose("XAUUSD", PERIOD_D1, 0) - iLow("XAUUSD", PERIOD_D1, 0)) / ld_584);
   else ld_248 = 0;
   if (ld_592 != 0.0) ld_256 = 100.0 * ((iClose("USOil", PERIOD_D1, 0) - iLow("USOil", PERIOD_D1, 0)) / ld_592);
   else ld_256 = 0;
   if (ld_600 != 0.0) ld_264 = 100.0 * ((iClose("SPX500", PERIOD_D1, 0) - iLow("SPX500", PERIOD_D1, 0)) / ld_600);
   else ld_264 = 0;
   if (ld_608 != 0.0) ld_272 = 100.0 * ((iClose("NAS100", PERIOD_D1, 0) - iLow("NAS100", PERIOD_D1, 0)) / ld_608);
   else ld_272 = 0;
   if (ld_616 != 0.0) ld_280 = 100.0 * ((iClose("US30", PERIOD_D1, 0) - iLow("US30", PERIOD_D1, 0)) / ld_616);
   else ld_280 = 0;
   if (ld_624 != 0.0) ld_288 = 100.0 * ((iClose("ER2_CONT", PERIOD_D1, 0) - iLow("ER2_CONT", PERIOD_D1, 0)) / ld_624);
   else ld_288 = 0;
   if (ld_632 != 0.0) ld_296 = 100.0 * ((iClose("UK100", PERIOD_D1, 0) - iLow("UK100", PERIOD_D1, 0)) / ld_632);
   else ld_296 = 0;
   if (ld_640 != 0.0) ld_304 = 100.0 * ((iClose("GER30", PERIOD_D1, 0) - iLow("GER30", PERIOD_D1, 0)) / ld_640);
   else ld_304 = 0;
   if (ld_648 != 0.0) ld_312 = 100.0 * ((iClose("FESX_CONT", PERIOD_D1, 0) - iLow("FESX_CONT", PERIOD_D1, 0)) / ld_648);
   else ld_312 = 0;
   if (ld_656 != 0.0) ld_320 = 100.0 * ((iClose("FRA40", PERIOD_D1, 0) - iLow("FRA40", PERIOD_D1, 0)) / ld_656);
   else ld_320 = 0;
   if (ld_664 != 0.0) ld_328 = 100.0 * ((iClose("SUI30", PERIOD_D1, 0) - iLow("SUI30", PERIOD_D1, 0)) / ld_664);
   else ld_328 = 0;
   if (!IsTradingTime(RUSOpenTime, RUSCloseTime)) {
      Print("aaa");
      ld_288 = 0;
   }
   if (!IsTradingTime(FTSEOpenTime, FTSECloseTime)) ld_296 = 0;
   if (!IsTradingTime(DAXOpenTime, DAXCloseTime)) ld_304 = 0;
   if (!IsTradingTime(EUXOpenTime, EUXCloseTime)) ld_312 = 0;
   if (!IsTradingTime(CACOpenTime, CACCloseTime)) ld_320 = 0;
   if (!IsTradingTime(SMIOpenTime, SMICloseTime)) ld_328 = 0;
   double ld_672 = (ld_0 + ld_8 + ld_16 + ld_24 + (100 - ld_32) + ld_40 + ld_48) / 7.0;
   double ld_680 = (ld_56 + (100 - ld_64) + (100 - ld_72) + (100 - ld_80) + (100 - ld_88) + (100 - ld_40) + (100 - ld_96)) / 7.0;
   double ld_688 = (ld_104 + (100 - ld_112) + (100 - ld_120) + (100 - ld_128) + (100 - ld_136) + (100 - ld_48) + (100 - ld_96)) / 7.0;
   double ld_696 = (ld_144 + ld_152 + ld_160 + ld_128 + ld_168 + ld_176 + ld_80) / 7.0;
   double ld_704 = (ld_184 + ld_192 + ld_200 + ld_136 + (100 - ld_168) + ld_32 + ld_88) / 7.0;
   double ld_712 = (100 - ld_0 + (100 - ld_56) + (100 - ld_104) + (100 - ld_144) + (100 - ld_184) + (100 - ld_208) + (100 - ld_216)) / 7.0;
   double ld_720 = (ld_208 + (100 - ld_192) + ld_224 + ld_112 + (100 - ld_152) + (100 - ld_8) + ld_64) / 7.0;
   double ld_728 = (100 - ld_16 + ld_72 + ld_120 + (100 - ld_160) + (100 - ld_200) + ld_216 + (100 - ld_224)) / 7.0;
   objectBlank();
   paint("AUD", ld_672);
   paint("CHF", ld_680);
   paint("CAD", ld_688);
   paint("EUR", ld_696);
   paint("GBP", ld_704);
   paint("JPY", ld_712);
   paint("NZD", ld_720);
   paint("USD", ld_728);
   paint("GOLD", ld_248);
   paint("OIL", ld_256);
   paint("SPX500", ld_264);
   paint("NAS100", ld_272);
   paint("US30", ld_280);
   paint("ER2_CONT", ld_288);
   paint("UK100", ld_296);
   paint("GER30", ld_304);
   paint("FESX_CONT", ld_312);
   paint("FRA40", ld_320);
   paint("SUI30", ld_328);
   string l_text_736 = "AUDJPY: " + DoubleToStr(ld_0, 0) + "%";
   string l_text_744 = "AUDNZD: " + DoubleToStr(ld_8, 0) + "%";
   string l_text_752 = "AUDUSD: " + DoubleToStr(ld_16, 0) + "%";
   string l_text_760 = "CADCHF: " + DoubleToStr(ld_96, 0) + "%";
   string l_text_768 = "CADJPY: " + DoubleToStr(ld_104, 0) + "%";
   string l_text_776 = "CHFJPY: " + DoubleToStr(ld_56, 0) + "%";
   string l_text_784 = "EURAUD: " + DoubleToStr(ld_176, 0) + "%";
   string l_text_792 = "EURCHF: " + DoubleToStr(ld_80, 0) + "%";
   string l_text_800 = "EURCAD: " + DoubleToStr(ld_128, 0) + "%";
   string l_text_808 = "EURGBP: " + DoubleToStr(ld_168, 0) + "%";
   string l_text_816 = "EURJPY: " + DoubleToStr(ld_144, 0) + "%";
   string l_text_824 = "EURNZD: " + DoubleToStr(ld_152, 0) + "%";
   string l_text_832 = "EURUSD: " + DoubleToStr(ld_160, 0) + "%";
   string l_text_840 = "GBPAUD: " + DoubleToStr(ld_32, 0) + "%";
   string l_text_848 = "GBPCAD: " + DoubleToStr(ld_136, 0) + "%";
   string l_text_856 = "GBPCHF: " + DoubleToStr(ld_88, 0) + "%";
   string l_text_864 = "GBPJPY: " + DoubleToStr(ld_184, 0) + "%";
   string l_text_872 = "GBPUSD: " + DoubleToStr(ld_200, 0) + "%";
   string l_text_880 = "NZDCAD: " + DoubleToStr(ld_112, 0) + "%";
   string l_text_888 = "NZDCHF: " + DoubleToStr(ld_64, 0) + "%";
   string l_text_896 = "NZDJPY: " + DoubleToStr(ld_208, 0) + "%";
   string l_text_904 = "NZDUSD: " + DoubleToStr(ld_224, 0) + "%";
   string l_text_912 = "USDCAD: " + DoubleToStr(ld_120, 0) + "%";
   string l_text_920 = "USDCHF: " + DoubleToStr(ld_72, 0) + "%";
   string l_text_928 = "USDHKD: " + DoubleToStr(ld_240, 0) + "%";
   string l_text_936 = "USDJPY: " + DoubleToStr(ld_216, 0) + "%";
   string l_text_944 = "USDZAR: " + DoubleToStr(ld_232, 0) + "%";
   ObjectCreate("Overalltitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Overalltitle", "OVERALL CURRENCY STRENGTHS", FontSize + 2, "Segoe UI", Yellow);
   ObjectSet("Overalltitle", OBJPROP_CORNER, g_corner_192);
   ObjectSet("Overalltitle", OBJPROP_XDISTANCE, gd_204 - 13 * FontSize);
   ObjectSet("Overalltitle", OBJPROP_YDISTANCE, gi_200 + 10);
   ObjectCreate("Stocktitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Stocktitle", "STOCK INDICES", FontSize + 2, "Segoe UI", Yellow);
   ObjectSet("Stocktitle", OBJPROP_CORNER, g_corner_192);
   ObjectSet("Stocktitle", OBJPROP_XDISTANCE, gd_236 - 6 * FontSize);
   ObjectSet("Stocktitle", OBJPROP_YDISTANCE, gi_200 + 10);
   ObjectCreate("Commtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Commtitle", "COMMODITIES", FontSize + 2, "Segoe UI", Yellow);
   ObjectSet("Commtitle", OBJPROP_CORNER, g_corner_192);
   ObjectSet("Commtitle", OBJPROP_XDISTANCE, gd_212 - 5 * FontSize);
   ObjectSet("Commtitle", OBJPROP_YDISTANCE, gi_200 + 30);
   ObjectCreate("USAtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("USAtitle", "USA", FontSize + 2, "Segoe UI", Yellow);
   ObjectSet("USAtitle", OBJPROP_CORNER, g_corner_192);
   ObjectSet("USAtitle", OBJPROP_XDISTANCE, gd_220 - 1 * FontSize);
   ObjectSet("USAtitle", OBJPROP_YDISTANCE, gi_200 + 30);
   ObjectCreate("EURtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("EURtitle", "EUROPE", FontSize + 2, "Segoe UI", Yellow);
   ObjectSet("EURtitle", OBJPROP_CORNER, g_corner_192);
   ObjectSet("EURtitle", OBJPROP_XDISTANCE, gd_228 - 3 * FontSize);
   ObjectSet("EURtitle", OBJPROP_YDISTANCE, gi_200 + 30);
   ObjectCreate("goldoilavgtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("goldoilavgtitle", DoubleToStr((ld_248 + ld_256) / 2.0, 0) + "%", FontSize + 8, "Segoe UI", White);
   ObjectSet("goldoilavgtitle", OBJPROP_CORNER, g_corner_192);
   ObjectSet("goldoilavgtitle", OBJPROP_XDISTANCE, gd_212 - 5 * FontSize);
   ObjectSet("goldoilavgtitle", OBJPROP_YDISTANCE, gi_200 + 250);
   ObjectCreate("USavgtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("USavgtitle", DoubleToStr((ld_264 + ld_272 + ld_280 + ld_288) / 4.0, 0) + "%", FontSize + 8, "Segoe UI", White);
   ObjectSet("USavgtitle", OBJPROP_CORNER, g_corner_192);
   ObjectSet("USavgtitle", OBJPROP_XDISTANCE, gd_220 - 1 * FontSize);
   ObjectSet("USavgtitle", OBJPROP_YDISTANCE, gi_200 + 250);
   ObjectCreate("EURavgtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("EURavgtitle", DoubleToStr((ld_296 + ld_304 + ld_312 + ld_320 + ld_328) / 5.0, 0) + "%", FontSize + 8, "Segoe UI", White);
   ObjectSet("EURavgtitle", OBJPROP_CORNER, g_corner_192);
   ObjectSet("EURavgtitle", OBJPROP_XDISTANCE, gd_228 - 3 * FontSize);
   ObjectSet("EURavgtitle", OBJPROP_YDISTANCE, gi_200 + 250);
   ObjectCreate("Stocksavgtitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Stocksavgtitle", DoubleToStr(((ld_264 + ld_272 + ld_280 + ld_288) / 4.0 + (ld_296 + ld_304 + ld_312 + ld_320 + ld_328) / 5.0) / 2.0, 0) + "%", FontSize +
      8, "Segoe UI", White);
   ObjectSet("Stocksavgtitle", OBJPROP_CORNER, g_corner_192);
   ObjectSet("Stocksavgtitle", OBJPROP_XDISTANCE, (gd_220 - 1 * FontSize + (gd_228 - 3 * FontSize)) / 2.0);
   ObjectSet("Stocksavgtitle", OBJPROP_YDISTANCE, gi_200 + 270);
   int li_952 = 300;
   ObjectCreate("audjpy", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audjpyRange", OBJ_LABEL, 0, 0, 0);
   if (ld_0 >= buy_level) ObjectSetText("audjpy", l_text_736, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_0 <= sell_level) ObjectSetText("audjpy", l_text_736, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("audjpy", l_text_736, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("audjpy", "AUDJPY", 5 * FontSize / 10, li_952);
   ObjectCreate("audnzdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audnzdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audnzd", OBJ_LABEL, 0, 0, 0);
   if (ld_8 >= buy_level) ObjectSetText("audnzd", l_text_744, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_8 <= sell_level) ObjectSetText("audnzd", l_text_744, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("audnzd", l_text_744, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("audnzd", "AUDNZD", 140 * FontSize / 10, li_952);
   ObjectCreate("audusdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audusdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("audusd", OBJ_LABEL, 0, 0, 0);
   if (ld_16 >= buy_level) ObjectSetText("audusd", l_text_752, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_16 <= sell_level) ObjectSetText("audusd", l_text_752, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("audusd", l_text_752, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("audusd", "AUDUSD", 275 * FontSize / 10, li_952);
   ObjectCreate("cadchfRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("cadchfBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("cadchf", OBJ_LABEL, 0, 0, 0);
   if (ld_96 >= buy_level) ObjectSetText("cadchf", l_text_760, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_96 <= sell_level) ObjectSetText("cadchf", l_text_760, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("cadchf", l_text_760, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("cadchf", "CADCHF", 410 * FontSize / 10, li_952);
   ObjectCreate("cadjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("cadjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("cadjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_104 >= buy_level) ObjectSetText("cadjpy", l_text_768, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_104 <= sell_level) ObjectSetText("cadjpy", l_text_768, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("cadjpy", l_text_768, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("cadjpy", "CADJPY", 545 * FontSize / 10, li_952);
   ObjectCreate("chfjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("chfjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("chfjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_56 >= buy_level) ObjectSetText("chfjpy", l_text_776, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_56 <= sell_level) ObjectSetText("chfjpy", l_text_776, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("chfjpy", l_text_776, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("chfjpy", "CHFJPY", 680 * FontSize / 10, li_952);
   ObjectCreate("euraudRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("euraudBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("euraud", OBJ_LABEL, 0, 0, 0);
   if (ld_176 >= buy_level) ObjectSetText("euraud", l_text_784, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_176 <= sell_level) ObjectSetText("euraud", l_text_784, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("euraud", l_text_784, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("euraud", "EURAUD", 815 * FontSize / 10, li_952);
   ObjectCreate("eurcadRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurcadBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurcad", OBJ_LABEL, 0, 0, 0);
   if (ld_128 >= buy_level) ObjectSetText("eurcad", l_text_800, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_128 <= sell_level) ObjectSetText("eurcad", l_text_800, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("eurcad", l_text_800, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("eurcad", "EURCAD", 950 * FontSize / 10, li_952);
   ObjectCreate("eurchfRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurchfBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurchf", OBJ_LABEL, 0, 0, 0);
   if (ld_80 >= buy_level) ObjectSetText("eurchf", l_text_792, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_80 <= sell_level) ObjectSetText("eurchf", l_text_792, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("eurchf", l_text_792, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("eurchf", "EURCHF", 1085 * FontSize / 10, li_952);
   ObjectCreate("eurgbpRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurgbpBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurgbp", OBJ_LABEL, 0, 0, 0);
   if (ld_168 >= buy_level) ObjectSetText("eurgbp", l_text_808, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_168 <= sell_level) ObjectSetText("eurgbp", l_text_808, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("eurgbp", l_text_808, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("eurgbp", "EURGBP", 5 * FontSize / 10, li_952 + 65);
   ObjectCreate("eurjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_144 >= buy_level) ObjectSetText("eurjpy", l_text_816, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_144 <= sell_level) ObjectSetText("eurjpy", l_text_816, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("eurjpy", l_text_816, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("eurjpy", "EURJPY", 140 * FontSize / 10, li_952 + 65);
   ObjectCreate("eurnzdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurnzdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurnzd", OBJ_LABEL, 0, 0, 0);
   if (ld_152 >= buy_level) ObjectSetText("eurnzd", l_text_824, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_152 <= sell_level) ObjectSetText("eurnzd", l_text_824, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("eurnzd", l_text_824, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("eurnzd", "EURNZD", 275 * FontSize / 10, li_952 + 65);
   ObjectCreate("eurusdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurusdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("eurusd", OBJ_LABEL, 0, 0, 0);
   if (ld_160 >= buy_level) ObjectSetText("eurusd", l_text_832, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_160 <= sell_level) ObjectSetText("eurusd", l_text_832, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("eurusd", l_text_832, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("eurusd", "EURUSD", 410 * FontSize / 10, li_952 + 65);
   ObjectCreate("gbpaudRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpaudBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpaud", OBJ_LABEL, 0, 0, 0);
   if (ld_32 >= buy_level) ObjectSetText("gbpaud", l_text_840, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_32 <= sell_level) ObjectSetText("gbpaud", l_text_840, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("gbpaud", l_text_840, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("gbpaud", "GBPAUD", 545 * FontSize / 10, li_952 + 65);
   ObjectCreate("gbpcadRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpcadBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpcad", OBJ_LABEL, 0, 0, 0);
   if (ld_136 >= buy_level) ObjectSetText("gbpcad", l_text_848, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_136 <= sell_level) ObjectSetText("gbpcad", l_text_848, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("gbpcad", l_text_848, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("gbpcad", "GBPCAD", 680 * FontSize / 10, li_952 + 65);
   ObjectCreate("gbpchfRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpchfBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpchf", OBJ_LABEL, 0, 0, 0);
   if (ld_88 >= buy_level) ObjectSetText("gbpchf", l_text_856, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_88 <= sell_level) ObjectSetText("gbpchf", l_text_856, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("gbpchf", l_text_856, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("gbpchf", "GBPCHF", 815 * FontSize / 10, li_952 + 65);
   ObjectCreate("gbpjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_184 >= buy_level) ObjectSetText("gbpjpy", l_text_864, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_184 <= sell_level) ObjectSetText("gbpjpy", l_text_864, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("gbpjpy", l_text_864, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("gbpjpy", "GBPJPY", 950 * FontSize / 10, li_952 + 65);
   ObjectCreate("gbpusdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpusdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("gbpusd", OBJ_LABEL, 0, 0, 0);
   if (ld_200 >= buy_level) ObjectSetText("gbpusd", l_text_872, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_200 <= sell_level) ObjectSetText("gbpusd", l_text_872, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("gbpusd", l_text_872, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("gbpusd", "GBPUSD", 1085 * FontSize / 10, li_952 + 65);
   ObjectCreate("nzdcadRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdcadBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdcad", OBJ_LABEL, 0, 0, 0);
   if (ld_112 >= buy_level) ObjectSetText("nzdcad", l_text_880, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_112 <= sell_level) ObjectSetText("nzdcad", l_text_880, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("nzdcad", l_text_880, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("nzdcad", "NZDCAD", 5 * FontSize / 10, li_952 + 130);
   ObjectCreate("nzdchfRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdchfBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdchf", OBJ_LABEL, 0, 0, 0);
   if (ld_64 >= buy_level) ObjectSetText("nzdchf", l_text_888, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_64 <= sell_level) ObjectSetText("nzdchf", l_text_888, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("nzdchf", l_text_888, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("nzdchf", "NZDCHF", 140 * FontSize / 10, li_952 + 130);
   ObjectCreate("nzdjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_208 >= buy_level) ObjectSetText("nzdjpy", l_text_896, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_208 <= sell_level) ObjectSetText("nzdjpy", l_text_896, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("nzdjpy", l_text_896, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("nzdjpy", "NZDJPY", 275 * FontSize / 10, li_952 + 130);
   ObjectCreate("nzdusdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdusdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nzdusd", OBJ_LABEL, 0, 0, 0);
   if (ld_224 >= buy_level) ObjectSetText("nzdusd", l_text_904, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_224 <= sell_level) ObjectSetText("nzdusd", l_text_904, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("nzdusd", l_text_904, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("nzdusd", "NZDUSD", 410 * FontSize / 10, li_952 + 130);
   ObjectCreate("usdcadRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdcadBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdcad", OBJ_LABEL, 0, 0, 0);
   if (ld_120 >= buy_level) ObjectSetText("usdcad", l_text_912, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_120 <= sell_level) ObjectSetText("usdcad", l_text_912, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("usdcad", l_text_912, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("usdcad", "USDCAD", 545 * FontSize / 10, li_952 + 130);
   ObjectCreate("usdchfRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdchfBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdchf", OBJ_LABEL, 0, 0, 0);
   if (ld_72 >= buy_level) ObjectSetText("usdchf", l_text_920, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_72 <= sell_level) ObjectSetText("usdchf", l_text_920, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("usdchf", l_text_920, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("usdchf", "USDCHF", 680 * FontSize / 10, li_952 + 130);
   ObjectCreate("usdhkdRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdhkdBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdhkd", OBJ_LABEL, 0, 0, 0);
   if (ld_240 >= buy_level) ObjectSetText("usdhkd", l_text_928, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_240 <= sell_level) ObjectSetText("usdhkd", l_text_928, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("usdhkd", l_text_928, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("usdhkd", "USDHKD", 815 * FontSize / 10, li_952 + 130);
   ObjectCreate("usdjpyRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdjpyBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdjpy", OBJ_LABEL, 0, 0, 0);
   if (ld_216 >= buy_level) ObjectSetText("usdjpy", l_text_936, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_216 <= sell_level) ObjectSetText("usdjpy", l_text_936, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("usdjpy", l_text_936, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("usdjpy", "USDJPY", 950 * FontSize / 10, li_952 + 130);
   ObjectCreate("usdzarRange", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdzarBid", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("usdzar", OBJ_LABEL, 0, 0, 0);
   if (ld_232 >= buy_level) ObjectSetText("usdzar", l_text_944, FontSize + 2, "Segoe UI", Lime);
   else {
      if (ld_232 <= sell_level) ObjectSetText("usdzar", l_text_944, FontSize + 2, "Segoe UI", Red);
      else ObjectSetText("usdzar", l_text_944, FontSize + 2, "Segoe UI", White);
   }
   ObjSettxt("usdzar", "USDZAR", 1085 * FontSize / 10, li_952 + 130);
   return (0);
}

void ObjSettxt(string a_name_0, string a_symbol_8, int ai_16, int ai_20) {
   ObjectSetText(a_name_0 + "Bid", "Bid : " + DoubleToStr(MarketInfo(a_symbol_8, MODE_BID), MarketInfo(a_symbol_8, MODE_DIGITS)), FontSize, "Segoe UI", White);
   ObjectSet(a_name_0 + "Bid", OBJPROP_CORNER, g_corner_192);
   ObjectSet(a_name_0 + "Bid", OBJPROP_XDISTANCE, gi_196 + ai_16);
   ObjectSet(a_name_0 + "Bid", OBJPROP_YDISTANCE, gi_200 + ai_20 + 20);
   ObjectSetText(a_name_0 + "Range", "Range : " + DoubleToStr((iHigh(a_symbol_8, PERIOD_D1, 0) - iLow(a_symbol_8, PERIOD_D1, 0)) / MarketInfo(a_symbol_8, MODE_POINT), 0), FontSize, "Segoe UI", White);
   ObjectSet(a_name_0 + "Range", OBJPROP_CORNER, g_corner_192);
   ObjectSet(a_name_0 + "Range", OBJPROP_XDISTANCE, gi_196 + ai_16);
   ObjectSet(a_name_0 + "Range", OBJPROP_YDISTANCE, gi_200 + ai_20 + 40);
   ObjectSet(a_name_0, OBJPROP_CORNER, g_corner_192);
   ObjectSet(a_name_0, OBJPROP_XDISTANCE, gi_196 + ai_16);
   ObjectSet(a_name_0, OBJPROP_YDISTANCE, gi_200 + ai_20);
}

void objectCreate(string a_name_0, int a_x_8, int a_y_12, string a_text_16 = "-", int a_fontsize_24 = 60, string a_fontname_28 = "Arial", color a_color_36 = -1) {
   if (a_fontsize_24 == 60) a_fontsize_24 = 6 * FontSize;
   ObjectCreate(a_name_0, OBJ_LABEL, 0, 0, 0);
   ObjectSet(a_name_0, OBJPROP_CORNER, 0);
   ObjectSet(a_name_0, OBJPROP_COLOR, a_color_36);
   ObjectSet(a_name_0, OBJPROP_XDISTANCE, a_x_8);
   ObjectSet(a_name_0, OBJPROP_YDISTANCE, a_y_12);
   ObjectSetText(a_name_0, a_text_16, a_fontsize_24, a_fontname_28, a_color_36);
}

void initGraph() {
   ObjectsDeleteAll(0, OBJ_LABEL);
   int li_0 = 120;
   int li_4 = 50 * FontSize / 10;
   int li_8 = li_0;
   for (int li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("aud_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("audtxt", li_4, li_0 + 100, "AUD", FontSize + 2, "Arial Narrow", White);
   objectCreate("audp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 100 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("chf_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("chftxt", li_4, li_0 + 100, "CHF", FontSize + 2, "Arial Narrow", White);
   objectCreate("chfp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 150 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("cad_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("cadtxt", li_4, li_0 + 100, "CAD", FontSize + 2, "Arial Narrow", White);
   objectCreate("cadp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 200 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("eur_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("eurtxt", li_4, li_0 + 100, "EUR", FontSize + 2, "Arial Narrow", White);
   objectCreate("eurp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 250 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("gbp_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("gbptxt", li_4, li_0 + 100, "GBP", FontSize + 2, "Arial Narrow", White);
   objectCreate("gbpp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 300 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("jpy_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("jpytxt", li_4, li_0 + 100, "JPY", FontSize + 2, "Arial Narrow", White);
   objectCreate("jpyp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 350 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("nzd_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("nzdtxt", li_4, li_0 + 100, "NZD", FontSize + 2, "Arial Narrow", White);
   objectCreate("nzdp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 400 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("usd_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("usdtxt", li_4, li_0 + 100, "USD", FontSize + 2, "Arial Narrow", White);
   objectCreate("usdp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   gd_204 = (li_4 + 40 + FontSize) / 2;
   li_4 = 550 * FontSize / 10;
   double ld_16 = li_4;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("xau_usd_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("xau_usdtxt", li_4, li_0 + 100, "GOLD", FontSize + 2, "Arial Narrow", White);
   objectCreate("xau_usdp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 610 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("usoil_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("usoiltxt", li_4, li_0 + 100, "OIL", FontSize + 2, "Arial Narrow", White);
   objectCreate("usoilp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   gd_212 = (ld_16 + li_4) / 2.0;
   li_4 = 700 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("spx500_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("spx500txt", li_4, li_0 + 100, "S&P", FontSize + 2, "Arial Narrow", White);
   objectCreate("spx500p", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   double ld_24 = li_4;
   li_4 = 750 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("nas100_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("nas100txt", li_4, li_0 + 100, "NDQ", FontSize + 2, "Arial Narrow", White);
   objectCreate("nas100p", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 800 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("us30_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("us30txt", li_4, li_0 + 100, "DOW", FontSize + 2, "Arial Narrow", White);
   objectCreate("us30p", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 850 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("russel_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("russeltxt", li_4, li_0 + 100, "RUS", FontSize + 2, "Arial Narrow", White);
   objectCreate("russelp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   gd_220 = (ld_24 + li_4) / 2.0;
   li_4 = 950 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("uk100_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("uk100txt", li_4, li_0 + 100, "FSE", FontSize + 2, "Arial Narrow", White);
   objectCreate("uk100p", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   double ld_32 = li_4;
   li_4 = 1000 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("ger30_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("ger30txt", li_4, li_0 + 100, "DAX", FontSize + 2, "Arial Narrow", White);
   objectCreate("ger30p", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 1050 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("eux_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("euxtxt", li_4, li_0 + 100, "EUX", FontSize + 2, "Arial Narrow", White);
   objectCreate("euxp", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 1100 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("fra40_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("fra40txt", li_4, li_0 + 100, "CAC", FontSize + 2, "Arial Narrow", White);
   objectCreate("fra40p", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   li_4 = 1150 * FontSize / 10;
   li_8 = li_0;
   for (li_12 = 1; li_12 <= 51; li_12++) {
      objectCreate("sui30_" + li_12, li_4, li_8);
      li_8 -= 2;
   }
   objectCreate("sui30txt", li_4, li_0 + 100, "SMI", FontSize + 2, "Arial Narrow", White);
   objectCreate("sui30p", li_4, li_0 + 80 - 2, DoubleToStr(9, 1), FontSize + 2, "Arial Narrow", White);
   gd_228 = (ld_32 + li_4) / 2.0;
   gd_236 = (ld_24 + li_4) / 2.0;
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
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("xau_usd_" + li_0);
   ObjectSet("xau_usdtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("xau_usdp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("usoil_" + li_0);
   ObjectSet("usoiltxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("usoilp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("spx500_" + li_0);
   ObjectSet("spx500txt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("spx500p", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("nas100_" + li_0);
   ObjectSet("nas100txt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("nas100p", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("us30_" + li_0);
   ObjectSet("us30txt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("us30p", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("russel_" + li_0);
   ObjectSet("russeltxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("russelp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("uk100_" + li_0);
   ObjectSet("uk100txt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("uk100p", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("ger30_" + li_0);
   ObjectSet("ger30txt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("ger30p", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("eux_" + li_0);
   ObjectSet("euxtxt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("euxp", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("fra40_" + li_0);
   ObjectSet("fra40txt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("fra40", OBJPROP_COLOR, CLR_NONE);
   for (li_0 = 1; li_0 <= 51; li_0++) ObjectSetBlank("sui30_" + li_0);
   ObjectSet("sui30txt", OBJPROP_COLOR, CLR_NONE);
   ObjectSet("sui30p", OBJPROP_COLOR, CLR_NONE);
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
   if (as_0 == "GOLD") ls_16 = "xau_usd";
   if (as_0 == "OIL") ls_16 = "usoil";
   if (as_0 == "SPX500") ls_16 = "SPX500";
   if (as_0 == "NAS100") ls_16 = "NAS100";
   if (as_0 == "US30") ls_16 = "us30";
   if (as_0 == "ER2_CONT") ls_16 = "russel";
   if (as_0 == "UK100") ls_16 = "UK100";
   if (as_0 == "GER30") ls_16 = "GER30";
   if (as_0 == "FESX_CONT") ls_16 = "eux";
   if (as_0 == "FRA40") ls_16 = "FRA40";
   if (as_0 == "SUI30") ls_16 = "sui30";
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
      ObjectSetText(ls_16 + "p", DoubleToStr(ad_8, 0) + "%", FontSize + 2, "Arial Narrow", Red);
      return;
   }
   if (ad_8 >= buy_level) {
      ObjectSet(ls_16 + "txt", OBJPROP_COLOR, Lime);
      ObjectSetText(ls_16 + "p", DoubleToStr(ad_8, 0) + "%", FontSize + 2, "Arial Narrow", Lime);
      return;
   }
   ObjectSet(ls_16 + "txt", OBJPROP_COLOR, White);
   ObjectSetText(ls_16 + "p", DoubleToStr(ad_8, 0) + "%", FontSize + 2, "Arial Narrow", White);
}

bool IsTradingTime(string as_0, string as_8) {
   int l_str2time_16 = StrToTime(Year() + "." + Month() + "." + Day() + " " + as_0);
   int li_20 = StrToTime(Year() + "." + Month() + "." + Day() + " " + as_8);
   if (l_str2time_16 > li_20) li_20 += 86400;
   if (TimeCurrent() > l_str2time_16 && TimeCurrent() < li_20) return (TRUE);
   return (FALSE);
}