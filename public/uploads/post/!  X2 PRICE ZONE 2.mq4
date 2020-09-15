
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 LimeGreen
#property indicator_color2 Red
#property indicator_color3 Red
#property indicator_color4 Black
#property indicator_color5 Black
#property indicator_color6 Black
#property indicator_color7 Silver

extern int Gi_76 = 14;
extern double Gd_80 = 0.382;
extern int Gi_88 = MODE_SMMA;
extern int Gi_92 = 2;
extern int Gi_96 = PRICE_WEIGHTED;
extern bool alertsOn = FALSE;
extern bool alertsOnCurrent = FALSE;
extern bool alertsOnHighLow = TRUE;
extern bool alertsMessage = TRUE;
extern bool alertsSound = FALSE;
extern bool alertsNotify = FALSE;
extern bool alertsEmail = FALSE;
double Gda_128[];
double Gda_132[];
double Gda_136[];
double Gda_140[];
double Gda_144[];
double Gda_148[];
double Gda_152[];
double Gda_156[];
double Gda_160[][4];
string Gs_nothing_164 = "nothing";
datetime Gt_172;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   string Ls_0 = " X2 PRICE ZONE";
   IndicatorShortName(Ls_0);
   IndicatorBuffers(8);
   SetIndexBuffer(0, Gda_132);
   SetIndexBuffer(1, Gda_136);
   SetIndexBuffer(2, Gda_140);
   SetIndexBuffer(3, Gda_144);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexBuffer(4, Gda_148);
   SetIndexStyle(4, DRAW_LINE);
   SetIndexBuffer(5, Gda_152);
   SetIndexBuffer(6, Gda_128);
   SetIndexBuffer(7, Gda_156);
   return (0);
}
	  	  	 											    	 			 	 	   	  			     		  	 	   		 	        		  			  						 		   						  	  		 		 		   		    			     	  	  	        	 	 	
// 52D46093050F38C27267BCE42543EF60
int deinit() {
   return (0);
}
	    			 		 	 	  			 	  			     	    		    	 		 	 				 	 	   	 		  		  	 			  	  				  				 	 				 		     	  	     	  	 	  	   	     	 		  					 
// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   double Ld_12;
   double Ld_20;
   double Ld_28;
   int Li_0 = IndicatorCounted();
   if (Li_0 < 0) return (-1);
   if (Li_0 > 0) Li_0--;
   int Li_4 = MathMin(Bars - Li_0, Bars - 1);
   if (Gda_152[Li_4] == -1.0) f0_0(Li_4, Gda_136, Gda_140);
   for (int Li_8 = Li_4; Li_8 >= 0; Li_8--) {
      Ld_12 = f0_2(Close[Li_8], Gi_76, Li_8, 0);
      Ld_20 = f0_2(High[Li_8] - Low[Li_8], Gi_76, Li_8, 1);
      Ld_28 = f0_2(Ld_20, Gi_76, Li_8, 2);
      Gda_132[Li_8] = f0_2(Ld_12, Gi_76, Li_8, 3);
      Gda_144[Li_8] = Gda_132[Li_8] + Ld_28 * Gd_80;
      Gda_148[Li_8] = Gda_132[Li_8] - Ld_28 * Gd_80;
      Gda_152[Li_8] = Gda_152[Li_8 + 1];
      Gda_136[Li_8] = EMPTY_VALUE;
      Gda_140[Li_8] = EMPTY_VALUE;
      if (Gda_132[Li_8] > Gda_132[Li_8 + 1]) Gda_152[Li_8] = 1;
      if (Gda_132[Li_8] < Gda_132[Li_8 + 1]) Gda_152[Li_8] = -1;
      if (Gda_152[Li_8] == -1.0) f0_3(Li_8, Gda_136, Gda_140, Gda_132);
      Gda_156[Li_8] = 0;
      Gda_128[Li_8] = 2.0 * Gda_132[Li_8] - iMA(NULL, 0, Gi_92, 0, Gi_88, Gi_96, Li_8);
      if (alertsOnHighLow) {
         if (High[Li_8] > Gda_144[Li_8]) Gda_156[Li_8] = -1;
         if (Low[Li_8] < Gda_148[Li_8]) Gda_156[Li_8] = 1;
      } else {
         if (Close[Li_8] > Gda_144[Li_8]) Gda_156[Li_8] = -1;
         if (Close[Li_8] < Gda_148[Li_8]) Gda_156[Li_8] = 1;
      }
   }
   f0_1();
   return (0);
}
	 	 	  			   	  		 		 	  	  			   	 	   	 			      	  					 	 		  		 					 			  		 	 			 	   	 	 			 		 	   	 	 	 				    							 	 	 		  		   		
