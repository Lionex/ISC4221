function [ W ] = randwalk( I, D, S )
%RANDWALK axis-aligned random walk in n-dimensional space
%   RANDWALK by default performs a ramdom walk across a uniform grid until
%   the walk reaches the boundaries of a hypercube centered on the origin.
%
%   RANDWALK() performs a random walk on the domain [-10,10]x[-10,10],
%   taking steps of length 1 producing a 2D random walk.
%   RANDWALK(I) sets the initial point of the random walk, where I is a row
%   vector and NUMEL(I) sets the dimensions of the walk
%
%   RANDWALK(I, D) where D is scalar will stop the walk when it reaches
%   the boundaries of a hypercube with side-length 2*D centered on the
%   origin.
%   RANDWALK(I, D) where D is a matrix which defines the bounding
%   hyper-rectangle such that each row is the upper and lower bound of each
%   dimension of I.
%
%   RANDWALK(I, stop) where stop is a function handle will end the walk
%   when stop(W) evaluates to true, where W is the current row vector in
%   the random walk.  If stop returns a logical vector, when any element is
%   true the random walk will stop. By default, stop is defined as:
%
%       @(w) or(w'<=D(:,1)+0.1*S, w'>=D(:,2)-0.1*S)
%
%   Note that a margin of error is included to avoid issues with
%   non-integral step sizes and the ordinal operators <= and >= regarding
%   machine precision.
%
%   RANDWALK(I, D, S) takes axis-aligned steps of length S in all
%   directions
%
%   W = RANDWALK(...) produces matrix W where each row is a step in the
%   random walk.
%
%
%   Examples
%   2D random walk with domain [-5,10]x[-2,13] and initial point [0,0]
%
%       RANDWALK([0,0], [-5 10; -2 13])
%
%   3D random walk with initial point [1,2,3], which ends when the walk
%   reaches the boundary of the domain [-5,5]x[-5,5]x[-5,5]
%
%       RANDWALK([1,2,3], 5)
%
%   Plot a 2D and 3D random walk.
%
%       W = RANDWALK();
%       plot(W(:,1),W(:,2));
%       W = RANDWALK([0,0,0]);
%       plot3(W(:,1),W(:,2),W(:,3));
%
%   See also RAND, RANDI, RANDN, RNG, PLOT, PLOT3

%% Handle variadic arguments
if nargin < 1, I = [0 0]; end
if nargin < 2, D = 10; end % Build D matrix from Scalar value
if isscalar(D), D=repmat([-abs(D) abs(D)],[numel(I) 1]); end
if ismatrix(D) % Define stop function if one isn't user defined
    if size(D,1) ~= numel(I)
        error('Mismatched domain and initial point size');
    end
    % Add a margin of error by decreasing the bounds by a fraction of the
    % step size to avoid errors with floating point precision and the
    % conditional or ordinal operators, especially when using non-integral
    % step sizes.
    stop = @(w) or(w'<=D(:,1)+0.1*S, w'>=D(:,2)-0.1*S);
end
if nargin < 3, S = 1; end

%% Random walk

% Define a function which determines which direction to move along the axis
% in a random way
S = [-S S];
move = @() S(randi([1 2],1));

% Set W to initial value
W = I;

% Calculate random walk
while ~any(stop(W(end,:))) % Test last row of W
    % Pre-initialize v
    v = zeros(size(I));

    % Calcualte axis aligned move, replacing an element with -1 or 1
    v(randi([1 numel(I)],1)) = move();

    % Accumulate move over the last element of W and concatenate
    W = [W; W(end,:) + v];
end
