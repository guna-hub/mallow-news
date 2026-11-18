# Mallow News App (Flutter)

A production-grade News application built with Flutter, fetching live space articles from the **Spaceflight News API (v4)**. Designed with clean MVVM architecture, BLoC state management, and responsive layouts across mobile phones, tablets, and iPads.

---

## 📱 Features

### 1. Discover / List Screen
- **Live Search**: Debounced search input (500ms) filtering articles by title and summary without spamming API requests.
- **Category Filter Chips**: Filter by news sources/categories (`All`, `SpaceNews`, `NASA Spaceflight`, `Ars Technica`, etc.) with animated active pill states.
- **Pull-to-Refresh**: Seamless `RefreshIndicator` enabling users to fetch the latest feed.
- **Infinite Scroll Pagination**: Automatically triggers next page requests as the user scrolls near the bottom.
- **Error & Loading States**:
  - Full skeleton loader (`ShimmerArticleLoader`) on initial fetch.
  - Non-intrusive loading spinner at the bottom during pagination.
  - Retry footer when pagination fails without clearing existing list items.
  - Dedicated empty state widget when search returns 0 results.

### 2. Article Detail Screen
- **Gmail-style Swipe Navigation**: Swiping left/right (`PageView.builder`) navigates between articles.
- **End-of-List Pre-fetching**: If the user swipes near the end of loaded articles in detail mode, the next batch is fetched seamlessly in the background.
- **Hero Image & Metadata**: Hero transitions, verified publisher badge, dynamic category chip, and humanized relative timestamps (`timeAgo` e.g., "6 hours ago").
- **Read Full Article Action**: External web browser launch using `url_launcher`.
- **Bookmarking & Sharing**: Header shortcuts for bookmarking and sharing article links.

### 3. Responsiveness (Phones, Tablets & iPads)
- Built with `LayoutBuilder` and `MediaQuery`.
- Displays a clean single-column list on mobile phones (`width < 600`).
- Adapts to a 2-column card grid on tablets and iPads (`width >= 600`).

### 4. Production Robustness & Theming
- **Typed API Errors**: `ApiException` distinguishes between connection timeouts, send/receive timeouts, offline/network errors, and server HTTP codes.
- **Image Fallback Handling**: Null-safe `CustomNetworkImage` wrapper around `cached_network_image` with placeholder and missing-image fallbacks.
- **Dark Mode Support**: Full light and dark themes adhering to system brightness.
- **Safe Memory Management**: All `ScrollController`, `PageController`, `TextEditingController`, and debounce timers are properly disposed of.

---

## 🏛️ Architecture Overview

The app follows **MVVM (Model - View - ViewModel / BLoC)** with clear separation of concerns across Clean Architecture layers:

```
lib/
├── core/
│   ├── constants/       # API endpoints, timeouts, and categories
│   ├── di/              # GetIt + Injectable dependency injection
│   ├── errors/          # Typed ApiException & error categorization
│   ├── network/         # DioFactory, Retrofit ApiClient & generated client
│   ├── theme/           # Light & Dark ThemeData configurations
│   └── utils/           # Debouncer, DateFormatter
├── data/
│   ├── models/          # ArticleResponse, ResultsResponse (json_serializable)
│   └── repositories/    # NewsRepositoryImpl with Dio & error mapping
├── domain/
│   └── repositories/    # NewsRepository contract interface
└── presentation/
    ├── bloc/            # NewsBloc, NewsEvent, NewsState
    ├── screens/         # NewsListScreen, NewsDetailScreen
    └── widgets/         # ArticleCard, SearchBarWidget, FilterChips, ShimmerLoader, etc.
```

---

## 💡 State Management Justification (BLoC)

**BLoC (`flutter_bloc`)** was chosen over Provider or Riverpod for this application:
1. **Unidirectional Data Flow**: Clear, predictable state transitions driven by explicit events (`FetchInitialNews`, `RefreshNews`, `LoadMoreNews`, `SearchQueryChanged`, `CategorySelected`).
2. **Robust Pagination & Concurrency Handling**: Simplifies keeping existing article items while tracking distinct pagination states (`isLoadingMore`, `hasReachedMax`, `loadMoreError`).
3. **Traceability**: Every user action is recorded as an event, facilitating debugging and event replay.
4. **Testability**: With `bloc_test`, every edge case (offline errors, empty searches, successful pagination) can be deterministically tested with declarative expectations.

---

## 📦 Packages Used

| Package | Purpose |
|---|---|
| `flutter_bloc` | MVVM BLoC state management |
| `get_it` & `injectable` | Dependency Injection (DI) service locator and auto-generation |
| `dio` & `retrofit` | HTTP client with typed REST client generation |
| `json_annotation` & `json_serializable` | Compile-time JSON parsing and model generation |
| `cached_network_image` | Image caching with placeholder and error handling |
| `intl` | Date formatting |
| `url_launcher` | Opening original article URLs in external browser |
| `flutter_dotenv` | Loading environment configurations (`.env`) |
| `mocktail` & `bloc_test` | Unit and BLoC testing |

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

3. Generate serialization and Retrofit files:
   ```bash
   dart run build_runner build
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
- `NewsRepositoryImpl` tests (fetching article list, fetching single article, Dio mapping).
- `NewsBloc` tests (initial state, successful load, network failure, search queries).
- `ArticleCard` widget test (rendering title, publisher, tap interactions).

---

## 📝 Assumptions & Adaptations
- **Categories & Authors**: The Spaceflight News API (v4) does not categorize articles by general news topics (e.g., "Politic", "Education") or return author profile avatars. As suggested in the assignment specification, `news_site` is used to represent the category filter and publisher branding with fallback avatar initials.
- **Base URL**: Defaulted to `https://api.spaceflightnewsapi.net/v4` configurable via `.env`.
