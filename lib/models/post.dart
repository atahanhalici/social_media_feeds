import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Post extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String headerText;

  @HiveField(3)
  String bodyText;

  @HiveField(4)
  List<String> imageUrl; // String liste

  @HiveField(5)
  String author; // Yeni alan

  @HiveField(6)
  List<String> likes; // Beğenenler listesi

  @HiveField(7)
  List<Map<String, String>> comments; // Yorumlar listesi

  Post(
    this.id,
    this.date,
    this.headerText,
    this.bodyText,
    this.imageUrl,
    this.author,
    this.likes,
    this.comments,
  );
}

class PostAdapter extends TypeAdapter<Post> {
  @override
  final int typeId = 1;

  @override
  Post read(BinaryReader reader) {
    return Post(
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readList().cast<String>(), // imageUrl: List<String>
      reader.readString(), // author: String
      reader.readList().cast<String>(), // likes: List<String>
      reader.readList().map((item) => Map<String, String>.from(item as Map)).toList(), // comments: List<Map<String, String>>
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.date)
      ..writeString(obj.headerText)
      ..writeString(obj.bodyText)
      ..writeList(obj.imageUrl) // imageUrl: List<String>
      ..writeString(obj.author) // author: String
      ..writeList(obj.likes) // likes: List<String>
      ..writeList(obj.comments); // comments: List<Map<String, String>>
  }
}

