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
    
    methods (Abstract)
        execute(obj, cmSystem);
    end
end

