class Auction {
  final String title;
  final String description;
  final double basePrice;
  final double? latestBid;
  final String? imageUrl;
  final int remainingTime;

  Auction(this.title, this.description, this.basePrice, this.latestBid,
      this.imageUrl, this.remainingTime);
}
