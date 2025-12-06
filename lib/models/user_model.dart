class UserModel {
  final String uid;
  final String name;
  final String username;
  final String role;        // admin, guru, siswa
  final String linkedId;    // id siswa/guru
  final String kelas;

  UserModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.role,
    required this.linkedId,
    required this.kelas,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'role': role,
      'linkedId': linkedId,
      'kelas': kelas,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      username: map['username'],
      role: map['role'],
      linkedId: map['linkedId'],
      kelas: map['kelas'] ?? '',
    );
  }
}