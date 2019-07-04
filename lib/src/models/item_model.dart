import 'dart:convert';

class ItemModel {
  final int id;	
  final bool deleted;
  final String type;
  final String by;	
  final int time;	
  final String text;	
  final bool dead;	
  final int parent;	
  final List<dynamic>kids;	
  final String url;
  final int score;	
  final String title;	
  final int descendants;	

  ItemModel.fromJson(Map<String, dynamic> parsedJson)
    : id = parsedJson['id'],
      deleted = parsedJson['deleted'] ?? false, //default to false
      type = parsedJson['type'],
      by = parsedJson['by'] ?? '', // default to empty string
      time = parsedJson['time'],
      text = parsedJson['text'] ?? '', // default to empty string
      dead = parsedJson['dead'] ?? false,
      parent = parsedJson['parent'],
      kids = parsedJson['kids'] ?? [], // default to empty list
      url = parsedJson['url'],
      score = parsedJson['score'],
      title = parsedJson['title'],
      descendants = parsedJson['descendants'];

 //need to convert sqlite type to json for itemModel from API

  ItemModel.fromDb(Map<String, dynamic> parsedJson)
    : id = parsedJson['id'],
      deleted = parsedJson['deleted'] == 1, // if parsedJson = 1 then true, else false
      type = parsedJson['type'],
      by = parsedJson['by'],
      time = parsedJson['time'],
      text = parsedJson['text'],
      dead = parsedJson['dead'] == 1,
      parent = parsedJson['parent'],
      kids = jsonDecode(parsedJson['kids']), // conversion from dart covert module, converts blob to string
      url = parsedJson['url'],
      score = parsedJson['score'],
      title = parsedJson['title'],
      descendants = parsedJson['descendants'];

//need to convert json to Db type sepcific

  Map<String, dynamic> toMapForDb(){
    return <String, dynamic>{
      "id": id,
      "type": type,
      "by": by,
      "time": time,
      "text": text,
      "parent": parent,
      "url": url,
      "score": score,
      "title": title,
      "descendants": descendants,
      "dead": dead ? 1:0, // returns 1 instead of true,if false return 0
      "deleted": deleted ? 1:0,
      "kids": jsonEncode(kids),
    };
  }
}