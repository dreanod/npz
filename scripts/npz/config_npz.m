% Model Parameters ------------------------------------------------

% Known --------------------
% NPZ parameters
MU    = 2.0;
K     = 0.5;
G     = 1.0;
GAMMA = 0.9;
EP    = 0.02;
EZ    = 0.01;
EP_   = 0.1;
EZ_   = 0.1;
alpha = .7; % Phi Auto-Regressive Coefficient
THETA = [MU; K; G; GAMMA; EP; EZ; EP_; EZ_];
theta = [transform_state(THETA); alpha];

% Observations Parameters -------------------------------------------

% Known ----------------------
% Conversion rate (phytoplankton -> Chl)
C = 2;
c = log(C);

% State Initialization ---------------------------------------------------

% Truth
phi0 = 0.1;
N0 = .1;
P0 = .1;
Z0 = .01;
x0 = [log(N0); log(P0); log(Z0); phi0];
Nx = size(x0, 1); % nb of state

% First Guess
sqB = 0.05 * eye(Nx);
x0 = x0 * 1.05;

% Model function ----------------------------------------------------------

npz = @(x, theta, alpha) npz_predict2(x, alpha(1:end-1), alpha(end));

% Observation function ----------------------------------------------------

H = zeros(1, Nx); H(2) = 1;
h = @(x, c) H * x + c;
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

% Ensemble parameters -----------------------------------------------------

Ne = 100; % Ensemble size