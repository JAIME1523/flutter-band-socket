class Band {
  Band({this.id, this.name, this.votes});

  String? id;
  String? name;
  int? votes;
//regresa una instancia de mi clase
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        id: obj['id'],
        name: obj['name'],
        votes: obj['votes'],
      );
}
