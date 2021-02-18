% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DEPENDENCY CMStrategyInterface.m
% @DATE: 28.12.2020
classdef CMStrategy < CMStrategyInterface
    %CMSTRATEGY
    
    properties
        L = JLog();
        name = 'CMStrategy1';
    end
    
    methods
        function obj = CMStrategy(name)
            obj.name = name;
        end
    end
    
    methods (Abstract)
        out = execute(obj, cmSystem);
    end
end

