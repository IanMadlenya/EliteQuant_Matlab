classdef PerformanceManager < handle
   properties
      realizedPnL
      unrealizedPnL
      equitySeries
      positionsTable
      tradesTable
      symbols
   end
   methods (Access = public)
      function self = PerformanceManager(symbols)
          self.symbols = symbols;
          self.reset();
      end
      
      function reset(self)
          self.realizedPnL = 0;
          self.unrealizedPnL = 0;
          self.equitySeries = {};
          self.tradesTable = cell2table(cell(0,4), 'VariableNames', {'Date', 'Amount','Price','Symbol'});
          %self.tradesTable.Properties.VariableNames = [{'Date'}, self.symbols];
      end
      
      % T = table({},{},'VariableNames',{'Date','Price'})
      % T = [T; [123,{'ced'}]];  T.Date{1}
      function updateperformance(self, currentTime, positionManager, dataBoard)
          if isempty(self.equitySeries)
              self.equitySeries = fints(currentTime, 0.0);
          elseif (currentTime ~= self.equitySeries.dates(end))              
              equity = 0.0;
              nSyms = size(positionManager.positions,1);
              for i = 1:nSyms
                  equity = equity + positionManager.positions{i,2}.size ...
                      * dataBoard.getlastprice(positionManager.positions{i,1});
              end
              
              self.equitySeries.series1(end) = equity + positionManager.cash;
              self.equitySeries = vertcat(self.equitySeries, fints(currentTime, 0.0));
          end
      end
      
      function onfill(self, fillEvent)
          self.tradesTable = [self.tradesTable; {fillEvent.timeStamp, fillEvent.fillSize, ...
              fillEvent.fillPrice, fillEvent.fullSymbol}];
      end
      
      function updatefinalperformance(self, currentTime, positionManager, dataBoard)
          equity = 0.0;
          nSyms = size(positionManager.positions,1);
          for i = 1:nSyms
              equity = equity + positionManager.positions{i,2}.size ...
                  * dataBoard.getlastprice(positionManager.positions{i,1});
          end
          
          self.equitySeries.series1(end) = equity + positionManager.cash;   
      end
      
      function createtearsheet(self)
          subplot(2,1,1);
          plot(self.equitySeries);
          title('Strategy Equity Line');
          
          tret = tick2ret(self.equitySeries);
          subplot(2,1,2);
          plot(tret);
          title('Strategy Returns');          
      end
      
      function saveresults(self, outputDir)
          fts2ascii([outputDir '/equity_line.txt'], self.equitySeries)
      end
   end
end