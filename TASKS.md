# TASKS.md — Project Execution Roadmap & Task Tracker

> **Project:** Personal Portfolio Website (Flutter Web)  
> **Reference Specification:** [AGENT.md](file:///c:/Users/hassa/AndroidStudioProjects/portfolio/AGENT.md)  
> **Current Status File:** [AI_STATE.md](file:///c:/Users/hassa/AndroidStudioProjects/portfolio/AI_STATE.md)  
> **Instructions:** Check off tasks (`[x]`) as they are completed and verified with `dart analyze`.

---

## 📌 Phase 1: Dependencies & Core Infrastructure
- [x] **Task 1.1: Add Missing Packages to `pubspec.yaml`**
  - Add `lottie` for hero animations
  - Add `animated_text_kit` for typewriter effect
  - Add `video_player` and `chewie` for project video demos
  - Add `photo_view` for image gallery lightbox
  - Add `pdfx` for Web-compatible inline CV viewing
  - Run `flutter pub get` and verify compatibility
- [x] **Task 1.2: Create Conditional PDF Download & New Tab Helper**
  - Create `lib/core/utils/pdf_download_helper.dart` (abstract interface for downloading & opening in new tab)
  - Create `lib/core/utils/pdf_download_helper_web.dart` (uses `dart:html` anchor download & `window.open` for new tab)
  - Create `lib/core/utils/pdf_download_helper_stub.dart` (fallback stub for non-web environments)
  - Configure conditional import logic in `pdf_download_helper.dart`

---

## 📌 Phase 2: Data Layer & Models Implementation
- [x] **Task 2.1: Implement Data Models**
  - Create `lib/features/projects/data/models/project_model.dart` (fields: `id`, `titleKey`, `descriptionKey`, `tags`, `thumbAsset`, `screenshotAssets`, `videoAsset`, `githubUrl`, `liveUrl`, extends `Equatable`)
  - Create `lib/features/home/data/models/skill_model.dart` (fields: `name`, `iconPath`, `category`, extends `Equatable`)
  - Create `lib/features/home/data/models/experience_model.dart` (fields: `companyKey`, `roleKey`, `durationKey`, `descriptionKey`, `technologies`, extends `Equatable`)
- [x] **Task 2.2: Implement Repositories & Static Content**
  - Create `lib/features/home/data/portfolio_data.dart` (static instances of skills and experience data)
  - Create `lib/features/projects/data/projects_repository.dart` (static data fetching & retrieval by ID)
  - Create `lib/features/contact/data/contact_repository.dart` (form submission handling & external links)
  - Create `lib/features/cv/data/cv_constants.dart` (points to `assets/pdf/cv.pdf`)

---

## 📌 Phase 3: State Management (BLoC / Cubit)
- [x] **Task 3.1: Implement `ProjectsCubit` & `ProjectsState`**
  - Location: `lib/features/projects/presentation/bloc/`
  - Manage loading projects, filtering by tag/category, and selecting project details
- [ ] **Task 3.2: Implement `VideoPlayerCubit` & `VideoPlayerState`**
  - Location: `lib/features/projects/presentation/bloc/`
  - Manage lifecycle of `VideoPlayerController`, initialization, play/pause, and disposal
- [ ] **Task 3.3: Implement `ContactCubit` & `ContactState`**
  - Location: `lib/features/contact/presentation/bloc/`
  - Manage contact form input, validation, loading, success, and error states
- [x] **Task 3.4: Implement `CvCubit` & `CvState`**
  - Location: `lib/features/cv/presentation/bloc/`
  - Manage PDF loading, page counting, current page index, new-tab opening, and download status

---

## 📌 Phase 4: Media Handling Widgets & Viewers
- [x] **Task 4.1: Build CV Action Buttons & New Tab PDF Helper**
  - Create `lib/features/cv/presentation/views/cv_view.dart` & `cv_viewer.dart`
  - Implement two distinct action buttons: "Download CV" (direct download) and "View CV" (opens PDF in a new browser tab `_blank`)
- [ ] **Task 4.2: Build Project Image Gallery Widget**
  - Create `lib/features/projects/presentation/widgets/project_gallery.dart`
  - Integrate `photo_view` / `PhotoViewGallery`, keyboard navigation (arrow keys), and index counter
- [ ] **Task 4.3: Build Project Video Player Widget**
  - Create `lib/features/projects/presentation/widgets/project_video_player.dart`
  - Integrate `Chewie` wrapper, poster thumbnail, controls, and strict `autoplay: false` gate

---

## 📌 Phase 5: UI & Presentation Layer Integration
- [ ] **Task 5.1: Enhance Hero & About Sections**
  - Wire `hero_section.dart` with `AnimatedTextKit` and Lottie ambient animation
  - Connect "View CV" and "Download CV" buttons in Hero/About to `CvView` dialog/route and `PdfDownloadHelper`
- [ ] **Task 5.2: Enhance Skills & Experience Sections**
  - Update `skills_section.dart` to load `SkillModel` grid with `flutter_svg` tech icons
  - Update `experience_section.dart` to render responsive timeline using `ExperienceModel`
- [ ] **Task 5.3: Enhance Projects Section & Detail Pages**
  - Update `projects_section.dart` (Home grid shows thumbnails only; no video preloading)
  - Connect `projects_page.dart` and `project_detail_page.dart` to `ProjectsCubit`, gallery modal, and video player
- [ ] **Task 5.4: Enhance Contact Section & Footer**
  - Connect `contact_section.dart` form inputs to `ContactCubit` with proper accessibility labels
  - Verify `footer_widget.dart` copyright text and back-to-top smooth scroll logic

---

## 📌 Phase 6: Assets & Content Population
- [ ] **Task 6.1: Asset Files Setup**
  - Add `cv.pdf` inside `assets/pdf/`
  - Add tech stack SVG icons inside `assets/icons/tech/`
  - Add profile picture `avatar.png` inside `assets/images/`
  - Add project thumbnail images and screenshots into `assets/images/projects/<project_id>/`
  - Add demo videos (`demo.mp4`) into `assets/videos/projects/<project_id>/`
- [ ] **Task 6.2: Complete Translations**
  - Verify identical translation keys across `assets/translations/en.json`, `ar.json`, `fr.json`, `de.json`
  - Re-generate `locale_keys.g.dart` via `easy_localization` runner command

---

## 📌 Phase 7: Accessibility, Responsiveness & Final Verification
- [ ] **Task 7.1: Responsiveness Audit**
  - Mobile (<600px): Verify drawer menu, stacked hero/about, 1-column project cards, timeline
  - Tablet (600px - 1024px): Verify 2-column skills grid, 2-column projects, layout scaling
  - Laptop / Desktop (>1024px): Verify full navbar links, side-by-side hero, 3-column projects, 4-5 column skills
- [ ] **Task 7.2: Accessibility & Reduced Motion Audit**
  - Verify `shouldAnimate(context)` gates all visual animations
  - Ensure all `IconButton`s have tooltips and semantic labels
  - Verify focus rings in dark and light themes across all interactive elements
  - Ensure keyboard tab navigation operates logically across all pages/dialogs
- [ ] **Task 7.3: Quality Check & Build Verification**
  - Run `dart analyze` (Ensure **zero warnings**)
  - Run `dart format .`
  - Verify release build readiness via `flutter build web --release`
