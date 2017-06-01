clearvars( '-except', '-regexp', '^fig\d*$' );

	% -----------------------------------------------------------------------
	% a continuous test signal (sine with frequency f and length L)
	% -----------------------------------------------------------------------
f = 1; % signal frequency, EXERCISE!
L = 1;

x = @( t ) sin( 2*pi*f * t ); % continuous sine with frequency f

	% -----------------------------------------------------------------------
	% quantize the test signal (using sampling rate fS and nS bits/sample)
	% -----------------------------------------------------------------------
fS = 48; % sampling rate, EXERCISE!
nS = 3; % bits per sample, EXERCISE!

N = floor( L * fS ); % number of samples
ti = (0:N-1) / fS; % quantized time values
xi = round( (2^(nS-1)-1) * x( ti ) ) / (2^(nS-1)-1); % quantized amplitudes

	% -----------------------------------------------------------------------
	% reconstruct the signal from qunatization (Whittaker-Shannon)
	% THIS PART IS NOT IMPORTANT FOR FOLLOWING THE LECTURE!
	% -----------------------------------------------------------------------
dt = 1 / 2000; % temporal resolution
t = linspace( 0, L, L / dt );

for j = 1:numel( t )
	sincarg = (t(j) - ti) * fS; % sinc function
	sincarg(find( sincarg == 0)) = 1;
	sincval = sin( pi * sincarg ) ./ (pi * sincarg);

	xr(j) = sum( xi .* sincval ); % reconstructed amplitude
end

fR = sum( abs( diff( xr >= 0 ) ) ) / L / 2; % estimate frequency using zero-crossings rate

	% -----------------------------------------------------------------------
	% plot A/D conversion
	% THIS PART IS NOT IMPORTANT FOR FOLLOWING THE LECTURE!
	% -----------------------------------------------------------------------
if exist( 'fig1', 'var' ) ~= 1 || ~ishandle( fig1 ) % prepare figure window
	fig1 = figure( ...
		'Color', [0.9, 0.9, 0.9], 'InvertHardcopy', 'off', ...
		'PaperPosition', [0, 0, 8, 5], ...
		'defaultAxesFontName', 'DejaVu Sans Mono', 'defaultAxesFontSize', 16, 'defaultAxesFontWeight', 'bold', ...
		'defaultAxesNextPlot', 'add', ...
		'defaultAxesBox', 'on', 'defaultAxesLayer', 'top', ...
		'defaultAxesXGrid', 'on', 'defaultAxesYGrid', 'on' );
end

figure( fig1 ); % set and clear current figure
clf( fig1 );

set( fig1, 'Name', 'A/D CONVERSION' ); % set labels
title( get( fig1, 'Name' ) );

xlabel( 'time in seconds' );
ylabel( 'amplitude' );

xlim( [0, L] ); % set axes
ylim( [-1, 1] * max( abs( cat( 2, x( t ), xi, xr ) ) ) * 1.1 );

plot( t, x( t ), ... % plot continuous signal
	'Color', 'blue', 'LineWidth', 2 );

stem( ti, xi, ... % plot discrete signal
	'Color', 'red', 'LineWidth', 2, 'MarkerSize', 4, 'MarkerFaceColor', 'red', ...
	'ShowBaseLine', 'off' );

h = legend( ... % show legend
	{sprintf( 'continuous sine (%.1fHz)', f ), sprintf( 'quantization (%.1fHz, %dbit)', fS, nS )}, ...
	'Location', 'southeast' );
set( h, 'Color', [0.9825, 0.9825, 0.9825] );

%print( fig1, 'sampling_ad.eps', '-depsc2' );
	
	% -----------------------------------------------------------------------
	% plot D/A conversion
	% THIS PART IS NOT IMPORTANT FOR FOLLOWING THE LECTURE!
	% -----------------------------------------------------------------------
if exist( 'fig2', 'var' ) ~= 1 || ~ishandle( fig2 ) % prepare figure window
	fig2 = figure( ...
		'Color', [0.9, 0.9, 0.9], 'InvertHardcopy', 'off', ...
		'PaperPosition', [0, 0, 8, 5], ...
		'defaultAxesFontName', 'DejaVu Sans Mono', 'defaultAxesFontSize', 16, 'defaultAxesFontWeight', 'bold', ...
		'defaultAxesNextPlot', 'add', ...
		'defaultAxesBox', 'on', 'defaultAxesLayer', 'top', ...
		'defaultAxesXGrid', 'on', 'defaultAxesYGrid', 'on' );
end

figure( fig2 ); % set and clear current figure
clf( fig2 );

set( fig2, 'Name', 'D/A CONVERSION' ); % set labels
title( get( fig2, 'Name' ) );

xlabel( 'time in seconds' );
ylabel( 'amplitude' );

xlim( [0, L] ); % set axes
ylim( [-1, 1] * max( abs( cat( 2, x( t ), xi, xr ) ) ) * 1.1 );

stem( ti, xi, ... % plot discrete signal
	'Color', 'red', 'LineWidth', 2, 'MarkerSize', 4, 'MarkerFaceColor', 'red', ...
	'ShowBaseLine', 'off' );

plot( t, xr, ... % plot reconstructed signal
	'Color', 'blue', 'LineWidth', 2 );

h = legend( ... % show legend
	{'quantized signal', sprintf( 'reconstruction (~%.1fHz)', fR )}, ...
	'Location', 'southeast' );
set( h, 'Color', [0.9825, 0.9825, 0.9825] );

%print( fig2, 'sampling_da.eps', '-depsc2' );

