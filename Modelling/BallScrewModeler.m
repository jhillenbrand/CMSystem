classdef BallScrewModeler < Modeler
    %BallScrewModeler 
    
    properties
        ballscrew = BallScrew.empty
        
        % csv column defs
        timeColumn = 1;
        speedColumn = 2;
        forceColumn = 5;
    end
    
    methods
        function obj = BallScrewModeler(ballscrew)
            obj.ballscrew = ballscrew;
        end                 
    end
    
    %% Interface Methods
    methods 
        function newData = transform(obj, data)
            
            ts = data(:, obj.timeColumn);
            sp = data(:, obj.speedColumn);
            fa = data(:, obj.forceColumn) * 1000;
            % check if data is 1D or 2D
            if isscalar(ts)           
            
                obj.ballscrew.updateLoad(ts, sp, fa);
                obj.ballscrew.updateL10();
                obj.ballscrew.updateRUL();

                if obj.ballscrew.EndTimeStamp == 0
                    obj.ballscrew.EndTimeStamp = ts;
                end
            
                newData = [ts, obj.ballscrew.L_10, obj.ballscrew.Revolutions / obj.ballscrew.L_10 * 100];
            elseif isvector(ts)
                obj.ballscrew.updateLifeCycleInformation(ts, fa, sp);
                
                newData = [mean(ts), obj.ballscrew.L_10, obj.ballscrew.Revolutions / obj.ballscrew.L_10 * 100];
            end
        end
    end
end

