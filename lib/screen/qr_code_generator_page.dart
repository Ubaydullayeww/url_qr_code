import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_qr_code/service/global_provider/inherted.dart';

class QrCodeGeneratorPage extends StatelessWidget {
  QrCodeGeneratorPage({super.key});

  final patterns = [
    Icons.grid_view_rounded,
    Icons.stairs_rounded,
    Icons.blur_on_rounded,
    Icons.star,
  ];

  final colors = ['Blue', 'Red', 'Green', 'Purple'];
  final logos = ['None', 'Flutter', 'Custom'];
  final formats = ['PNG', 'JPG', 'SVG'];

  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = QRProvider.of(context);

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
                  // QR Code
                  Center(
                    child:
                        provider.qrData.isEmpty
                            ? const Text(
                              'QR hali mavjud emas',
                              style: TextStyle(color: Colors.white),
                            )
                            : QrImageView(
                              data: provider.qrData,
                              version: QrVersions.auto,
                              size: 200,
                              backgroundColor: Colors.white,
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
                            color:
                                provider.selectedPattern == index
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  provider.selectedPattern == index
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
                  _buildDropdown("COLOR", colors, provider.selectedColor, (
                    value,
                  ) {
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
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.updateQrData(urlController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0A043C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Generate QR'),
                  ),

                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        formats.map((format) {
                          final isSelected = provider.selectedFormat == format;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: ElevatedButton(
                                onPressed: () => provider.selectFormat(format),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isSelected
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.05),
                                  foregroundColor:
                                      isSelected
                                          ? const Color(0xFF0A043C)
                                          : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
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
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items:
                  items.map((item) {
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
