class Datamodel {
  dynamic id;
  dynamic title;
  dynamic price;
  dynamic description;
  dynamic category;
  dynamic image;
  dynamic rating;

  Datamodel(
      {required this.id,
      required this.title,
      required this.image,
      required this.category,
      required this.description,
      required this.price,
      required this.rating});

  factory Datamodel.api({required Map<String, dynamic> data}) {
    return Datamodel(
        id: data['id'],
        title: data['title'],
        image: data['image'],
        category: data['category'],
        description: data['description'],
        price: data['price'],
        rating: data['rating']);
  }
}
