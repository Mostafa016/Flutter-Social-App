class UserModel {
  final String uid;
  final String name;
  final String email;
  final String image;
  final String coverImage;
  final String? bio;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.image,
    required this.coverImage,
    required this.bio,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        email = json['email'],
        image = json['image'],
        coverImage = json['coverImage'],
        bio = json['bio'];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
      'coverImage': coverImage,
      'bio': bio,
    };
  }
}
