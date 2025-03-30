# 💎 KGK Diamond Selection App

A **Flutter-based mobile application** that allows users to filter, view, and manage a cart of diamonds. The app follows **best practices in architecture, state management, dependency injection, and performance optimization** to ensure **scalability and maintainability**.

---

## 📚 Project Structure

```plaintext
lib/
├── app.dart                 # App entry point
├── main.dart                # Main function
├── controllers/             # BLoC Controllers
│   ├── cart_controller.dart
│   ├── diamond_controller.dart
│   └── filter_controller.dart
├── models/                  # Data Models
│   └── diamond_model.dart
├── network/                 # API & Networking
│   ├── api_client.dart
│   ├── api_endpoints.dart
│   ├── api_service.dart
│   └── diamond_service.dart  # Fetch diamonds & filter locally
├── utils/                   # Dependency Injection & Helpers
│   └── injection.dart
└── view/                    # UI Screens
    ├── cart_page.dart
    ├── filter_page.dart
    └── result_page.dart
```

---

## 🎯 Architecture & Coding Style

### 🛠️ Architectural Approach: MVC

- **Model**: Defines diamond-related data.
- **View**: Displays UI and listens for state changes.
- **Controller (BLoC)**: Manages business logic and communicates with services.
- **Service Layer**: `DiamondService` fetches data and applies offline filtering.

### 🗲 Key Design Principles

✅ **Separation of Concerns** → UI, logic, and data layers are modular.  
✅ **SOLID Principles** → Ensures maintainability and scalability.  
✅ **Dependency Injection (GetIt)** → Reduces coupling, improves testability.  
✅ **Offline Filtering** → API data is processed locally for efficient filtering.  

---

## 🧬 State Management: BLoC (Business Logic Component)

We use **Flutter BLoC** for predictable state management:

- `FilterCubit`: Manages filtering logic for diamonds.
- `DiamondController`: Handles fetching and sorting diamonds.
- `CartController`: Manages cart operations (add/remove diamonds).

### Why BLoC?

✅ **Scalable for large applications**  
✅ **Improves code reusability & testability**  
✅ **Decouples UI from business logic**  

---

## 📢 Networking & API (Mockoon)

The app **fetches diamonds from a mock API using Mockoon**, then applies filtering locally.

- **Base URL**: `http://localhost:3001/api/diamonds`
- **Library Used**: `Dio` for HTTP requests.

### Mockoon Setup

1. Open Mockoon & import `mockoon_kgk.json`.
2. Start the server on `localhost:3001`.
3. The app fetches diamonds from the mock API and filters them offline.

---

## 🚀 How to Run the App?

### 1️⃣ Setup Mock API

```sh
mockoon-cli start --data mockoon_kgk.json --port 3001
```

### 2️⃣ Run the Flutter App

```sh
flutter pub get
flutter run
```

---

## 📉 Future Enhancements

- [ ] Implement **Hive** for persistent cart storage.
- [ ] Optimize **API caching** with `dio_cache_interceptor`.
- [ ] Add **unit and integration tests** for controllers and services.

---

## © License

This project is licensed under custom terms. **For usage rights, modifications, or distribution, please contact** [Roshan Singh](mailto:thisisroshans@gmail.com) .