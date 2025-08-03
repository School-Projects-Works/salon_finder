bool validateEmail(String email) {
  // Define the regex pattern for email validation.
  // This pattern generally covers common email formats.
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';

  // Create a RegExp object with the defined pattern.
  RegExp regex = RegExp(pattern);

  // Check if the email string matches the regex pattern.
  return regex.hasMatch(email);
}
