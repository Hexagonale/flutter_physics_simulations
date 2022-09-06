/// Vector interface - specifies basic function that every vector should have.
abstract class Vector {
  const Vector();

  /// Creates new instance of the vector with the same parameters.
  Vector copy();

  /// Adds two vectors together.
  Vector operator +(covariant Vector other);

  /// Subtracts this vector from [other].
  Vector operator -(covariant Vector other);

  /// Multiplies this vector by the factor of [other].
  Vector operator *(covariant double other);

  /// Divides this vector by the factor of [other].
  Vector operator /(covariant double other);

  /// Inverts all of the vector axis values.
  Vector operator -();

  /// Returns vector with the biggest axis value equal to one.
  Vector get normalized;
}
