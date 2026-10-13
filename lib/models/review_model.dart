class Review {
  final String? id;
  final String? productId;
  final String? userId;
  final String userName;
  final int rating;
  final String? comment;
  final int helpfulCount;
  final DateTime? createdAt;

  const Review({
    this.id,
    this.productId,
    this.userId,
    required this.userName,
    required this.rating,
    this.comment,
    this.helpfulCount = 0,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id']?.toString(),
      productId: json['productId']?.toString(),
      userId: json['userId']?.toString(),
      userName: json['userName']?.toString() ?? 'Anonymous',
      rating: json['rating'] != null
          ? (json['rating'] as num).toInt()
          : 0,
      comment: json['comment']?.toString(),
      helpfulCount: json['helpfulCount'] != null
          ? (json['helpfulCount'] as num).toInt()
          : 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}