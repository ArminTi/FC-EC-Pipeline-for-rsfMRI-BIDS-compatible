function C = simulate_DMN_SC()

% DMN nodes: [mPFC PCC L-IPL R-IPL]

C = [
    0    0.9  0.4  0.4;
    0.9  0    0.8  0.8;
    0.4  0.8  0    0.6;
    0.4  0.8  0.6  0
];

% Normalize to [0,1]
C = C ./ max(C(:));

end
