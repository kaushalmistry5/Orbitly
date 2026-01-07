class ApodModel {
  final String imageUrl;
  final String title;
  final String description;
  final String date;
  final String center;

  ApodModel({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.date,
    required this.center,
  });

  factory ApodModel.fromNasaItem(Map<String, dynamic> item) {
    final List dataList =
        item['data'] is List ? item['data'] as List : const [];
    final List linksList =
        item['links'] is List ? item['links'] as List : const [];

    if (dataList.isEmpty || linksList.isEmpty) {
      return ApodModel(
        imageUrl: '',
        title: 'NASA Image',
        description: '',
        date: '',
        center: 'NASA',
      );
    }

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(dataList.first);
    final Map<String, dynamic> link =
        Map<String, dynamic>.from(linksList.first);

    return ApodModel(
      imageUrl: (link['href'] ?? '').toString(),
      title: (data['title'] ?? 'NASA Image').toString(),
      description: (data['description'] ?? '').toString(),
      date: (data['date_created'] ?? '').toString(),
      center: (data['center'] ?? 'NASA').toString(),
    );
  }
}