# Formula Student vehicle model study

An individual learning project by **Thibault Fesler** exploring an existing
Formula Student vehicle model in MATLAB, Simulink, and Simscape.

The work focused on understanding the model and attempting to connect/integrate
it. The upstream model was changed very little; this repository records that
exploration and does not claim a completed, validated integration.

## Upstream model and attribution

The base model is [Formula Student Vehicle with Simscape on MathWorks File
Exchange](https://www.mathworks.com/matlabcentral/fileexchange/172279-formula-student-vehicle-with-simscape).
The original model and its authors deserve the credit for the underlying vehicle
simulation. The repository retains the supplied [MathWorks license](LICENSE.md).

## Repository guide

| File or directory | Contents |
| --- | --- |
| `FormulaOneStudent_simulation.prj` | MATLAB project entry point |
| `sm_car.slx` | Vehicle model supplied with the project |
| `model2bf.slx`, `Braking_dynamic.slx` | Additional model files present in the workspace |
| `model2_dim.m` | Vehicle, motor, brake, tyre, suspension, and aerodynamic parameters |
| `braking_dyn.m` | Braking-study parameters and exploratory code |
| `Scripts_Data/` | Startup, vehicle data, plotting, and configuration scripts |
| `Aerodynamics/`, `Powertrain/`, `Tires/` | Subsystem-related files |
| `Libraries/`, `Testrigs/`, `Skidpad/` | Libraries and simulation scenarios |

File inclusion alone does not establish authorship of a subsystem. Many assets
and scripts originate from the upstream project.

## Opening the project

1. Clone or download the repository.
2. Open `FormulaOneStudent_simulation.prj` in MATLAB.
3. Inspect the project startup configuration and `Scripts_Data/startup_sm_car.m`.
4. Open the model you want to study and check its parameters and dependencies
   before simulating it.

MATLAB, Simulink, and the relevant Simscape products are required. The code uses
Simscape Multibody functionality. Refer to the upstream project's requirements
and MATLAB's dependency checks for the complete toolbox and release requirements;
a working release/toolbox combination is not verified by this README.

## Scope and assumptions

Parameter scripts contain a mixture of metres and centimetres with inline unit
comments, and some parameters are marked provisional. Review those values and
their use in the selected model before interpreting outputs.

`braking_dyn.m` describes a simplified flat-road study that neglects drag,
downforce, rolling resistance, and engine influence. Those assumptions apply to
that study and should not be generalised to every model in the repository.

The intended value of this project is model comprehension and integration
experience. No new vehicle-model accuracy, performance improvement, or completed
hardware connection is claimed here.
