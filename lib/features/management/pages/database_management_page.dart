import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatabaseManagementPage extends ConsumerStatefulWidget {
  const DatabaseManagementPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DatabaseManagementPage> createState() => _DatabaseManagementPageState();
}

class _DatabaseManagementPageState extends ConsumerState<DatabaseManagementPage> {
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veritabanı Yönetimi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 26),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Tehlikeli Bölge',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Bu işlemler geri alınamaz. Veritabanını sıfırlamadan önce gerekli yedekleri aldığınızdan emin olun!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: null, // Sıfırlama devre dışı
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Veritabanını Sıfırla (Devre Dışı)'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Veri Yönetimi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: null, // Örnek veri yükleme devre dışı
                      icon: const Icon(Icons.data_array),
                      label: const Text('Örnek Veri Yükle (Devre Dışı)'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _backupDatabase,
                      icon: const Icon(Icons.backup),
                      label: const Text('Veritabanını Yedekle'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _restoreDatabase,
                      icon: const Icon(Icons.restore),
                      label: const Text('Yedekten Geri Yükle'),
                    ),
                  ],
                ),
              ),
            ),
            if (_statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Card(
                  color: _statusMessage.contains('Hata') 
                      ? Theme.of(context).colorScheme.error.withValues(alpha: 26)
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 26),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _statusMessage,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _statusMessage.contains('Hata')
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _backupDatabase() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _statusMessage = 'Veritabanı başarıyla yedeklendi! (Simülasyon)';
    });
  }

  Future<void> _restoreDatabase() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _statusMessage = 'Veritabanı yedekten başarıyla geri yüklendi! (Simülasyon)';
    });
  }
} 