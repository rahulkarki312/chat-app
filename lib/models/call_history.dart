class CallHistory {
  final String receiverUserId;
  final String receiverProfilePic;
  final String receiverUserName;
  final String senderUserId;
  final String senderUserName;
  final String senderProfilePic;
  final DateTime callDate;

  CallHistory({
    required this.receiverUserId,
    required this.receiverProfilePic,
    required this.receiverUserName,
    required this.senderUserId,
    required this.senderProfilePic,
    required this.senderUserName,
    required this.callDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'receiverUserId': receiverUserId,
      'receiverProfilePic': receiverProfilePic,
      'receiverUserName': receiverUserName,
      'senderUserId': senderUserId,
      'senderProfilePic': senderProfilePic,
      'senderUserName': senderUserName,
      'callDate': callDate.millisecondsSinceEpoch,
    };
  }

  factory CallHistory.fromMap(Map<String, dynamic> map) {
    return CallHistory(
      receiverUserId: map['receiverUserId'] ?? '',
      receiverProfilePic: map['receiverProfilePic'] ?? '',
      receiverUserName: map['receiverUserName'] ?? '',
      senderUserId: map['senderUserId'] ?? '',
      senderProfilePic: map['senderProfilePic'] ?? '',
      senderUserName: map['senderUserName'] ?? '',
      callDate: DateTime.fromMillisecondsSinceEpoch(map['callDate']),
    );
  }
}
