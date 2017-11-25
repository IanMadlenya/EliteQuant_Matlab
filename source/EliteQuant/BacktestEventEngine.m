classdef BacktestEventEngine < handle   
    properties (SetAccess = public)
        active
        queue
        dataFeed
    end
    events
        eTick
        eBar
        eOrder
        eFill
        eCancel
        eAccount
        ePosition
        eTimer
        eGeneral
    end
    
    methods
        function self = BacktestEventEngine(dataFeed)
            self.active = true;
            self.queue = SimpleQueue();
            self.dataFeed = dataFeed;
        end
        
        function run(self)
            disp('Running Backtest...')
            
            self.queue.reset();
            self.dataFeed.reset();
            self.active = true;
            
            while(self.active)
                event = self.queue.pop();
                if (isempty(event))
                    event = self.dataFeed.streamnext();
                    if (isempty(event))
                        self.active = false;
                    else
                        self.queue.push(event);
                    end
                else  % call event listener
                    switch event.eventType
                        case EventType.TICK
                            notify(self,'eTick',event);
                        case EventType.BAR
                            notify(self,'eBar',event);
                        case EventType.ORDER
                            notify(self,'eOrder',event);
                        case EventType.FILL
                            notify(self,'eFill',event);
                        case EventType.CANCEL
                            notify(self,'eCancel',event);
                        case EventType.ACCOUNT
                            notify(self,'eAccount',event);
                        case EventType.POSITION
                            notify(self,'ePosition',event);
                        case EventType.TIMER
                            notify(self,'eTimer',event);
                        case EventType.GENERAL
                            notify(self,'eGeneral',event);
                    end
                end
            end
        end
        
        function push(self, event)
            self.queue.push(event);
        end
    end
end