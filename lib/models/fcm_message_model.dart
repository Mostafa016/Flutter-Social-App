class FcmMessageModel {
  final String to;
  final NotificationModel notification;

  FcmMessageModel({
    required this.to,
    required this.notification,
  });

  FcmMessageModel.fromJson(Map<String, dynamic> json)
      : to = json['to'],
        notification = NotificationModel.fromJson(json['notification']);

  Map<String, dynamic> toMap() => {
        'to': to,
        'notification': notification.toMap(),
      };
}

class NotificationModel {
  final String title;
  final String body;

  NotificationModel({
    required this.title,
    required this.body,
  });

  NotificationModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        body = json['body'];

  Map<String, dynamic> toMap() => {
        'title': title,
        'body': body,
      };
}
