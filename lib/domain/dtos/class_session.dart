class ClassSession {
  // TODO: Make all the fields final.
  late int id;
  late String name;
  late List<int> availableSemesters;

  ClassSession(Map json) {
    id = json['id'];
    name = json['name'];
    availableSemesters = [...(json['availableSemesters'] as List).map((e) => int.parse('$e'))];
  }
}
