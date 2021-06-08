class Image {
  final String imageUrl;
  final String auctionId;
  final int id;

  Image({required this.id, required this.imageUrl, required this.auctionId});

  Image.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        imageUrl = res['image_url'],
        auctionId = res['auction_id'];

  Map<String, Object?> toMap() {
    return {'id': id, 'image_url': imageUrl, 'auction_id': auctionId};
  }
}
