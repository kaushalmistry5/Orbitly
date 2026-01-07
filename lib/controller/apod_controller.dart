import 'package:get/get.dart';
import 'package:orbitly/news/model/apod_model.dart';
import 'package:orbitly/service/apod_api_service.dart';

class ApodController extends GetxController {
  final ApodApiService _service = ApodApiService();

  final isLoading = false.obs;
  final apod = Rxn<ApodModel>();
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApod();
  }

  Future<void> fetchApod() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _service.fetchApod();

      final List items =
          response['collection']?['items'] is List
              ? response['collection']['items']
              : [];

      if (items.isEmpty) {
        throw Exception('No images found');
      }

      // Pick a random image for "Generate Another Image"
      items.shuffle();
      apod.value = ApodModel.fromNasaItem(items.first);
    } catch (e) {
      error.value = 'Failed to load image';
    } finally {
      isLoading.value = false;
    }
  }
}