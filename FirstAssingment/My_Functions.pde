String multiplyInSciNotation(String a, String b) {
  // Extract coefficients and exponents
  float aCoeff= float(a.substring(0, a.indexOf("x"))); // Coefficient of a
  int aExp = int(a.substring(a.indexOf("^") + 1)); // Exponent of a
  float bCoeff = float(b.substring(0, b.indexOf("x"))); // Coefficient of b
  int bExp = int(b.substring(b.indexOf("^") + 1)); // Exponent of b

  // Perform calculations
  float resultCoeff = aCoeff * bCoeff; // Multiply coefficients
  int resultExp = aExp + bExp; // Add exponents

  // Normalize the result
  while (resultCoeff >= 10.0) {
    resultCoeff /= 10; // Normalize coefficient
    resultExp++; // Adjust exponent
  }

  resultCoeff = round(resultCoeff * 1000) / 1000.0; // Round coefficient

  // Format the result
  if (resultExp == 0) {
    return str(resultCoeff); // Return coefficient if exponent is zero
  } 
  else {
    return resultCoeff + "x10^" + resultExp; // Return in scientific notation
  }
}
