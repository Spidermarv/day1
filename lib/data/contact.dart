

class Contact {
  final String name;
  final String email;
  final String phoneNumber;
  bool isFavorite;

  Contact({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavorite = false,
  });
}
