# 📱 CSE 0613-4206 — Mobile Application & Development Lab

**Khwaja Yunus Ali University**  
B.Sc. in CSE (Batch: 15th) · 4th Year 2nd Semester · Summer 2026 Final Examination

---

## 🗂️ Project Structure

```
lib/
├── main.dart                  # Home screen with question navigation
├── q1/
│   └── food_menu_app.dart     # Question 1 — Food Menu
└── q2/
    ├── article_model.dart     # Article data model
    ├── news_provider.dart     # State management (Provider)
    └── news_reader_app.dart   # Question 2 — News Reader
```

---

## ✅ Question 1 — Food Menu `[20 Marks]`

> **CLO 1:** Design and develop cross-platform mobile user interfaces in Flutter using widgets, layouts, navigation and themes.

### Features
- 🍽️ Displays food items (name, icon, price, rating, category)
- 📱 **Responsive layout** — `ListView` on phones, `GridView` on tablets/landscape using `LayoutBuilder`
- 🧩 **Custom reusable `FoodCard` widget** built with `Row`, `Column`, `Stack`, and `Expanded`
- 🌙 **Light & Dark theme** with custom `ThemeData` (colors, text styles, font)
- 🔄 **Theme toggle button** in AppBar using `ChangeNotifier`
- ➕ **Interactive Add button** with quantity counter (+/-)
- 🚫 No overflow in portrait or landscape mode

### Widgets Used
`Scaffold` · `AppBar` · `LayoutBuilder` · `GridView.builder` · `ListView.separated` · `Card` · `Stack` · `Row` · `Column` · `Expanded` · `FilledButton` · `AnimatedBuilder`

---

## ✅ Question 2 — News Reader `[25 Marks]`

> **CLO 2:** Apply state management, REST API integration, local storage and Firebase services to build data-driven mobile applications.

### Features
- 🌐 Fetches articles from [JSONPlaceholder](https://jsonplaceholder.typicode.com/posts) REST API using the `http` package
- 🧱 Parses JSON response into `Article` Dart model class
- 🔄 **3 UI states** — Loading (spinner), Error (with Retry button), Success (article list)
- 📦 **Provider (`ChangeNotifier`)** for state management — business logic fully separated from UI
- 🔍 **Real-time search** filters articles by title
- 📄 **Detail screen** opens on article tap
- ❤️ **Favorites system** — mark/unmark articles as favorites
- 🔢 **Live favorites badge count** shown in AppBar

### Packages Used
| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.2 | State management |
| `http` | ^1.2.1 | REST API calls |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Android Studio / VS Code
- Android Emulator or physical device

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/lab_final.git

# 2. Navigate to project
cd lab_final

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run
```

> ⚠️ **Internet required** for Question 2 (fetches from JSONPlaceholder API)

---

## 📸 Screenshots

| Home | Food Menu (Phone) | Food Menu (Tablet) |
|------|-------------------|--------------------|
| ![home](screenshots/home.png) | ![q1_phone](screenshots/q1_phone.png) | ![q1_tablet](screenshots/q1_tablet.png) |

| News — Loading | News — Success | News — Detail |
|----------------|----------------|---------------|
| ![loading](screenshots/q2_loading.png) | ![success](screenshots/q2_success.png) | ![detail](screenshots/q2_detail.png) |

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Provider (ChangeNotifier)
- **API:** JSONPlaceholder (REST)
- **IDE:** Android Studio
- **Target:** Android / iOS / Web

---

## 👨‍💻 Author

**Tanvir Hasan Tanim**  
B.Sc. in Computer Science & Engineering  
Khwaja Yunus Ali University, Bangladesh  
Batch: 15th · Roll: [YOUR ROLL]

---

*Summer 2026 Final Examination — Course Code: CSE 0613-4206*
