classdef BacktestEngine < handle
   properties
      currentTime
      initialCash
      symbols
      benchmark
      startDate
      endDate
      strategyName
      outputDir
      
      strategy
      dataFeed
      eventsEngine
      dataBoard
      backtestBrokerage
      portfolioManager
      performanceManager
      riskManager
   end
   methods (Access = public)
      function self = BacktestEngine(strategy)
          self.initialCash = 500000;
          self.symbols = {'AMZN', 'AAPL'};
          self.startDate = datenum('2010-01-01', 'yyyy-mm-dd');
          self.endDate = datenum('2017-05-01', 'yyyy-mm-dd');
          self.outputDir = 'd://workspace//EliteQuant_Matlab//out';
          
          % 1. datafeed
          self.dataFeed = BacktestDataFeed(self.startDate, self.endDate);
          self.dataFeed.subscribemarketdata(self.symbols);
          
          % 2. event engine
          self.eventsEngine = BacktestEventEngine(self.dataFeed);
          
          % 3. brokerage
          self.dataBoard = DataBoard();
          self.backtestBrokerage = BacktestBrokerage(self.eventsEngine, self.dataBoard);
          
          % 4. portfolio manager
          self.portfolioManager = PortfolioManager(self.initialCash);
          
          % 5 performance manager
          self.performanceManager = PerformanceManager(self.symbols);
          
          % 6. risk manager
          
          % 7. load strategy
          self.strategy = strategy;
          self.strategy.seteventsengine(self.eventsEngine);
          
          % 8. trade recorder
          
          % 9. wire up event listeners
          addlistener(self.eventsEngine,'eTick',@(~,e) tickhandler(self,e));
          addlistener(self.eventsEngine,'eBar',@(~,e) barhandler(self,e));
          addlistener(self.eventsEngine,'eOrder',@(~,e) orderhandler(self,e));
          addlistener(self.eventsEngine,'eFill',@(~,e) fillhandler(self,e));
      end
      
      function tickhandler(self, tickEvent)
          self.currentTime = tickEvent.timeStamp;
          
          self.performanceManager.updateperformance(self.currentTime, self.portfolioManager, self.dataBoard);
          self.portfolioManager.marktomarket(self.currentTime, tickEvent.fullSymbol, tickEvent.price);
          self.dataBoard.ontick(tickEvent);
          self.strategy.ontick(tickEvent);
      end
      
      function barhandler(self, barEvent)
          self.currentTime = barEvent.barendtime();
          %disp([datestr(barEvent.barStartTime) ' ' barEvent.fullSymbol]);
          
          self.performanceManager.updateperformance(self.currentTime, self.portfolioManager, self.dataBoard);
          self.portfolioManager.marktomarket(self.currentTime, barEvent.fullSymbol, barEvent.adjClosePrice);
          self.dataBoard.onbar(barEvent);
          self.strategy.onbar(barEvent);     
      end
      
      function orderhandler(self, orderEvent)
          self.backtestBrokerage.placeorder(orderEvent);
      end
      
      function fillhandler(self, fillEvent)
          self.portfolioManager.onfill(fillEvent);
          self.performanceManager.onfill(fillEvent);
      end
      
      function run(self)
          % reset
          self.performanceManager.reset();
          self.dataBoard.symbols = {};
          self.portfolioManager.cash = self.initialCash;
          self.portfolioManager.positions = {};
          self.strategy.reset();
          
          self.eventsEngine.run();
          
          self.performanceManager.updatefinalperformance(self.currentTime, self.portfolioManager, self.dataBoard);
          self.performanceManager.saveresults(self.outputDir);
          self.performanceManager.createtearsheet();
      end
   end
end