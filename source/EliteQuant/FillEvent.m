classdef (ConstructOnLoad) FillEvent < event.EventData
   properties
      eventType
      internalOrderID
      brokerOrderID
      timeStamp
      fullSymbol
      fillPrice
      fillSize
      exchange
      commission
   end
   methods
       function self = FillEvent()
           self.eventType = EventType.FILL;
       end
       function [position] = toposition(self)
           if self.fillSize > 0
               averagePriceIncludingCommission = self.fillPrice + self.commission ...
                   / retrievemultiplierfromfullsymbol(self.fullSymbol);
           else
               averagePriceIncludingCommission = self.fillPrice - self.commission ...
                   / retrievemultiplierfromfullsymbol(self.fullSymbol);
           end
           position = Position(self.fullSymbol, averagePriceIncludingCommission, self.fillSize);
       end
   end
end