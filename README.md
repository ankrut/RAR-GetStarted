# RAR-GetStarted
Quick introduction how to calculate and plot RAR solutions.

# Install
Simply clone (or download) the repository. Then set the root folder of the project as the workspace in Matlab. You should see the three subfolders (+lib, +view, export).

The *lib* folder contains the core files of the framwork. DO NOT CHANGE ANYTHING THERE UNLESS YOU KNOW WHAT YOU DO!

The *view* folder contains one view-project where the RAR solutions are calculated and the density profiles plotted.

The plotted figure then is saved as a PDF file in the *export* folder.

# Quick start
Call the following command

````matlab
view.radius_density.main
````

to see a family of RAR density profiles.

# Calculate RAR solution
The RAR solutions are calculated in the file *view.radius_density.cache* and cached in the file *CACHE.mat* which is in the same subfolder. Therefore, to calculate and cache a family of RAR solutions simply call

````matlab
view.radius_density.cache
````
Now, let's check that file in more detail. Keep in mind that RAR solution needs 4 parameters: the particle mass *m*, the temperature parameter *beta0*, the degeneracy parameter *theta0* and the cutoff parameter *W0*. In order to set the particle mass we load the CONSTANTS package

````matlab
CONST = lib.require(@lib.module.constants);
````

which allows us to set the particle mass *m* in units of keV. In next we define an inline-function

````matlab
fModel = @(beta0, theta0, W0) struct(...
	'param',	struct('m', 48*CONST.keVcc, 'beta0', beta0, 'theta0', theta0, 'W0', W0),...
	'options',	struct('xmax', 1E15, 'tau', 1E-16, 'rtau', 1E-4)...
);
````

which generates a structure with information necessary to calculate a RAR solution for a given particle mass. The input arguments are therefore *beta0*, *theta0* and *W0* to keep it simply. The structure requires also some parameter for the ODE solver such as *xmax* which tells how far in radius should be integrated. The other parameters *tau* and *rtau* are accuracy parameters for the absolute and relative tolerance. Note, the default *options* parameters are sufficient in general.

In next we have to set a family of RAR parameters. For simplicity we consider only different *theta0* values, given in an array

````matlab
THETA0 = lib.module.array([0 2 5 10 15 20]);
````

The *lib.module.array* object creats of a list of a given array [...]. That objects provides several useful methods which are inspired by the JavaScript Array object. Here, we need only the map method which maps a *theta0* value to the RAR solution for given *m*, *beta0* and *W0*. The inline-function

````matlab
fMap = @(theta0) lib.model.tov.rar.profile('model', fModel(1E-6,theta0,150));
````

does exactly the mapping *theta0* -> RAR solution for one *theta0* value. The next line

````matlab
TBL.profiles = THETA0.map(fMap);
````

then does the mapping for each *theta0* value in the *THETA0* array and returns a new array where each entry is the corresponding RAR solution. Note that a RAR solution is given by the command *lib.model.tov.rar.profile* which requires a model structure as input in the key-value scheme. Here, 'model' is the key and *fModel(1E-6,theta0,150)* is the value.

Finally, the calculated RAR solutions are saved in a file via

````matlab
lib.save('+view/+radius_density/CACHE.mat',TBL);
````

# Plot RAR solutions
After calculating a family of RAR solutions we want now to plot their density profiles. This is done via

````matlab
view.radius_density.main
````

Let's take a closer look. The first few lines

````matlab
TBL	= load('+view/+radius_density/CACHE.mat');
AXIS	= lib.require(@lib.model.tov.rar.axes.astro);
fh	= lib.require(@view.radius_density.figure);
````
basically load the cached RAR solutions, an axis package to get variables in astro units (e.g. radius in pc and density in Msun/pc³) and a figure object (which is hidden initially). We show the figure with 

````matlab
figure(fh);
````

what sets automatically the focus to the figure and its axes object. To plot a RAR solution we set first an inline-function

````matlab
fPlot = @(p) lib.view.plot.curve2D(...
	'data', p,...
	'x',	AXIS.radius,...
	'y',	AXIS.density,...
	'plot', {...
		'DisplayName',	lib.sprintf('$\theta_0 = %d$', p.data.theta0) ...
	}...
);
````

and afterwards we plot all RAR solutions with

````matlab
TBL.profiles.forEach(fPlot);
````

Here, the RAR solutions are stored in *TBL.profiles*. Each solution is plotted as a curve with the method *lib.view.plot.curve2D*. This method requires here at least three arguments (in the key-value scheme): a profile *p* as 'data' argument and two axis objects for the 'x' and 'y' arguments. An axis object does the mapping *p* -> double-array. In this example the *AXIS.radius* object maps to an array of radius values (in astro units) and *AXIS.density* object maps to an array of density values (in astro units, too). The optional argument 'plot' specifies the Chart Line Properties (just like for the native *plot* function). Here, we indicate each curve with the *theta0* value in the DisplayName property.

Finally, we show the legend with 

````matlab
lib.view.plot.legend([],'location','northeast');
````

and save the figure (as a pdf)

````matlab
lib.view.file.figure(...
	'figure',	fh,...
	'filepath',	'export/radius-density',...
	'type',		'pdf' ...
);
````

Note, that Matlab's legend function uses the information in the DisplayName property.
