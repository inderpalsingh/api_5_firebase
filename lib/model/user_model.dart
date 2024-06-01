class UserModel {
  String? name;
  String? email;
  int? age;
  String? pass;

  UserModel(
      {required this.name,
      required this.email,
      required this.age,
      required this.pass});

  factory UserModel.fromJsonDoc(Map<String, dynamic> jsonDoc) {
    return UserModel(
        name: jsonDoc['name'],
        email: jsonDoc['email'],
        age: jsonDoc['age'],
        pass: jsonDoc['pass']
    );
  }
  
  
  Map<String,dynamic> toMapDoc(){
    return {
      'name': name,
      'email': email,
      'age': age,
      'pass': pass
    } ;
  }
}
