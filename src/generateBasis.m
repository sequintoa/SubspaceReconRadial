function [basis, U] = generateBasis(seqParams, numCoeff)
% generate the basis vectors based on the t2 decay model for reconstruction
% using the REPCOM model
%
% Mahesh Keerthivasan
% April 2016

%% Generate the library of curves assuming single exponential model

T2List = linspace(10,300,100);
I0List = linspace(0.01,1.0,30);

signalLib = zeros(length(T2List)*length(I0List),seqParams.etl);
TE = seqParams.esp:seqParams.esp:seqParams.esp*seqParams.etl;

id = 1;
for id1 = 1 :length(T2List)
    for id2 = 1 : length(I0List)
        I0 = I0List(id2); T2 = T2List(id1);
        signalLib(id,:) = I0 .* exp(-TE./T2);
        id = id + 1;
    end
end

%% Compute subspace basis using SVD
[U,~,~] = svd((signalLib.')*(signalLib));

%% Reduced dimension subspace
basis = U(:,1:numCoeff);



end
