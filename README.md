# Equations Real Solver
Functions on GDScript for finding real roots of equations of 1-4 degrees.

## Usage
Functions take a value of type float and return an array of roots.
If there are no roots, return an empty array.

```gdscript

# Example
func _ready():
	var roots: Array[float] = quartic_solve_real(1, -10, 35, -50, 24))
	print(roots) # Prints "[1, 2, 3, 4]"

# Functions
	linear_solve_real(a: float, b: float) -> Array[float]
	quadratic_solve_real(a: float, b: float, c: float) -> Array[float]
	cubic_solve_real(a: float, b: float, c: float, d: float) -> Array[float]
	quartic_solve_real(a: float, b: float, c: float, d: float, e: float) -> Array[float]

```

## Warning
Arguments that are too large or small can lead to inaccurate answers.
