classdef BacktestBrokerage < handle
   properties
      eventsEngine
      dataBoard
   end
   methods (Access = public)
      function self = BacktestBrokerage(ee, db)
          self.eventsEngine = ee;
          self.dataBoard = db;
      end
      
      function commission = calculatecommission(self, fullSymbol, fillPrice, fillSize)
          if ~isempty(strfind(fullSymbol,' STK'))
              commission = max(0.005*abs(fillSize), 1);
          elseif ~isempty(strfind(fullSymbol,' FUT'))
              commission = 2.01 * abs(fillSize);
          elseif ~isempty(strfind(fullSymbol,' OPT'))
              commission = max(0.7 * abs(fillSize), 1.0);
          elseif ~isempty(strfind(fullSymbol,' CASH'))
              commission = max(0.000002 * abs(fillPrice * fillSize), 2);
          else
              commission = 0;
          end
      end
      
      function placeorder(self, orderEvent)
          % immediate fill at last price
          % no latency, no slippage
          orderEvent.orderStatus = OrderStatus.FILLED;
          fill = FillEvent;
          fill.internalOrderID = orderEvent.internalOrderID;
          fill.brokerOrderID = orderEvent.brokerOrderID;
          fill.timeStamp = self.dataBoard.getlasttimestamp(orderEvent.fullSymbol);
          fill.fullSymbol = orderEvent.fullSymbol;
          fill.fillSize = orderEvent.size;
          fill.fillPrice = self.dataBoard.getlastprice(orderEvent.fullSymbol);
          fill.exchange = 'BACKTEST';
          fill.commission = self.calculatecommission(fill.fullSymbol, fill.fillPrice, fill.fillSize);
          
          self.eventsEngine.push(fill);
      end
      
      function cancelorder(self, orderid)
      end
   end
end