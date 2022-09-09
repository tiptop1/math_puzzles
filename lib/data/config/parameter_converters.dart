/// Convert from String to [T] type.
abstract class ValueConverter<T> {
  const ValueConverter();

  T convert(String strValue);
}

class IntValueConverter extends ValueConverter<int> {
  const IntValueConverter();

  @override
  int convert(String strValue) => int.parse(strValue);
}

class BoolValueConverter extends ValueConverter<bool> {
  const BoolValueConverter();

  @override
  bool convert(String strValue) =>
      (strValue.toLowerCase() == true.toString() || strValue == '1');
}
