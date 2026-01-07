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
    final List dataList = item['data'] is List ? item['data'] : const [];
    final List linksList = item['links'] is List ? item['links'] : const [];

    final Map<String, dynamic> data =
        dataList.isNotEmpty && dataList.first is Map
            ? Map<String, dynamic>.from(dataList.first)
            : const {};

    final Map<String, dynamic> link =
        linksList.isNotEmpty && linksList.first is Map
            ? Map<String, dynamic>.from(linksList.first)
            : const {};

    return ApodModel(
      imageUrl: (link['href'] ?? '').toString(),
      title: (data['title'] ?? 'NASA Image').toString(),
      description: (data['description'] ?? '').toString(),
      date: (data['date_created'] ?? '').toString(),
      center: (data['center'] ?? 'NASA').toString(),
    );
  }
}