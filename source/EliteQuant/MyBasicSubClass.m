% c = MyBasicSubClass(7)
classdef MyBasicSubClass < MyBasicClass
   properties
      vy
   end
   methods (Access = public)
      function self = MyBasicSubClass(val)
          if nargin == 0
              
          end
         self@MyBasicClass(val);
         if nargin > 0
            self.vy = val+1;
         end
      end
      
      function printString(self)
          disp('Hello SubClass');
      end
   end
end