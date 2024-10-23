# Farmlink

## About

Farmlink is a mobile application that connects farmers directly with consumers, enabling the purchase of fresh agricultural products. The platform streamlines the farm-to-table process, making fresh produce more accessible while supporting local farmers.

## Features

### Authentication & User Management

- Splash screen with app introduction
- User registration and login functionality
- Social media integration (Google, Facebook, Twitter)
- User type selection (Farmer/Consumer)
- Detailed account management

### Core Features

- **Home Screen**: Browse featured products with a grid layout of fresh produce
- **Explore Screen**: Category-based product exploration
  - Fresh fruits
  - Vegetables
  - Nuts & grains
  - Search functionality
  
- **Product Management**:
  - Detailed product listings with high-quality images
  - Product descriptions and pricing
  - Rating and review system
  - Add to cart functionality

- **Shopping Experience**:
  - Cart management
  - Checkout process
  - Purchase history
  - Order tracking
  - Delivery details input

- **User Features**:
  - Profile management
  - Notification center
  - Order acceptance confirmation
  - Delivery status updates

## Technical Structure

### Screens

```text
lib/
├── account_screen.dart
├── add_on_reg_screen.dart
├── cart_screen.dart
├── checkout_screen.dart
├── explore_screen.dart
├── home_screen.dart
├── notification_screen.dart
├── order_accepted_screen.dart
├── product_detail_screen.dart
├── product_details_screen.dart
├── product_listing_screen.dart
├── purchase_process_screen.dart
└── usertype_screen.dart
```

## Installation

Prerequisites

1. Flutter SDK: Ensure that you have Flutter installed. If not, follow the official Flutter installation guide.
2. IDE: Use either Android Studio, Visual Studio Code, or any other preferred code editor with Flutter and Dart plugins installed.
3. Git: Ensure Git is installed to clone the repository.

Steps

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/farmlink.git
    ```

2. Navigate into the project directory:

    ```bash
    cd farmlink
    ```

3. Install dependencies:

    ```bash
    flutter pub get
    ```

4. Run the app:
 • For Android:

    ```bash
    flutter run
    ```

 • For iOS:

```bash
flutter run --no-sound-null-safety
```

## Development Setup

To start developing the Farmlink app, follow these steps:

```text
 1. Ensure Flutter SDK is set up:
 • Install and configure Flutter SDK if not already done.

 2. Dependencies:
 • After cloning the project, use flutter pub get to install the required dependencies.

 3. Running the App:
 • Use the flutter run command in the terminal to launch the app on a connected device or simulator.

 4. Editing UI Components:
 • Figma designs are linked to help developers match the UI. Ensure that the structure of the UI remains intact while adding or changing features.

 5. Testing:
 • You can write and run unit tests using the command:
 ```

```bash
flutter test
```

## Contributions

### Willie B Daniels

• Provided the overall app design and structure.

• Coded 13 screens of the app.

• Contributed to the Figma design for the app.

### Samuel Dushime

• Worked on the Figma design.

• Linked various screens.

• Coded 4 pages of the app.

If you’d like to contribute, please feel free to submit a pull request or report any issues to help improve the platform. Ensure your code follows the project’s guidelines and include comments where necessary.

## License

This project is licensed under the ALU License. See the LICENSE file for details.
