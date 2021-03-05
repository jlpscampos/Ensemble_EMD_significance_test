# Ensemble Empirical Mode Decomposition Significance Test #

This project computes the Ensemble Empirical Decomposition (EEMD), and their significance test based on t-student distribution in two ways:
* (1) Given the time series' signal to noise ratio, it creates n amounts of surrogate time series and then, evaluates the EEMD and the significance test.
* (2) Given a signal with observational uncertainty previoulsy simulated, it evaluates the EEMD and the significance test (Suitable for paleoclimatic data).

This project uses some built in matlab functions. So, it is advisable to run this project with matlab versions after R2017a.

## How to run ##

* (i)  Create the surrogate time series or simulates the observational uncertainty. You can use the script sym_ts.m in folder resources.
* (ii) call the class EMD_timeseries as:

> EEMD = EMD_timeseries(time,serie,opt);

where time is the *time* axis, an array of float, integers or datetime object, *serie* is the input data and *opt* is the interpolating method 
for the envelope, opt can be '-pchip' for raw data and '-spline' for smoothed data 

* (iii) A figure for the significance test can be obtained by calling the function:

> plot_sign(EEMD, title, opt);

where *EEMD* is the Ensemble EMD object, title is the figure title string and *opt* is an option to plot the 95% confidence bound ellipsoid of 
the surrogates IMFs, opt can be '-1sigma' to show the ellipsoid and otherwise to not show.

### Example (1) - BTC price ###
See examples/BTC_price.mlx or BTC_price.m

### Example (2) - Holocene South American Paleoprecipitation ###
See examples/paleoprecipitation.mlx or paleoprecipitation.m

## Detailing ##

Empirical Mode Decomposition (EMD), decomposes a signal into a finite set of Intrinsic Mode Functions (IMFs) and residual series, with each IMF representing a scale of data variability, where the sum of the IMFs and the residual component represent the full data.

First of all, the time series upper and lower envelope is computed and thus, averaged and subtracted from the signal, generating a residual time series, this residual time series, becomes an IMF. So, the process above is repeated up to number of time series zero crossing or tolerance is no more verified.

The statistical significance test for the IMFs, will verify the capacity of the IMFs in representing signal band. If the band is too wide, one can say that the signal is "contaminated" with white noise, or that the IMF is unable to represent the signal in a given band. In physics and engineering studies is extremely important that the EMD
is able to decompose correctly the signal.


wavelet analysis, however without the fourier cons
