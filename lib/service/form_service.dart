class FormService {
  static final RegExp alphabetRegEx = RegExp('[a-zA-Z]');
  static final RegExp emailRegEx = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static final RegExp passwordContainOneUpper = RegExp(r'^(?=.*?[A-Z])');
  static final RegExp passwordContainOneLower = RegExp(r'^(?=.*?[a-z])');
  static final RegExp passwordContainOneNumber = RegExp(r'^(?=.*?[0-9])');
}
