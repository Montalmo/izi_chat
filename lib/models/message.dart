enum MessageType { text, image }

class Message {
  Message({
    required this.toid,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromid,
    required this.sent,
  });

  late final String toid;
  late final String msg;
  late final String read;
  late final MessageType type;
  late final String fromid;
  late final String sent;

  Message.fromJson(Map<String, dynamic> json) {
    toid = json['toid'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == MessageType.image.name
        ? MessageType.image
        : MessageType.text;
    fromid = json['fromid'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toid'] = toid;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type.name;
    data['fromid'] = fromid;
    data['sent'] = sent;
    return data;
  }
}
