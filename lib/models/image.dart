class Image {
  final String imageUrl;
  final String auctionId;

  Image({required this.imageUrl, required this.auctionId});

  Image.fromMap(Map<String, dynamic> res)
      : imageUrl = res['image_url'],
        auctionId = res['auction_id'];

  Map<String, Object?> toMap() {
    return {'image_url': imageUrl, 'auction_id': auctionId};
  }
}
