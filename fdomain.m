clearvars( '-except', '-regexp', '^fig\d*$' );

	% -----------------------------------------------------------------------
	% discrete test signal (with base frequency f and length L)
	% -----------------------------------------------------------------------
f = 1; % base frequency, EXERCISE!
L = 1;

fS = 48; % sampling rate, EXERCISE!
N = floor( L * fS );

ti = (0:N-1) / fS; % quantized time values

xi = sin( 2*pi*f * ti ); % sine wave, EXERCISE!
%xi = sin( 2*pi*f * ti) + 0.5*sin( 2*pi*3*f * ti ); % mixed sines, EXERCISE!
%xi = 2*(2*floor( f * ti ) - floor( 2*f * ti ) + 1) - 1; % square wave, EXERCISE!
%xi = 2*(ti/f - floor( 1/2 + ti/f )); % sawtooth wave, EXERCISE!
%xi = 2*abs( 2*(ti/f - floor( 1/2 + ti/f )) ) - 1; % triangle wave, EXERCISE!

	% -----------------------------------------------------------------------
	% apply a phase shift to test signal
	% -----------------------------------------------------------------------
phase = 0; % phase shift in degrees, EXERCISE!
xi = circshift( xi, [0, round( f*fS*phase/360 )] );

	% -----------------------------------------------------------------------
	% Fourier transform the test signal
	% -----------------------------------------------------------------------
fNy = fS / 2; % Nyquist frequency

Xk = fft( xi ) / N; % complex Fourier coefficients

fk = (0:N-1) / N * fS; % frequency values
fk(fk >= fNy) = fk(fk >= fNy) - fS; % imply negative frequencies

	% -----------------------------------------------------------------------
	% compute the power spectral density (aka power spectrum)
	% -----------------------------------------------------------------------
Pk = abs( Xk ) .^ 2;

Pk(fk < 0) = []; % remove negative frequency components
Xk(fk < 0) = [];
fk(fk < 0) = [];

Pk(2:end) = 2 * Pk(2:end); % rescale to match total power
Xk(2:end) = sqrt( 2 ) * Xk(2:end);

	% -----------------------------------------------------------------------
	% re-composite signal from spectrum
	% THIS PART IS NOT IMPORTANT FOR FOLLOWING THE LECTURE!
	% -----------------------------------------------------------------------
dt = 1 / 2000; % temporal resolution
t = linspace( 0, L, L / dt );

xr = Xk(1) * ones( 1, numel( t ) );
for j = 2:numel( Xk )
	xr = xr + sqrt( 2 ) * sqrt( Pk(j) ) * sin( 2*pi*fk(j) * t ); % reconstruction from one-sided (real) spectrum
	%xr = xr + sqrt( 2 ) * (Xk(j) * exp( 2*pi*i*fk(j) * t ) ); % reconstruction from full (complex) spectrum
end
xr = real( xr );

	% -----------------------------------------------------------------------
	% plot Fourier decomposition
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

set( fig1, 'Name', 'FOURIER DECOMPOSITION' ); % set labels
title( get( fig1, 'Name' ) );

xlabel( 'time in seconds' );
ylabel( 'amplitude' );

xlim( [0, L] ); % set axes
ylim( [-1, 1] * max( abs( cat( 2, xi, xr ) ) ) * 1.1 );

stem( ti, xi, ... % plot discrete signal
	'Color', 'red', 'LineWidth', 2, 'MarkerSize', 4, 'MarkerFaceColor', 'red', ...
	'ShowBaseLine', 'off' );

plot( t, xr, ... % plot recomposed signal
	'Color', 'blue', 'LineWidth', 2 );

h = legend( {sprintf( 'discrete signal (%.1fHz, @%.1fHz)', f, fS ), 'recomposition from spectrum'}, ...
	'Location', 'southeast' );
set( h, 'Color', [0.9825, 0.9825, 0.9825] );

%print( fig1, 'fdomain_decomp.eps', '-depsc2' );

	% -----------------------------------------------------------------------
	% plot power spectrum
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

set( fig2, 'Name', 'POWER SPECTRUM' ); % set labels
title( get( fig2, 'Name' ) );

xlabel( 'frequency in hertz' );
ylabel( 'power' );

xlim( [0, floor( max( fk ) )+1] ); % set axes
ylim( [0, 1] * 1.1 );

stem( fk(Pk > eps), Pk(Pk > eps), ... % plot power spectrum
	'Color', 'red', 'LineWidth', 2, 'MarkerSize', 4, 'MarkerFaceColor', 'red', ...
	'ShowBaseLine', 'off' );

%print( fig2, 'fdomain_powspec.eps', '-depsc2' );

