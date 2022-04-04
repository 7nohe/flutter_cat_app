class Photo {
  String id;
  Map<String, dynamic> urls;

  Photo({required this.id, required this.urls});

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        urls: json["urls"],
      );
}
