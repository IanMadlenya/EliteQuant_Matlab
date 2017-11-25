classdef (ConstructOnLoad) GeneralEvent < event.EventData
   properties
      eventType
      timeStamp
      content
   end
   methods
       function self = GeneralEvent()
           self.eventType = EventType.GENERAL;
       end
   end
end