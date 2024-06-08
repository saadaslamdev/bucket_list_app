class BucketData {
  String? itemName;
  double? price;
  String? description;
  String? imageURL;
  bool? isCompleted;
  int? index;

  BucketData(
      {this.itemName,
      this.price,
      this.description,
      this.imageURL,
      this.isCompleted,
      this.index});

  factory BucketData.fromJson(Map<String, dynamic> json) {
    return BucketData(
      itemName: json['item'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      description: json['description'] ?? '',
      imageURL: json['image'] ?? '',
      isCompleted: json['completed'] ?? false,
      index: json['index'] ?? 0,
    );
  }
}
