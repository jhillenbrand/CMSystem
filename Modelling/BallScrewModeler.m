classdef BallScrewModeler < Modeler
    %BallScrewModeler 
    
    properties
        ballscrew = BallScrew.empty
    end
    
    methods
        function obj = BallScrewModeler(ballscrew)
            obj.ballscrew = ballscrew;
        end                 
    end
    
    %% Interface Methods
    methods 
        function newData = transform(obj, data)
            
            ts = data(:, 1);
            sp = data(:, 2);
            fa = data(:, 5) * 1000;
            
            
            obj.ballscrew.updateLoad(ts, sp, fa);
            obj.ballscrew.updateL10();
            obj.ballscrew.updateRUL();
            
            if obj.ballscrew.EndTimeStamp == 0
                obj.ballscrew.EndTimeStamp = ts;
            end
            
            newData = [ts, obj.ballscrew.L_10, obj.ballscrew.Revolutions / obj.ballscrew.L_10 * 100];            
        end
    end
end

