class Bid {
  final String userId;
  final String auctionId;
  final double bid;

  Bid({required this.userId, required this.auctionId, required this.bid});

  Bid.fromMap(Map<String, dynamic> res)
      : userId = res['user_id'],
        auctionId = res['auction_id'],
        bid = res['bid'];

  Map<String, Object?> toMap() {
    return {'user_id': userId, 'auction_id': auctionId, 'bid': bid};
  }
}
