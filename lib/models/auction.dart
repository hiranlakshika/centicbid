class Auction {
  final String id;
  final String title;
  final String description;
  final dynamic basePrice;
  final dynamic latestBid;
  final List<dynamic>? images;
  final dynamic remainingTime;

  Auction({required this.id, required this.title, required this.description, required this.basePrice, this.latestBid,
      this.images, required this.remainingTime});

}
