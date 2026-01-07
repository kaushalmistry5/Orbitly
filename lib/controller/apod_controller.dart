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

      // Safely extract items from NASA Image Library response
      final collection = response['collection'];
      final List items = (collection is Map && collection['items'] is List)
          ? collection['items'] as List
          : const [];

      if (items.isEmpty) {
        // Do not throw — expose a clear state to the UI
        apod.value = null;
        error.value = 'No images found for the current query';
        return;
      }

      // Pick a random image for "Generate Another Image"
      items.shuffle();
      apod.value = ApodModel.fromNasaItem(items.first);
    } catch (e) {
      apod.value = null;
      error.value = 'Failed to load image';
    } finally {
      isLoading.value = false;
    }
  }
}