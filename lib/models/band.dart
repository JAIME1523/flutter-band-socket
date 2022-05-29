class Band {
  Band({this.id, this.name, this.votes});

  String? id;
  String? name;
  dynamic votes;
//regresa una instancia de mi clase
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        id: obj.containsKey('id') ? obj['id'] : 'no-id',
        name: obj.containsKey('name') ? obj['name'] : 'no-name',
        votes:  obj['vote'] ,
      );
}
