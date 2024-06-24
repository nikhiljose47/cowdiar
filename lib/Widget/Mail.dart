class MailContent {
  String? image;
  String? subject;
  String? time;
  String? sender;
  String? message;
  String? status;


  MailContent(this.image ,this.subject, this.sender, this.time, this.message, this.status);
  String getimage() => image;
  String getSubject() => subject;
  String getSender() => sender;
  String getTime() => time;
  String getMessage() => message;
  String getstatus() => status;

}