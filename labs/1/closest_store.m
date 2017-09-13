%% Closest Store
% Gwen Lofman, ISC4221C, Lab #1
%%

%% Load data from file

S = textscan(fopen('stores_location.dat','r'),'%s %s %f %s %f %s');
T = S{2};
L = deg2rad([ S{3} S{5} ]);
clear S;

%% Ask user for a city

% get the name of the city from user
disp('Of the following cities:\n');
for t=1:numel(T), fprintf('\t%d: %s\n',t,T{t}); end
city = input('select one:\n>> ');

clear t;

%% Sort data based on desired results

t = 0;
if isscalar(city)
    t = city;
else
    % Use city text to find the index
    t = 1;
    while t <= numel(T) && ~strcmp(city,T{t}), t = t+1; end
end

if t > numel(T), error('city %s not found', city); end

% Grab the lat-long values of the current city, and use it to define sort
% criteron
D=L(t,:);
comp = @(L1,L2) havdist(L1,D) < havdist(L2,D);

[L, I] = select_sort(L, comp);

fprintf('The closest store locations are:\n');
for t=1:numel(T)
    fprintf('\t%d: %s\t%f miles\n',I(t),T{I(t)},havdist(L(t,:),D,3959));
end
