
% Unknown Model Parameters ------------------------------------------------

% NPZ parameters
MU    = 2.0;
K     = 0.5;
G     = 1.0;
GAMMA = 0.9;
EP    = 0.02;
EZ    = 0.01;
EP_   = 0.1;
EZ_   = 0.1;

THETA = [MU; K; G; GAMMA; EP; EZ; EP_; EZ_];
theta = transform_state(THETA);

% First guess -----------------
theta0 = theta;
sqTheta = 0.06 * eye(8); 

% Known Model Parameters --------------------------------------------------

% Phi Auto-Regressive Coefficient
alpha = .7;

% Known Observations Parameters -------------------------------------------

% Conversion rate phytoplankton -> Chl
C = 2;
c = log(C);

% True State Initialization -----------------------------------------------

phi0 = 0.1;
N0 = .1;
P0 = .1;
Z0 = .01;
x0 = [log(N0); log(P0); log(Z0); phi0];

% First guess -------------
x0b = x0;
sqB = 0.06 * eye(4);

% Model function ----------------------------------------------------------

npz = @(x, theta) npz(x, theta, alpha);
Nx = size(x0, 1); % nb of state

% Observation function ----------------------------------------------------

H = zeros(1, Nx); H(2) = 1;
h   = @(x, c) H * x + c;
No = 1;   % nb of obs

% True Model Noise --------------------------------------------------------

sigma_phi = 0.05; % phi model noise
sigma_x = 0.032 * ones(3,1); % CI of ± 5% around model forecast
sqQ = diag([sigma_x; sigma_phi]);

% True Observation noise --------------------------------------------------

sigmao = 0.06;           % obs noise deviation, CI of ± 10% around true value
sqR    = sigmao*eye(No); % obs noise covariance

% Simulation parameters ---------------------------------------------------

T  = 30; % nb of time steps

% EnKS/KS parameters ------------------------------------------------------

Ne = 100;