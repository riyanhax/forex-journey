//+------------------------------------------------------------------+
//|                                       ChangeAllTFsIndicators.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+

#property indicator_chart_window

#import "user32.dll"
   int      PostMessageA(int hWnd,int Msg,int wParam,int lParam);
   int      GetWindow(int hWnd,int uCmd);
   int      GetParent(int hWnd);
#import

#define GW_HWNDFIRST 0
#define GW_HWNDNEXT  2
#define WM_COMMAND   0x0111

int eintTF,prevTF;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init(){

   
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
//---
   bool blnContinue = true;   
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );   
   int intChild = GetWindow( intParent, GW_HWNDFIRST );  
   int intCmd; 
   
   eintTF = Period();
   if (prevTF == eintTF)
      return(0);
   else
      prevTF=eintTF;
   
   switch( eintTF )
   {
      case PERIOD_M1:   intCmd = 33137;  break;
      case PERIOD_M5:   intCmd = 33138;  break;
      case PERIOD_M15:  intCmd = 33139;  break;
      case PERIOD_M30:  intCmd = 33140;  break;
      case PERIOD_H1:   intCmd = 35400;  break;
      case PERIOD_H4:   intCmd = 33136;  break;
      case PERIOD_D1:   intCmd = 33134;  break;
      case PERIOD_W1:   intCmd = 33141;  break;
      case PERIOD_MN1:  intCmd = 33334;  break;
   }
   
   if ( intChild > 0 )   
   {
      if ( intChild != intParent )   PostMessageA( intChild, WM_COMMAND, intCmd, 0 );
   }
   else      blnContinue = false;   
   
   while( blnContinue )
   {
      intChild = GetWindow( intChild, GW_HWNDNEXT );
      
      if ( intChild > 0 )   
      { 
         if ( intChild != intParent )   PostMessageA( intChild, WM_COMMAND, intCmd, 0 );
      }
      else   blnContinue = false;   
   }
   
   // Now do the current window
   PostMessageA( intParent, WM_COMMAND, intCmd, 0 );

   return(0);
  }
//+------------------------------------------------------------------+
