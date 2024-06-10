// data model
class TodoModel {
  final int? id;
  final String? title;
  final String? des;
  final String? dateTime;

  TodoModel({
    this.id,
    this.title,
    this.des,
    this.dateTime,
  });

  TodoModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        des = res['des'],
        dateTime = res['dateTime'];

  Map<String,Object?> toMap(){
    return {
      "id" : id,
      "title" : title,
      "des" : des,
      "dateTime" : dateTime,
    };
  }
}
