class PostModel {
  final String uid;
  final String name;
  final String userImage;
  final String dateTime;
  final String textContent;
  int numOfLikes;
  final String? postImage;

  PostModel({
    required this.uid,
    required this.name,
    required this.userImage,
    required this.dateTime,
    required this.textContent,
    required this.numOfLikes,
    this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        userImage = json['userImage'],
        dateTime = json['dateTime'],
        textContent = json['textContent'],
        numOfLikes = json['numOfLikes'],
        postImage = json['postImage'];

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'userImage': userImage,
        'dateTime': dateTime,
        'textContent': textContent,
        'numOfLikes': numOfLikes,
        'postImage': postImage,
      };
}
