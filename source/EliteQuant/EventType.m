classdef EventType < int32
   enumeration
      TICK (0)
      BAR (1)
      ORDER (2)
      FILL (3)
      CANCEL (4)
      ACCOUNT (5)
      POSITION (6)
      TIMER (7)
      GENERAL (8)
   end
end