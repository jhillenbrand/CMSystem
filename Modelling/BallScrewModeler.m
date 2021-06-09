classdef BallScrewModeler < Modeler
    %BallScrewModeler 
    
    properties
        ballscrew = BallScrew.empty
        
        % csv column defs
        timeColumn = 1;
        speedColumn = 2;
        forceColumn = 5;
        
        % modes (1 = lifetime, 2 = frequency)
        mode = 1;
        periodOutput = false;
    end
    
    methods
        function obj = BallScrewModeler(ballscrew)
            obj.ballscrew = ballscrew;
        end                 
    end
    
    %% Interface Methods
    methods 
        function newData = transform(obj, data)
            switch (obj.mode)
                case 1
                    newData = obj.executeLifetimeMode(data);
                    
                case 2
                    newData = obj.executeFrequencyMode(data);
                    
                otherwise
                    error(['unknown mode [' num2str(obj.mode) ']'])
            end
            
        end
    end
    
    %% Mode Methods
    methods
        function newData = executeLifetimeMode(obj, data)
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
            
                newData = [ts, obj.ballscrew.F_m, obj.ballscrew.n_m, obj.ballscrew.Revolutions / obj.ballscrew.L_10 * 100];
            elseif isvector(ts)
                obj.ballscrew.updateLifeCycleInformation(ts, fa, sp);
                
                newData = [mean(ts), obj.ballscrew.F_m, obj.ballscrew.n_m, obj.ballscrew.Revolutions / obj.ballscrew.L_10 * 100];
            end
        end
        
        function newData = executeFrequencyMode(obj, data)
            f_s = abs(data(:, obj.speedColumn) / 60);
            f_b_n = obj.ballscrew.getNutEntryFrequency(f_s);
            f_b_s = obj.ballscrew.getSpindleEntryFrequency(f_s);
            t_d_s = obj.ballscrew.L ./ obj.ballscrew.getFeedVelocity(f_s);
            f_b = obj.ballscrew.getBallRotationFrequency(f_s);
            f_b_t = obj.ballscrew.getBallCirculationFrequency(f_s);
            
            if obj.periodOutput
                newData = [1 ./ f_s, 1 ./ f_b_n, 1 ./ f_b_s, t_d_s, 1 ./ f_b, 1 ./ f_b_t];
            else               
                newData = [f_s, f_b_n, f_b_s, 1 ./ t_d_s, f_b, f_b_t];
            end
        end
    end
end

