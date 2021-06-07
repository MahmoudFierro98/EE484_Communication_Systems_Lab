function [fadedSamples, gain]=ApplyFading(inputSamples, fadingModel, maxDelaySpreadInSamples) 

    % fadingModel = 0 is no fading
    % fadingModel = 1 is uniform profile
    
    numPaths=maxDelaySpreadInSamples;
    if fadingModel == 0
        % No fading is applied, go back
        fadedSamples = inputSamples ;
        gain=1;
        return
    elseif fadingModel == 1 
     % Uniform Power Profile  
        variance(1:numPaths)=1/numPaths ;
    end
    
    variance=variance/sum(variance);
    sumPower=sum(variance) ;
    gain(1:numPaths)=(randn(1,numPaths)+ j*randn(1,numPaths)) .* sqrt(variance(1:numPaths)/2);
    fadedSamples=conv(inputSamples, gain);
     
 end