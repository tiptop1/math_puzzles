/// Convert from String to [T] type.
abstract class ValueConverter<T> {
  const ValueConverter();

  T? convertValue(String? strValue);
}

class IntValueConverter extends ValueConverter<int> {
  const IntValueConverter();

  @override
  int? convertValue(String? strValue) => strValue != null ? int.tryParse(strValue) : null;
}

class BoolValueConverter extends ValueConverter<bool> {
  const BoolValueConverter();

  @override
  bool? convertValue(String? strValue) {
    var lowerStrValue = strValue?.toLowerCase();
    bool? value;
    if (lowerStrValue == true.toString()) {
      value = true;
    } else if (lowerStrValue == false.toString()) {
      value = false;
    }
    return value;
  }
}
