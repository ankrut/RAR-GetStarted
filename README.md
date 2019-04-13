# RAR-GetStarted
Quick introduction how to calculate and plot RAR solutions.

### Disclaimer
This project is still in an alpha status. Although it produces good results the code requires some clean-up, better consistency and less dependencies between the different modules. It is therefore possible that some functions, properties and workflows will slightly change in future.

# Install
Simply clone (or download) the repository. Then set the root folder of the project as the workspace in Matlab. You should see the two subfolders (+lib, +script).

The `lib` folder contains the core files of the framwork. **DO NOT CHANGE ANYTHING THERE UNLESS YOU KNOW WHAT YOU DO!**

The `script` folder contains three examples. The first example `calc` describes how RAR solutions are calculated while the second example `plot` shows how to visualize the results (e.g. in a radius vs. density plot). The other example `find` shows how to obtain the right parameter for a given set of constraints, aka how to find a particular solution.

# Quick start
Call the following commands

````matlab
script.calc.main
script.plot.main
````

to calculate and visualize a family of RAR density profiles.

# Calculate RAR solution

````matlab
script.calc.main
````
Let's check that file in more detail. Keep in mind that a RAR solution needs 4 parameters: the particle mass `m`, the temperature parameter `beta0`, the degeneracy parameter `theta0` and the cutoff parameter `W0`. Additionally, few more parameters are requiered for the ode solver. All of them are optional and default values do a good job in most cases. However, in this example two option parameters are emphasized: the outer bound for the integration `xmax` and the relative tolerance `RelTol`. In some cases it is necessary to decrease the tolerance or increase the range to obtain the full solution.

In order to set the particle mass we load the `constants` package

````matlab
CONST = lib.ecma.require(@lib.physics.constants);
````

which allows us to describe the particle mass `m` in units of keV/c². In next we define an inline-function as a helper

````matlab
fModel = @(beta0, theta0, W0) struct(...
	'm', 48*CONST.keVcc,...
	'beta0', beta0,...
	'theta0', theta0,...
	'W0', W0,...
	'xmax', 1E15
	'RelTol', 1E-6...
);
````

which generates a structure with information necessary to calculate a RAR solution for a given particle mass. The input arguments are therefore `beta0`, `theta0` and `W0` to keep it simple. The structure may contain also optional parameters for the ODE solver such as `xmax` (default is 1E15, in system units) which tells how far in radius should be integrated. Other useful parameters are `AbsTol` (default 1E-15) and `RelTol` (default 1E-6) are accuracy parameters for the absolute and relative tolerance. Note, the default parameters are sufficient in general. More important is that `RelTol` should not be greater than 1E-6 or the ode solver may stop at the pleatau. In this case try to decrease the value, e.g. 1E-8.

In next we have to set a family of RAR parameters. For simplicity we consider only different `theta0` values, given in an array

````matlab
THETA0 = lib.ecma.array([0 2 5 10 15 20]);
````

The `lib.ecma.array` object creates a list of a given array `[...]`. That object provides several useful methods which are inspired by the JavaScript Array object. Here, we need only the map method which maps a `theta0` value to the RAR solution (e.g. radius, potential, mass) for given `m`, `beta0` and `W0`. The inline-function

````matlab
fMap = @(theta0) lib.model.cRAR.profile('model', fModel(1E-6,theta0,150));
````

does exactly the mapping `theta0` -> *RAR solution* for one `theta0` value while `beta0 = 1E-6` and `W0 = 150` are fixed. The next line

````matlab
STORE.profiles = THETA0.map(fMap);
````

then does the mapping for each `theta0` value in the `THETA0` array and returns a new array where each entry is the corresponding RAR solution. Note that a RAR solution is given by the command `lib.model.cRAR.profile` which requires a model structure as input in the key-value scheme. Here, `model` is the key and `fModel(1E-6,theta0,150)` is the value.

Finally, the calculated RAR solutions are saved in a file via

````matlab
lib.view.file.mat('+script/+calc/STORE.mat',STORE);
````

# Plot RAR solutions
After calculating a family of RAR solutions we want now to plot their density profiles. This is done via

````matlab
script.plot.main
````

Let's take a closer look. The first few lines

````matlab
STORE	= load('+script/+calc/STORE.mat');
RENDER	= lib.ecma.require(@script.plot.render);
FIG	= lib.ecma.require(@script.plot.figure);
````
basically load the cached RAR solutions, a renderer package and a figure object (which is hidden initially). We show the figure with 

````matlab
figure(FIG);
````

what sets automatically the focus to the figure and its axes object. To plot a RAR solution we set an inline-function. This is done separately in the `render` package, e.g.

````matlab
@(p) lib.view.plot.curve2D(...
	'data', p,...
	'x',	AXIS.radius,...
	'y',	AXIS.density,...
	'plot', {...
		'DisplayName',	lib.char.sprintf('$\theta_0 = %d$', p.data.theta0) ...
	}...
);
````
Here, an axis package is used to get variables in astro units (e.g. radius in pc and density in Msun/pc³). It is possible to add or modify the renderer.

Having a solution (e.g. an *object*) and a corresponding render (e.g. a *view*) for a figure object (e.g. a *medium*), we plot each solution via

````matlab
STORE.profiles.forEach(fPlot);
````

