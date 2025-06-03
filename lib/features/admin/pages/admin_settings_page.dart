import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/core/settings/providers/settings_provider.dart';
import 'package:ravpos/core/router/app_router.dart';
import 'package:ravpos/features/reports/providers/receipt_template_provider.dart';
import 'package:ravpos/features/reports/providers/printer_settings_provider.dart';
import 'package:ravpos/features/reports/presentation/printer_utils.dart';
import 'package:ravpos/shared/models/order.dart';
import 'package:ravpos/shared/models/order_item.dart';
import 'package:ravpos/shared/models/order_status.dart';
import 'package:ravpos/shared/models/payment_method.dart';
import 'package:ravpos/features/reports/providers/print_log_provider.dart';

class AdminSettingsPage extends ConsumerStatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  ConsumerState<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends ConsumerState<AdminSettingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabTitles = [
    'Genel',
    'Görünüm',
    'Yazıcı',
    'Yazdırma Logları',
    'Fiş Şablonları',
    'Online Sipariş',
    'Yedekleme',
    'Hakkında'
  ];
  
  final List<IconData> _tabIcons = [
    Icons.settings,
    Icons.palette,
    Icons.print,
    Icons.history,
    Icons.receipt_long,
    Icons.cloud,
    Icons.backup,
    Icons.info
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isTablet = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: List.generate(_tabTitles.length, (index) {
            return Tab(
              text: _tabTitles[index],
              icon: Icon(_tabIcons[index]),
            );
          }),
        ),
      ),
      body: Row(
        children: [
          if (isTablet)
            Container(
              width: 250,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1.0,
                  ),
                ),
              ),
              child: ListView.builder(
                itemCount: _tabTitles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(_tabIcons[index]),
                    title: Text(_tabTitles[index]),
                    selected: _tabController.index == index,
                    onTap: () {
                      _tabController.animateTo(index);
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralSettings(settings),
                _buildAppearanceSettings(settings),
                _buildPrinterSettings(settings),
                _buildPrintLogTab(),
                _buildReceiptTemplatesSettings(),
                _buildOnlineOrderSettings(settings),
                _buildBackupSettings(),
                _buildAboutSettings(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(settingsProvider.notifier).saveSettings();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ayarlar kaydedildi')),
          );
        },
        icon: const Icon(Icons.save),
        label: const Text('Kaydet'),
      ),
    );
  }

  Widget _buildGeneralSettings(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Genel Ayarlar',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Management Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'İşletme Yönetimi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: const Text('Yönetim Paneli'),
                    subtitle: const Text('Ürün, kategori ve diğer işletme verilerini yönet'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.goToManagement();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Yönetim paneline yönlendiriliyor...')),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Yönetim panelinden ürün ve kategori ekleme, düzenleme, silme işlemlerini gerçekleştirebilirsiniz.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'İşletme Bilgileri',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: settings.restaurantName,
                    decoration: const InputDecoration(
                      labelText: 'Restoran Adı',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).updateRestaurantName(value);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Uygulama Davranışı',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Masaları Göster'),
                    subtitle: const Text('Ana menüde masaları göster'),
                    value: settings.showTables,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).updateShowTables(value);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSettings(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Görünüm Ayarları',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tema Ayarları',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ThemeMode>(
                    value: settings.themeMode,
                    decoration: const InputDecoration(
                      labelText: 'Tema',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('Sistem Teması'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Açık Tema'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Koyu Tema'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(settingsProvider.notifier).updateThemeMode(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrinterSettings(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yazıcı Ayarları',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yazıcı Türü',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Bluetooth Yazıcı Kullan'),
                    subtitle: const Text('Kapalıysa ağ yazıcısı kullanılacak'),
                    value: settings.useBluetoothPrinter,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).updateUseBluetoothPrinter(value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    settings.useBluetoothPrinter ? 'Bluetooth Yazıcı Bağlantısı' : 'Ağ Yazıcısı Bağlantısı',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (settings.useBluetoothPrinter)
                    TextFormField(
                      initialValue: settings.printerMac,
                      decoration: const InputDecoration(
                        labelText: 'Yazıcı MAC Adresi',
                        border: OutlineInputBorder(),
                        hintText: 'XX:XX:XX:XX:XX:XX',
                      ),
                      onChanged: (value) {
                        ref.read(settingsProvider.notifier).updatePrinterMac(value);
                      },
                    )
                  else
                    Column(
                      children: [
                        TextFormField(
                          initialValue: settings.printerIp,
                          decoration: const InputDecoration(
                            labelText: 'Yazıcı IP Adresi',
                            border: OutlineInputBorder(),
                            hintText: '192.168.1.100',
                          ),
                          onChanged: (value) {
                            ref.read(settingsProvider.notifier).updatePrinterIp(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: settings.printerPort,
                          decoration: const InputDecoration(
                            labelText: 'Yazıcı Port',
                            border: OutlineInputBorder(),
                            hintText: '9100',
                          ),
                          onChanged: (value) {
                            ref.read(settingsProvider.notifier).updatePrinterPort(value);
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yazdırma Seçenekleri',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Test yazdırma işlemi
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Test sayfası yazdırılıyor...')),
                      );
                    },
                    icon: const Icon(Icons.print),
                    label: const Text('Test Sayfası Yazdır'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineOrderSettings(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Online Sipariş Ayarları',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API Sunucu Ayarları',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Online Siparişleri Etkinleştir'),
                    subtitle: const Text('API sunucusunu aktif et'),
                    value: settings.enableOnlineOrders,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).updateEnableOnlineOrders(value);
                    },
                  ),
                  if (settings.enableOnlineOrders) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: settings.apiServerIp,
                      decoration: const InputDecoration(
                        labelText: 'API Sunucu IP Adresi',
                        border: OutlineInputBorder(),
                        hintText: '0.0.0.0 (tüm ağlardan erişim)',
                      ),
                      onChanged: (value) {
                        ref.read(settingsProvider.notifier).updateApiServerIp(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: settings.apiServerPort,
                      decoration: const InputDecoration(
                        labelText: 'API Sunucu Port',
                        border: OutlineInputBorder(),
                        hintText: '8080',
                      ),
                      onChanged: (value) {
                        ref.read(settingsProvider.notifier).updateApiServerPort(value);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (settings.enableOnlineOrders) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Online Sipariş Durumu',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.circle, color: Colors.green),
                      title: const Text('API Sunucu Çalışıyor'),
                      subtitle: Text('${settings.apiServerIp}:${settings.apiServerPort}'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // API sunucusunu yeniden başlat
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('API sunucusu yeniden başlatılıyor...')),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Sunucuyu Yeniden Başlat'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBackupSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yedekleme Ayarları',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Veri Yedekleme',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.backup),
                    title: const Text('Veritabanı Yedekle'),
                    subtitle: const Text('Tüm verileri dışa aktar'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Veritabanı yedekleniyor...')),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.restore),
                    title: const Text('Yedekten Geri Yükle'),
                    subtitle: const Text('Önceki yedeği içe aktar'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Yedekten geri yükleme işlemi başlatılıyor...')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Otomatik Yedekleme',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Günlük Otomatik Yedekleme'),
                    subtitle: const Text('Her gün gün sonu verilerini yedekle'),
                    value: false, // Bu değer ayarlardan alınabilir
                    onChanged: (value) {
                      // Otomatik yedekleme ayarını güncelle
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Günlük yedekleme ${value ? "aktif" : "pasif"}')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Uygulama Hakkında',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.restaurant_menu, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    ref.watch(settingsProvider).restaurantName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'RavPOS Restaurant & Cafe Yönetim Sistemi',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sürüm 1.0.0',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '© 2023 RavSoft Yazılım\nTüm hakları saklıdır.',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Destek',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Yardım Dökümanları'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Yardım dökümanlarını aç
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Destek Talebi Oluştur'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Destek talebi oluştur
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptTemplatesSettings() {
    return Consumer(
      builder: (context, ref, _) {
        final templates = ref.watch(receiptTemplatesProvider);
        final notifier = ref.read(receiptTemplatesProvider.notifier);
        final printers = ref.watch(printerSettingsProvider);
        final mappings = ref.watch(printerTemplateMappingsProvider);
        final mappingsNotifier = ref.read(printerTemplateMappingsProvider.notifier);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _ReceiptTemplateEditor(
                    templates: templates,
                    notifier: notifier,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text('Yazıcı-Şablon Eşleştirme', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...printers.map((printer) {
                        PrinterTemplateMapping? mapping;
                        try {
                          mapping = mappings.firstWhere((m) => m.printerName == printer.name);
                        } catch (_) {
                          mapping = null;
                        }
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('${printer.name} (${printer.type == PrinterType.receipt ? 'Fiş' : 'Mutfak'})'),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: DropdownButton<String>(
                                value: mapping?.templateId ?? templates.first.id,
                                items: templates.map((tpl) => DropdownMenuItem(
                                  value: tpl.id,
                                  child: Text('${_templateTypeName(tpl.type)} - ${tpl.name}'),
                                )).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    mappingsNotifier.updateMapping(
                                      PrinterTemplateMapping(printerName: printer.name, templateId: val),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${printer.name} için şablon güncellendi')),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrintLogTab() {
    return Consumer(
      builder: (context, ref, _) {
        final logs = ref.watch(printLogProvider);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Yazdırma Logları', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('Tümünü Temizle'),
                    onPressed: () {
                      ref.read(printLogProvider.notifier).clearLogs();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tüm loglar silindi')));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: logs.isEmpty
                  ? const Center(child: Text('Henüz log kaydı yok.'))
                  : ListView.separated(
                      itemCount: logs.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final log = logs[i];
                        return ListTile(
                          leading: Icon(log.success ? Icons.check_circle : Icons.error, color: log.success ? Colors.green : Colors.red),
                          title: Text('${log.printerName} - ${log.templateName ?? '-'}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sipariş: ${log.orderNumber ?? '-'}'),
                              Text('Tarih: ${log.timestamp.toString().substring(0, 19)}'),
                              if (log.errorMessage != null) Text('Hata: ${log.errorMessage}', style: const TextStyle(color: Colors.red)),
                              if (log.contentPreview != null) ...[
                                const SizedBox(height: 4),
                                Text('İçerik:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.grey[100],
                                  child: Text(log.contentPreview!, style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
                                ),
                              ],
                            ],
                          ),
                          trailing: Text(log.success ? 'Başarılı' : 'Hata', style: TextStyle(color: log.success ? Colors.green : Colors.red)),
                        );
                      },
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReceiptTemplateEditor extends StatefulWidget {
  final List<ReceiptTemplate> templates;
  final ReceiptTemplatesNotifier notifier;
  const _ReceiptTemplateEditor({required this.templates, required this.notifier});

  @override
  State<_ReceiptTemplateEditor> createState() => _ReceiptTemplateEditorState();
}

class _ReceiptTemplateEditorState extends State<_ReceiptTemplateEditor> {
  late ReceiptTemplateType selectedType;
  late ReceiptTemplate selectedTemplate;
  late TextEditingController headerController;
  late TextEditingController footerController;
  late TextEditingController fontSizeController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    selectedType = ReceiptTemplateType.receipt;
    selectedTemplate = widget.templates.firstWhere((t) => t.type == selectedType);
    headerController = TextEditingController(text: selectedTemplate.header);
    footerController = TextEditingController(text: selectedTemplate.footer);
    fontSizeController = TextEditingController(text: selectedTemplate.fontSize.toString());
    contentController = TextEditingController(text: selectedTemplate.contentTemplate.isNotEmpty ? selectedTemplate.contentTemplate : _defaultContent(selectedType));
  }

  void _updateControllers() {
    selectedTemplate = widget.templates.firstWhere((t) => t.type == selectedType);
    headerController.text = selectedTemplate.header;
    footerController.text = selectedTemplate.footer;
    fontSizeController.text = selectedTemplate.fontSize.toString();
    contentController.text = selectedTemplate.contentTemplate.isNotEmpty ? selectedTemplate.contentTemplate : _defaultContent(selectedType);
  }

  @override
  void didUpdateWidget(covariant _ReceiptTemplateEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Şablon Türü:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            DropdownButton<ReceiptTemplateType>(
              value: selectedType,
              items: ReceiptTemplateType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_templateTypeName(type)),
                );
              }).toList(),
              onChanged: (type) {
                if (type != null) {
                  setState(() {
                    selectedType = type;
                    _updateControllers();
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: headerController,
          decoration: const InputDecoration(labelText: 'Başlık'),
          onChanged: (val) {
            widget.notifier.updateTemplate(selectedTemplate.copyWith(header: val));
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: footerController,
          decoration: const InputDecoration(labelText: 'Alt Bilgi'),
          onChanged: (val) {
            widget.notifier.updateTemplate(selectedTemplate.copyWith(footer: val));
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: fontSizeController,
          decoration: const InputDecoration(labelText: 'Yazı Boyutu'),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            final size = double.tryParse(val) ?? 12;
            widget.notifier.updateTemplate(selectedTemplate.copyWith(fontSize: size));
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: contentController,
          minLines: 4,
          maxLines: 8,
          decoration: InputDecoration(
            labelText: 'Fiş İçeriği (Dinamik Alanlar)',
            alignLabelWithHint: true,
            helperText: 'Kullanılabilir alanlar: {TABLE_NO}, {DATE}, {ITEMS}, {TOTAL}, {PAYMENT_TYPE}',
            border: const OutlineInputBorder(),
          ),
          onChanged: (val) {
            widget.notifier.updateTemplate(selectedTemplate.copyWith(contentTemplate: val));
          },
        ),
        const SizedBox(height: 8),
        Card(
          color: Color(0xFFF5F5F5),
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kullanılabilir Dinamik Alanlar:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('{ORDER_NO}, {TABLE_NO}, {DATE}, {TIME}, {ITEMS}, {PRODUCTS}, {ITEMS_TABLE}, {TOTAL}, {FINAL_TOTAL}, {DISCOUNT}, {TAX}, {WAITER}, {BRANCH}, {CUSTOMER_NOTE}, {PAYMENT_TYPE}', style: TextStyle(fontSize: 13)),
                SizedBox(height: 8),
                Text('Ürün Döngüsü:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('{#ITEMS}\n{PRODUCT_NAME} x {QUANTITY}  {TOTAL_PRICE}\n{/ITEMS}', style: TextStyle(fontFamily: 'monospace', fontSize: 13)),
                SizedBox(height: 8),
                Text('Açıklama:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Alanlar otomatik olarak sipariş verileriyle doldurulur. {#ITEMS}...{/ITEMS} bloğu ile ürünler üzerinde döngü kurabilirsiniz.', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Canlı Önizleme:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: 320,
          padding: const EdgeInsets.all(12),
          color: Colors.grey[200],
          child: _ReceiptPreviewWidget(
            template: selectedTemplate.copyWith(contentTemplate: contentController.text),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Kaydet'),
              onPressed: () {
                widget.notifier.updateTemplate(selectedTemplate.copyWith(
                  header: headerController.text,
                  footer: footerController.text,
                  fontSize: double.tryParse(fontSizeController.text) ?? 12,
                  contentTemplate: contentController.text,
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Şablon kaydedildi')),
                );
              },
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.print),
              label: const Text('Test Yazdır'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Test Fişi Önizleme'),
                    content: SizedBox(
                      width: 320,
                      child: _ReceiptPreviewWidget(
                        template: selectedTemplate.copyWith(contentTemplate: contentController.text),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Kapat'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  String _defaultContent(ReceiptTemplateType type) {
    switch (type) {
      case ReceiptTemplateType.receipt:
        return '{ITEMS}\nToplam: {TOTAL}\nÖdeme: {PAYMENT_TYPE}';
      case ReceiptTemplateType.kitchen:
        return '{ITEMS}';
      case ReceiptTemplateType.bill:
        return '{ITEMS}\nToplam: {TOTAL}';
    }
  }
}

class _ReceiptPreviewWidget extends StatelessWidget {
  final ReceiptTemplate template;
  const _ReceiptPreviewWidget({required this.template});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          template.header,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: template.fontSize + 2),
          textAlign: TextAlign.center,
        ),
        const Divider(),
        ...template.contentTemplate.split('\n').map((line) => Text(line, style: TextStyle(fontSize: template.fontSize))),
        const Divider(),
        Text(
          template.footer,
          style: TextStyle(fontSize: template.fontSize),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

String _templateTypeName(ReceiptTemplateType type) {
  switch (type) {
    case ReceiptTemplateType.receipt:
      return 'Müşteri Fişi';
    case ReceiptTemplateType.kitchen:
      return 'Mutfak Fişi';
    case ReceiptTemplateType.bill:
      return 'Hesap Fişi';
  }
} 