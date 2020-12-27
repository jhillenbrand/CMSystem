% AUTHOR: jonas.hillenbrand@kit.edu
% VERSION: v1.0
% DEPENDENCY:
classdef Subscriber < SubscriberInterface
    %SUBSCRIBER
                                 
    properties
        
    end
    
    methods
        function obj = Subscriber(name)
            if nargin < 1
                name = 'Subscriber-1';
            end
            obj.name = name;
            obj.id = string(java.util.UUID.randomUUID());
        end
    end
    
    methods 
        function update(obj, publisher)
            disp([obj.name ' received info from ' publisher.name ' its state changed to ' publisher.state]);
        end
    end
end

