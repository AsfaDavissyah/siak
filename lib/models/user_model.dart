class UserModel {
  final String uid;
  final String name;
  final String username;
  final String role;
  final String linkedId;
  final String kelas;
  final String email;
  final bool isApproved;
  final String? approvalMessage;


  UserModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.role,
    required this.linkedId,
    required this.kelas,
    required this.email,
    required this.isApproved,
    this.approvalMessage,
    
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'role': role,
      'linkedId': linkedId,
      'kelas': kelas,
      'email': email,
      'isApproved': isApproved,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map['uid'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      username: (map['username'] ?? '') as String,
      role: (map['role'] ?? '') as String,
      linkedId: (map['linkedId'] ?? '') as String,
      kelas: (map['kelas'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      isApproved: (map['isApproved'] ?? false) as bool,
      approvalMessage: map['approvalMessage'] ?? '',
    );
  }
}