// 7AB56568D944A23B42AE223B164F7933
double f0_2(double Ad_0, double Ad_8, int Ai_16, int Ai_20 = 0) {
   if (ArrayRange(Gda_160, 0) != Bars) ArrayResize(Gda_160, Bars);
   Ai_16 = Bars - Ai_16 - 1;
   double Ld_24 = 2.0 / (Ad_8 + 1.0);
   Gda_160[Ai_16][Ai_20] = Gda_160[Ai_16 - 1][Ai_20] + Ld_24 * (Ad_0 - (Gda_160[Ai_16 - 1][Ai_20]));
   return (Gda_160[Ai_16][Ai_20]);
}
				  	 	  						      	   	 	 	 			  					   		 	  	   	 		     		 		  	    				   		     				   	 		 			 	   				  			 		  	  				     		 	 	 	
// 21F8D7C6ACBD885873A4BA3D594D41CD
void f0_0(int Ai_0, double &Ada_4[], double &Ada_8[]) {
   if (Ada_8[Ai_0] != EMPTY_VALUE && Ada_8[Ai_0 + 1] != EMPTY_VALUE) {
      Ada_8[Ai_0 + 1] = EMPTY_VALUE;
      return;
   }
   if (Ada_4[Ai_0] != EMPTY_VALUE && Ada_4[Ai_0 + 1] != EMPTY_VALUE && Ada_4[Ai_0 + 2] == EMPTY_VALUE) Ada_4[Ai_0 + 1] = EMPTY_VALUE;
}
		  	 			 	  		 	 			     	 		   	  	 	 		 		 	  			   		   	  	 	 	 	 		 					 	 		 	 	  	  			   	 	  			 	   		 				  	 			 			  	  	 	 	  			
// D1B45A6FF1A5430B6E40FB3AD384517E
void f0_3(int Ai_0, double &Ada_4[], double &Ada_8[], double &Ada_12[]) {
   if (Ada_4[Ai_0 + 1] == EMPTY_VALUE) {
      if (Ada_4[Ai_0 + 2] == EMPTY_VALUE) {
         Ada_4[Ai_0] = Ada_12[Ai_0];
         Ada_4[Ai_0 + 1] = Ada_12[Ai_0 + 1];
         Ada_8[Ai_0] = EMPTY_VALUE;
         return;
      }
      Ada_8[Ai_0] = Ada_12[Ai_0];
      Ada_8[Ai_0 + 1] = Ada_12[Ai_0 + 1];
      Ada_4[Ai_0] = EMPTY_VALUE;
      return;
   }
   Ada_4[Ai_0] = Ada_12[Ai_0];
   Ada_8[Ai_0] = EMPTY_VALUE;
}
			         		 	   	  			    						    	 			   			 		 	   	   	 							    	 	 	   				 	   		  	 						 	    		 			 	 					 		  		   	 					    
// 304CD8F881C2EC9D8467D17452E084AC
void f0_1() {
   int Li_0;
   if (alertsOn) {
      if (alertsOnCurrent) Li_0 = 0;
      else Li_0 = 1;
      if (Gda_156[Li_0] != Gda_156[Li_0 + 1]) {
         if (Gda_156[Li_0] == 1.0) f0_4(Li_0, "lower");
         if (Gda_156[Li_0] == -1.0) f0_4(Li_0, "upper");
      }
   }
}
		    			 	 			 	 		      	  	   	    	 		 	  	  				  		      	 	 			 		 		 		 	 				 	  	 				   			  			     		 	 		  	 	 	 			     	 	 		 			
// DA717D55A7C333716E8D000540764674
void f0_4(int Ai_0, string As_4) {
   string Ls_12;
   if (Gs_nothing_164 != As_4 || Gt_172 != Time[Ai_0]) {
      Gs_nothing_164 = As_4;
      Gt_172 = Time[Ai_0];
      Ls_12 = StringConcatenate(Symbol(), " at ", TimeToStr(TimeLocal(), TIME_SECONDS), " Price Zone price touching ", As_4, " band");
      if (alertsMessage) Alert(Ls_12);
      if (alertsNotify) SendNotification(StringConcatenate(Symbol(), Period(), " Price Zone " + " " + Ls_12));
      if (alertsEmail) SendMail(StringConcatenate(Symbol(), " Price Zone "), Ls_12);
      if (alertsSound) PlaySound("alert2.wav");
   }
}