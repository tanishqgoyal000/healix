class Medicine {
  final String name;
  final String expiry;

  Medicine({required this.name, required this.expiry});

  Map<String, dynamic> toJson() => {
    'name': name,
    'expiry': expiry,
  };

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'],
      expiry: json['expiry'],
    );
  }
}
