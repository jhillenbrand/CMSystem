classdef LearnableInterface < handle
    %LEARNABLEINTERFACE 
    
    properties
        hasLearned = false;
    end
    
    methods
        learn(obj, data);
    end
end

