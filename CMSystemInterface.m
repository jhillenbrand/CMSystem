% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DEPENDENCY
% @DATE: 28.12.2020
classdef CMSystemInterface < handle
    %CMSYSTEMINTERFACE 
    
    %% Abstract Methods    
    methods (Abstract)
        
        addTransformer(obj, dataTransformer);
        
        switchStrategy(obj, strategy);
        
        executeActiveStrategy(obj);
        
        addInterventor(obj, interventor);
        
        addReporter(obj, reporter);        
    end    
end

