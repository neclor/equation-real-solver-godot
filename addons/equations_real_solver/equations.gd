extends Node


func linear_solve_real(a: float, b: float) -> Array[float]: # a * x + b = 0
	if is_zero_approx(a): # Exception, because if a = 0 then this is not a equation. 
		return []

	return [-b / a] # Linear equation. # https://en.wikipedia.org/wiki/Linear_equation


func quadratic_solve_real(a: float, b: float, c: float) -> Array[float]: # a * x^2 + b * x + c = 0
	if is_zero_approx(a): # Exception, because if a = 0 then this is not a quadratic equation.
		return linear_solve_real(b, c)

	var real_roots: Array[float] = []

	var D: float = b ** 2 - 4 * a * c # Solution using discriminant. # https://en.wikipedia.org/wiki/Quadratic_equation
	if is_zero_approx(D):
		real_roots.append(-b / 2 * a)

	elif D > 0:
		var sqrt_D: float = sqrt(D)
		var a_mul_2: float = 2 * a

		real_roots.append((sqrt_D - b) / a_mul_2)
		real_roots.append((-sqrt_D - b) / a_mul_2)

	real_roots.sort()
	return real_roots


func cubic_solve_real(a: float, b: float, c: float, d: float) -> Array[float]: # a * x^3 + b * x^2 + c * x + d = 0
	if is_zero_approx(a): # Exception, because if a = 0 then this is not a cubic equation.
		return quadratic_solve_real(b, c, d)

	var real_roots: Array[float] = []

	var a1: float = b / a # Solution using Vieta's trigonometric formula. 
	var b1: float = c / a # https://en.wikipedia.org/wiki/Cubic_equation
	var c1: float = d / a # https://ru.wikipedia.org/wiki/%D0%A2%D1%80%D0%B8%D0%B3%D0%BE%D0%BD%D0%BE%D0%BC%D0%B5%D1%82%D1%80%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B0%D1%8F_%D1%84%D0%BE%D1%80%D0%BC%D1%83%D0%BB%D0%B0_%D0%92%D0%B8%D0%B5%D1%82%D0%B0

	var a1_div_3: float = a1 / 3

	var Q: float = a1_div_3 ** 2 - b1 / 3
	var R: float = a1_div_3 ** 3 - a1_div_3 * b1 / 2 + c1 / 2

	var k: float
	if absf(Q) > 45000:
		k = Q / 45000
	elif absf(Q) < 0.00045:
		k = Q / 0.00045
	else:
		k = 1

	var Q_pow_3_div_k_pow_3: float = (Q / k) ** 3
	var R_pow_2_div_k_pow_3: float = (R / k) ** 2 / k

	var S_div_k_pow_3: float = (Q / k) ** 3 - (R / k) ** 2 / k
	var S: float = S_div_k_pow_3 * (k ** 3)

	#prints(Q**3 - R**2, Q**3, R**2)
	#prints(S, Q_pow_3_div_k_pow_3, R_pow_2_div_k_pow_3, is_equal_approx(Q_pow_3_div_k_pow_3, R_pow_2_div_k_pow_3))

	#if is_zero_approx(S):
	if is_equal_approx(Q_pow_3_div_k_pow_3, R_pow_2_div_k_pow_3):
		if is_zero_approx(R):
			real_roots.append(-a1_div_3)
		else:
			if Q < 0:
				var cbrt_R: float = R ** (1.0 / 3)
				real_roots.append(-2 * cbrt_R - a1_div_3)
				real_roots.append(cbrt_R - a1_div_3)
			else:
				var sign_r_mul_sqrt_Q: float = sign(R) * sqrt(Q)
				real_roots.append(-2 * sign_r_mul_sqrt_Q - a1_div_3)
				real_roots.append(sign_r_mul_sqrt_Q - a1_div_3)

	elif S > 0:
		var f: float = acos(R / sqrt(Q ** 3)) / 3
		var neg_2_mul_sqrt_Q: float = -2 * sqrt(Q)
		var TAU_div_3: float = TAU / 3

		real_roots.append(neg_2_mul_sqrt_Q * cos(f) - a1_div_3)
		real_roots.append(neg_2_mul_sqrt_Q * cos(f + TAU_div_3) - a1_div_3)
		real_roots.append(neg_2_mul_sqrt_Q * cos(f - TAU_div_3) - a1_div_3)

	else:
		if is_zero_approx(Q):
			real_roots.append(-1 * ((c - a1_div_3 ** 3) ** (1.0 / 3) + a1_div_3))

		elif Q > 0:
			var f: float = acosh(absf(R) / sqrt(Q ** 3)) / 3
			real_roots.append(-2 * signf(R) * sqrt(Q) * cosh(f) - a1_div_3)

		else:
			var f: float = asinh(absf(R) / sqrt(absf(Q ** 3))) / 3
			real_roots.append(-2 * signf(R) * sqrt(absf(Q)) * sinh(f) - a1_div_3)

	real_roots.sort()
	return real_roots


