import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ravpos/shared/models/models.dart'; // OrderItem

part 'online_order.freezed.dart';
part 'online_order.g.dart';

enum OnlinePlatform {
  yemeksepeti,
  trendyolYemek,
  getirYemek,
  website,
  other,
}

extension OnlinePlatformExtension on OnlinePlatform {
  String get displayName {
    switch (this) {
      case OnlinePlatform.yemeksepeti: return 'Yemeksepeti';
      case OnlinePlatform.trendyolYemek: return 'Trendyol Yemek';
      case OnlinePlatform.getirYemek: return 'Getir Yemek';
      case OnlinePlatform.website: return 'Web Sitesi';
      case OnlinePlatform.other: return 'Diğer';
    }
  }
  
  // Helper for platform icon 
  String get iconName {
    switch (this) {
      case OnlinePlatform.yemeksepeti: return 'yemeksepeti';
      case OnlinePlatform.trendyolYemek: return 'trendyol';
      case OnlinePlatform.getirYemek: return 'getir';
      case OnlinePlatform.website: return 'website';
      case OnlinePlatform.other: return 'other';
    }
  }
}

@freezed
class OnlineOrder with _$OnlineOrder {
  const factory OnlineOrder({
    required String onlineOrderId, // Platform's own order ID
    required OnlinePlatform platform, // Platform from which the order came
    required String customerName,
    required String customerPhone, // Optional
    String? customerAddress, // Optional, delivery address
    @Default([]) List<OrderItem> items, // Products in POS OrderItem format
    required double totalAmount,
    required DateTime createdAt,
    String? customerNote, // Note from customer
    @Default(false) bool isAccepted, // Has it been accepted by POS?
    @Default(false) bool isRejected, // Has it been rejected by POS?
    String? rejectionReason, // Rejection reason
    // Other fields: estimatedDeliveryTime, paymentStatus, etc.
  }) = _OnlineOrder;

  factory OnlineOrder.fromJson(Map<String, dynamic> json) => _$OnlineOrderFromJson(json);
} 