Here, the RAR solutions are stored in `STORE.profiles` and each solution is plotted as a curve with the method `lib.view.plot.curve2D`. This method requires at least three arguments (in the key-value scheme): a RAR solution `p` as `data` argument and two axis objects for the `x` and `y` arguments. An axis object does the mapping `p` -> *double-array*. In this example the `AXIS.radius` object maps to an array of radius values (in astro units) and `AXIS.density` object maps to an array of density values (in astro units, too). The optional argument 'plot' specifies the `Chart Line` Properties (just like for the native Matlab `plot` function). Here, we indicate each curve with the `theta0` value in the `DisplayName` property. Thus, `curve2D` is simply speaking a wrapper for the Matlab's `plot` function.

Finally, we show the legend with 

````matlab
lib.view.plot.legend([],'location','northeast');
````

and save the figure (as a pdf)

````matlab
saveas(FIG, '+script/+plot/figure.pdf');
````

Note, that Matlab's legend function uses the information in the DisplayName property.


# Constrain solutions and find RAR parameter
After getting familar how RAR solutions are obtained (`calc`) and visualized (`plot`), the next important workflow to know is how to constrain solutions and find the corresponding parameter - aka how to find a solution. In the following example we are interested, simply speaking, in the mapping `Mc` -> `p` with `Mc` being the core mass (4.2E6 Msun) and `p` the RAR solution. Technically speaking, we need one more step in between, e.g. `Mc` -> `beta0` -> `p` because the RAR solution is described through the RAR model parameters (`m`, `beta0`, `theta0`, `W0`). Note that we have here in this example only one constraint, `Mc` = 4.2E6 Msun, which allows us to constrain only one parameter, e.g. `beta0`, for given other parameters.

For the first step there are three possible methods available, each with its pros and cons. In general, the non-linear fitting method `nlinfit` is convenient for most cases. Only for special cases other methods, especially a combination of them, is necessary. We limit this example to the numerically stable regime without strong cutoff (e.g. `Wp` > 1 with `Wp` the cutoff value at the plateau).

A quick run to find `beta0` for a given core mass `Mc` = 4.2E6 Msun and (arbitrary) given RAR parameters (`m`, `theta0`, `W0`) is done with 

````matlab
script.find.nlinfit
````

This will store a `model` struct with the right RAR parameter corresponding to the constraint core mass `Mc`. Additionally, a profile container `p` contains the RAR solution which can be used for further post-processing.

Now let's take a closer look of the file `script.find.nlinfit`.

First, we need to load the necessary packages, such as physical constants, RAR axes and RAR anchors.

````matlab
CONST	= lib.ecma.require(@lib.physics.constants);
AXES	= lib.ecma.require(@lib.model.cRAR.axes.astro);
ANCH	= lib.ecma.require(@lib.model.cRAR.anchor);
````

`CONST` and `AXES` should be clear from the example above. The new introduced package is the anchor package which allows to calculate, for instance, the density in a given unit system at an anchor what is a predefined particular point. In detail, we need the core anchor because the core mass is defined at the first maximum in the rotation curve {r,v(r)}. Such definitions of particular scale invariant points are called 'anchors' here.

Without going to deep into the idea of the anchor packages, the only required information are a seed model struct and the definition of a the core mass constraint. The seed we simply store in a variable `modelSeed` with

````matlab
modelSeed = struct(...
	'm',      48*CONST.keVcc,...
	'beta0',  1E-5,...
	'theta0', 38,...
	'W0',     70,...
	'RelTol', 1E-9
);
````

In this example the chosen values are very close to the required solution. Sometimes it is necessary to adjust the seed parameter manually if the finding method fails.

After setting the initial seed parameters we need to define the core mass constraint. Technically speaking it is called here a `response`.

````matlab
fMcore = @(obj) AXES.mass.map('data', obj, 'anhor', ANCH.velocity_core);
response = lib.profile.response('map', fMcore, 'prediction', 4.2E6);
````

The function `lib.profile.response` requires two parameter in the key-value scheme. `map` excpects an inline function which does the mapping *obj* -> *double* with *obj* being a RAR solution. In other words it *responds* to a given solution. The second property is the constraint value, also called `prediction`, we are looking for.

Here we calculate the core mass with 

````matlab
AXES.mass.map('data', obj, 'anchor', ANCH.velocity_core)
````
where the mass is given in the unit as given in `AXES.mass`. Meaning in solar masses, a typical astrophysical unit.

Finally, we need to put this constraint into a constraints/response list.

````matlab
constraintsList = lib.profile.responseList([
	lib.profile.response(fMcore, 4.2E6);
	% ... further constraints if necessary
]);
````

(It is possible to add further constraints/responses. This case will be described in future)

Now, we are ready to run the non-linear fitting method in order to find `beta0`.

````matlab
[p,model] = lib.model.cRAR.find.nlinfit(...
	'model',	modelSeed,...
	'list',		constraintsList,...
	'parameter', struct(...
		'm',		'print',...
		'beta0',	'log',... % <-- in log scale it is faster and more stable
		'theta0',	'print',...
		'W0',		'print' ...
	)...
);
````

This method requires three parameter in the key-value scheme. `model` contains the initial seed parameter and `list` is the list of constraints/responses. The third argument `parameter` describes which values will be varied and how (e.g. on a linear or logarithmic scale, o rnot at all). There are three keywords available:

* **print**:	don't vary, just print the value
* **linear**:	vary on linear scale and print value in bold
* **log**:	vary on logarithmic scale and print value in bold

The output is the RAR solution `p` and a model struct `model`. Both fulfill the given core mass constraint.

Here it is possible to look for `theta0` instead of `beta0` simply by changing the `parameter` argument. It is important to know that `W0` affects mainly the halo while `beta0` and `theta0` --- actually their product --- affects mainly the core. Therefore, with this information it should be clear that searching for `W0` for a constraint core will much likely fail.
