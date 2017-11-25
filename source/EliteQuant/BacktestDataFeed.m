classdef BacktestDataFeed < handle
   properties
       endDate
       startDate
       dataSource
       histData
       currentCursor
   end
   methods (Access = public)
      function self = BacktestDataFeed(sd, ed)
          self.startDate = sd;      % yyyy-mm-dd
          self.endDate = ed;        % yyyy-mm-dd
          self.dataSource = 'quandl';
          self.currentCursor = 1;
          self.histData = {};
      end
      
      function subscribemarketdata(self, syms)
          disp('start downloading data...');
          Quandl.api_key('ay68s2CUzKbVuy8GAqxj');
          
          data = cell(0);
          for i = 1:length(syms)
              data0 = Quandl.get(['WIKI/' syms{i}], 'type','table', ...
                  'start_date',self.startDate, 'end_date', self.endDate);
              data0.Symbol = repmat({syms{i}}, size(data0,1),1);
              data = [data; data0];
          end
		  %data(:,1) = datenum(data(:,1),'mm/dd/yyyy');
          self.histData = sortrows(data, 1);  % sort on date
          
          disp('data downloaded');
      end
      
      function reset(self)
          self.currentCursor = 1;
      end
      
      function [bar] = streamnext(self)
          if (self.currentCursor <= size(self.histData,1))
              bar = BarEvent();
              bar.barStartTime = self.histData.Date(self.currentCursor);
              bar.fullSymbol = self.histData.Symbol{self.currentCursor};
              bar.openPrice = self.histData.Open(self.currentCursor);
              bar.highPrice = self.histData.High(self.currentCursor);
              bar.lowPrice = self.histData.Low(self.currentCursor);
              bar.closePrice = self.histData.Close(self.currentCursor);
              bar.volume = self.histData.Volume(self.currentCursor);
              bar.adjClosePrice = self.histData.Adj_Close(self.currentCursor);
              
              self.currentCursor = self.currentCursor+1;
          else
              bar = cell(0);
          end
          
      end
   end
end