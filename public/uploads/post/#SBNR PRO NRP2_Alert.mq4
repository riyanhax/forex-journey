///////////////////////////////////////////////////////////////////
//Generated by ex4 to mq4 decompile Service                      // 
//Website:                                                       //
//E-mail : jlk2k3@gmail.com ; decompiler.ex4tomq4@gmail.com      //
///////////////////////////////////////////////////////////////////

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red

extern bool   UseSound           = true;
extern bool   AlertSound         = true;
extern string SoundFileBuy       = "alert2.wav";
extern string SoundFileSell      = "email.wav";
extern bool   SendMailPossible   = false;
extern int    SIGNAL_BAR = 2;
bool SoundBuy  = False;
bool SoundSell = False;
int Gi_76 = 10;
int G_timeframe_80 = PERIOD_M30;
double G_ibuf_84[];
double G_ibuf_88[];
int Gia_92[];

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 110);
   SetIndexBuffer(0, G_ibuf_84);
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 110);
   SetIndexBuffer(1, G_ibuf_88);
   SetIndexEmptyValue(1, 0.0);
   if (Period() > G_timeframe_80) {
      Alert("Signal in SBNR PRO NRP2 ", G_timeframe_80);
      return (0);
   }
   ArrayCopySeries(Gia_92, 5, Symbol(), G_timeframe_80);
   return (0);
}
					  	   	 	   	           			 				   				    		  	     				  				 	 	 		 		  			 	 				   	        	 	  			  		 	     		  	  				 	 		 				 		
// 52D46093050F38C27267BCE42543EF60
int deinit() {
   return (0);
}
		     		 	 		  					   	 								       	  	    			    	    	   	  		 			 	 	   	 	  		 					  	 			 	   	  	   		 	   		 			   	  		 	     	 	 
// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   int count_0;
   double icustom_4;
   if (!IsConnected() || AccountNumber() == 0) return (0);
/*   if (StringFind(AccountServer(), "Exness.LTD", 0) == -1 && StringFind(AccountServer(), "Exness", 0) == -1) {
      Alert("Sory...is only running in Broker Exness!!!");
      return (-1);
   }
   string Ls_12 = "2013.09.20";
   int str2time_20 = StrToTime(Ls_12);
   if (TimeCurrent() >= str2time_20) {
      Alert(" Sorry SBNR PRO NRP 2 Already Expired ... Please contact SBNR TEAM(dunhilfx@gmail.com ");
      return (0);
   }*/
   int Li_24 = IndicatorCounted();
   int Li_28 = 300;
   if (Li_24 < 0) return (-1);
   if (Li_24 > 0) Li_24--;
   Li_28 = Bars - Li_24;
   for (int index_32 = 0; index_32 < Li_28; index_32++) {
      if (Time[index_32] >= Gia_92[0]) count_0 = 0;
      else {
         count_0 = ArrayBsearch(Gia_92, Time[index_32 - 1], WHOLE_ARRAY, 0, MODE_DESCEND);
         if (Period() <= G_timeframe_80) count_0++;
      }
      for (int Li_36 = count_0; Li_36 < count_0 + 100; Li_36++) {
         icustom_4 = iCustom(NULL, G_timeframe_80, "ZigZag", Gi_76, 5, 3, 0, Li_36 + 1);
         if (icustom_4 != 0.0) break;
      }
      if (iClose(NULL, 0, index_32 + 1) <= icustom_4) G_ibuf_88[index_32] = icustom_4;
      else G_ibuf_88[index_32] = 0.0;
      if (iClose(NULL, 0, index_32 + 1) >= icustom_4) G_ibuf_84[index_32] = icustom_4;
      else G_ibuf_84[index_32] = 0.0;
      WindowRedraw();
   }
 string  message  =  StringConcatenate("SBNR PRO NRP2(", Symbol(), ", ", Period(), ")  -  BUY!!!"," Price - ",Ask ," !!! Time - " ,TimeToStr(TimeLocal(),TIME_SECONDS)); 
 string  message2 =  StringConcatenate("SBNR PRO NRP2(", Symbol(), ", ", Period(), ")  -  SELL!!!"," Price - ",Bid," !!! Time - " ,TimeToStr(TimeLocal(),TIME_SECONDS)); 
               
        if (G_ibuf_84[SIGNAL_BAR] != EMPTY_VALUE && G_ibuf_84[SIGNAL_BAR] != 0 && SoundBuy)
         {
         SoundBuy = False;
            if (UseSound) PlaySound (SoundFileBuy);
               if(AlertSound){         
               Alert(message);                             
               if (SendMailPossible) SendMail(Symbol(),message); 
            }              
         } 
      if (!SoundBuy && (G_ibuf_84[SIGNAL_BAR] == EMPTY_VALUE || G_ibuf_84[SIGNAL_BAR] == 0)) SoundBuy = True;  
            
  
     if (G_ibuf_88[SIGNAL_BAR] != EMPTY_VALUE && G_ibuf_88[SIGNAL_BAR] != 0 && SoundSell)
         {
         SoundSell = False;
            if (UseSound) PlaySound (SoundFileSell); 
             if(AlertSound){                    
             Alert(message2);             
             if (SendMailPossible) SendMail(Symbol(),message2); 
             }            
         } 
      if (!SoundSell && (G_ibuf_88[SIGNAL_BAR] == EMPTY_VALUE || G_ibuf_88[SIGNAL_BAR] == 0)) SoundSell = True; 
      
       //+------------------------------------------------------------------+   
   return (0);
}