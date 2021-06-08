class Bid {
  final String id;
  final String userId;
  final String auctionId;
  final double bid;

  Bid(
      {required this.id,
      required this.userId,
      required this.auctionId,
      required this.bid});

  Bid.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        userId = res['user_id'],
        auctionId = res['auction_id'],
        bid = res['bid'];

  Map<String, Object?> toMap() {
    return {'id': id, 'user_id': userId, 'auction_id': auctionId, 'bid': bid};
  }
}
