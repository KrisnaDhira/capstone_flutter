import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_image_classification/controller/home_provider.dart';
import 'package:online_image_classification/service/http_service.dart';
import 'package:online_image_classification/util/widgets_extension.dart';
import 'package:provider/provider.dart';

import 'home_page_beranda.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;  // Menyimpan index halaman yang dipilih

  // Fungsi untuk mengubah halaman ketika tab bottom navigation dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(
        HttpService(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Aplikasi Prediksi Beras"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: _getBody(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Prediksi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Histori',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  // Fungsi untuk memilih halaman sesuai tab yang dipilih
  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomePageBeranda();  // Halaman Beranda
      case 1:
        return const _PredictionPage();  // Halaman Prediksi
      case 2:
        return const _HistoryPage();  // Halaman Histori
      default:
        return const HomePageBeranda();
    }
  }
}

// Halaman Prediksi: Menampilkan proses analisis dengan model ML
class _PredictionPage extends StatefulWidget {
  const _PredictionPage();

  @override
  State<_PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<_PredictionPage> {
  TextEditingController riceNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final homeProvider = context.read<HomeProvider>();

    homeProvider.addListener(() {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final message = homeProvider.message;

      if (message != null) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
      }
    });
  }

  @override
  void dispose() {
    riceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 4,
            children: [
              Expanded(
                child: Consumer<HomeProvider>(
                  builder: (context, value, child) {
                    final imagePath = value.imagePath;
                    return imagePath == null
                        ? const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image,
                        size: 100,
                      ),
                    )
                        : Image.file(
                      File(imagePath.toString()),
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Input for Rice Name
                  TextField(
                    controller: riceNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Rice Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Consumer<HomeProvider>(
                    builder: (context, value, child) {
                      final uploadResponse = value.uploadResponse;
                      final data = uploadResponse?.data;
                      if (value.uploadResponse == null || data == null) {
                        return SizedBox.shrink();
                      }

                      return Text(
                        "${data.result} - ${data.confidenceScore.round()}%",
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            context.read<HomeProvider>().openGallery(),
                        child: const Text("Gallery"),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<HomeProvider>().openCamera(),
                        child: const Text("Camera"),
                      ),
                      ElevatedButton(
                        onPressed: () => context
                            .read<HomeProvider>()
                            .openCustomCamera(context),
                        child: const Text("Custom Camera"),
                      ),
                    ].expanded(),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      final riceName = riceNameController.text;
                      if (riceName.isNotEmpty) {
                        context.read<HomeProvider>().upload(riceName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter rice name')),
                        );
                      }
                    },
                    child: Consumer<HomeProvider>(
                      builder: (context, value, child) {
                        if (value.isUploading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return const Text("Analyze");
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Histori: Menampilkan teks "Histori" (nanti bisa diisi dengan data riwayat)
class _HistoryPage extends StatelessWidget {
  const _HistoryPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: const [
              Text('Histori', style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
