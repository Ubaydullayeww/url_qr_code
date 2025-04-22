import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_qr_code/screen/scaner.dart';
import '../service/provider/provider.dart';

class QrCodeGeneratorPage extends StatelessWidget {
  QrCodeGeneratorPage({super.key});

  final patterns = [
    Icons.grid_view_rounded,
    Icons.stairs_rounded,
    Icons.blur_on_rounded,
    Icons.star,
  ];

  final colors = ['Blue', 'Red', 'Green', 'Purple'];
  final logos = ['BMW', 'Flutter', 'Merc'];
  final formats = ['PNG', 'JPG', 'SVG'];

  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QRDataProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A043C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListenableBuilder(
            listenable: provider,
            builder: (context, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar with scan button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'QR Generator',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: () async {
                          final scannedData = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QrScannerPage(),
                            ),
                          );
                          if (scannedData != null) {
                            urlController.text = scannedData;
                            provider.updateQrData(scannedData);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // QR Code
                  Center(
                    child: provider.qrData.isEmpty
                        ? const Text(
                      'QR hali mavjud emas',
                      style: TextStyle(color: Colors.white),
                    )
                        : QrImageView(
                      data: provider.qrData,
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                      foregroundColor: provider.getColorFromName(
                        provider.selectedColor,
                      ),
                      embeddedImage: provider.selectedLogo == 'BMW'
                          ? const NetworkImage(
                          'https://www.citypng.com/public/uploads/preview/bmw-car-logo-735811696610457s9siw7ivja.png')
                          : provider.selectedLogo == 'Merc'
                          ? const NetworkImage(
                          'https://st3.depositphotos.com/1012627/13762/i/450/depositphotos_137626418-stock-photo-mercedes-benz-sign.jpg')
                          : provider.selectedLogo == 'Flutter'
                          ? const AssetImage('assets/flutter_logo.png')
                          : null,
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size(40, 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle("PATTERN"),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(patterns.length, (index) {
                      return GestureDetector(
                        onTap: () => provider.selectPattern(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: provider.selectedPattern == index
                                ? Colors.white.withOpacity(0.2)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: provider.selectedPattern == index
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            patterns[index],
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),
                  _buildDropdown(
                      "COLOR", colors, provider.selectedColor, (value) {
                    provider.selectColor(value!);
                  }),

                  const SizedBox(height: 16),
                  _buildDropdown("LOGO", logos, provider.selectedLogo, (value) {
                    provider.selectLogo(value!);
                  }),

                  const SizedBox(height: 24),
                  TextField(
                    controller: urlController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'URL kiriting',
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      provider.updateQrData(value.trim());
                    },
                  ),
                  const SizedBox(height: 16),

                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: formats.map((format) {
                      final isSelected = provider.selectedFormat == format;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            onPressed: () => provider.selectFormat(format),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.05),
                              foregroundColor: isSelected
                                  ? const Color(0xFF0A043C)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(format),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        letterSpacing: 1.5,
        color: Colors.white70,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDropdown(
      String label,
      List<String> items,
      String selectedValue,
      Function(String?) onChanged,
      ) {
    // Ensure the selected value is in the items list
    final validValue = items.contains(selectedValue) ? selectedValue : (items.isNotEmpty ? items[0] : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFF1B1B3A),
              value: validValue,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}