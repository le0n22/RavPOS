import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
      ),
      body: ResponsiveLayout.builder(
        context: context,
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Cash'),
              Tab(text: 'Card'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPaymentsList('All'),
                _buildPaymentsList('Cash'),
                _buildPaymentsList('Card'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Left side - Payment list
        Expanded(
          flex: 2,
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'All'),
                    Tab(text: 'Cash'),
                    Tab(text: 'Card'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildPaymentsList('All'),
                      _buildPaymentsList('Cash'),
                      _buildPaymentsList('Card'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Right side - Payment details
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 51),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment header
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment #12345',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Chip(
                        label: Text('Completed'),
                        backgroundColor: Color(0xFFE8F5E9),
                        labelStyle: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                
                // Payment info
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payment Method'),
                            SizedBox(height: 4),
                            Text(
                              'Credit Card',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date'),
                            SizedBox(height: 4),
                            Text(
                              '15 May 2023, 14:30',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Amount'),
                            SizedBox(height: 4),
                            Text(
                              '₺250.00',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                
                // Order items
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Order Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildOrderItemRow('Item 1', 2, '₺50.00'),
                      _buildOrderItemRow('Item 2', 1, '₺75.00'),
                      _buildOrderItemRow('Item 3', 3, '₺45.00'),
                      _buildOrderItemRow('Item 4', 1, '₺80.00'),
                      const SizedBox(height: 16),
                      const Divider(),
                      _buildTotalRow('Subtotal', '₺250.00'),
                      _buildTotalRow('Tax (8%)', '₺20.00'),
                      _buildTotalRow('Discount', '-₺20.00'),
                      const Divider(),
                      _buildTotalRow('Total', '₺250.00', isTotal: true),
                    ],
                  ),
                ),
                
                // Actions
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Print receipt
                        },
                        icon: const Icon(Icons.print),
                        label: const Text('Print Receipt'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Send receipt
                        },
                        icon: const Icon(Icons.email),
                        label: const Text('Email Receipt'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildPaymentsList(String type) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        final paymentMethod = index % 2 == 0 ? 'Cash' : 'Card';
        final isVisible = type == 'All' || type == paymentMethod;
        
        if (!isVisible) {
          return const SizedBox.shrink();
        }
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text('Payment #${10000 + index}'),
            subtitle: Text('${paymentMethod} • 15 May 2023'),
            trailing: Text(
              '₺${(index + 1) * 25}.00',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () {
              // TODO: View payment details
            },
          ),
        );
      },
    );
  }
  
  Widget _buildOrderItemRow(String name, int quantity, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(name),
          ),
          Expanded(
            flex: 1,
            child: Text('x$quantity'),
          ),
          Expanded(
            flex: 1,
            child: Text(
              price,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTotalRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }
} 