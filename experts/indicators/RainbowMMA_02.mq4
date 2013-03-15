/*

*********************************************************************
          
                        Rainbow MMA 1
                   Copyright � 2006  Akuma99
                  http://www.beginnertrader.com
                  
*********************************************************************

*/


#property copyright "Code written by - Akuma99"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 MediumOrchid
#property indicator_color2 MediumOrchid
#property indicator_color3 MediumOrchid
#property indicator_color4 MediumOrchid
#property indicator_color5 MediumOrchid
#property indicator_color6 MediumOrchid
#property indicator_color7 MediumOrchid
#property indicator_color8 MediumOrchid

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE,EMPTY,1);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE,EMPTY,1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE,EMPTY,1);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_LINE,EMPTY,1);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexStyle(4,DRAW_LINE,EMPTY,1);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexStyle(5,DRAW_LINE,EMPTY,1);
   SetIndexBuffer(5,ExtMapBuffer6);
   SetIndexStyle(6,DRAW_LINE,EMPTY,1);
   SetIndexBuffer(6,ExtMapBuffer7);
   SetIndexStyle(7,DRAW_LINE,EMPTY,1);
   SetIndexBuffer(7,ExtMapBuffer8);
//----
   return(0);
  }

int deinit()
  {
   return(0);
  }

int start()
  {
   int i,j,limit,counted_bars=IndicatorCounted();
   
   
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   
   for(i=0; i<limit; i++){
      ExtMapBuffer1[i]=iMA(NULL,0,145,0,MODE_EMA,PRICE_CLOSE,i);
      ExtMapBuffer2[i]=iMA(NULL,0,150,0,MODE_EMA,PRICE_CLOSE,i);
      ExtMapBuffer3[i]=iMA(NULL,0,155,0,MODE_EMA,PRICE_CLOSE,i);
      ExtMapBuffer4[i]=iMA(NULL,0,160,0,MODE_EMA,PRICE_CLOSE,i);
      ExtMapBuffer5[i]=iMA(NULL,0,165,0,MODE_EMA,PRICE_CLOSE,i);
      ExtMapBuffer6[i]=iMA(NULL,0,170,0,MODE_EMA,PRICE_CLOSE,i);
   }
   

   return(0);
  }
//+------------------------------------------------------------------+