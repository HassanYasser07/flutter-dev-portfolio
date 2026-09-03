# AI_STATE.md — Portfolio Project State

> **Last Updated:** 2026-09-03  
> **Target Platform:** Flutter Web  
> **Architecture Pattern:** Feature-First Clean Architecture + BLoC / Cubit  
> **Status:** Phase 1 Complete (Dependencies & PDF Helper) / Phase 2 (Data Layer & Models) Next (~55% Total Completion)

---

## 📊 Overall Progress Summary

| Subsystem / Feature | Status | Completion | Notes |
|---|---|---|---|
| **Core Architecture & Design Tokens** | ✅ Complete | 100% | Colors, Typography (Local Fonts), Sizes, Theme Cubit, Responsive Helpers, PDF Download Helper |
| **Routing & Navigation** | ✅ Complete | 100% | `go_router` setup (`/`, `/projects`, `/project/:id`, `/contact`, `/cv`) |
| **Localization (i18n)** | 🟡 Partial | 80% | `easy_localization` set up for AR, EN, FR, DE. Base keys generated (`locale_keys.g.dart`) |
| **Home Feature (Presentation UI)** | 🟡 Partial | 75% | Section UI skeletons created (Hero, About, Skills, Projects, Experience, Contact, Footer, NavBar) |
| **Dependencies & Packages** | ✅ Complete | 100% | All packages added to `pubspec.yaml` (`lottie`, `animated_text_kit`, `video_player`, `chewie`, `photo_view`, `pdfx`) |
| **Data Layer & Models** | ❌ Pending | 0% | Need `ProjectModel`, `SkillModel`, `ExperienceModel`, `PortfolioData`, Repositories |
| **Feature State Management (BLoC/Cubit)**| 🟡 Partial | 45% | `ThemeCubit`, `ScrollCubit`, & `CvCubit` ready; `ProjectsCubit`, `VideoPlayerCubit`, `ContactCubit` pending |
| **Media Handling (Gallery, Video, PDF)**  | 🟡 Partial | 50% | PDF download & new-tab viewer complete. PhotoView & Chewie player pending |
| **Assets & Content Population** | 🟡 Partial | 40% | Local fonts installed, real `cv.pdf` added. Images, videos, and SVG tech icons pending |
| **Accessibility & Optimization** | 🟡 Partial | 40% | Core `ResponsiveWidget` & breakpoints ready. Focus trap & semantics audit pending |

---

## 🗂️ Detailed File System State Analysis

### 1. `lib/core/` (Shared Architecture & Primitives)
- ✅ `constants/`: `app_colors.dart`, `app_fonts.dart`, `app_sizes.dart`, `locale_keys.g.dart` exist.
- ✅ `theme/`: `app_theme.dart` (Light & Dark), `theme_cubit.dart` exist.
- ✅ `router/`: `app_router.dart` configured with fade transitions and named routes.
- ✅ `localization/`: `app_localization.dart` supports EN, AR (RTL), FR, DE.
- ✅ `utils/`: `responsive.dart`, `scroll_utils.dart`, `pdf_download_helper.dart` (with `pdf_download_helper_web.dart` and `pdf_download_helper_stub.dart`) complete.
- ✅ `widgets/`: Base UI primitives exist (`app_button.dart`, `app_icon_button.dart`, `app_section.dart`, `app_card.dart`, `app_scaffold.dart`, `section_header.dart`, `theme_toggle.dart`, `locale_switcher.dart`).

---

### 2. `lib/features/` (Feature Modules)

#### 🏠 `home/`
- ✅ `presentation/views/home_view.dart`
- ✅ `presentation/bloc/scroll_cubit.dart` & `scroll_state.dart`
- ✅ `presentation/widgets/`: `hero_section.dart`, `about_section.dart`, `skills_section.dart`, `projects_section.dart`, `experience_section.dart`, `contact_section.dart`, `nav_bar.dart`, `footer_widget.dart`, `shell_section.dart`
- ❌ `data/`: Missing `models/skill_model.dart`, `models/experience_model.dart`, `portfolio_data.dart`.

#### 💼 `projects/`
- ✅ `presentation/views/projects_page.dart`, `project_detail_page.dart`
- ❌ `presentation/widgets/`: Missing `project_gallery.dart`, `project_video_player.dart`
- ❌ `presentation/bloc/`: Missing `projects_cubit.dart`, `projects_state.dart`, `video_player_cubit.dart`
- ❌ `data/`: Missing `models/project_model.dart`, `projects_repository.dart`

#### 📬 `contact/`
- ✅ `presentation/views/contact_page.dart`
- ❌ `presentation/bloc/`: Missing `contact_cubit.dart`, `contact_state.dart`
- ❌ `data/`: Missing `contact_repository.dart`

#### 📄 `cv/`
- ✅ `presentation/views/cv_view.dart`
- ✅ `presentation/widgets/cv_viewer.dart`
- ✅ `presentation/bloc/cv_cubit.dart` & `cv_state.dart`
- ✅ `data/cv_constants.dart`

---

## 📦 Dependency Audit (`pubspec.yaml`)

### Installed & Resolved ✅
- `flutter_bloc` (^9.1.1)
- `equatable` (^2.0.7)
- `go_router` (^16.1.0)
- `easy_localization` (^3.0.8)
- `flutter_svg` (^2.2.0)
- `url_launcher` (^6.3.2)
- `animate_do` (^4.2.0)
- `flutter_animate` (^4.5.2)
- `visibility_detector` (^0.4.0+2)
- `lottie` (^3.3.1)
- `animated_text_kit` (^4.2.2)
- `video_player` (^2.9.2)
- `chewie` (^1.8.5)
- `photo_view` (^0.15.0)
- `pdfx` (^2.8.0)

---

## 🎨 Asset Audit (`assets/`)

| Folder | Current Contents | Action Required |
|---|---|---|
| `assets/translations/` | `ar.json`, `de.json`, `en.json`, `fr.json` | 🟢 Expand keys for real projects/experience data |
| `assets/fonts/` | SpaceGrotesk (3 weights), Inter (4 weights), JetBrainsMono (2 weights) | 🟢 Complete local font stack declared in `pubspec.yaml` |
| `assets/images/` | `.gitkeep`, `projects/` subfolder | 🔴 Add `avatar.png`, project thumbnail images, and gallery screenshots |
| `assets/pdf/` | `cv.pdf` | 🟢 Sample `cv.pdf` created & ready for user replacement |
| `assets/videos/` | `projects/` subfolder | 🔴 Add compressed `.mp4` demo video clips |
| `assets/icons/tech/` | `tech/` subfolder | 🔴 Add SVG icons for technologies (Flutter, Dart, Firebase, etc.) |

---

## 🎯 Current AI Priority & Focus
1. Implement Phase 2: Data Models (`ProjectModel`, `SkillModel`, `ExperienceModel`).
2. Implement Phase 2: Static Repositories & Data (`PortfolioData`, `ProjectsRepository`, `ContactRepository`, `CvConstants`).
3. Implement Phase 3: BLoC / Cubit state management.

