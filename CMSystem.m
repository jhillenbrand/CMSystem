% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DEPENDENCY CMSystemInterface.m, JLog.m, Transformer.m, Reporter.m, Interventor.m
% @DATE 28.12.2020
classdef CMSystem < CMSystemInterface
    %CMSYSTEM
    
    %% properties
    properties
        L = JLog(); 
        name = '';
        transformers = [];
        strategies = [];
        activeStrategy = [];
        reporters = [];        
        interventors = [];
    end
    
    %% Constructor Method
    methods
        %% - CMSystem
        function obj = CMSystem()
            %CMSYSTEM
            
        end
    end
    
    %% Setup Methods
    methods
        
    end
    
    %% Interface Methods
    methods
        function addTransformer(obj, transformer)
            if class(Transformer()) == class(transformer)                
                obj.transformers = [obj.transformers; transformer];
            else
                obj.L.log('ERROR', ['transformer must be of type ' class(Transformer())]);
            end
        end
        
        function switchStrategy(obj, strategyName)
            strategy = obj.getStrategyByName(strategyName);
            if ~isempty(strategy)
                obj.activeStrategy = strategy;
            else
                obj.L.log('ERROR', ['strategy ' strategyName ' does not exist.']);
            end
        end
        
        function executeActiveStrategy(obj)
            obj.activeStrategy.execute(obj);
        end
        
        function addReporter(obj, reporter)
            if class(Reporter()) == class(reporter)
                obj.reporters = [obj.reporters; reporter];
            else
                obj.L.log('ERROR', ['reporter must be of type ' class(Reporter())]);
            end
        end
        
        function addInterventor(obj, interventor)
            if class(Interventor()) == class(interventor)
                obj.interventor = [obj.interventor; interventor];
            else
                obj.L.log('ERROR', ['interventor must be of type ' class(Interventor())]);
            end
        end
    end
    
    %% Public Helper Methods
    methods
        %% - getStrategyByName
        function foundStrategy = getStrategyByName(obj, strategyName)
            %GETSTRATEGYBYNAME(obj, strategyName) returns the strategy
            %   object within obj.strategies given by name strategyName
            foundStrategy = [];
            for s = 1 : length(obj.strategies)
                strategy = obj.strategies(s);
                if strcmp(strategy.name, strategyName)
                    foundStrategy = strategy;
                    return;
                end
            end
        end
    end
end

