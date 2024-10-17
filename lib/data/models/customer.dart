class Customer {
  final String id;
  final String name; // Add additional fields as needed

  Customer({required this.id, required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'],
      name: json['name'], // Make sure your backend sends the name
    );
  }
}
