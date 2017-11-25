% a = MyBasicClass(5)
% a.vx = 0
classdef MyBasicClass < handle
   properties
      vx
   end
   methods (Access = public)
      function self = MyBasicClass(val)
         if nargin > 0
            self.vx = val;
         end
      end
      
      function printString(self)
          disp('Hello Base');
      end
   end
end