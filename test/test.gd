extends Node


const TESTS_NUMBER: int = 1000
const VALUE_LIMIT: float = 1000


var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func init_random() -> void:
	rng.randomize()
	rng.seed = 2405495002050039053
	seed(rng.seed)
	prints("Seed:", rng.seed)
	print("")


func _ready() -> void:
	init_random()

	fast_test()

	start_tests()


func fast_test():
	var a: float = 921.344146391763
	var b: float = 736989.377023416
	var c: float = 921.344146391763
	var d: float = 736989.377023416
	var e: float = -0
	prints(a, b, c, d, e, Equation.quartic_solve_real(a, b, c, d, e))


func generate_coefficients() -> Array[float]:
	var a: float
	while is_zero_approx(a):
		a = randf_range(-VALUE_LIMIT, VALUE_LIMIT)

	var random_coefficients: Array[float]
	for e in 4:
		var new_random_coefficient: float
		while random_coefficients.has(new_random_coefficient):
			new_random_coefficient = randf_range(-VALUE_LIMIT, VALUE_LIMIT)
		random_coefficients.append(new_random_coefficient)

	random_coefficients.insert(0, a)
	return random_coefficients


#region Tests
func start_tests():
	print("TESTS STARTED")

	var tests_successful: bool = true

	if not zero_test():
		tests_successful = false
		print("	ZERO TEST FAILED")

	for i in TESTS_NUMBER:
		var random_coefficient: Array[float] = generate_coefficients()
		if not run_tests(random_coefficient[0], random_coefficient[1], random_coefficient[2], random_coefficient[3], random_coefficient[4]):
			tests_successful = false

	if tests_successful:
		print("TESTS COMPLITED SUCCESSFULLY")
	else:
		print("TESTS FAILED")


func zero_test() -> bool:
	if Equation.quartic_solve_real(0, 0, 0, 0, 0).size() == 0:
		return true
	return false


func run_tests(a: float, b: float, c: float, d: float, e: float) -> bool:
	if is_zero_approx(a):
		a = 1

	var tests_successful: bool = true

	if not tests_linear(a, b):
		tests_successful = false

	if not tests_quadratic(a, b, c):
		tests_successful = false

	if not tests_cubic(a, b, c, d):
		tests_successful = false

	if not tests_quartic(a, b, c, d, e):
		tests_successful = false

	return tests_successful


	#region Linear
func tests_linear(a: float, b: float) -> bool:
	var roots: Array[float] = [b]

	var linear_a: float = a
	var linear_b: float = -a * b

	var test_roots: Array[float] = Equation.linear_solve_real(linear_a, linear_b)

	if check_roots_equal(test_roots, roots):
		return true

	prints("	LINEAR TEST FAILED", linear_a, linear_b, roots, test_roots)
	return false
	#endregion


	#region Quadratic
func tests_quadratic(a: float, b: float, c: float) -> bool:
	var tests_successful: bool = true

	if not test_quadratic([], a, a, a):
		tests_successful = false 

	var a_mul_b: float = a * b

	if not test_quadratic([b], a, -2 * a_mul_b, a_mul_b * b):
		tests_successful = false

	if not test_quadratic([b, c], a, -a * (b + c), a_mul_b * c):
		tests_successful = false

	return tests_successful


func test_quadratic(roots: Array[float], a: float, b: float, c: float) -> bool:
	var test_roots: Array[float] = Equation.quadratic_solve_real(a, b, c)

	if check_roots_equal(test_roots, roots):
		return true

	roots.sort()
	prints("	QUADRATIC TEST FAILED", a, b, c, roots, test_roots)
	return false
	#endregion


	#region Cubic
func tests_cubic(a: float, b: float, c: float, d: float) -> bool:
	var tests_successful: bool = true

	var a_mul_b: float = a * b

	if not test_cubic([b], a, -a_mul_b, a, -a_mul_b):
		tests_successful = false

	var b_mul_c: float = b * c
	var b_add_c: float = b + c

	if not test_cubic([b, c], a, -a * (b + b_add_c), a_mul_b * (b_add_c + c), -a_mul_b * b_mul_c):
		tests_successful = false

	if not test_cubic([b, c, d], a, -a * (b_add_c + d), a * (b_mul_c + d * b_add_c), -a_mul_b * c * d):
		tests_successful = false 

	return tests_successful


func test_cubic(roots: Array[float], a: float, b: float, c: float, d: float) -> bool:
	var test_roots: Array[float] = Equation.cubic_solve_real(a, b, c, d)

	if check_roots_equal(roots, test_roots):
		return true

	roots.sort()
	prints("	CUBIC TEST FAILED", a, b, c, d, roots, test_roots)
	return false
	#endregion


	#region Quartic
func tests_quartic(a: float, b: float, c: float, d: float, e: float) -> bool:
	var tests_successful: bool = true

	if not test_quartic([], a, a, a + a, a, a):
		tests_successful = false

	var a_mul_b: float = a * b

	if not test_quartic([b], a, -2 * a_mul_b, a_mul_b * b + a, -2 * a_mul_b, a_mul_b * b):
		tests_successful = false

	var b_add_c: float = b + c

	if not test_quartic([b, c], a, -a * b_add_c, a_mul_b * c + a, -a * b_add_c, a_mul_b * c):
		tests_successful = false

	var c_mul_d: float = c * d
	var c_add_d: float = c + d

	if not test_quartic([b, c, d], a, -a * (b + b_add_c + d), a * (b * (b_add_c + c_add_d + d) + c_mul_d), -a_mul_b * (d * (b_add_c + c) + b * c), b * a_mul_b * c_mul_d):
		tests_successful = false

	if not test_quartic([b, c, d, e], a, -a * (b_add_c + d + e), a * (b * (c_add_d + e) + e * c_add_d + c_mul_d), -a * (b * (e * c_add_d + c_mul_d) + c_mul_d * e), a_mul_b * c_mul_d * e):
		tests_successful = false

	return tests_successful


func test_quartic(roots: Array[float], a: float, b: float, c: float, d: float, e: float) -> bool:

	if is_equal_approx(a , -784.63224109702):
		prints(a, b, c, d, e)
		prints(-784.632241097025, -884.891320349566, 282107501.687061, 0, 0)
		print(Equation.quartic_solve_real(a, b, c, d, e))
		print(Equation.quartic_solve_real(-784.63224109702, -884.891320349566, 282107501.687061, 0, 0))

	var test_roots: Array[float] = Equation.quartic_solve_real(a, b, c, d, e)

	if check_roots_equal(roots, test_roots):
		return true

	roots.sort()
	prints("	QUARTIC TEST FAILED", a, b, c, d, e, roots, test_roots)
	return false
	#endregion


func check_roots_equal(roots_0: Array, roots_1: Array) -> bool:
	if roots_0.size() != roots_1.size():
		return false

	elif roots_0.size() == 0 and roots_1.size() == 0:
		return true

	else:
		var roots_0_d: Array[float] = roots_0.duplicate()
		var roots_1_d: Array[float] = roots_1.duplicate()

		roots_0_d.sort()
		roots_1_d.sort()

		for i in roots_0_d.size():
			if not is_equal_approx(roots_0_d[i], roots_1_d[i]):
				return false
		return true
#endregion
