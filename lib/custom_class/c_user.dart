class CustomUser {
  String email;
  String name;
  List<String> favorited;
  Map reserve;

  CustomUser(this.email, this.name, this.favorited, this.reserve);

  Map<String, dynamic> toJson () => {
    "Email" : email,
    "Name" : name,
    "Favorited" : favorited,
    "Reserve" : reserve,
  };

  CustomUser.fromJson(Map<String, dynamic> json) 
    : email = json['Email'],
      name = json['Name'],
      favorited = json['Favorited'],
      reserve = json['Reserve'];

  void addFavoritedList(String academy) {
    favorited.add(academy);
  }
}