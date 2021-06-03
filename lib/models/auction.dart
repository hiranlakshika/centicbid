class Auction {
  final String id;
  final String title;
  final String description;
  final double basePrice;
  final double? latestBid;
  final String? imageUrl;
  final int remainingTime;

  Auction(this.id, this.title, this.description, this.basePrice, this.latestBid,
      this.imageUrl, this.remainingTime);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'base_price': basePrice,
      'latest_bid': latestBid,
      'image_URL': imageUrl,
      'remaining_time': remainingTime,
    };
  }

  @override
  String toString() {
    return 'Auction{id: $id, title: $title, description: $description, base_price: $basePrice, latest_bid: $latestBid, image_URL: $imageUrl, remaining_time: $remainingTime}';
  }
}
