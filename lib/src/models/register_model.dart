class Register {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String password;
  String username;

  Register({this.firstName, this.lastName, this.email, this.phoneNumber, this.password, this.username});

  Map<String, dynamic> toJson() => {
    "fisrt_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone_number": phoneNumber,
    "password": password,
    "username": email,
  };

}