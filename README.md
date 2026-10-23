# SkillCircle — Peer-to-Peer Skill Sharing Platform

## Project Overview

**SkillCircle** is a native iOS peer-to-peer skill-sharing and tutoring application designed to connect learners and tutors within academic communities. Built with **SwiftUI** and **Firebase**, SkillCircle enables students to exchange knowledge seamlessly through real-time messaging, flexible session proposal management, interactive meeting point selection, live session status tracking, and home screen widgets.

## Key Features & Highlights

### 1. 💬 Real-Time Chat & Session Proposals

* **Firebase Cloud Firestore Sync:** Instant messaging backed by live Firestore snapshot listeners.

* **Inline Proposal Cards:** Send, review, accept, or reject tutoring proposals directly within chat conversations.

* **Dynamic Role Routing (`ActiveSessionRouterView`):** Automatically routes users into either `ActiveSessionTeacherView` (displays QR code verification) or `ActiveSessionLearnerView` (displays camera QR scanner) based on the current user's role and goal (`proposerId` and `goal`).

### 2. Home Screen Widgets (WidgetKit Framework)

* **`TokensWidget` (Small):** Displays real-time Spark Token balance.

* **`ScheduleWidget` (Medium):** Shows today's upcoming tutoring schedule with time and subject details.

* **`ActivityChartWidget` (Medium):** Visualizes weekly teaching vs. learning hours using a custom bar chart.

### 3. Interactive Location Selection & MapKit

* Integrated Apple **MapKit** framework for selecting and visualizing meeting locations (libraries, labs, cafeterias, online links).

* Pin annotations and spatial route directions for session venues.

### 4.  Push Notifications (`UserNotifications` Framework)

* Local push notification alerts delivered when peer proposals are sent, accepted, or rescheduled.

* Foreground notification presentation handling for live demo contexts.

### 5. Core Data Offline Caching (`CoreDataManager`)

* Persistent local storage layer using `NSPersistentContainer` to cache session details locally.

* Ensures offline availability of user schedules without an active internet connection.

## System Architecture & Technology Stack

The application follows the **MVVM (Model-View-ViewModel)** architectural pattern for clean code separation, testability, and reactive state management using **Combine**.

```
SkillCircle App Architecture
│
├── 📂 App Entry & Navigation
│   ├── SkillCircleApp.swift
│   ├── MainTabView.swift
│   └── ActiveSessionRouterView.swift
│
├── 📂 Views (SwiftUI Layer)
│   ├── MySessionsView.swift
│   ├── ChatDetailView.swift
│   ├── ProposeSessionView.swift
│   └── NearbyHelpView.swift
│
├── 📂 ViewModels (Business Logic & State)
│   ├── SessionsViewModel.swift
│   ├── ChatDetailViewModel.swift
│   └── AuthViewModel.swift
│
├── 📂 Models & Core Data
│   ├── TutoringSession.swift
│   ├── ChatMessage.swift
│   └── CoreDataManager.swift
│
├── 📂 Services & Utilities
│   └── NotificationManager.swift
│
└── 📂 Widget Extension (WidgetKit Target)
    └── SkillCircleWidgets.swift

```

## Tech Stack & SDKs

* **Language:** Swift 5.9

* **UI Framework:** SwiftUI & Combine

* **Backend Platform:** Firebase Authentication & Cloud Firestore

* **iOS SDKs:** WidgetKit, MapKit, UserNotifications, CoreData

* **Target Version:** iOS 17.0+

## Installation & Setup Instructions

### Prerequisites

* macOS 14.0 or later

* Xcode 15.0 or later

* iOS 17.0+ Simulator or Physical Device

### Steps to Run

1. **Clone the Repository:**

   ```
   git clone https://github.com/sithuminimahinsala/SkillCircle-App.git
   cd SkillCircle-App/SkillCircle
   
   ```

2. **Open in Xcode:**
   Open `SkillCircle.xcodeproj` in Xcode.

3. **Verify Firebase Configuration:**
   Ensure `GoogleService-Info.plist` is bundled inside the `SkillCircle` main target.

4. **Build and Run:**

   * Select the **SkillCircle** scheme and press `Cmd + R` to run the main application.

   * To preview Home Screen Widgets, select the **SkillCircleWidgetsExtension** scheme and run on the simulator.

## Test Account Credentials for Assessors / Evaluators

To test cross-device real-time synchronization between two simulator instances:

| Account Role | Email Address | Password | 
| ----- | ----- | ----- | 
| **Learner Test Account** | `learner.test@student.com` | `TestPassword123!` | 
| **Teacher Test Account** | `teacher.test@student.com` | `TestPassword123!` | 

### Quick Verification Steps for Markers:

1. Launch **Simulator A** and log into `learner.test@student.com`.

2. Launch **Simulator B** and log into `teacher.test@student.com`.

3. Send a session proposal from Chat in Simulator A.

4. Observe real-time proposal update and status changes instantly reflected in Simulator B.


