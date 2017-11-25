classdef (ConstructOnLoad) BarEvent < event.EventData
   properties
      eventType
      barStartTime
      interval
      fullSymbol
      openPrice
      highPrice
      lowPrice
      closePrice
      adjClosePrice
      volume
   end
   methods
       function self = BarEvent()
           self.eventType = EventType.BAR;
           self.interval = 86400;  % 1day in secs = 24hrs * 60min * 60sec
       end
       function [barEndTime] = barendtime(self)
           barEndTime = self.barStartTime;
       end
   end
end