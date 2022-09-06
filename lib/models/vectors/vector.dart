/// Vector interface specifies basic function that every vector should have.
abstract class Vector {
  const Vector();

  Vector copy();

  Vector operator +(covariant Vector other);

  Vector operator -(covariant Vector other);

  Vector operator *(covariant double other);

  Vector operator /(covariant double other);

  Vector operator -();

  Vector get normalized;
}
