class CustomUser {
  String email;
  String name;
  List<String> favorited;
  List<String> manage;
  Map reserve;

  CustomUser(this.email, this.name, this.favorited, this.manage, this.reserve);

  Map<String, dynamic> toJson () => {
    "Email" : email,
    "Name" : name,
    "Favorited" : favorited,
    "Manage" : manage,
    "Reserve" : reserve,
  };

  CustomUser.fromJson(Map<String, dynamic> json) 
    : email = json['Email'],
      name = json['Name'],
      favorited = json['Favorited'],
      manage = json['Manage'],
      reserve = json['Reserve'];

  void addFavoritedList(String academy) {
    favorited.add(academy);
  }
}