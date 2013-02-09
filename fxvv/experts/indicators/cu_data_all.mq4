//+------------------------------------------------------------------+
//|                                                      cu_data.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window

double val, val2, val3, val4, val5, val6, val7, val8, val9, val10;
int period[9] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1, PERIOD_W1, PERIOD_MN1};
string symbols[28] = {
               "AUDUSD", "NZDUSD", "EURUSD", 
               "USDCHF", "EURJPY", 
               "NZDCHF", "NZDCAD", 
               "EURAUD", "GBPAUD", "AUDCAD", "AUDCHF", "AUDJPY", "NZDJPY", "EURNZD", "GBPNZD", 
               "CHFJPY", "EURCAD", "CADCHF", "GBPCAD", 
                  "USDCAD", "GBPCHF", "CADJPY", "GBPJPY",  
               "GBPUSD", "USDJPY",
               "EURGBP", "AUDNZD", "EURCHF"};
int limit = 15;
int openTime;
int openTime2;
int start = 20;
int side = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   delete_object();
   create_heading();
   create_side_items();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   delete_object();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   custom_start();
//----
   return(0);
  }
//+------------------------------------------------------------------+


void custom_start()
{
   Sleep(3000);
   calculate_heiken();
}


void delete_object()
{
   ObjectDelete("result");
   ObjectDelete("suggestion_text");
   ObjectDelete("suggestionlbl");
   ObjectDelete("h1_0");
   ObjectDelete("h1_1");
   string name;
   int i;
   int c;
   for (c = 0; c < 28; c++) {
         name = "heiken_"+c;
         ObjectDelete(name);
         name = "heiken1_"+c;
         ObjectDelete(name);
         name = "heiken2_"+c;
         ObjectDelete(name);
         name = "heiken3_"+c;
         ObjectDelete(name);
         name = symbols[c] + "_lbl";
         ObjectDelete(name);
   }
}

