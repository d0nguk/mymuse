class AcademyData {

  String name;
  dynamic members;
  dynamic reserve;
  dynamic settings;
  dynamic searchlist;

  AcademyData(this.name, this.members, this.reserve, this.settings, this.searchlist);

  Map<String, dynamic> toJson () => {
    'Name' : name,
    'Members' : members,
    'Reserve' : reserve,
    'Settings' : settings,
    'SearchList' : searchlist,
  };

  AcademyData.fromJson(Map<String, dynamic> json)
    : name = json['Name'],
      members = json['Members'],
      reserve = json['Reserve'],
      settings = json['Settings'],
      searchlist = json['SearchList'];
}