# RavPOS - Restaurant Point of Sale System

RavPOS is a modern restaurant point of sale application built with Flutter, designed to help restaurant owners and staff manage orders, products, payments, and reports efficiently.

## Features

- **Dashboard**: Quick overview of sales, orders, and key metrics
- **Products Management**: Add, edit, and manage your menu items
- **Order Management**: Create and track orders, add items, and process payments
- **Payment Processing**: Handle different payment methods and generate receipts
- **Reports**: View sales reports, analyze product performance, and track revenue

## Technical Details

- Built with Flutter 3.16+
- Material Design 3 with a custom orange/dark green theme
- Responsive design optimized for both tablets and phones
- Clean architecture for maintainable and scalable code

## Project Structure

```
lib/
  core/
    constants/      # App constants
    theme/          # Theme configuration
    utils/          # Utility classes
  features/
    dashboard/      # Dashboard feature
    products/       # Products management
    orders/         # Order management
    payments/       # Payment processing
    reports/        # Reports and analytics
  shared/
    widgets/        # Reusable widgets
    models/         # Shared data models
```

## Dependencies

- **flutter_riverpod**: State management
- **go_router**: Navigation and routing
- **sqflite**: Local database storage
- **freezed**: Code generation for immutable classes
- **json_annotation**: JSON serialization
- **dio**: HTTP client for API calls

## Getting Started

1. Ensure you have Flutter 3.16+ installed
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Screenshots

(Screenshots will be added here)

## Future Enhancements

- User authentication and role-based access
- Inventory management
- Customer management and loyalty program
- Online ordering integration
- Kitchen display system
- Cloud synchronization

## License

This project is licensed under the MIT License - see the LICENSE file for details.
