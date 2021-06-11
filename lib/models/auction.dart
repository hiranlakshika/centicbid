class Auction {
  final String id;
  final String title;
  final String description;
  final String? uid;
  final dynamic basePrice;
  final dynamic latestBid;
  final List<dynamic>? images;
  final String remainingTime;

  Auction(
      {required this.id,
      required this.title,
      required this.description,
      required this.uid,
      required this.basePrice,
      this.latestBid,
      this.images,
      required this.remainingTime});

  Auction.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        description = res['description'],
        uid = res['uid'],
        basePrice = res['base_price'],
        latestBid = res['latest_bid'],
        images = res['images'],
        remainingTime = res['remaining_time'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'uid': uid,
      'base_price': basePrice,
      'latest_bid': latestBid,
      'remaining_time': remainingTime
    };
  }
}