void create_heading()
{
   if (ObjectCreate("h1_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("h1_0", OBJPROP_CORNER, side);
      ObjectSet("h1_0", OBJPROP_XDISTANCE, start + 100);
      ObjectSet("h1_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("h1_0", "H1", 10, "Verdana", White);
   }
   if (ObjectCreate("h1_1", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("h1_1", OBJPROP_CORNER, side);
      ObjectSet("h1_1", OBJPROP_XDISTANCE, start + 150);
      ObjectSet("h1_1", OBJPROP_YDISTANCE, 40);
      ObjectSetText("h1_1", "Change", 10, "Verdana", White);
   }
   
   
   
}

void create_side_items()
{
   if (ObjectCreate("suggestionlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("suggestionlbl", OBJPROP_CORNER, side);
      ObjectSet("suggestionlbl", OBJPROP_XDISTANCE, start);
      ObjectSet("suggestionlbl", OBJPROP_YDISTANCE, 20);
      ObjectSetText("suggestionlbl", "Suggestion", 10, "Verdana", White);
   }
   int c;
   string name;
   int tmp = 60;
   int tmpcnt = 20;
   int y;
   for (c = 0; c < limit; c++) {
      name = symbols[c] + "_lbl";
      y = tmp + (c * tmpcnt);
      if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
         ObjectSet(name, OBJPROP_CORNER, side);
         ObjectSet(name, OBJPROP_XDISTANCE, start);
         ObjectSet(name, OBJPROP_YDISTANCE, y);
         ObjectSetText(name, (c+1) + ". " + symbols[c], 10, "Verdana", White);
      }
   }
}

void create_label(string name, int x, int y, string text, color textcolor)
{
   if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
      ObjectSet(name, OBJPROP_CORNER, side);
      ObjectSet(name, OBJPROP_XDISTANCE, x);
      ObjectSet(name, OBJPROP_YDISTANCE, y);
      ObjectSetText(name, text, 10, "Verdana", textcolor);
   }
}
/*
void create_label_v2(string name, int x, int y, string text, color textcolor, int corner)
{
   if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
      ObjectSet(name, OBJPROP_CORNER, corner);
      ObjectSet(name, OBJPROP_XDISTANCE, x);
      ObjectSet(name, OBJPROP_YDISTANCE, y);
      ObjectSetText(name, text, 10, "Verdana", textcolor);
   }
}*/
void create_arrow(string name, int x, int y, int trend)
{
   if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
      ObjectSet(name, OBJPROP_CORNER, side);
      ObjectSet(name, OBJPROP_XDISTANCE, x);
      ObjectSet(name, OBJPROP_YDISTANCE, y);
      string text = "";
      color color_code;
      if (trend == 1) {
         text = CharToStr(233);
         color_code = Blue;
      } else if (trend == -1) {
         text = CharToStr(234);
         color_code = Red;
      } else {
         text = CharToStr(232);
         color_code = Gold;
      }
      
      ObjectSetText(name, text, 10, "Wingdings", color_code);
   }
}
void calculate_heiken()
{
   string name;
   string symbol;
   int base, x, y, c;
   x = start + 100;
   for (c = 0; c < limit; c++) {
      symbol = symbols[c];
      name = "heiken_"+c;
      base = 60;
      y = base + (c * 20);
      val2 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
      ObjectDelete(name);
      if (val2 < val3) {
         create_arrow(name, x, y, 1);
      } else if (val2 > val3) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }
   }
   x = start + 150;
   for (c = 0; c < limit; c++) {
      symbol = symbols[c];
      name = "heiken1_"+c;
      base = 60;
      y = base + (c * 20);
      val2 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
      val4  = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
      val5 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
      ObjectDelete(name);
      if (val2 < val3 && val4 > val5) {
         create_arrow(name, x, y, 1);
      } else if (val2 > val3 && val4 < val5) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }
   }
   x = start + 170;
   int j;
   for (c = 0; c < limit; c++) {
      symbol = symbols[c];
      name = "heiken2_"+c;
      base = 60;
      y = base + (c * 20);
      for (j = 0; j < 240; j++) {
         val2 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,j);
         val3 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,j);
         val4  = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,j+1);
         val5 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,j+1);
         ObjectDelete(name);
         if (val2 < val3 && val4 > val5) {
            create_label(name, x, y, "("+j+")", White);
            break;
         } else if (val2 > val3 && val4 < val5) {
            create_label(name, x, y, "("+j+")", Red);
            break;
         }
      }
   }
   x = start + 200;
   int counter;
   string values;
   int hour;
   for (c = 0; c < limit; c++) {
      symbol = symbols[c];
      name = "heiken3_"+c;
      base = 60;
      y = base + (c * 20);
      counter = 0;
      values = "";
      //hour = TimeHour(iTime(symbol, PERIOD_H1, 0));
      for (j = 0; j < 120; j++) {
         val2 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,j);
         val3 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,j);
         val4  = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,j+1);
         val5 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,j+1);
         ObjectDelete(name);
         if (val2 < val3 && val4 > val5) {
            counter++;
            //hour = (TimeHour(iTime(symbol, PERIOD_H1, j)) - 3);
            //if (hour < 0) {
               //hour = hour + 24;
            //}
            //values = values + ","+hour;
            //values = values + ", " + DoubleToStr(val2, MarketInfo(symbol, MODE_DIGITS));
         } else if (val2 > val3 && val4 < val5) {
            //hour = (TimeHour(iTime(symbol, PERIOD_H1, j)) - 3);
            //if (hour < 0) {
              // hour = hour + 24;
            //}
            //values = values + ","+hour;
            //values = values + ", " + DoubleToStr(val2, MarketInfo(symbol, MODE_DIGITS));
            counter++;
         }
      }
      create_label(name, x, y, "(C:"+counter+")" + values, White);
   }
}