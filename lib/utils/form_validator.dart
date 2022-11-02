import 'package:ones_blog/l10n/l10n.dart';

class FormValidator {
  FormValidator({
    required this.l10n,
    required this.value,
    this.anotherValue,
  });

  final AppLocalizations l10n;
  final String? value;
  final String? anotherValue;
  String? errorMessage;

  bool _empty(String? value) => value == null || value.isEmpty;

  void validateRequired() =>
      errorMessage ??= _empty(value) ? l10n.requiredErrorText : null;

  void validateEmail() => errorMessage ??= (!_empty(value) &&
          !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value!))
      ? l10n.emailErrorText
      : null;

  void validateMin(int length) =>
      errorMessage ??= (!_empty(value) && value!.length < length)
          ? l10n.minErrorText(length)
          : null;

  void validateSame(String label, String comparedLabel) => errorMessage ??=
      ((!_empty(value) || !_empty(anotherValue)) && value! != anotherValue!)
          ? l10n.sameErrorText(label, comparedLabel.toLowerCase())
          : null;
}