func quartic_solve_real(a: float, b: float, c: float, d: float, e: float) -> Array[float]: # a * x^4 + b * x^3 + c * x^2 + d * x + e = 0
	if is_zero_approx(a): # Exception, because if a = 0 then this is not a quartic equation.
		return cubic_solve_real(b, c, d, e)

	var real_roots: Array[float] = []

	var b_div_2a: float = b / (2 * a) # Converting to a depressed quartic. x = u - b / (4 * a) => u^4 + p * u^2 + q * u + r = 0
	var x_sub_u: float = -b_div_2a / 2 # x - u = - b / (4 * a)

	var p: float = -6 * (x_sub_u ** 2) + c / a # Using Ferrari's solution.
	var q: float = b_div_2a ** 3 - c * b_div_2a / a + d / a # https://en.wikipedia.org/wiki/Quartic_equation
	var r: float = -3 * (x_sub_u ** 4) + c * (x_sub_u ** 2) / a + d * x_sub_u / a + e / a

	if is_zero_approx(q):
		for u_pow_2 in quadratic_solve_real(1, p, r):
			if is_zero_approx(u_pow_2):
				real_roots.append(0)

			elif u_pow_2 > 0:
				var u: float = sqrt(u_pow_2)
				real_roots.append(u)
				real_roots.append(-u)

	else:
		var cubic_b: float = 2.5 * p
		var cubic_c: float = 2 * (p ** 2) - r
		var cubic_d: float = (p ** 3 - p * r - (q / 2) ** 2) / 2

		var y: float = cubic_solve_real(1 ,cubic_b, cubic_c, cubic_d)[0]
		var sqrt_p_add_2y: float = sqrt(p + 2 * y)
		var p_add_y: float = p + y
		var q_div_2_mul_sqrt_p_add_2y: float = q / 2 / sqrt_p_add_2y

		real_roots.append_array(quadratic_solve_real(1, -sqrt_p_add_2y, p_add_y + q_div_2_mul_sqrt_p_add_2y))
		var new_real_roots: Array[float] = quadratic_solve_real(1, sqrt_p_add_2y, p_add_y - q_div_2_mul_sqrt_p_add_2y)

		if is_equal_approx(-784.632241097025, a):
			prints(p, q)
			prints(p + 2 * y, p + y, q_div_2_mul_sqrt_p_add_2y)
			prints(1, -sqrt_p_add_2y, p_add_y + q_div_2_mul_sqrt_p_add_2y, real_roots)

		if real_roots.size() == 0:
			real_roots.append_array(new_real_roots)
		else:
			for new_real_root in new_real_roots:
				var has_root: bool = false
				for real_root in real_roots:
					if is_equal_approx(new_real_root, real_root):
						has_root = true
				if not has_root:
					real_roots.append(new_real_root)

	for i in real_roots.size():
		real_roots[i] += x_sub_u
	real_roots.sort()
	return real_roots
