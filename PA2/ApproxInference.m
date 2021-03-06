%APPROXINFERENCE Computes approximate inference on cluster graphs.
%   M = APPROXINFERENCE(G, F, E) performs inference given a cluster graph, G,
%   factors, F and evidence, E. Returns a set of factors containing
%   the marginal probabilities over each variable in T.
%   The cluster graph data structure, G, has the following fields:
%       .names  Cell array containing the names of each variable [M]
%       .dim    Vector containing dimensionality of each variable [M]
%       .nodes  Cell array of variables in each clique [N]
%       .edges  Adjacency graph for clique tree [N-by-N]
%   The factor data structure, F, has the following fields:
%       .var    Vector of variables in the factor, e.g. [1 2 3]
%       .dim    Vector of dimensions corresponding to .var, e.g. [2 2 2]
%       .val    Value table of size prod(.dim)
%   The evidence vector, E, is a vector the same length as T.names, where
%   an entry of 0 means unobserved.
%
%   See also OBSERVEEVIDENCE, CLUSTERGRAPHCALIBRATE

% CS228 Probabilistic Models in AI (Winter 2007)
% Copyright (C) 2007, Stanford University

function M = ApproxInference(G, F, E);

% observe the evidence
for i = 1:length(E),
    if (E(i) > 0),
        F = ObserveEvidence(F, [i, E(i)]);
    end;
end;

% calibrate the cluster graph
P = ClusterGraphCalibrate(G, F);

% compute marginals on each variable
M = repmat(struct('var', 0, 'dim', 0, 'val', []), length(G.names), 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Populate M so that M(i) contains the marginal probability over
% variable i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(M),
    pIdx = FindPotentialWithVariable(P,i);
    M(i) = FactorMarginalization(P(pIdx), setdiff(P(pIdx).var,i));
    M(i).val = M(i).val/sum(M(i).val);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return;

% FindPotentialWithVariable -----------------------------------------
function indx = FindPotentialWithVariable(P, V);

indx = 0;
for i = 1:length(P),
    if (any(P(i).var == V)),
        indx = i;
        return;
    end;
end;

return;
