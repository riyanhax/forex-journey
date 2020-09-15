
#property copyright "http://www.texno-forex.ru   Copyright © 2011"
#property link      "http://www.texno-forex.ru"

extern string cht000 = "лиценция на счет";
extern string cht001 = "FREE";
extern string c0000000 = " === РАЗРЕШЕНИЕ НА РАБОТУ ===";
extern bool Run = TRUE;
extern string cht002 = "валюты ";
extern bool EUR_USD = TRUE;
extern bool GBP_USD = TRUE;
extern bool USD_JPY = TRUE;
extern bool USD_CHF = TRUE;
extern bool USD_CAD = TRUE;
extern bool AUD_USD = TRUE;
extern bool NZD_USD = TRUE;
extern bool EUR_JPY = TRUE;
extern bool EUR_CHF = TRUE;
extern bool EUR_GBP = TRUE;
extern string с0000001 = "=======================================================";
extern string с0000002 = "идентификатор ордеров";
extern int id = 1111111;
extern string с0000030 = "Размер бонуса";
extern int Bonus = 0;
extern string с0000003 = "Доступно в % от баланса";
extern int FreeBalanсe = 100;
extern string с0000004 = "Размер лота руч/авт.";
extern bool Lots_auto = TRUE;
extern string с0000005 = "Динамичный лот, %";
extern double Risk = 1.0;
extern string с0000006 = "Размер стартового лота";
extern double Lots_min = 0.1;
extern string с0000007 = "Максимальный размер лота";
extern double Lots_max = 10.0;
extern string с0000008 = "блок./разблок. ордеров";
extern string с1000008 = "общий";
extern double CloseLosk = 90.0;
extern double OpenLosk = 50.0;
extern string с2000008 = "по валютным парам";
extern double IndCloseLosk = 15.0;
extern double IndOpenLosk = 5.0;
extern string с0000009 = "расстояние между ордерами";
extern double Delta = 35.0;
extern string с1000009 = "увелич. расстояния, пунктов";
extern double DeltaPlus = 10.0;
extern string с00000010 = "расстояние до ордера";
extern int Front = 3;
extern string с0000013 = "задание профита";
extern int Prof = 20;
extern string с1000013 = "Закрывать только тралом";
extern bool ProfTrall = FALSE;
extern string с2000012 = "Comp. лот, %";
extern double StepCompLot = 100.0;
extern string с0000018 = "проскальзывание";
extern int Slip = 7;
extern string с0000019 = "вывод информации на монитор";
extern bool Info = TRUE;
extern string с0000021 = "выводить сообщения об ошибках";
extern bool InfoError = FALSE;
extern string с0000022 = "глубина фильтрации";
extern int filter = 100;
extern string с0000023 = "порог";
extern int dam = 1;
extern string с0000014 = "========================";
extern string с0000015 = "тралить через...пунктов";
extern int Trall = 5;
extern string с0000016 = "шаг трала";
extern int TrailingStep = 2;
extern string с0000024 = "=======================================================";
int g_color_496 = LightBlue;
int g_color_500 = Chartreuse;
int g_color_504 = DarkGray;
int g_color_508 = Red;
int g_color_512 = LimeGreen;
int g_color_516 = PaleGoldenrod;
bool gba_520[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
bool gba_524[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
bool gi_528 = FALSE;
color g_color_532;
int gi_536 = 3024;
bool gba_540[11];
int gi_544 = 100;
bool gi_548 = FALSE;
bool gba_556[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
bool gi_560 = TRUE;
int gi_564 = 3;
int Accunt_number;
double gd_592 = 0.0;
int gia_604[11];
double gda_608[11][10002];
double gda_612[11];
double gda_616[11];
double gda_620[11];
double gda_624[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_628[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_632[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_636[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_640[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_644[11];
int gia_648[11];
int gia_652[11];
int gia_656[11];
int gi_660 = 0;
string gsa_664[11] = {"NO", "EURUSD", "GBPUSD", "USDJPY", "USDCHF", "USDCAD", "AUDUSD", "NZDUSD", "EURJPY", "EURCHF", "EURGBP"};
bool gba_668[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_672[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_676[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_680[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_684[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
bool gba_688[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
bool gba_692[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
bool gba_696[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
bool gba_700[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
bool gba_704[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gi_708;
int gi_712;
int gia_716[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_720[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_724[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_728[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_732[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_736[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_740[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_744[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_748[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_752[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_756[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_760[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_764[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_768[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_772[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_776[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_780[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_784[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_788[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_792[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gd_796;
double gda_804[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_808[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_812[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_816[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_820[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_824[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_828[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_832[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_836[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_840[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_844[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_848[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_852[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_856[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_860[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_864[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gd_868;
double gd_876;
double gd_884;
double gd_892;
double gd_900;
double gd_908;
double gda_916[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_920[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_924[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_928[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_932[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_936[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_940[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_944[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_948[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_952[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_956[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_960[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_964[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_968[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_972[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_976[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_980[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_984[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_988[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_992[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int gia_996[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_1000[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_1004[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
string gsa_1008[7] = {" отключен", "1 минута", "5 минут", "15 минут", "30 минут", "1 час", "4 часа", "1 день"};
string gsa_1012[12] = {"число", "января", "Февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"};
string gsa_1016[7] = {"воскресенье", "понедельник", "вторник", "среда", "четверг", "пятница", "суббота"};
string gsa_1020[11] = {"Валютная пара EUR_USD", "Comment 1_1", "Comment 1_2", "Comment 1_3", "Comment 1_4", "Comment 1_5", "Comment 1_6", "Comment 1_7", "Comment 1_8", "Comment 1_9", "Comment 1_10", "Comment 1_11"};
string gsa_1024[11] = {"Валютная пара GBR_USD", "Comment _2_1", "Comment 2_2", "Comment 2_3", "Comment 2_4", "Comment 2_5", "Comment 2_6", "Comment 2_7", "Comment 2_8", "Comment 2_9", "Comment 2_10", "Comment 2_11"};
string gsa_1028[11] = {"Валютная пара USD_JPY", "Comment 3_1", "Comment 3_2", "Comment 3_3", "Comment 3_4", "Comment 3_5", "Comment 3_6", "Comment 3_7", "Comment 3_8", "Comment 3_9", "Comment 3_10", "Comment 3_11"};
string gsa_1032[11] = {"Валютная пара USD_CHF", "Comment 4_1", "Comment 4_2", "Comment 4_3", "Comment 4_4", "Comment 4_5", "Comment 4_6", "Comment 4_7", "Comment 4_8", "Comment 4_9", "Comment 4_10", "Comment 4_11"};
string gsa_1036[11] = {"Валютная пара USD_CAD", "Comment 5_1", "Comment 5_2", "Comment 5_3", "Comment 5_4", "Comment 5_5", "Comment 5_6", "Comment 5_7", "Comment 5_8", "Comment 5_9", "Comment 5_10", "Comment 5_11"};
string gsa_1040[11] = {"Валютная пара AUD_USD", "Comment 6_1", "Comment 6_2", "Comment 6_3", "Comment 6_4", "Comment 6_5", "Comment 6_6", "Comment 6_7", "Comment 6_8", "Comment 6_9", "Comment 6_10", "Comment 6_11"};
string gsa_1044[11] = {"Валютная пара NZD_USD", "Comment 7_1", "Comment 7_2", "Comment 7_3", "Comment 7_4", "Comment 7_5", "Comment 7_6", "Comment 7_7", "Comment 7_8", "Comment 7_9", "Comment 7_10", "Comment 7_11"};
string gsa_1048[11] = {"Валютная пара EUR_JPY", "Comment 8_1", "Comment 8_2", "Comment 8_3", "Comment 8_4", "Comment 8_5", "Comment 8_6", "Comment 8_7", "Comment 8_8", "Comment 8_9", "Comment 8_10", "Comment 8_11"};
string gsa_1052[11] = {"Валютная пара EUR_CHF", "Comment 9_1", "Comment 9_2", "Comment 9_3", "Comment 9_4", "Comment 9_5", "Comment 9_6", "Comment 9_7", "Comment 9_8", "Comment 9_9", "Comment 9_10", "Comment 9_11"};
string gsa_1056[11] = {"Валютная пара EUR_GBR", "Comment 10_1", "Comment 10_2", "Comment 10_3", "Comment 10_4", "Comment 10_5", "Comment 10_6", "Comment 10_7", "Comment 10_8", "Comment 10_9", "Comment 10_10", "Comment 10_11"};
string gsa_1060[11] = {"Comment 11_0", "Comment 11_1", "Comment 11_2", "Comment 11_3", "Comment 11_4", "Comment 11_5"};
string gsa_1064[5] = {"Comment 12_0", "Comment 12_1", "Comment 12_2", "Comment 12_3", "Comment 12_4", "Comment 12_5"};
double gda_1068[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_1072[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
bool gi_1076 = FALSE;
bool gi_1080 = FALSE;
int g_count_1084;

int init() 
{
   if (EUR_USD == TRUE) gba_540[1] = 1;
   else gba_540[1] = 0;
   if (GBP_USD == TRUE) gba_540[2] = 1;
   else gba_540[2] = 0;
   if (USD_JPY == TRUE) gba_540[3] = 1;
   else gba_540[3] = 0;
   if (USD_CHF == TRUE) gba_540[4] = 1;
   else gba_540[4] = 0;
   if (USD_CAD == TRUE) gba_540[5] = 1;
   else gba_540[5] = 0;
   if (AUD_USD == TRUE) gba_540[6] = 1;
   else gba_540[6] = 0;
   if (NZD_USD == TRUE) gba_540[7] = 1;
   else gba_540[7] = 0;
   if (EUR_JPY == TRUE) gba_540[8] = 1;
   else gba_540[8] = 0;
   if (EUR_CHF == TRUE) gba_540[9] = 1;
   else gba_540[9] = 0;
   if (EUR_GBP == TRUE) gba_540[10] = 1;
   else gba_540[10] = 0;
   gia_632[1] = id + 1;
   gia_632[2] = id + 3;
   gia_632[3] = id + 5;
   gia_632[4] = id + 7;
   gia_632[5] = id + 9;
   gia_632[6] = id + 11;
   gia_632[7] = id + 13;
   gia_632[8] = id + 15;
   gia_632[9] = id + 17;
   gia_632[10] = id + 19;
   gia_636[1] = id + 2;
   gia_636[2] = id + 4;
   gia_636[3] = id + 6;
   gia_636[4] = id + 8;
   gia_636[5] = id + 10;
   gia_636[6] = id + 12;
   gia_636[7] = id + 14;
   gia_636[8] = id + 16;
   gia_636[9] = id + 18;
   gia_636[10] = id + 20;
   return (0);
}

int deinit() 
{
   for (int index_0 = 0; index_0 <= 12; index_0++) 
   {
      ObjectDelete(gsa_1020[index_0]);
      ObjectDelete(gsa_1024[index_0]);
      ObjectDelete(gsa_1028[index_0]);
      ObjectDelete(gsa_1032[index_0]);
      ObjectDelete(gsa_1036[index_0]);
      ObjectDelete(gsa_1040[index_0]);
      ObjectDelete(gsa_1044[index_0]);
      ObjectDelete(gsa_1048[index_0]);
      ObjectDelete(gsa_1052[index_0]);
      ObjectDelete(gsa_1056[index_0]);
   }
   for (int index_4 = 0; index_4 <= 5; index_4++) 
   {
      ObjectDelete(gsa_1060[index_4]);
      ObjectDelete(gsa_1064[index_4]);
   }
   return (0);
}

int start() 
{
   int hist_total_0;
   int hist_total_20;
   int cmd_40;
   bool li_44;
   int slippage_52;
   int li_56;
   int li_60;
   int li_64;
   double point_68;
   int cmd_84;
   bool is_deleted_88;
   int cmd_92;
   int cmd_100;
   bool is_deleted_104;
   int cmd_108;
   string lsa_116[11];
   string lsa_120[11];
   string lsa_124[11];
   string lsa_128[11];
   string lsa_132[11];
   string lsa_136[11];
   string lsa_140[11];
   string lsa_144[11];
   string lsa_148[11];
   string lsa_152[11];
   string lsa_156[5];
   string lsa_160[5];
   gi_1076 = TRUE;
   while (IsExpertEnabled() == TRUE && gi_1076 == TRUE) 
   {
      if (gi_1080 == FALSE) gi_1080 = TRUE;
      else gi_1080 = FALSE;
      if (IsTesting() == FALSE) gi_1076 = TRUE;
      else gi_1076 = FALSE;
      if (IsTesting() == FALSE) 
      {
         if (gi_528 == TRUE) 
         {
            deinit();
            return;
         }
      }
      g_count_1084++;
      if (g_count_1084 >= 9000) g_count_1084 = 0;
      Comment(g_count_1084);
      Accunt_number = AccountNumber();
      gd_868 = AccountBalance() - Bonus;
      gd_876 = AccountFreeMargin() - Bonus;
      gd_884 = 100 - 100.0 * gd_876 / gd_868;
      if (gd_876 < 0.0) gd_884 = 100;
      gd_900 = gd_868 / 100.0 * FreeBalanсe;
      gd_892 = gd_876 / 100.0 * FreeBalanсe;
      gd_908 = 100 - 100.0 * gd_892 / gd_900;
      if (gd_892 < 0.0) gd_908 = 100;
      
      gd_796 = 0;    
      hist_total_0 = OrdersHistoryTotal();
      for (int pos_4 = 0; pos_4 < hist_total_0; pos_4++) 
      {
         if (OrderSelect(pos_4, SELECT_BY_POS, MODE_HISTORY)) 
         {
            if (gi_660 > 0) 
            {
               if (!(OrderMagicNumber() == gia_632[1] || OrderMagicNumber() == gia_632[2] || OrderMagicNumber() == gia_632[3] || OrderMagicNumber() == gia_632[4] || OrderMagicNumber() == gia_632[5] ||
                  OrderMagicNumber() == gia_632[6] || OrderMagicNumber() == gia_632[7] || OrderMagicNumber() == gia_632[8] || OrderMagicNumber() == gia_632[9] || OrderMagicNumber() == gia_632[10])) continue;
               if (gi_660 >= OrderCloseTime()) continue;
               gd_796 = gd_796 + OrderProfit() + OrderCommission() + OrderSwap();
               continue;
            }
            gd_796 = 0;
         }
      }
      if (IsTesting() == FALSE) 
      {
         gi_712++;
         if (gi_712 > 10) gi_712 = 1;
      } 
      else 
      {
         if (Symbol() == gsa_664[1]) gi_712 = 1;
         if (Symbol() == gsa_664[2]) gi_712 = 2;
         if (Symbol() == gsa_664[3]) gi_712 = 3;
         if (Symbol() == gsa_664[4]) gi_712 = 4;
         if (Symbol() == gsa_664[5]) gi_712 = 5;
         if (Symbol() == gsa_664[6]) gi_712 = 6;
         if (Symbol() == gsa_664[7]) gi_712 = 7;
         if (Symbol() == gsa_664[8]) gi_712 = 8;
         if (Symbol() == gsa_664[9]) gi_712 = 9;
         if (Symbol() == gsa_664[10]) gi_712 = 10;
         for (int li_8 = 1; li_8 <= 10; li_8++) gba_540[li_8] = 0;
         gba_540[gi_712] = 1;
      }
      gda_1072[gi_712] = MarketInfo(gsa_664[gi_712], MODE_BID);
      if (gda_1072[gi_712] != gda_1068[gi_712]) 
      {
         gda_1068[gi_712] = gda_1072[gi_712];
         RefreshRates();
         gda_936[gi_712] = MarketInfo(gsa_664[gi_712], MODE_MINLOT);
         gda_940[gi_712] = MarketInfo(gsa_664[gi_712], MODE_MAXLOT);
         gda_932[gi_712] = MarketInfo(gsa_664[gi_712], MODE_MARGINREQUIRED);
         gda_928[gi_712] = MarketInfo(gsa_664[gi_712], MODE_LOTSTEP);
         gia_924[gi_712] = MarketInfo(gsa_664[gi_712], MODE_SPREAD);
         gia_684[gi_712] = MarketInfo(gsa_664[gi_712], MODE_DIGITS);
         gia_672[gi_712] = MarketInfo(gsa_664[gi_712], MODE_STOPLEVEL);
         gda_948[gi_712] = MarketInfo(gsa_664[gi_712], MODE_LOW);
         gda_952[gi_712] = MarketInfo(gsa_664[gi_712], MODE_HIGH);
         gda_612[gi_712] = 0;
         gda_616[gi_712] = 0;
         gda_620[gi_712] = 0;
         gda_624[gi_712] = 0;
         gda_628[gi_712] = 0;
         gd_592 = filter;
         if (gd_592 < 10.0) gd_592 = 10;
         if (gd_592 > 10000.0) gd_592 = 10000;
         gia_604[gi_712]++;
         if (gia_604[gi_712] > gd_592) gia_604[gi_712] = gd_592;
         gda_612[gi_712] = 100 / gd_592 * gia_604[gi_712];
         gda_608[gi_712][0] = MarketInfo(gsa_664[gi_712], MODE_BID);
         for (int li_12 = gd_592; li_12 >= 0; li_12--) gda_608[gi_712][li_12 + 1] = gda_608[gi_712][li_12];
         for (int li_16 = 1; li_16 <= gd_592; li_16++) gda_616[gi_712] += gda_608[gi_712][li_16];
         gda_620[gi_712] = gda_616[gi_712] / gd_592;
         if (gda_620[gi_712] < gda_608[gi_712][0]) gda_624[gi_712] = 10.0 * ((gda_608[gi_712][0] - gda_620[gi_712]) / MarketInfo(gsa_664[gi_712], MODE_POINT));
         if (gda_620[gi_712] > gda_608[gi_712][0]) gda_628[gi_712] = 10.0 * ((gda_620[gi_712] - gda_608[gi_712][0]) / MarketInfo(gsa_664[gi_712], MODE_POINT));
         gda_624[gi_712] = gda_624[gi_712] - dam;
         if (gda_624[gi_712] < 0.0) gda_624[gi_712] = 0;
         gda_628[gi_712] = gda_628[gi_712] - dam;
         if (gda_628[gi_712] < 0.0) gda_628[gi_712] = 0;
         if (gda_612[gi_712] < 100.0) 
         {
            gda_624[gi_712] = 0;
            gda_628[gi_712] = 0;
         }
         gda_784[gi_712] = 0;
         gda_788[gi_712] = 0;
         gda_792[gi_712] = 0;
         hist_total_20 = OrdersHistoryTotal();
         for (int pos_24 = 0; pos_24 < hist_total_20; pos_24++) 
         {
            if (OrderSelect(pos_24, SELECT_BY_POS, MODE_HISTORY)) 
            {
               if (gia_640[gi_712] > 0) 
               {
                  if (!(OrderMagicNumber() == gia_632[gi_712] || OrderMagicNumber() == gia_636[gi_712])) continue;
                  if (gia_640[gi_712] >= OrderCloseTime()) continue;
                  if (OrderType() == OP_BUY || OrderType() == OP_SELL) gda_784[gi_712] += OrderProfit() + OrderCommission() + OrderSwap();
                  if (OrderType() == OP_BUY) gda_788[gi_712] += OrderProfit() + OrderCommission() + OrderSwap();
                  if (OrderType() != OP_SELL) continue;
                  gda_792[gi_712] += OrderProfit() + OrderCommission() + OrderSwap();
                  continue;
               }
               gda_784[gi_712] = 0;
               gda_788[gi_712] = 0;
               gda_792[gi_712] = 0;
            }
         }
         gia_720[gi_712] = 0;
         gia_732[gi_712] = 0;
         gia_736[gi_712] = 0;
         gia_740[gi_712] = 0;
         gia_744[gi_712] = 0;
         gia_748[gi_712] = 0;
         gia_752[gi_712] = 0;
         gia_716[gi_712] = 0;
         if (OrdersTotal() > 0) 
         {
            for (int pos_28 = 0; pos_28 <= OrdersTotal(); pos_28++) 
            {
               if (OrderSelect(pos_28, SELECT_BY_POS) == TRUE) 
               {
                  if (OrderMagicNumber() == gia_632[gi_712] || OrderMagicNumber() == gia_636[gi_712]) 
                  {
                     if (OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP) 
                     {
                        gia_720[gi_712]++;
                        gia_724[gi_712]++;
                        gia_732[gi_712]++;
                        gia_736[gi_712]++;
                     }
                     if (OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) 
                     {
                        gia_720[gi_712]++;
                        gia_728[gi_712]++;
                        gia_732[gi_712]++;
                        gia_740[gi_712]++;
                     }
                     if (OrderType() == OP_BUY) 
                     {
                        gia_720[gi_712]++;
                        gia_724[gi_712]++;
                        gia_744[gi_712]++;
                        gia_748[gi_712]++;
                     }
                     if (OrderType() == OP_SELL) 
                     {
                        gia_720[gi_712]++;
                        gia_728[gi_712]++;
                        gia_744[gi_712]++;
                        gia_752[gi_712]++;
                     }
                  }
                  if (OrderMagicNumber() == gia_636[gi_712]) 
                  {
                     if (OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP) gia_716[gi_712]++;
                     if (OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) gia_716[gi_712]++;
                     if (OrderType() == OP_BUY) gia_716[gi_712]++;
                     if (OrderType() == OP_SELL) gia_716[gi_712]++;
                  }
               }
            }
            gda_804[gi_712] = 0;
            gda_808[gi_712] = 0;
            gda_812[gi_712] = 0;
            gda_816[gi_712] = 0;
            gda_824[gi_712] = 0;
            gda_820[gi_712] = 0;
            gda_828[gi_712] = 0;
            gia_972[gi_712] = 0;
            gia_956[gi_712] = 0;
            for (int pos_32 = 0; pos_32 <= OrdersTotal(); pos_32++) 
            {
               if (OrderSelect(pos_32, SELECT_BY_POS, MODE_TRADES)) 
               {
                  if (gia_956[gi_712] < OrderOpenTime() && OrderMagicNumber() == gia_632[gi_712] || OrderMagicNumber() == gia_636[gi_712]) 
                  {
                     gia_956[gi_712] = OrderOpenTime();
                     gia_960[gi_712] = OrderTicket();
                     gda_964[gi_712] = OrderOpenPrice();
                     gda_968[gi_712] = OrderLots();
                     if (OrderType() == OP_BUYSTOP || OrderType() == OP_BUYLIMIT) gia_972[gi_712] = 11;
                     if (OrderType() == OP_BUY) gia_972[gi_712] = 111;
                     if (OrderType() == OP_SELLSTOP || OrderType() == OP_SELLLIMIT) gia_972[gi_712] = 33;
                     if (OrderType() == OP_SELL) gia_972[gi_712] = 333;
                  }
                  if (OrderMagicNumber() == gia_632[gi_712] || OrderMagicNumber() == gia_636[gi_712]) 
                  {
                     if (OrderType() == OP_BUY || OrderType() == OP_SELL) gda_804[gi_712] += OrderProfit() + OrderCommission() + OrderSwap();
                     if (OrderType() == OP_BUY) gda_808[gi_712] += OrderProfit() + OrderCommission() + OrderSwap();
                     if (OrderType() == OP_SELL) gda_812[gi_712] += OrderProfit() + OrderCommission() + OrderSwap();
                     if (OrderType() == OP_BUY) gda_816[gi_712] += OrderLots();
                     if (OrderType() == OP_SELL) gda_824[gi_712] += OrderLots();
                     if (OrderType() == OP_BUY || OrderType() == OP_BUYSTOP) gda_820[gi_712] += OrderLots();
                     if (OrderType() == OP_SELL || OrderType() == OP_SELLSTOP) gda_828[gi_712] += OrderLots();
                  }
               }
            }
         }
         gda_836[gi_712] = Lots_min;
         if (gda_836[gi_712] < gda_936[gi_712]) gda_836[gi_712] = gda_936[gi_712];
         if (gda_836[gi_712] > gda_940[gi_712]) gda_836[gi_712] = gda_940[gi_712];
         if (Lots_auto == FALSE) gda_944[gi_712] = gda_836[gi_712];
         else 
         {
            gda_944[gi_712] = MathFloor(gd_900 * (Risk / 1000.0) / gda_932[gi_712] / gda_928[gi_712]) * gda_928[gi_712];
            if (gda_944[gi_712] > Lots_max) gda_944[gi_712] = Lots_max;
            if (gda_944[gi_712] < gda_936[gi_712]) gda_944[gi_712] = gda_936[gi_712];
            if (gda_944[gi_712] > gda_940[gi_712]) gda_944[gi_712] = gda_940[gi_712];
         }
         if (gia_720[gi_712] == 0) gda_832[gi_712] = gda_944[gi_712];
         if (gda_832[gi_712] == 0.0) gda_832[gi_712] = gda_944[gi_712];
         if (gda_824[gi_712] > gda_816[gi_712]) gda_844[gi_712] = gda_824[gi_712] / 100.0 * StepCompLot + gda_824[gi_712] - gda_816[gi_712];
         if (gda_816[gi_712] > gda_824[gi_712]) gda_848[gi_712] = gda_816[gi_712] / 100.0 * StepCompLot + gda_816[gi_712] - gda_824[gi_712];
         gia_756[gi_712] = 0;
         if (gia_720[gi_712] > 0) 
         {
            if (gia_972[gi_712] == 111) gia_756[gi_712] = (gda_964[gi_712] - MarketInfo(gsa_664[gi_712], MODE_BID)) / MarketInfo(gsa_664[gi_712], MODE_POINT);
            if (gia_972[gi_712] == 333) gia_756[gi_712] = (MarketInfo(gsa_664[gi_712], MODE_ASK) - gda_964[gi_712]) / MarketInfo(gsa_664[gi_712], MODE_POINT);
            gia_760[gi_712] = 0;
            if (gia_972[gi_712] == 11) gia_760[gi_712] = (gda_964[gi_712] - MarketInfo(gsa_664[gi_712], MODE_BID)) / MarketInfo(gsa_664[gi_712], MODE_POINT);
            if (gia_972[gi_712] == 33) gia_760[gi_712] = (MarketInfo(gsa_664[gi_712], MODE_ASK) - gda_964[gi_712]) / MarketInfo(gsa_664[gi_712], MODE_POINT);
         }
         gda_768[gi_712] = Prof * (gda_816[gi_712] + gda_824[gi_712]) * gda_932[gi_712] / 100.0;
         gda_772[gi_712] = gda_804[gi_712] + gda_784[gi_712];
         if (ProfTrall == FALSE)
            if (gda_772[gi_712] > gda_768[gi_712]) gba_688[gi_712] = 1;
         if (ProfTrall == TRUE) 
         {
            if (gda_772[gi_712] > gda_768[gi_712]) 
            {
               gba_520[gi_712] = 1;
               gba_524[gi_712] = 1;
            }
            if (gba_520[gi_712] == 1) 
            {
               if (gia_736[gi_712] > 0) gba_700[gi_712] = 1;
               if (gia_740[gi_712] > 0) gba_704[gi_712] = 1;
            }
         }
         if (gia_720[gi_712] == 0) gba_688[gi_712] = 0;
         if (gia_724[gi_712] == 0) gba_692[gi_712] = 0;
         if (gia_728[gi_712] == 0) gba_696[gi_712] = 0;
         gda_916[gi_712] = -1.0 * (100.0 * gda_772[gi_712] / gd_900);
         
         if (gd_908 >= CloseLosk) gi_548 = TRUE;
         if (gd_908 <= OpenLosk) gi_548 = FALSE;
         if (gda_916[gi_712] >= IndCloseLosk) gba_556[gi_712] = 1;
         if (gda_916[gi_712] <= IndOpenLosk) gba_556[gi_712] = 0;
         if (gi_548 == TRUE || gba_556[gi_712] == 1) 
         {
            if (gia_736[gi_712] > 0) gba_700[gi_712] = 1;
            if (gia_740[gi_712] > 0) gba_704[gi_712] = 1;
         }
         if (gba_688[gi_712] == 1) 
         {
            while (IsTradeContextBusy() == TRUE) Sleep(gi_544);
            for (int pos_36 = OrdersTotal() - 1; pos_36 >= 0; pos_36--) 
            {
               OrderSelect(pos_36, SELECT_BY_POS);
               if (OrderMagicNumber() == gia_632[gi_712] || OrderMagicNumber() == gia_636[gi_712]) 
               {
                  cmd_40 = OrderType();
                  li_44 = FALSE;
                  switch (cmd_40) 
                  {
                  case OP_BUY:
                     li_44 = OrderClose(OrderTicket(), OrderLots(), MarketInfo(gsa_664[gi_712], MODE_BID), Slip);
                     break;
                  case OP_SELL:
                     li_44 = OrderClose(OrderTicket(), OrderLots(), MarketInfo(gsa_664[gi_712], MODE_ASK), Slip);
                     break;
                  case OP_BUYLIMIT:
                  case OP_BUYSTOP:
                  case OP_SELLLIMIT:
                  case OP_SELLSTOP:
                     li_44 = OrderDelete(OrderTicket());
                  }
                  if (li_44 == 0 && InfoError == TRUE) 
                  {
                     Alert("Ордер ", OrderTicket(), " Код ошибки: ", GetLastError());
                     Sleep(1000);
                  }
               }
            }
         }
         if (gba_524[gi_712] == 1) 
         {
            slippage_52 = 2;
            for (int pos_76 = OrdersTotal() - 1; pos_76 >= 0; pos_76--) 
            {
               if (!(OrderSelect(pos_76, SELECT_BY_POS, MODE_TRADES))) break;
               if (OrderType() == OP_BUY) 
               {
                  if (OrderMagicNumber() == gia_632[gi_712] || OrderMagicNumber() == gia_636[gi_712]) 
                  {
                     point_68 = MarketInfo(OrderSymbol(), MODE_POINT);
                     if (point_68 == 0.0) break;
                     li_60 = MathRound(MarketInfo(OrderSymbol(), MODE_BID) / point_68);
                     li_64 = MathRound(OrderOpenPrice() / point_68);
                     if (li_64 - li_60 < 0) continue;
                     OrderClose(OrderTicket(), OrderLots(), li_60 * point_68, slippage_52);
                  }
               }
               if (OrderType() == OP_SELL) 
               {
                  if (OrderMagicNumber() == gia_632[gi_712] || OrderMagicNumber() == gia_636[gi_712]) 
                  {
                     point_68 = MarketInfo(OrderSymbol(), MODE_POINT);
                     if (point_68 == 0.0) break;
                     li_56 = MathRound(MarketInfo(OrderSymbol(), MODE_ASK) / point_68);
                     li_64 = MathRound(OrderOpenPrice() / point_68);
                     if (li_56 - li_64 >= 0) OrderClose(OrderTicket(), OrderLots(), li_56 * point_68, slippage_52);
                  }
               }
            }
         }
         if (gba_700[gi_712] == 1) 
         {
            while (IsTradeContextBusy() == TRUE) Sleep(gi_544);
            for (int pos_80 = OrdersTotal() - 1; pos_80 >= 0; pos_80--) 
            {
               OrderSelect(pos_80, SELECT_BY_POS);
               if (OrderMagicNumber() == gia_632[gi_712] || OrderMagicNumber() == gia_636[gi_712]) 
               {
                  cmd_84 = OrderType();
                  is_deleted_88 = FALSE;
                  cmd_92 = cmd_84;
                  if (cmd_92 != OP_BUYLIMIT) 
                  {
                     if (cmd_92 == OP_BUYSTOP) 
                     {
                     }
                  }
                  is_deleted_88 = OrderDelete(OrderTicket());
                  if (is_deleted_88 == 0 && InfoError == TRUE) 
                  {
                     Alert("Ордер ", OrderTicket(), " Код ошибки: ", GetLastError());
                     Sleep(1000);
                  }
               }
            }
         }
         gba_700[gi_712] = 0;
         if (gba_704[gi_712] == 1) 
         {
            while (IsTradeContextBusy() == TRUE) Sleep(gi_544);
            for (int pos_96 = OrdersTotal() - 1; pos_96 >= 0; pos_96--) 
            {
               OrderSelect(pos_96, SELECT_BY_POS);
               if (OrderMagicNumber() == gia_632[gi_712] || OrderMagicNumber() == gia_636[gi_712]) 
               {
                  cmd_100 = OrderType();
                  is_deleted_104 = FALSE;
                  cmd_108 = cmd_100;
                  if (cmd_108 != OP_SELLLIMIT) 
                  {
                     if (cmd_108 == OP_SELLSTOP) 
                     {
                     }
                  }
                  is_deleted_104 = OrderDelete(OrderTicket());
                  if (is_deleted_104 == 0 && InfoError == TRUE) 
                  {
                     Alert("Ордер ", OrderTicket(), " Код ошибки: ", GetLastError());
                     Sleep(1000);
                  }
               }
            }
         }
         gba_704[gi_712] = 0;
         
         if (gia_720[gi_712] == 0) gia_640[gi_712] = 0;
         if (IsTesting() == TRUE && gia_720[gi_712] == 0 && gda_612[gi_712] == 100.0) ObjectsDeleteAll(EMPTY, EMPTY);
         if (gi_548 == TRUE || gba_556[gi_712] == 1) 
         {
            if (gda_824[gi_712] > gda_816[gi_712]) 
            {
               gda_860[gi_712] = gda_824[gi_712] - gda_816[gi_712];
               OrderSend(gsa_664[gi_712], OP_BUY, gda_860[gi_712], MarketInfo(gsa_664[gi_712], MODE_ASK), Slip, 0, 0, gsa_664[gi_712] + "=BloskBay=" + gia_632[gi_712], gia_632[gi_712], 0, Blue);
            }
            if (gda_816[gi_712] > gda_824[gi_712]) 
            {
               gda_864[gi_712] = gda_816[gi_712] - gda_824[gi_712];
               OrderSend(gsa_664[gi_712], OP_SELL, gda_864[gi_712], MarketInfo(gsa_664[gi_712], MODE_BID), Slip, 0, 0, gsa_664[gi_712] + "=BloskSell=" + gia_632[gi_712], gia_632[gi_712], 0, Red);
            }
         }
         if (gia_720[gi_712] == 0) 
         {
            gia_640[gi_712] = 0;
            gba_520[gi_712] = 0;
            gba_524[gi_712] = 0;
         }
         if (gi_548 == FALSE && gba_556[gi_712] == 0) 
         {
            if (gba_688[gi_712] == 0) 
            {
               gia_760[gi_712] = 0;
               if (gia_720[gi_712] == 1) 
               {
                  if (gia_972[gi_712] == 11) 
                  {
                     gia_760[gi_712] = (gda_964[gi_712] - MarketInfo(gsa_664[gi_712], MODE_BID)) / MarketInfo(gsa_664[gi_712], MODE_POINT);
                     if (gia_760[gi_712] > gi_564 + Front) gba_700[gi_712] = 1;
                  }
                  if (gia_972[gi_712] == 33) 
                  {
                     gia_760[gi_712] = (MarketInfo(gsa_664[gi_712], MODE_ASK) - gda_964[gi_712]) / MarketInfo(gsa_664[gi_712], MODE_POINT);
                     if (gia_760[gi_712] > gi_564 + Front) gba_704[gi_712] = 1;
                  }
               }
               if (Run == TRUE && gba_540[gi_712] == 1 && gia_720[gi_712] == 0) 
               {
                  if (gia_640[gi_712] == 0) gia_640[gi_712] = TimeCurrent();
                  if (gda_624[gi_712] > 0.0) 
                  {
                     OrderSend(gsa_664[gi_712], OP_BUYSTOP, gda_832[gi_712], MarketInfo(gsa_664[gi_712], MODE_ASK) + Front * MarketInfo(gsa_664[gi_712], MODE_POINT), 3, 0, 0, gsa_664[gi_712] +
                        "=1=Bay=" + gia_632[gi_712], gia_632[gi_712], 0);
                  }
                  if (gda_628[gi_712] > 0.0) 
                  {
                     OrderSend(gsa_664[gi_712], OP_SELLSTOP, gda_832[gi_712], MarketInfo(gsa_664[gi_712], MODE_BID) - Front * MarketInfo(gsa_664[gi_712], MODE_POINT), 3, 0, 0, gsa_664[gi_712] +
                        "=1=Sell=" + gia_632[gi_712], gia_632[gi_712], 0);
                  }
               }
               if (gba_520[gi_712] == 0) 
               {
                  if (gia_720[gi_712] > 0 && gia_732[gi_712] == 0) 
                  {
                     if (gia_972[gi_712] == 333) 
                     {
                        OrderSend(gsa_664[gi_712], OP_BUYSTOP, gda_844[gi_712], MarketInfo(gsa_664[gi_712], MODE_ASK) + (Delta + DeltaPlus * gia_716[gi_712]) * MarketInfo(gsa_664[gi_712],
                           MODE_POINT), 3, 0, 0, gsa_664[gi_712] + "=" + ((gia_716[gi_712] + 1)) + "=BayComp=" + gia_636[gi_712], gia_636[gi_712], 0);
                     }
                     if (gia_972[gi_712] == 111) 
                     {
                        OrderSend(gsa_664[gi_712], OP_SELLSTOP, gda_848[gi_712], MarketInfo(gsa_664[gi_712], MODE_BID) - (Delta + DeltaPlus * gia_716[gi_712]) * MarketInfo(gsa_664[gi_712],
                           MODE_POINT), 3, 0, 0, gsa_664[gi_712] + "=" + ((gia_716[gi_712] + 1)) + "=SellComp=" + gia_636[gi_712], gia_636[gi_712], 0);
                     }
                  }
               }
            }
         }
         gia_644[gi_712] = TimeCurrent() - gia_640[gi_712];
         if (gia_640[gi_712] == 0) gia_644[gi_712] = 0;
         gia_648[gi_712] = MathFloor(gia_644[gi_712] - 60.0 * MathFloor(gia_644[gi_712] / 60));
         gia_656[gi_712] = MathFloor(MathFloor(gia_644[gi_712] / 60) / 60.0);
         gia_652[gi_712] = MathFloor(gia_644[gi_712] / 60) - 60 * gia_656[gi_712];
         
         if (gba_520[gi_712] == 1 && gi_548 == FALSE || gba_556[gi_712] == 0) 
         {
            for (int li_112 = 1; li_112 <= OrdersTotal(); li_112++) 
            {
               if (OrderSelect(li_112 - 1, SELECT_BY_POS, MODE_TRADES)) 
               {
                  if (OrderMagicNumber() == gia_632[gi_712] || OrderMagicNumber() == gia_636[gi_712]) 
                  {
                     while (IsTradeContextBusy() == TRUE) Sleep(gi_544);
                     gi_708 = Trall;
                     f0_3();
                  }
               }
            }
         }
      }
      if (Info == TRUE) 
      {
         lsa_116[0] = "== EUR_USD ==";
         lsa_116[1] = "=============";
         lsa_116[2] = "Готовность   " + DoubleToStr(gda_612[1], 1) + " %";
         lsa_116[3] = "Тренд ВUY=   " + DoubleToStr(gda_624[1], 0);
         lsa_116[4] = "Тренд SELL=  " + DoubleToStr(gda_628[1], 0);
         lsa_116[5] = "Просадка=    " + DoubleToStr(gda_916[1], 1);
         lsa_116[6] = "Профит=    " + DoubleToStr(gda_768[1], 2);
         lsa_116[7] = "Раб. ордера=   " + DoubleToStr(gda_804[1], 2);
         lsa_116[8] = "Закр. ордера=   " + DoubleToStr(gda_784[1], 2);
         lsa_116[9] = "Лот BUY=   " + DoubleToStr(gda_816[1], 2);
         lsa_116[10] = "Лот SELL=   " + DoubleToStr(gda_824[1], 2);
         lsa_116[11] = "Сессия:   " + gia_656[1] + " час.  " + gia_652[1] + " мин.";
         lsa_120[0] = "== GBP_USD ==";
         lsa_120[1] = "=============";
         lsa_120[2] = "Готовность   " + DoubleToStr(gda_612[2], 1) + " %";
         lsa_120[3] = "Тренд ВUY=   " + DoubleToStr(gda_624[2], 0);
         lsa_120[4] = "Тренд SELL=  " + DoubleToStr(gda_628[2], 0);
         lsa_120[5] = "Просадка=    " + DoubleToStr(gda_916[2], 1);
         lsa_120[6] = "Профит=    " + DoubleToStr(gda_768[2], 2);
         lsa_120[7] = "Раб. ордера=   " + DoubleToStr(gda_804[2], 2);
         lsa_120[8] = "Закр. ордера=   " + DoubleToStr(gda_784[2], 2);
         lsa_120[9] = "Лот BUY=   " + DoubleToStr(gda_816[2], 2);
         lsa_120[10] = "Лот SELL=   " + DoubleToStr(gda_824[2], 2);
         lsa_120[11] = "Сессия:   " + gia_656[2] + " час.  " + gia_652[2] + " мин.";
         lsa_124[0] = "== USD_JPY ==";
         lsa_124[1] = "=============";
         lsa_124[2] = "Готовность   " + DoubleToStr(gda_612[3], 1) + " %";
         lsa_124[3] = "Тренд ВUY=   " + DoubleToStr(gda_624[3], 0);
         lsa_124[4] = "Тренд SELL=  " + DoubleToStr(gda_628[3], 0);
         lsa_124[5] = "Просадка=    " + DoubleToStr(gda_916[3], 1);
         lsa_124[6] = "Профит=    " + DoubleToStr(gda_768[3], 2);
         lsa_124[7] = "Раб. ордера=   " + DoubleToStr(gda_804[3], 2);
         lsa_124[8] = "Закр. ордера=   " + DoubleToStr(gda_784[3], 2);
         lsa_124[9] = "Лот BUY=   " + DoubleToStr(gda_816[3], 2);
         lsa_124[10] = "Лот SELL=   " + DoubleToStr(gda_824[3], 2);
         lsa_124[11] = "Сессия:   " + gia_656[3] + " час.  " + gia_652[3] + " мин.";
         lsa_128[0] = "== USD_CHF ==";
         lsa_128[1] = "=============";
         lsa_128[2] = "Готовность   " + DoubleToStr(gda_612[4], 1) + " %";
         lsa_128[3] = "Тренд ВUY=   " + DoubleToStr(gda_624[4], 0);
         lsa_128[4] = "Тренд SELL=  " + DoubleToStr(gda_628[4], 0);
         lsa_128[5] = "Просадка=    " + DoubleToStr(gda_916[4], 1);
         lsa_128[6] = "Профит=    " + DoubleToStr(gda_768[4], 2);
         lsa_128[7] = "Раб. ордера=   " + DoubleToStr(gda_804[4], 2);
         lsa_128[8] = "Закр. ордера=   " + DoubleToStr(gda_784[4], 2);
         lsa_128[9] = "Лот BUY=   " + DoubleToStr(gda_816[4], 2);
         lsa_128[10] = "Лот SELL=   " + DoubleToStr(gda_824[4], 2);
         lsa_128[11] = "Сессия:   " + gia_656[4] + " час.  " + gia_652[4] + " мин.";
         lsa_132[0] = "== USD_CAD ==";
         lsa_132[1] = "=============";
         lsa_132[2] = "Готовность   " + DoubleToStr(gda_612[5], 1) + " %";
         lsa_132[3] = "Тренд ВUY=   " + DoubleToStr(gda_624[5], 0);
         lsa_132[4] = "Тренд SELL=  " + DoubleToStr(gda_628[5], 0);
         lsa_132[5] = "Просадка=    " + DoubleToStr(gda_916[5], 1);
         lsa_132[6] = "Профит=    " + DoubleToStr(gda_768[5], 2);
         lsa_132[7] = "Раб. ордера=   " + DoubleToStr(gda_804[5], 2);
         lsa_132[8] = "Закр. ордера=   " + DoubleToStr(gda_784[5], 2);
         lsa_132[9] = "Лот BUY=   " + DoubleToStr(gda_816[5], 2);
         lsa_132[10] = "Лот SELL=   " + DoubleToStr(gda_824[5], 2);
         lsa_132[11] = "Сессия:   " + gia_656[5] + " час.  " + gia_652[5] + " мин.";
         lsa_136[0] = "== AUD_USD ==";
         lsa_136[1] = "=============";
         lsa_136[2] = "Готовность   " + DoubleToStr(gda_612[6], 1) + " %";
         lsa_136[3] = "Тренд ВUY=   " + DoubleToStr(gda_624[6], 0);
         lsa_136[4] = "Тренд SELL=  " + DoubleToStr(gda_628[6], 0);
         lsa_136[5] = "Просадка=    " + DoubleToStr(gda_916[6], 1);
         lsa_136[6] = "Профит=    " + DoubleToStr(gda_768[6], 2);
         lsa_136[7] = "Раб. ордера=   " + DoubleToStr(gda_804[6], 2);
         lsa_136[8] = "Закр. ордера=   " + DoubleToStr(gda_784[6], 2);
         lsa_136[9] = "Лот BUY=   " + DoubleToStr(gda_816[6], 2);
         lsa_136[10] = "Лот SELL=   " + DoubleToStr(gda_824[6], 2);
         lsa_136[11] = "Сессия:   " + gia_656[6] + " час.  " + gia_652[6] + " мин.";
         lsa_140[0] = "== NZD_USD ==";
         lsa_140[1] = "=============";
         lsa_140[2] = "Готовность   " + DoubleToStr(gda_612[7], 1) + " %";
         lsa_140[3] = "Тренд ВUY=   " + DoubleToStr(gda_624[7], 0);
         lsa_140[4] = "Тренд SELL=  " + DoubleToStr(gda_628[7], 0);
         lsa_140[5] = "Просадка=    " + DoubleToStr(gda_916[7], 1);
         lsa_140[6] = "Профит=    " + DoubleToStr(gda_768[7], 2);
         lsa_140[7] = "Раб. ордера=   " + DoubleToStr(gda_804[7], 2);
         lsa_140[8] = "Закр. ордера=   " + DoubleToStr(gda_784[7], 2);
         lsa_140[9] = "Лот BUY=   " + DoubleToStr(gda_816[7], 2);
         lsa_140[10] = "Лот SELL=   " + DoubleToStr(gda_824[7], 2);
         lsa_140[11] = "Сессия:   " + gia_656[7] + " час.  " + gia_652[7] + " мин.";
         lsa_144[0] = "== EUR_JPY ==";
         lsa_144[1] = "=============";
         lsa_144[2] = "Готовность   " + DoubleToStr(gda_612[8], 1) + " %";
         lsa_144[3] = "Тренд ВUY=   " + DoubleToStr(gda_624[8], 0);
         lsa_144[4] = "Тренд SELL=  " + DoubleToStr(gda_628[8], 0);
         lsa_144[5] = "Просадка=    " + DoubleToStr(gda_916[8], 1);
         lsa_144[6] = "Профит=    " + DoubleToStr(gda_768[8], 2);
         lsa_144[7] = "Раб. ордера=   " + DoubleToStr(gda_804[8], 2);
         lsa_144[8] = "Закр. ордера=   " + DoubleToStr(gda_784[8], 2);
         lsa_144[9] = "Лот BUY=   " + DoubleToStr(gda_816[8], 2);
         lsa_144[10] = "Лот SELL=   " + DoubleToStr(gda_824[8], 2);
         lsa_144[11] = "Сессия:   " + gia_656[8] + " час.  " + gia_652[8] + " мин.";
         lsa_148[0] = "== EUR_CHF ==";
         lsa_148[1] = "=============";
         lsa_148[2] = "Готовность   " + DoubleToStr(gda_612[9], 1) + " %";
         lsa_148[3] = "Тренд ВUY=   " + DoubleToStr(gda_624[9], 0);
         lsa_148[4] = "Тренд SELL=  " + DoubleToStr(gda_628[9], 0);
         lsa_148[5] = "Просадка=    " + DoubleToStr(gda_916[9], 1);
         lsa_148[6] = "Профит=    " + DoubleToStr(gda_768[9], 2);
         lsa_148[7] = "Раб. ордера=   " + DoubleToStr(gda_804[9], 2);
         lsa_148[8] = "Закр. ордера=   " + DoubleToStr(gda_784[9], 2);
         lsa_148[9] = "Лот BUY=   " + DoubleToStr(gda_816[9], 2);
         lsa_148[10] = "Лот SELL=   " + DoubleToStr(gda_824[9], 2);
         lsa_148[11] = "Сессия:   " + gia_656[9] + " час.  " + gia_652[9] + " мин.";
         lsa_152[0] = "== EUR_GBP ==";
         lsa_152[1] = "=============";
         lsa_152[2] = "Готовность   " + DoubleToStr(gda_612[10], 1) + " %";
         lsa_152[3] = "Тренд ВUY=   " + DoubleToStr(gda_624[10], 0);
         lsa_152[4] = "Тренд SELL=  " + DoubleToStr(gda_628[10], 0);
         lsa_152[5] = "Просадка=    " + DoubleToStr(gda_916[10], 1);
         lsa_152[6] = "Профит=    " + DoubleToStr(gda_768[10], 2);
         lsa_152[7] = "Раб. ордера=   " + DoubleToStr(gda_804[10], 2);
         lsa_152[8] = "Закр. ордера=   " + DoubleToStr(gda_784[10], 2);
         lsa_152[9] = "Лот BUY=   " + DoubleToStr(gda_816[10], 2);
         lsa_152[10] = "Лот SELL=   " + DoubleToStr(gda_824[10], 2);
         lsa_152[11] = "Сессия:   " + gia_656[10] + " час.  " + gia_652[10] + " мин.";
         lsa_156[0] = Hour() + "  час.  " + Minute() + "   мин.    " + gsa_1016[DayOfWeek()] + ",  " + Day() + "  " + gsa_1012[Month()] + " " + Year() + " год";
         lsa_156[1] = "Счет №   " + Accunt_number;
         lsa_156[2] = "Сканируется валютная пара    " + gsa_664[gi_712];
         lsa_156[3] = "Всего средств на счете=  " + DoubleToStr(gd_868, 2);
         lsa_156[4] = "Всего средств свободно=    " + DoubleToStr(gd_876, 2);
         lsa_156[5] = "Просадка по счету=   " + DoubleToStr(gd_884, 2) + " %";
         lsa_160[0] = "   ";
         lsa_160[1] = "Размер бонуса=    " + Bonus + " $";
         lsa_160[2] = "Задействовать средств   " + FreeBalanсe + " %";
         lsa_160[3] = "Cредства советника=   " + DoubleToStr(gd_900, 2);
         lsa_160[4] = "Свободные средства советника=   " + DoubleToStr(gd_892, 2);
         lsa_160[5] = "Просадка по средствам советника=   " + DoubleToStr(gd_908, 2) + " %";
         
         for (int index_164 = 0; index_164 <= 11; index_164++) 
         {
            if (ObjectFind(gsa_1020[index_164]) == -1) 
            {
               ObjectCreate(gsa_1020[index_164], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1020[index_164], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1020[index_164], OBJPROP_XDISTANCE, 50);
               ObjectSet(gsa_1020[index_164], OBJPROP_YDISTANCE, 15 * index_164 + 150);
            }
            if (index_164 < 2) 
            {
               if (gba_540[1] == 0) g_color_532 = g_color_504;
               else 
               {
                  if (gda_612[1] < 99.9) g_color_532 = g_color_512;
                  else g_color_532 = g_color_500;
               }
               if (gi_548 == TRUE || gba_556[1] == 1) g_color_532 = g_color_508;
            }
            if (index_164 >= 2) g_color_532 = g_color_496;
            ObjectSetText(gsa_1020[index_164], lsa_116[index_164], 8, "MS Sans Serif", g_color_532);
         }
         for (int index_168 = 0; index_168 <= 11; index_168++) 
         {
            if (ObjectFind(gsa_1024[index_168]) == -1) 
            {
               ObjectCreate(gsa_1024[index_168], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1024[index_168], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1024[index_168], OBJPROP_XDISTANCE, 250);
               ObjectSet(gsa_1024[index_168], OBJPROP_YDISTANCE, 15 * index_168 + 150);
            }
            if (index_168 < 2) 
            {
               if (gba_540[2] == 0) g_color_532 = g_color_504;
               else 
               {
                  if (gda_612[2] < 99.9) g_color_532 = g_color_512;
                  else g_color_532 = g_color_500;
               }
               if (gi_548 == TRUE || gba_556[2] == 1) g_color_532 = g_color_508;
            }
            if (index_168 >= 2) g_color_532 = g_color_496;
            ObjectSetText(gsa_1024[index_168], lsa_120[index_168], 8, "MS Sans Serif", g_color_532);
         }
         for (int index_172 = 0; index_172 <= 11; index_172++) 
         {
            if (ObjectFind(gsa_1028[index_172]) == -1) 
            {
               ObjectCreate(gsa_1028[index_172], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1028[index_172], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1028[index_172], OBJPROP_XDISTANCE, 450);
               ObjectSet(gsa_1028[index_172], OBJPROP_YDISTANCE, 15 * index_172 + 150);
            }
            if (index_172 < 2) 
            {
               if (gba_540[3] == 0) g_color_532 = g_color_504;
               else 
               {
                  if (gda_612[3] < 99.9) g_color_532 = g_color_512;
                  else g_color_532 = g_color_500;
               }
               if (gi_548 == TRUE || gba_556[3] == 1) g_color_532 = g_color_508;
            }
            if (index_172 >= 2) g_color_532 = g_color_496;
            ObjectSetText(gsa_1028[index_172], lsa_124[index_172], 8, "MS Sans Serif", g_color_532);
         }
         for (int index_176 = 0; index_176 <= 11; index_176++) 
         {
            if (ObjectFind(gsa_1032[index_176]) == -1) 
            {
               ObjectCreate(gsa_1032[index_176], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1032[index_176], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1032[index_176], OBJPROP_XDISTANCE, 650);
               ObjectSet(gsa_1032[index_176], OBJPROP_YDISTANCE, 15 * index_176 + 150);
            }
            if (index_176 < 2) 
            {
               if (gba_540[4] == 0) g_color_532 = g_color_504;
               else 
               {
                  if (gda_612[4] < 99.9) g_color_532 = g_color_512;
                  else g_color_532 = g_color_500;
               }
               if (gi_548 == TRUE || gba_556[4] == 1) g_color_532 = g_color_508;
            }
            if (index_176 >= 2) g_color_532 = g_color_496;
            ObjectSetText(gsa_1032[index_176], lsa_128[index_176], 8, "MS Sans Serif", g_color_532);
         }
         for (int index_180 = 0; index_180 <= 11; index_180++) 
         {
            if (ObjectFind(gsa_1036[index_180]) == -1) 
            {
               ObjectCreate(gsa_1036[index_180], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1036[index_180], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1036[index_180], OBJPROP_XDISTANCE, 850);
               ObjectSet(gsa_1036[index_180], OBJPROP_YDISTANCE, 15 * index_180 + 150);
            }
            if (index_180 < 2) 
            {
               if (gba_540[5] == 0) g_color_532 = g_color_504;
               else 
               {
                  if (gda_612[5] < 99.9) g_color_532 = g_color_512;
                  else g_color_532 = g_color_500;
               }
               if (gi_548 == TRUE || gba_556[5] == 1) g_color_532 = g_color_508;
            }
            if (index_180 >= 2) g_color_532 = g_color_496;
            ObjectSetText(gsa_1036[index_180], lsa_132[index_180], 8, "MS Sans Serif", g_color_532);
         }
         for (int index_184 = 0; index_184 <= 11; index_184++) 
         {
            if (ObjectFind(gsa_1040[index_184]) == -1) 
            {
               ObjectCreate(gsa_1040[index_184], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1040[index_184], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1040[index_184], OBJPROP_XDISTANCE, 50);
               ObjectSet(gsa_1040[index_184], OBJPROP_YDISTANCE, 15 * index_184 + 370);
            }
            if (index_184 < 2) 
            {
               if (gba_540[6] == 0) g_color_532 = g_color_504;
               else 
               {
                  if (gda_612[6] < 99.9) g_color_532 = g_color_512;
                  else g_color_532 = g_color_500;
               }
               if (gi_548 == TRUE || gba_556[6] == 1) g_color_532 = g_color_508;
            }
            if (index_184 >= 2) g_color_532 = g_color_496;
            ObjectSetText(gsa_1040[index_184], lsa_136[index_184], 8, "MS Sans Serif", g_color_532);
         }
         for (int index_188 = 0; index_188 <= 11; index_188++) 
         {
            if (ObjectFind(gsa_1044[index_188]) == -1) 
            {
               ObjectCreate(gsa_1044[index_188], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1044[index_188], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1044[index_188], OBJPROP_XDISTANCE, 250);
               ObjectSet(gsa_1044[index_188], OBJPROP_YDISTANCE, 15 * index_188 + 370);
            }
            if (index_188 < 2) 
            {
               if (gba_540[7] == 0) g_color_532 = g_color_504;
               else 
               {
                  if (gda_612[7] < 99.9) g_color_532 = g_color_512;
                  else g_color_532 = g_color_500;
               }
               if (gi_548 == TRUE || gba_556[7] == 1) g_color_532 = g_color_508;
            }
            if (index_188 >= 2) g_color_532 = g_color_496;
            ObjectSetText(gsa_1044[index_188], lsa_140[index_188], 8, "MS Sans Serif", g_color_532);
         }
         for (int index_192 = 0; index_192 <= 11; index_192++) 
         {
            if (ObjectFind(gsa_1048[index_192]) == -1) 
            {
               ObjectCreate(gsa_1048[index_192], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1048[index_192], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1048[index_192], OBJPROP_XDISTANCE, 450);
               ObjectSet(gsa_1048[index_192], OBJPROP_YDISTANCE, 15 * index_192 + 370);
            }
            if (index_192 < 2) 
            {
               if (gba_540[8] == 0) g_color_532 = g_color_504;
               else 
               {
                  if (gda_612[8] < 99.9) g_color_532 = g_color_512;
                  else g_color_532 = g_color_500;
               }
               if (gi_548 == TRUE || gba_556[8] == 1) g_color_532 = g_color_508;
            }
            if (index_192 >= 2) g_color_532 = g_color_496;
            ObjectSetText(gsa_1048[index_192], lsa_144[index_192], 8, "MS Sans Serif", g_color_532);
         }
         for (int index_196 = 0; index_196 <= 11; index_196++) 
         {
            if (ObjectFind(gsa_1052[index_196]) == -1) 
            {
               ObjectCreate(gsa_1052[index_196], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1052[index_196], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1052[index_196], OBJPROP_XDISTANCE, 650);
               ObjectSet(gsa_1052[index_196], OBJPROP_YDISTANCE, 15 * index_196 + 370);
            }
            if (index_196 < 2) 
            {
               if (gba_540[9] == 0) g_color_532 = g_color_504;
               else 
               {
                  if (gda_612[9] < 99.9) g_color_532 = g_color_512;
                  else g_color_532 = g_color_500;
               }
               if (gi_548 == TRUE || gba_556[9] == 1) g_color_532 = g_color_508;
            }
            if (index_196 >= 2) g_color_532 = g_color_496;
            ObjectSetText(gsa_1052[index_196], lsa_148[index_196], 8, "MS Sans Serif", g_color_532);
         }
         for (int index_200 = 0; index_200 <= 11; index_200++) 
         {
            if (ObjectFind(gsa_1056[index_200]) == -1) 
            {
               ObjectCreate(gsa_1056[index_200], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1056[index_200], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1056[index_200], OBJPROP_XDISTANCE, 850);
               ObjectSet(gsa_1056[index_200], OBJPROP_YDISTANCE, 15 * index_200 + 370);
            }
            if (index_200 < 2) 
            {
               if (gba_540[10] == 0) g_color_532 = g_color_504;
               else 
               {
                  if (gda_612[10] < 99.9) g_color_532 = g_color_512;
                  else g_color_532 = g_color_500;
               }
               if (gi_548 == TRUE || gba_556[10] == 1) g_color_532 = g_color_508;
            }
            if (index_200 >= 2) g_color_532 = g_color_496;
            ObjectSetText(gsa_1056[index_200], lsa_152[index_200], 8, "MS Sans Serif", g_color_532);
         }
         g_color_532 = g_color_516;
         for (int index_204 = 0; index_204 <= 5; index_204++) 
         {
            if (ObjectFind(gsa_1060[index_204]) == -1) 
            {
               ObjectCreate(gsa_1060[index_204], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1060[index_204], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1060[index_204], OBJPROP_XDISTANCE, 50);
               ObjectSet(gsa_1060[index_204], OBJPROP_YDISTANCE, 15 * index_204 + 30);
            }
            ObjectSetText(gsa_1060[index_204], lsa_156[index_204], 10, "MS Sans Serif", g_color_532);
         }
         for (int index_208 = 0; index_208 <= 5; index_208++) 
         {
            if (ObjectFind(gsa_1064[index_208]) == -1) 
            {
               ObjectCreate(gsa_1064[index_208], OBJ_LABEL, 0, 0, 0);
               ObjectSet(gsa_1064[index_208], OBJPROP_CORNER, 0);
               ObjectSet(gsa_1064[index_208], OBJPROP_XDISTANCE, 650);
               ObjectSet(gsa_1064[index_208], OBJPROP_YDISTANCE, 15 * index_208 + 30);
            }
            ObjectSetText(gsa_1064[index_208], lsa_160[index_208], 10, "MS Sans Serif", g_color_532);
         }
      }
      Sleep(200);
   }
   return (0);
}


void f0_3() 
{
   double bid_0;
   double ask_8;
   double point_16 = MarketInfo(gsa_664[gi_712], MODE_POINT);
   if (OrderType() == OP_BUY) 
   {
      bid_0 = MarketInfo(gsa_664[gi_712], MODE_BID);
      if (!gi_560 || bid_0 - OrderOpenPrice() > gi_708 * point_16) 
      {
         if (OrderStopLoss() < bid_0 - (gi_708 + TrailingStep - 1) * point_16) 
         {
            f0_1(bid_0 - gi_708 * point_16);
            return;
         }
      }
   }
   if (OrderType() == OP_SELL) 
   {
      ask_8 = MarketInfo(gsa_664[gi_712], MODE_ASK);
      if (!gi_560 || OrderOpenPrice() - ask_8 > gi_708 * point_16) 
      {
         if (OrderStopLoss() > ask_8 + (gi_708 + TrailingStep - 1) * point_16 || OrderStopLoss() == 0.0) 
         {
            f0_1(ask_8 + gi_708 * point_16);
            return;
         }
      }
   }
}

void f0_1(double a_price_0) 
{
   bool bool_8 = OrderModify(OrderTicket(), OrderOpenPrice(), a_price_0, OrderTakeProfit(), 0, CLR_NONE);
}