import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbitly/controller/apod_controller.dart';
import 'package:orbitly/news/model/apod_model.dart';

class ApodFragment extends StatelessWidget {
  ApodFragment({super.key});

  final ApodController controller = Get.put(
    ApodController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    if (controller.apod.value == null && !controller.isLoading.value) {
      Future.microtask(() => controller.fetchApod());
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Image of Day',
          style: GoogleFonts.spaceMono(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              Obx(() {
                if (controller.isLoading.value) {
                  return Container(
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.error.isNotEmpty) {
                  return Container(
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        controller.error.value,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final ApodModel? apod = controller.apod.value;
                if (apod == null || apod.imageUrl.isEmpty) {
                  return _imagePlaceholder('No image available');
                }

                final String url = apod.imageUrl.toLowerCase();
                final bool isImage =
                    url.endsWith('.jpg') ||
                    url.endsWith('.jpeg') ||
                    url.endsWith('.png') ||
                    url.endsWith('.webp');

                if (!isImage) {
                  return _imagePlaceholder('Today\'s APOD is not an image');
                }

                return Container(
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      Uri.encodeFull(
                        apod.imageUrl.startsWith('http://')
                            ? apod.imageUrl.replaceFirst('http://', 'https://')
                            : apod.imageUrl,
                      ),
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      headers: const {
                        'User-Agent': 'Mozilla/5.0',
                        'Accept': 'image/*',
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return _imageLoader();
                      },
                      errorBuilder: (_, __, ___) {
                        return _imagePlaceholder('Unable to load image');
                      },
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // PRIMARY BUTTON
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  controller.fetchApod();
                },
                icon: const Icon(Icons.auto_awesome, color: Colors.white,),
                label: Text(
                  'Generate Another Image',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12),


              // TITLE
              Obx(() {
                final apod = controller.apod.value;
                return Text(
                  apod?.title ?? '',
                  style: GoogleFonts.spaceMono(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),

              const SizedBox(height: 8),

              // META
              Text(
                'Date: ${_formatDate(controller.apod.value?.date)}',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Source: ${controller.apod.value?.center ?? 'NASA'}',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 16),

              // DESCRIPTION (SCROLLABLE)
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    _cleanDescription(controller.apod.value?.description),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15.5,
                      height: 1.7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _imageLoader() {
  return Container(
    height: 260,
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Center(child: CircularProgressIndicator()),
  );
}

Widget _imagePlaceholder(String text) {
  return Container(
    height: 260,
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

String _formatDate(String? rawDate) {
  if (rawDate == null || rawDate.isEmpty) return 'Unknown';

  try {
    final dateTime = DateTime.parse(rawDate);
    return '${dateTime.day} ${_monthName(dateTime.month)} ${dateTime.year}';
  } catch (_) {
    return rawDate;
  }
}

String _monthName(int month) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return months[month - 1];
}

String _cleanDescription(String? description) {
  if (description == null || description.trim().isEmpty) {
    return 'No description available for this NASA image.';
  }

  return description
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
