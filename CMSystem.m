% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DEPENDENCY CMSystemInterface.m, JLog.m, Transformer.m, Reporter.m, Interventor.m
% @DATE 28.12.2020
classdef CMSystem < CMSystemInterface
    %CMSYSTEM
    
    %% properties
    properties 
        name = '';
        transformers = [];
        strategies = {};
        activeStrategy = [];
        reporters = [];        
        interventors = [];
    end
    
    %% setting properties
    properties
        saveToFilePath = 'cmsystem_save.mat';
    end
    
    %% Constructor Method
    methods
        %% - CMSystem
        function obj = CMSystem()
            %CMSYSTEM
            
        end
    end
    
    %% Interface Methods
    methods (Abstract)
        start(obj);
    end
    
    %%
    methods
        function addTransformer(obj, transformer)
            if class(Transformer()) == class(transformer)                
                obj.transformers = [obj.transformers; transformer];
            else
                error(['transformer must be of type ' class(Transformer())]);
            end
        end
        
        function switchStrategy(obj, strategyName)
            strategy = obj.getStrategyByName(strategyName);
            if ~isempty(strategy)
                obj.activeStrategy = strategy;
            else
                error(['strategy ' strategyName ' does not exist.']);
            end
        end
        
        function executeActiveStrategy(obj)
            obj.activeStrategy.execute(obj);
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
                strategy = obj.strategies{s};
                if strcmp(strategy.name, strategyName)
                    foundStrategy = strategy;
                    return;
                end
            end
        end
        
        function addStrategy(obj, strategy)
            if isempty(obj.strategies)
                obj.strategies = {strategy};
            else
                obj.strategies = [obj.strategies; {strategy}];
            end  
        end
        
        function saveToFile(obj)
            save(obj.saveToFilePath, 'obj');
        end
        
        function buildFromFile(obj)
            mat = load(obj.saveToFilePath);
            obj = mat.obj;
        end
    end
end

