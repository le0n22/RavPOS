import 'package:flutter/material.dart';
import 'package:ravpos/shared/models/table.dart';
import 'package:ravpos/shared/models/table_status.dart';
import 'package:google_fonts/google_fonts.dart';

class TableCard extends StatelessWidget {
  final RestaurantTable table;
  final VoidCallback onTap;

  const TableCard({
    Key? key,
    required this.table,
    required this.onTap,
  }) : super(key: key);

  // Helper function to determine color based on table status
  Color _getColorForStatus(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        // A soft green tone
        return const Color(0xFFC8E6C9); // Colors.green[100]
      case TableStatus.occupied:
        // A friendly blue tone
        return const Color(0xFFBBDEFB); // Colors.blue[100]
      case TableStatus.paymentPending:
         // A warm orange tone
        return const Color(0xFFFFE0B2); // Colors.orange[100]
      default:
        // A neutral grey by default
        return const Color(0xFFE0E0E0); // Colors.grey[300]
    }
  }
  
  // Helper function to determine a contrasting foreground color for the text
  Color _getForegroundColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Colors.green.shade900;
      case TableStatus.occupied:
        return Colors.blue.shade900;
      case TableStatus.paymentPending:
        return Colors.orange.shade900;
      default:
        return Colors.grey.shade800;
    }
  }

  // Helper function to get a status icon for the table
  IconData _getIconForStatus(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Icons.check_circle_outline;
      case TableStatus.occupied:
        return Icons.restaurant_menu;
      case TableStatus.paymentPending:
        return Icons.hourglass_top;
      default:
        return Icons.help_outline;
    }
  }

  // Helper function to get the status text
  String _getStatusText(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return 'Available';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.paymentPending:
        return 'Payment Pending';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getColorForStatus(table.status);
    final foregroundColor = _getForegroundColor(table.status);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: isDark ? 1.0 : 4.0,
      shadowColor: isDark ? Colors.transparent : Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getStatusText(table.status),
                    style: GoogleFonts.inter(
                      color: foregroundColor.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Icon(
                    _getIconForStatus(table.status),
                    color: foregroundColor.withOpacity(0.8),
                    size: 20,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                table.name,
                style: GoogleFonts.poppins(
                  color: foregroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 4),
              if (table.status == TableStatus.available)
                Row(
                  children: [
                    Icon(Icons.person_outline_rounded, size: 16, color: foregroundColor.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Text(
                      '${table.capacity} Seats',
                      style: GoogleFonts.inter(
                        color: foregroundColor.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              if (table.status == TableStatus.occupied && table.currentOrderTotal != null && table.currentOrderTotal! > 0)
                Text(
                  '₺${table.currentOrderTotal!.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    color: foregroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 