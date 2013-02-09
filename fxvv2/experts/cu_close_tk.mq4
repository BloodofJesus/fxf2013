//+------------------------------------------------------------------+
//|                                                  cu_close_tk.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
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
   string infobox = "\n";
   int cnt, ticket, total;
   total=OrdersTotal();
   double val, val2, val3, val4, val5;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL  // check for opened position
         && OrderSymbol()==Symbol()
      )  // check for symbol
         {
         infobox = StringConcatenate(infobox, "\n", Symbol(), ", Bid: ", Bid, ", Ask: ", Ask);
         infobox = StringConcatenate(infobox, "\n", Symbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
         val=iIchimoku(OrderSymbol(),PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 1);
         val2=iIchimoku(OrderSymbol(),PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 2);
         val3=iIchimoku(OrderSymbol(),PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 3);
         val4=iIchimoku(OrderSymbol(),PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 4);
         val5=iIchimoku(OrderSymbol(),PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 5);
            if(OrderType()==OP_BUY && val < val2 && val2 < val3 && val3 >= val4 && val4 >= val5) {
               //OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
               Alert(OrderSymbol(), " close buy position");
            } else if(OrderType()==OP_SELL && val > val2 && val2 > val3 && val3 <= val4 && val4 <= val5) {
               //OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
               Alert(OrderSymbol(), " close sell position");
            } 
         }
         
      }
      Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+