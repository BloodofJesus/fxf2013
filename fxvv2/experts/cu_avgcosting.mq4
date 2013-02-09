//+------------------------------------------------------------------+
//|                                                cu_avgcosting.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

string infobox;
extern double Lots = 0.10;
extern int InitialTrailingStop = 150;
extern int TrailingStop = 150;
extern int magic1 = 2331;
extern int magic2 = 2332;
extern int magic3 = 2333;
extern int magic4 = 2334;
extern int magic5 = 2335;
extern int difference = 1500; //small for small currency like nzd (nzd will have about 500)

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
   infobox = "";
   double returncost = avg_costing(Symbol());
   create_orders(Symbol(), returncost, 1);
   create_orders(Symbol(), returncost, 2);
   create_orders(Symbol(), returncost, 3);
   create_orders(Symbol(), returncost, 4);
   create_orders(Symbol(), returncost, 5);
   infobox = StringConcatenate("Account #",AccountNumber(), "\nSpread: ", MarketInfo(Symbol(), MODE_SPREAD), "\n"
            , "Account Leverage: ", AccountLeverage()
            , ", Account free margin = ",AccountFreeMargin()
            , "\nLots = ",Lots
            , ", InitialTrailingStop = ",InitialTrailingStop
            , ", TrailingStop = ",TrailingStop
            , ", returncost = ", DoubleToStr(returncost, MarketInfo(Symbol(), MODE_DIGITS))
            ,", Lotsize: ", MarketInfo(Symbol(), MODE_LOTSIZE)
   , infobox);
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


double avg_costing(string symbol)
{
   int cnt, ticket, total;
   total=OrdersTotal();
   double bids, asks, pt;
   int digit;
               bids = MarketInfo(symbol, MODE_BID);
               asks = MarketInfo(symbol, MODE_ASK);
               pt = MarketInfo(symbol, MODE_POINT);
               digit = MarketInfo(symbol, MODE_DIGITS);
   int orders;
   infobox = StringConcatenate(infobox, "\nAverage Costing For Symbol: ", symbol, "\n");
   double num;
   double openprice;
   double lotsize;
   double lotsavg = 0.0;
   double totalcost = 0.0;
   int type = 0;
   int x = 0;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==symbol)  // check for symbol
         {
            x++;
            num = 500 * pt;
            openprice = OrderOpenPrice();
            lotsize = OrderLots();
            lotsavg = lotsavg + lotsize;
            totalcost = totalcost + (lotsize * openprice);
            if(OrderType()==OP_BUY) {
               type = 1;            
            } else if(OrderType()==OP_SELL) {
               type = -1;            
            }
            infobox = StringConcatenate(infobox, "Type: ", type);
            infobox = StringConcatenate(infobox, " - Openprice: ", DoubleToStr(openprice, digit));
            infobox = StringConcatenate(infobox, " - Order Profit: ", OrderProfit());
            infobox = StringConcatenate(infobox, "\n");
         }
     }
     if (x == 0) {
      infobox = StringConcatenate(infobox, "No Orders Found");
      return (0);
     }
     double cost = 0.0;
     cost = totalcost / lotsavg;
     double returncost = cost;
     infobox = StringConcatenate(infobox, "Current Average: ", DoubleToStr(cost, digit));
     infobox = StringConcatenate(infobox, " - ");
     infobox = StringConcatenate(infobox, "Totalcost: ", totalcost);
     infobox = StringConcatenate(infobox, " - ");
     infobox = StringConcatenate(infobox, "Lots: ", lotsavg);
     infobox = StringConcatenate(infobox, "\n");
     if (type == 1) {
         openprice = asks;
     } else if (type == -1) {
         openprice = bids;
     }
     for (int j=1;j<11;j++) {
         lotsize = Lots * j;
         cost = (totalcost + (lotsize * openprice)) / (lotsavg + lotsize);
         infobox = StringConcatenate(infobox, "Lots: ", lotsize, ", total lots: ", (lotsavg + lotsize));
         infobox = StringConcatenate(infobox, " - Avg: ", DoubleToStr(cost, digit));
         infobox = StringConcatenate(infobox, "\n");
    }
    return (returncost);
}

int create_orders(string symbol, double cost, int number)
{
   int cnt, ticket, total;
   total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL  // check for opened position
         && OrderSymbol()==symbol
      )  // check for symbol
         {
         infobox = StringConcatenate("\n", infobox, OrderSymbol(), ", Bid: ", Bid, ", Ask: ", Ask);
         infobox = StringConcatenate("\n", infobox, OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(
                  difference > 0 
                  && OrderProfit() < 0 
                  && OrderMagicNumber() != magic1 
                  && OrderMagicNumber() != magic2
                  && OrderMagicNumber() != magic3
                  && OrderMagicNumber() != magic4
                  && OrderMagicNumber() != magic5
                  && OrderOpenPrice()-Bid > (Point*(difference*number))
                  )  
               {                 
                  infobox = StringConcatenate("\n", infobox, OrderSymbol(), ", OrderOpenPrice()-Bid): ", (Bid-OrderOpenPrice())
                  , ", (Point*(difference*", number, "): ", (Point*(difference*number));
                  infobox = StringConcatenate("\n", infobox, OrderSymbol(), ", Create New Buy Order");
                  //create new buy order
                  
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(
                  difference > 0 
                  && OrderProfit() < 0 
                  && OrderMagicNumber() != magic1 
                  && OrderMagicNumber() != magic2
                  && OrderMagicNumber() != magic3
                  && OrderMagicNumber() != magic4
                  && OrderMagicNumber() != magic5
                  && Ask-OrderOpenPrice() > (Point*(difference*number)))  
                 {         
                  infobox = StringConcatenate("\n", infobox, OrderSymbol(), ", Ask-OrderOpenPrice(): ", (Ask-OrderOpenPrice())
                  , ", (Point*(difference*", number, "): ", (Point*(difference*number));
                  infobox = StringConcatenate("\n", infobox, OrderSymbol(), ", Create New Sell Order");
                  //create new sell order
      
                 }
            } 
         }
         
      }
}