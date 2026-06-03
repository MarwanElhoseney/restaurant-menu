# 🍔 Restaurant App

A full-featured Flutter restaurant ordering app with authentication, product browsing, cart management, and checkout.

---

## 🎥 App Demo

https://github.com/user-attachments/assets/7160471f-7469-4dac-9856-912f80e3c832

---

## ✨ Features

- **Authentication** — Login, Sign Up, Guest mode, Auto-login via saved token
- **Home** — Browse products in a responsive grid with search and category filtering
- **Favorites** — Save favorite items locally using SharedPreferences
- **Product Details** — Customize spicy level with a slider, choose toppings and side options
- **Cart** — Add/remove items, view total price
- **Checkout** — Order summary with taxes & fees, Cash or Visa payment selection
- **Profile** — View and edit profile info, upload avatar, add/update Visa card, logout
- **Order History** — View past orders and reorder
- **Skeleton Loading** — Smooth loading states across screens using `skeletonizer`

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State Management | Bloc / Cubit |
| HTTP Client | Dio |
| Local Storage | SharedPreferences |
| Image Picking | image_picker |
| SVG Rendering | flutter_svg |
| UI Utilities | gap, skeletonizer |

---

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/        # App colors and theme constants
│   ├── network/          # Dio client, API service, error handling
│   └── utils/            # SharedPreferences helper
│
├── features/
│   ├── auth/             # Login, Signup, Profile — Cubit + Repo
│   ├── home/             # Product listing — Cubit + Repo + Widgets
│   ├── product/          # Product details, toppings, spicy slider
│   ├── cart/             # Cart view, cart model & repo
│   ├── checkout/         # Checkout view & order summary widget
│   └── orderHistory/     # Order history screen
│
├── share/                # Shared/reusable widgets
├── root.dart             # Bottom navigation shell
├── splash.dart           # Splash screen with auto-login check
└── main.dart             # App entry point & BlocProviders
```

---

## 🧠 Architecture & State Management

The app follows a **Feature-First Clean Architecture** with **Bloc/Cubit** for state management.

### Why Cubit over Bloc?

Cubit is used where state transitions are straightforward (no complex event mapping needed), keeping boilerplate minimal while still being fully testable and reactive.

```
Feature
├── cubit/
│   ├── home_cubit.dart       # Business logic & state emission
│   └── home_states.dart      # State classes (Loading, Success, Error)
├── data/
│   ├── model/                # Data models with fromJson factory
│   └── repo/                 # Repository — single source of truth for data
└── views/ & widgets/         # Pure UI, reads state via BlocBuilder
```







---

### Error Handling Strategy

Errors are classified at two levels:

**1. Network level** — `ApiExceptions.handleError()` maps `DioExceptionType` to human-readable messages:

| Dio Error Type | User Message |
|---|---|
| `connectionTimeout` | "Bad Connection" |
| `sendTimeout` | "Request timeout, please try again" |
| `receiveTimeout` | "Response timeout, please try again" |
| HTTP 302 | "This Email Already Taken" |
| Server message | Extracted from `response.data["message"]` |

**2. Business logic level** — Repos check the API response `code` field and throw `ApiError` if it's not `200`/`201`:

```dart
if (code != 200 && code != 201) {
  throw ApiError(message: msg ?? "Unknown error");
}
```

All errors bubble up to the UI as `ApiError`, which has a clean `toString()` override for display in snackbars.

---

## 🔄 Data Flow & Repository Pattern

Each feature owns its repository which is the **only class allowed to talk to `ApiService`**. Views and Cubits never call `ApiService` directly.

```
UI (View)
  └── Cubit / StatefulWidget
        └── Repository
              └── ApiService
                    └── DioClient → REST API
```

---
### Authentication & Token Lifecycle

```
User logs in
  └── AuthRepo.login() → POST /login
        └── On success: PrefHelper.saveToken(token)

App cold starts
  └── SplashView → authRepo.autoLogin()
        ├── token == null   → LoginView
        ├── token == "guest" → Root (Guest mode)
        └── token exists    → getProfileData() → Root (Logged in)

Every API request
  └── DioClient interceptor reads token → injects Authorization header

Logout
  └── POST /logout + PrefHelper.clearToken() + navigate to LoginView
```

Guest mode stores the literal string `"guest"` as the token — the interceptor detects this and skips the Authorization header, while `AuthRepo.isGuest` flag drives conditional UI rendering.

---

## 🌍 API Reference

```
Base URL: https://sonic-zdi0.onrender.com/api
```

| Method | Endpoint | Description |
|---|---|---|
| POST | `/login` | User login |
| POST | `/register` | User registration |
| GET | `/profile` | Get user profile |
| POST | `/update-profile` | Update profile & avatar |
| POST | `/logout` | Logout |
| GET | `/products` | Get all products |
| GET | `/toppings` | Get available toppings |
| GET | `/side-options` | Get side options |
| POST | `/cart/add` | Add item to cart |
| GET | `/cart` | Get cart contents |
| DELETE | `/cart/remove/:id` | Remove cart item |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc:        # State management
  dio:                 # HTTP requests
  shared_preferences:  # Local token & favorites storage
  image_picker:        # Profile image upload
  flutter_svg:         # SVG assets
  gap:                 # Spacing utility
  skeletonizer:        # Skeleton loading UI
```

---

## 📄 License

This project is licensed under the MIT License.
