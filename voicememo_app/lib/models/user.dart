class AppUser {
  String name;
  final String email;
  String photoURL;

  AppUser({
    required this.name,
    required this.email,
    required this.photoURL,
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? photoURL,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
    );
  }
}
