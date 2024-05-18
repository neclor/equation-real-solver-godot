extends Node


var rng: RandomNumberGenerator = RandomNumberGenerator.new()


#region Functions
func update_random() -> void:
	rng.randomize()
	rng.seed = 2405495002050039053
	seed(rng.seed)
	print(rng.seed)


func randf_range_without_zero(from: float, to: float) -> float:
	var value: float = randf_range(from, to)
	return value if not is_zero_approx(value) else randf_range_without_zero(from, to)


func is_roots_equal(roots_0: Array, roots_1: Array) -> bool:
	var is_equal: bool = true

	if roots_0 == [] and roots_1 == []:
		is_equal = true

	elif roots_0.size() != roots_1.size():
		is_equal = false

	else:
		var roots_0_d: Array[float] = roots_0.duplicate()
		var roots_1_d: Array[float] = roots_1.duplicate()

		roots_0_d.sort()
		roots_1_d.sort()

		for i in roots_0_d.size():
			if !is_equal_approx(roots_0_d[i], roots_1_d[i]):
				is_equal = false

	return is_equal
#endregion


func _ready() -> void:
	update_random()
	start_test()


func start_test():
	const LIMIT_VALUE: float = 1000
	const TESTS_NUMBER: int = 1000

	var all_tests_passed: bool = true

	print("Test started")

	if not zero_test():
		all_tests_passed = false

	for i in TESTS_NUMBER:
		var a: float = randf_range_without_zero(-LIMIT_VALUE, LIMIT_VALUE)
		var random_roots: Array[float]

		for e in 4:
			var new_random_root: float

			while random_roots.has(new_random_root):
				new_random_root = randf_range(-LIMIT_VALUE, LIMIT_VALUE)
			random_roots.append(new_random_root)

		if not equations_test(a, random_roots[0], random_roots[1], random_roots[2], random_roots[3]):
			all_tests_passed = false

	if all_tests_passed:
		print("Test complited -> SUCCESS")
		return
	print("Test complited -> FAILED")


func zero_test() -> bool:
	if Equation.quartic_solve_real(0, 0, 0, 0, 0) == []:
		return true
	print("	zero test -> FAILED")
	return false


func equations_test(a: float, b: float, c: float, d: float, e: float) -> bool:
	if is_zero_approx(a):
		a = 1

	var all_equations_correct: bool = true

	if not linear_tests(a, b):
		all_equations_correct = false
		print("	linear tests -> FAILED")

	if not quadratic_tests(a, b, c):
		all_equations_correct = false
		print("	quadratic tests -> FAILED")
	
	if not cubic_tests(a, b, c, d):
		all_equations_correct = false
		print("	cubic tests -> FAILED")
	
	if not quartic_tests(a, b, c, d, e):
		all_equations_correct = false
		print("	quartic tests -> FAILED")

	return all_equations_correct


#region Linear
func linear_tests(a: float, b: float) -> bool:
	var roots: Array[float] = [b]

	var linear_a: float = a
	var linear_b: float = -a * b

	var test_roots: Array[float] = Equation.linear_solve_real(linear_a, linear_b)
	if is_roots_equal(roots, test_roots):
		return true

	prints("		linear test -> FAILED", linear_a, linear_b, roots, test_roots)
	return false
#endregion


#region Quadratic
func quadratic_tests(a: float, b: float, c: float) -> bool:
	var quadratic_correct: bool = true

	if not quadratic_roots_test([], a, a, a):
		quadratic_correct = false 

	if not quadratic_roots_test([b], a, -2 * a * b, a * (b ** 2)):
		quadratic_correct = false

	if not quadratic_roots_test([b, c], a, -a * (b + c), a * b * c):
		quadratic_correct = false

	return quadratic_correct


func quadratic_roots_test(roots: Array[float], a: float, b: float, c: float) -> bool:
	var test_roots: Array[float] = Equation.quadratic_solve_real(a, b, c)

	if is_roots_equal(roots, test_roots):
		return true

	roots.sort()
	prints("		quadratic test -> FAILED", a, b, c, roots, test_roots)
	return false
#endregion


#region Cubic
func cubic_tests(a: float, b: float, c: float, d: float) -> bool:
	var cubic_correct: bool = true

	if not cubic_roots_test([b], a, -a * b, a, -a * b):
		cubic_correct = false

	if not cubic_roots_test([b, c], a, -a * (2 * b + c), a * (b ** 2 + 2 * b * c), -a * (b ** 2) * c):
		cubic_correct = false

	if not cubic_roots_test([b, c, d], a, -a * (b + c + d), a * (b * c + b * d + c * d), -a * b * c * d):
		cubic_correct = false 

	return cubic_correct


func cubic_roots_test(roots: Array[float], a: float, b: float, c: float, d: float) -> bool:
	var test_roots: Array[float] = Equation.cubic_solve_real(a, b, c, d)

	if is_roots_equal(roots, test_roots):
		return true

	roots.sort()
	prints("		cubic test -> FAILED", a, b, c, d, roots, test_roots)
	return false
#endregion


#region Quartic
func quartic_tests(a: float, b: float, c: float, d: float, e: float) -> bool:
	var quartic_correct: bool = true

	if not quartic_roots_test([], a, 2 * a, 3 * a, 2 * a, a):
		quartic_correct = false

	if not quartic_roots_test([b], a, -2 * a * b, a * (b ** 2 + 1), -2 * a * b, a * (b ** 2)):
		quartic_correct = false

	if not quartic_roots_test([b, c], a, -a * (b + c), a * (b * c + 1), -a * (b + c), a * b * c):
		quartic_correct = false

	if not quartic_roots_test([b, c, d], a, -a * (2 * b + c + d), a * (b ** 2 + 2 * b * c + 2 * b * d + c * d), -a * (c * (b ** 2) + (b ** 2) * d + 2 * b * c * d), a * (b ** 2) * c * d):
		quartic_correct = false

	if not quartic_roots_test([b, c, d, e], a, -a * (b + c + d + e), a * (b * c + b * d + b * e + c * d + c * e + d * e), -a * (b * (c * d + c * e + d * e) + c * d * e), a * b * c * d * e):
		quartic_correct = false

	return quartic_correct
	
func quartic_roots_test(roots: Array[float], a: float, b: float, c: float, d: float, e: float) -> bool:
	var test_roots: Array[float] = Equation.quartic_solve_real(a, b, c, d, e)

	if is_roots_equal(roots, test_roots):
		return true

	roots.sort()
	prints("		quartic test -> FAILED", a, b, c, d, e, roots, test_roots)
	return false
#endregion
