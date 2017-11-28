classdef BacktestDataFeedLocal < handle
   properties
       histDataDir
       endDate
       startDate
       dataSource
       histData
       currentCursor
   end
   methods (Access = public)
      function self = BacktestDataFeedLocal(histDir, sd, ed)
          self.histDataDir = histDir;
          self.startDate = sd;      % yyyy-mm-dd
          self.endDate = ed;        % yyyy-mm-dd
          self.dataSource = 'quandl';
          self.currentCursor = 1;
          self.histData = {};
      end
      
      function subscribemarketdata(self, syms)
          disp('start importing data...');
          warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
          
          data = cell(0);
          for i = 1:length(syms)
              data0 = readtable([self.histDataDir '//' syms{i} '.csv']);
              data0.Date = datenum(data0.Date);
              inrange = (data0.Date >= datenum('2010-01-09') & data0.Date <= datenum(self.endDate));
              data0 = data0(inrange, :);
              data0.Symbol = repmat({syms{i}}, size(data0,1),1);
              data = [data; data0];
          end
		  %data(:,1) = datenum(data(:,1),'mm/dd/yyyy');
          self.histData = sortrows(data, 1);  % sort on date
          
          disp('data imported');
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
              bar.adjClosePrice = self.histData.AdjClose(self.currentCursor);
              
              self.currentCursor = self.currentCursor+1;
          else
              bar = cell(0);
          end
          
      end
   end
end