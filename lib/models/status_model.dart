class Status {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime validUntil;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;

  Status(
      {required this.uid,
      required this.username,
      required this.phoneNumber,
      required this.photoUrl,
      required this.validUntil,
      required this.profilePic,
      required this.statusId,
      required this.whoCanSee});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'validUntil': validUntil.microsecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
        uid: map['uid'] ?? '',
        username: map['username'] ?? '',
        photoUrl: List<String>.from(map['photoUrl']),
        phoneNumber: map['phoneNumber'] ?? '',
        validUntil: DateTime.fromMicrosecondsSinceEpoch(map['validUntil']),
        profilePic: map['profilePic'] ?? '',
        statusId: map['statusId'] ?? '',
        whoCanSee: List<String>.from(map['whoCanSee']));
  }
}
