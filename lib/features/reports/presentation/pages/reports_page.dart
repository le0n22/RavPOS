import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:ravpos/shared/providers/providers.dart';
import 'package:ravpos/shared/widgets/loading_widget.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as ex;
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:ravpos/shared/models/table_report.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart' as pos_printer;
import 'package:esc_pos_utils/esc_pos_utils.dart' as esc_utils;
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart' as pos_bt;
import 'dart:io' show Platform;
import '../printer_utils.dart'
  if (dart.library.html) '../printer_utils_web.dart';
import '../../providers/printer_settings_provider.dart';
import 'package:flutter/foundation.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> with SingleTickerProviderStateMixin {
  String _selectedPeriod = 'Günlük';

  // ADIM 1: Filtre ve arama için state değişkenleri
  String _searchText = '';
  String? _selectedPaymentType;
  String? _selectedTable;

  @override
  void initState() {
    super.initState();
    // Load daily report by default
    Future.microtask(() {
      ref.read(reportProvider.notifier).generateDailyReport();
    });
  }

  void _updateReport(String period) {
    setState(() {
      _selectedPeriod = period;
    });

    switch (period) {
      case 'Günlük':
        ref.read(reportProvider.notifier).generateDailyReport();
        break;
      case 'Haftalık':
        ref.read(reportProvider.notifier).generateWeeklyReport();
        break;
      case 'Aylık':
        ref.read(reportProvider.notifier).generateMonthlyReport();
        break;
      case 'Özel':
        _selectCustomDateRange();
        break;
    }
  }

  Future<void> _selectCustomDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(reportProvider.notifier).generateReport(picked.start, picked.end);
    } else {
      // If user cancels, revert to previous selection
      _updateReport(_selectedPeriod);
    }
  }

  final List<Tab> _tabs = const [
    Tab(text: 'Genel Özet'),
    Tab(text: 'Detaylı Siparişler'),
    Tab(text: 'Ürün Raporu'),
    Tab(text: 'Ödeme Yöntemleri'),
    Tab(text: 'Garson Raporu'),
    Tab(text: 'Masa Raporu'),
    Tab(text: 'Stok/Maliyet'),
    Tab(text: 'Kampanya Raporu'),
    Tab(text: 'Saatlik Yoğunluk'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Raporlar'),
          actions: [
            // Bildirim ikonu (örnek)
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            // ADIM: Güncel tarih ve saat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: StreamBuilder<DateTime>(
                stream: Stream<DateTime>.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
                builder: (context, snapshot) {
                  final now = snapshot.data ?? DateTime.now();
                  final formatted = '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
                  return Text(
                    formatted,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  );
                },
              ),
            ),
            PopupMenuButton<String>(
              onSelected: _updateReport,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'Günlük',
                  child: Text('Günlük'),
                ),
                const PopupMenuItem(
                  value: 'Haftalık',
                  child: Text('Haftalık'),
                ),
                const PopupMenuItem(
                  value: 'Aylık',
                  child: Text('Aylık'),
                ),
                const PopupMenuItem(
                  value: 'Özel',
                  child: Text('Özel Tarih Aralığı'),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(_selectedPeriod),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: _tabs,
          ),
        ),
        body: ref.watch(reportProvider).when(
          loading: () => const LoadingWidget(),
          error: (error, stackTrace) => Center(
            child: Text('Hata: [31m${error.toString()}[0m'),
          ),
          data: (reportData) {
            if (reportData.totalOrders == 0) {
              return const Center(
                child: Text(
                  'Seçilen tarih aralığında raporlanacak veri bulunmamaktadır.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return TabBarView(
              children: [
                // Genel Özet
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryCard(reportData),
                      const SizedBox(height: 24),
                      _buildSalesChart(reportData),
                    ],
                  ),
                ),
                // Detaylı Siparişler
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _OrderActionsSidebar(
                        filteredOrders: reportData.orders,
                        ref: ref,
                        onExportCsv: _exportOrdersToCsv,
                        onExportExcel: _exportOrdersToExcel,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Ara (Masa, Ürün, ...)',
                                prefixIcon: Icon(Icons.search),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchText = value;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: _selectedPaymentType,
                              hint: Text('Ödeme Tipi'),
                              items: ['Nakit', 'Kart', 'Diğer']
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentType = value;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: _selectedTable,
                              hint: Text('Masa'),
                              items: reportData.orders
                                  .map((o) => o.tableNumber ?? '-')
                                  .toSet()
                                  .map((masa) => DropdownMenuItem(
                                        value: masa,
                                        child: Text(masa),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTable = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Ürün Raporu
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildTopProductsSection(reportData),
                ),
                // Ödeme Yöntemleri
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildPaymentMethodsChart(reportData),
                ),
                // Garson Raporu (placeholder)
                const Center(child: Text('Garson Raporu (yakında)')),
                // Masa Raporu (analitik)
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildTableReportsSection(reportData.tableReports),
                ),
                // Stok/Maliyet (placeholder)
                const Center(child: Text('Stok/Maliyet Raporu (yakında)')),
                // Kampanya Raporu (placeholder)
                const Center(child: Text('Kampanya Raporu (yakında)')),
                // Saatlik Yoğunluk (yeni analitik)
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildHourlyOrderChart(reportData.hourlyOrderCounts),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ReportData reportData) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rapor Özeti',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  'Toplam Satış',
                  '₺${reportData.totalSales.toStringAsFixed(2)}',
                  Icons.attach_money,
                ),
                _buildSummaryItem(
                  'Sipariş Sayısı',
                  reportData.totalOrders.toString(),
                  Icons.receipt_long,
                ),
                _buildSummaryItem(
                  'Ortalama Sipariş',
                  '₺${reportData.averageOrderValue.toStringAsFixed(2)}',
                  Icons.analytics,
                ),
                _buildSummaryItem(
                  'Toplam İndirim',
                  '₺${reportData.totalDiscountGiven.toStringAsFixed(2)}',
                  Icons.discount,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChart(ReportData reportData) {
    final dailyData = reportData.dailySalesData;
    
    if (dailyData.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort the dates
    final sortedDates = dailyData.keys.toList()..sort();
    
    // Prepare line chart data
    final spots = <FlSpot>[];
    
    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      final amount = dailyData[date] ?? 0;
      spots.add(FlSpot(i.toDouble(), amount));
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Satış Trendi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '₺${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < sortedDates.length) {
                            final date = sortedDates[value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${date.day}/${date.month}',
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d), width: 1),
                  ),
                  minX: 0,
                  maxX: (sortedDates.length - 1).toDouble(),
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 51),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProductsSection(ReportData reportData) {
    final topProducts = reportData.topSellingProducts;
    
    if (topProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'En Çok Satan Ürünler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: topProducts.map((p) => p.totalQuantitySold.toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < topProducts.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _shortenProductName(topProducts[value.toInt()].productName),
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    topProducts.length > 5 ? 5 : topProducts.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: topProducts[index].totalQuantitySold.toDouble(),
                          color: Theme.of(context).colorScheme.primary,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _shortenProductName(String name) {
    if (name.length <= 8) {
      return name;
    }
    return '${name.substring(0, 6)}...';
  }

  Widget _buildPaymentMethodsChart(ReportData reportData) {
    final paymentData = reportData.salesByPaymentMethod;
    
    if (paymentData.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate the total amount to determine percentages
    final totalAmount = paymentData.values.fold(0.0, (sum, amount) => sum + amount);
    
    // Prepare the sections for pie chart
    final sections = <PieChartSectionData>[];
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];
    
    int colorIndex = 0;
    paymentData.forEach((method, amount) {
      final percentage = (amount / totalAmount) * 100;
      sections.add(
        PieChartSectionData(
          value: amount,
          title: '${percentage.toStringAsFixed(1)}%',
          color: colors[colorIndex % colors.length],
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ödeme Yöntemleri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(
                        paymentData.length,
                        (index) {
                          final entry = paymentData.entries.elementAt(index);
                          final percentage = (entry.value / totalAmount) * 100;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: colors[index % colors.length],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${entry.key} (${percentage.toStringAsFixed(1)}%)',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderListSection(List<Order> orders) {
    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detaylı Sipariş Listesi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Zaman')),
                  DataColumn(label: Text('Masa')),
                  DataColumn(label: Text('Tutar')),
                  DataColumn(label: Text('Ödeme')),
                  DataColumn(label: Text('Garson')),
                ],
                rows: orders.map((order) => DataRow(
                  cells: [
                    DataCell(Text(() {
                      final date = order.updatedAt ?? order.createdAt ?? DateTime(0);
                      if (date == DateTime(0)) return '-';
                      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
                    }())),
                    DataCell(Text(order.tableNumber ?? '-')),
                    DataCell(Text('₺${order.totalAmount.toStringAsFixed(2)}')),
                    DataCell(Text(order.paymentMethod?.displayName ?? '-')),
                    DataCell(Text('-')),
                  ],
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ADIM: CSV export fonksiyonu
  Future<void> _exportOrdersToCsv(List<Order> orders) async {
    List<List<String>> rows = [
      ['Zaman', 'Masa', 'Tutar', 'Ödeme', 'Garson']
    ];
    for (final order in orders) {
      final date = order.updatedAt ?? order.createdAt ?? DateTime(0);
      final formatted = date == DateTime(0)
          ? '-'
          : '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      rows.add([
        formatted,
        order.tableNumber ?? '-',
        '₺${order.totalAmount.toStringAsFixed(2)}',
        order.paymentMethod?.displayName ?? '-',
        '-', // Garson
      ]);
    }
    String csv = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csv);
    await FileSaver.instance.saveFile(
      name: 'siparis_raporu',
      bytes: Uint8List.fromList(bytes),
      ext: 'csv',
      mimeType: MimeType.csv,
    );
  }

  // ADIM: Excel export fonksiyonu
  Future<void> _exportOrdersToExcel(List<Order> orders) async {
    final excel = ex.Excel.createExcel();
    final sheet = excel['Sipariş Raporu'];
    sheet.appendRow(['Zaman', 'Masa', 'Tutar', 'Ödeme', 'Garson']);
    for (final order in orders) {
      final date = order.updatedAt ?? order.createdAt ?? DateTime(0);
      final formatted = date == DateTime(0)
          ? '-'
          : '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      sheet.appendRow([
        formatted,
        order.tableNumber ?? '-',
        '₺${order.totalAmount.toStringAsFixed(2)}',
        order.paymentMethod?.displayName ?? '-',
        '-', // Garson
      ]);
    }
    final fileBytes = excel.encode();
    if (fileBytes != null) {
      await FileSaver.instance.saveFile(
        name: 'siparis_raporu',
        bytes: Uint8List.fromList(fileBytes),
        ext: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );
    }
  }

  // Saatlik sipariş yoğunluğu bar chart
  Widget _buildHourlyOrderChart(Map<int, int> hourlyCounts) {
    if (hourlyCounts.isEmpty) {
      return const Center(child: Text('Saatlik sipariş verisi yok.'));
    }
    final sortedHours = List<int>.generate(24, (i) => i);
    final maxCount = hourlyCounts.values.isNotEmpty ? hourlyCounts.values.reduce((a, b) => a > b ? a : b) : 1;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saatlik Sipariş Yoğunluğu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (maxCount * 1.2).ceilToDouble(),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final hour = value.toInt();
                          if (hour % 2 == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('$hour'),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: sortedHours.map((hour) {
                    final count = hourlyCounts[hour] ?? 0;
                    return BarChartGroupData(
                      x: hour,
                      barRods: [
                        BarChartRodData(
                          toY: count.toDouble(),
                          color: Theme.of(context).colorScheme.primary,
                          width: 12,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Masa bazlı raporlar tablosu
  Widget _buildTableReportsSection(Map<String, TableReport> tableReports) {
    if (tableReports.isEmpty) {
      return const Center(child: Text('Masa bazlı rapor verisi yok.'));
    }
    final sorted = tableReports.values.toList()
      ..sort((a, b) => b.totalSales.compareTo(a.totalSales));
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masa Bazlı Rapor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Masa')),
                  DataColumn(label: Text('Sipariş Sayısı')),
                  DataColumn(label: Text('Toplam Ciro')),
                ],
                rows: sorted.map((table) => DataRow(
                  cells: [
                    DataCell(Text(table.tableNumber)),
                    DataCell(Text(table.orderCount.toString())),
                    DataCell(Text('₺${table.totalSales.toStringAsFixed(2)}')),
                  ],
                )).toList().cast<DataRow>(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ESC/POS ile fiş yazdırma fonksiyonu
  Future<void> printOrderReport(List<Order> orders, WidgetRef ref, PrinterType printerType) async {
    final profile = await esc_utils.CapabilityProfile.load();
    final printer = pos_printer.NetworkPrinter(esc_utils.PaperSize.mm80, profile);
    // IP ve portu sabit verdik, ayarlardan alınabilir
    final res = await printer.connect('192.168.1.100', port: 9100);
    if (res == pos_printer.PosPrintResult.success) {
      printer.text('Detaylı Sipariş Raporu', styles: esc_utils.PosStyles(align: esc_utils.PosAlign.center, bold: true));
      printer.hr();
      for (final order in orders) {
        printer.text('Masa: [1m${order.tableNumber ?? '-'}[0m  Tutar: ₺${order.totalAmount.toStringAsFixed(2)}');
        printer.text('Tarih: ${(order.updatedAt ?? order.createdAt)?.toString() ?? '-'}');
        printer.text('Ödeme: ${order.paymentMethod?.displayName ?? '-'}');
        printer.hr(ch: '-');
      }
      printer.feed(2);
      printer.cut();
      printer.disconnect();
    }
  }

  // Bluetooth ile ESC/POS yazdırma fonksiyonu
  Future<void> printOrderReportBluetooth(List<Order> orders) async {
    final printerManager = pos_bt.PrinterBluetoothManager();
    final profile = await esc_utils.CapabilityProfile.load();
    // Yazıcıları tara
    List<pos_bt.PrinterBluetooth> foundPrinters = [];
    final scanSubscription = printerManager.scanResults.listen((devices) {
      foundPrinters = devices;
    });
    printerManager.startScan(const Duration(seconds: 4));
    await Future.delayed(const Duration(seconds: 4));
    await scanSubscription.cancel();
    printerManager.stopScan();
    if (foundPrinters.isEmpty) {
      return;
    }
    // Basitçe ilk bulunan yazıcıyı seçiyoruz (UI ile seçtirmek için ek kod gerek)
    final selectedPrinter = foundPrinters.first;
    printerManager.selectPrinter(selectedPrinter);
    final result = await printerManager.printTicket(
      await buildBluetoothTicket(orders, profile),
    );
  }
}

class _OrderActionsSidebar extends StatelessWidget {
  final List<Order> filteredOrders;
  final WidgetRef ref;
  final Future<void> Function(List<Order>) onExportCsv;
  final Future<void> Function(List<Order>) onExportExcel;
  const _OrderActionsSidebar({
    required this.filteredOrders,
    required this.ref,
    required this.onExportCsv,
    required this.onExportExcel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dışa Aktar / Yazdır', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.download),
              label: Text('CSV\'ye Aktar'),
              onPressed: () => onExportCsv(filteredOrders),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: Icon(Icons.table_chart),
              label: Text('Excel\'e Aktar'),
              onPressed: () => onExportExcel(filteredOrders),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.receipt_long),
              label: Text('Fiş Yazdır'),
              onPressed: () => printOrderReport(filteredOrders, ref, PrinterType.receipt),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: Icon(Icons.restaurant_menu),
              label: Text('Mutfak Yazdır'),
              onPressed: () => printOrderReport(filteredOrders, ref, PrinterType.kitchen),
            ),
            const SizedBox(height: 8),
            if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
              ElevatedButton.icon(
                icon: Icon(Icons.bluetooth),
                label: Text('Bluetooth ile Yazdır'),
                onPressed: () => printOrderReportBluetooth(filteredOrders),
              ),
          ],
        ),
      ),
    );
  }
} 