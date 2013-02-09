//+------------------------------------------------------------------+
//|                                                     ga_close.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <ga_inc.mqh>
extern int trailingstop = 150;
extern int mintrailingstop = 400;
extern int mintrailingstopavgcosting = 401;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   custom_init();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   custom_start();
   for (int i=0; i<ARRSIZE; i++) {
      closingonprofit(aPair[i], i);
   }
//----
   Comment(infobox);
   return(0);
  }
//+------------------------------------------------------------------+


int closingonprofit(string symbol, int mode)
{
   if (totalorders[mode] == 0) {
      return (0);
   }

   int cnt;
   
   infobox = infobox + "\nTotal Profit: " + totalprofit[mode] + 
   ", totalorders: " + totalorders[mode];
   
   //new addition, if does not work then we can commit this.
   infobox = infobox + "\nAverage Cost: " + returncost[mode] + 
   ", trailingstop: " + trailingstop + ", mintrailingstop: " + mintrailingstop + 
   ", mintrailingstopavgcosting: " + mintrailingstopavgcosting;
   
   int checkpoint = mintrailingstop;
   if (totalorders[mode] > 1) {
      checkpoint = mintrailingstopavgcosting;
   }
   infobox = infobox + "\nstoploss: " + stoploss[mode] + ", checkpoint: " + checkpoint +
      ", (bid[mode]-returncost[mode]): " + (bid[mode]-returncost[mode]) +
      ", (point[mode]*checkpoint): " + (point[mode]*checkpoint)
   ;
   if(type[mode] == 1 && (bid[mode]-returncost[mode]) > point[mode]*checkpoint)
   {
      if(stoploss[mode] < (bid[mode] - point[mode]*trailingstop)) {
         stoploss[mode] = bid[mode] - point[mode]*trailingstop;
         infobox = infobox + "\nstoploss: " + stoploss[mode];
         change_stop_loss(symbol, stoploss[mode]);
      }
   } else if (type[mode] == -1 && (returncost[mode]-ask[mode])>(point[mode]*checkpoint)) {
      if((stoploss[mode] > (ask[mode] + point[mode]*trailingstop)) || (stoploss[mode]==0)) {
         stoploss[mode] = ask[mode] + point[mode]*trailingstop;
         infobox = infobox + "\nstoploss: " + stoploss[mode];
         change_stop_loss(symbol, stoploss[mode]);
      }
   }
   infobox = infobox + "\n----------------------------------";
}