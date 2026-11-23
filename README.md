# Mallow News App (Flutter)

A production-grade News application built with Flutter, fetching live space articles from the **Spaceflight News API (v4)**. Designed with Clean Architecture (Domain Use Cases, Repositories, Data Sources), BLoC state management, 100% Stateless UI screens, and responsive layouts across mobile phones, tablets, and iPads.

---

## 📱 Features

### 1. Discover / List Screen (`NewsListScreen`)
- **Stateless Architecture**: Implemented as a pure `StatelessWidget` utilizing `NotificationListener<ScrollNotification>` for performant, controller-free scroll pagination.
- **Live Search**: Debounced search input (500ms) filtering articles by title and summary without spamming API requests.
- **Category Filter Chips**: Filter by news sources/categories (`All`, `SpaceNews`, `NASA Spaceflight`, `Ars Technica`, etc.) with animated active pill states.
- **Pull-to-Refresh**: Seamless `RefreshIndicator` enabling users to fetch the latest feed.
- **Infinite Scroll Pagination**: Automatically triggers next page requests as the user scrolls near the bottom.
- **Error & Loading States**:
  - Full skeleton shimmer loader (`ShimmerArticleLoader`) on initial fetch.
  - Non-intrusive loading spinner at the bottom during pagination.
  - Dedicated retry footer when pagination fails without clearing existing list items.
  - Dedicated empty state widget when search returns 0 results.

### 2. Article Detail Screen (`NewsDetailScreen`)
- **Modern Curved Sheet UI**: Full-bleed hero image with high-contrast gradient overlay, dynamic category badge, headline, and time-ago label, overlapping into a rounded content card sheet.
- **Stateless & Gmail-style Swipe Navigation**: Pure `StatelessWidget` wrapping a `PageView.builder` allowing horizontal swipe navigation between articles with instant hero transitions.
- **End-of-List Pre-fetching**: If the user swipes near the end of loaded articles in detail mode, the next batch is fetched seamlessly in the background.
- **Publisher Verification**: Prominent publisher logo avatar with verified checkmark badge.
- **Native System Share**: Top circular share button triggering the native device share sheet via `share_plus` (`ShareUtils.shareArticle`).
- **Read Full Article Action**: Primary bottom call-to-action launching the external web browser using `url_launcher` via `UrlUtils.launchURL` with fallback handling and Android 11+ package visibility queries configured.

### 3. Responsiveness (Phones, Tablets & iPads)
- Built with `LayoutBuilder` and `MediaQuery`.
- Displays a clean single-column list on mobile phones (`width < 600`).
- Adapts to a 2-column card grid on tablets and iPads (`width >= 600`).

### 4. Production Robustness & Theming
- **Typed API Errors**: `ApiException` distinguishes between connection timeouts, send/receive timeouts, offline/network errors, and server HTTP codes.
- **Image Fallback Handling**: Null-safe `CustomNetworkImage` wrapper around `cached_network_image` with placeholder and missing-image fallbacks.
- **Dark Mode Support**: Full light and dark themes adhering to system brightness.

---

## 🏛️ Clean Architecture Overview

The app follows **Clean Architecture** principles with clear separation of concerns across Data, Domain, and Presentation layers:

```
lib/
├── core/
│   ├── constants/       # API endpoints, default page sizes, and categories
│   ├── di/              # GetIt + Injectable dependency injection
│   ├── errors/          # Typed ApiException & error categorization
│   ├── network/         # DioFactory, Retrofit ApiClient & generated client
│   ├── theme/           # Light & Dark ThemeData configurations
│   ├── usecase/         # Generic UseCase<Type, Params> base abstraction
│   └── utils/           # Debouncer, DateFormatter, ShareUtils, UrlUtils
├── data/
│   ├── models/          # ArticleResponse, ResultsResponse (json_serializable)
│   └── repositories/    # NewsRepositoryImpl with Dio & error mapping
├── domain/
│   ├── repositories/    # NewsRepository contract interface
│   └── usecases/        # GetArticlesUseCase, GetArticleByIdUseCase & parameters
└── presentation/
    ├── bloc/            # NewsBloc, NewsEvent, NewsState
    ├── screens/         # NewsListScreen, NewsDetailScreen (100% Stateless)
    └── widgets/         # ArticleCard, SearchBarWidget, CategoryFilterChips, ShimmerLoader, etc.
```

---

## 💡 State Management Justification (BLoC)

**BLoC (`flutter_bloc`)** was chosen for this application:
1. **Unidirectional Data Flow**: Clear, predictable state transitions driven by explicit events (`FetchInitialNews`, `RefreshNews`, `LoadMoreNews`, `SearchQueryChanged`, `CategorySelected`).
2. **Robust Pagination & Concurrency Handling**: Simplifies keeping existing article items while tracking distinct pagination states (`isLoadingMore`, `hasReachedMax`, `loadMoreError`).
3. **Traceability**: Every user action is recorded as an event, facilitating debugging and event replay.
4. **Testability**: With `bloc_test`, every edge case (offline errors, empty searches, successful pagination) is deterministically tested with declarative expectations.

---

## 📦 Packages Used

| Package | Purpose |
|---|---|
| `flutter_bloc` | Unidirectional BLoC state management |
| `get_it` & `injectable` | Dependency Injection (DI) service locator and auto-generation |
| `dio` & `retrofit` | HTTP client with typed REST client generation |
| `json_annotation` & `json_serializable` | Compile-time JSON parsing and model generation |
| `cached_network_image` | Image caching with placeholder and error handling |
| `share_plus` | Cross-platform native system share sheet integration |
| `url_launcher` | Opening original article URLs in external browser |
| `intl` | Relative time and date formatting (`timeAgo`) |
| `mocktail` & `bloc_test` | Unit, UseCase, and BLoC testing |

---

## 🚀 Setup & Execution

### Prerequisites
- Flutter SDK (3.14.0 or higher)
- Android Studio / Xcode / VS Code

### Steps
1. Clone the repository and navigate to the project directory:
   ```bash
   cd mallow_news
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate serialization, Retrofit, and DI files:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

Run all unit tests and widget tests:
```bash
flutter test
```

### Test Coverage includes:
- **`GetArticlesUseCase` & `GetArticleByIdUseCase` Tests**: Validates repository invocation with parameters and entity propagation.
- **`NewsRepositoryImpl` Tests**: Validates fetching article list, fetching single article, Dio mapping, and exception transformation.
- **`NewsBloc` Tests**: Validates initial state, successful load, network failure handling with `ApiException`, and search queries.
- **`ArticleCard` Widget Tests**: Validates rendering title, publisher, and tap interaction callbacks.

---

## 📝 Assumptions & Adaptations
- **Categories & Authors**: The Spaceflight News API (v4) does not categorize articles by general news topics (e.g., "Politic", "Education") or return author profile avatars. As suggested in the assignment specification, `news_site` is used to represent the category filter and publisher branding with fallback avatar initials.
- **Base URL**: Defaulted to `https://api.spaceflightnewsapi.net/v4` configured in `ApiConstants.baseUrl`.
