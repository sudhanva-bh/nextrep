# NextRep - Gym Tracker App  

NextRep is a modern gym/workout tracker app built with **Flutter**, following **Clean Architecture** principles.  
It combines a huge exercise database, smart workout tracking, and seamless cloud/local sync to help you stay on top of your fitness journey.  

---

## Features  

Prioritized by importance:  

1.  **AI-Powered Workout Assistant** - Get instant, intelligent help and form corrections for any exercise using integrated **Generative AI**.
2.  **Seamless Cloud & Offline Sync** - Combines **Firebase Firestore** for cloud storage and **Hive** for local offline access, with automatic data synchronization on login, registration, and logout.
3.  **Custom-Built Target Muscle API** - Features a unique, custom-built API that dynamically generates the specific muscles worked by each exercise.
4.  **BMI Visualiser** - Interactive graph for daily weight entry, and visualisation.
5.  **Clean, Scalable Architecture** - Built on a professional, modular project structure using **Riverpod** for robust state management and `fpdart` for flawless error handling.
6.  **Dynamic Workout Adjustments** - Smartly adapts your daily workout plan based on your progress and performance.
7.  **Massive Exercise Database** - Includes a comprehensive library of over 2000+ exercises, complete with high-quality images, detailed instructions, and descriptions.
8.  **Secure Authentication with Google Sign-In** - Offers fast and secure user login and registration using **Firebase Authentication** and one-tap Google Sign-In.
9.  **Fitness Challenges** - Engage with fun, challenges designed to test your limits and keep you motivated.
10.  **Live Workout Tracking & Editing** - Easily track your sets, reps, and weights during a session and customize your workout plan on the go.
11. **Personalized Stats & Goal Setting** - Calculate your BMI, set target weight goals, and track your personal fitness statistics.
12. **Favorite Workouts** - Quickly save and access your most-used exercises for convenient workout planning.
13. **Visual Progress Indicator** *(Coming Soon)* - A dedicated feature to visualize your fitness journey and track your gains over time.

---

## Demo  

Coming Soon

---

##  Setup Instructions  
Download the APK through the [Latest Release](https://github.com/sudhanva-bh/nextrep/releases) here or

### 1. Clone the repository  
```bash
git clone https://github.com/yourusername/nextrep.git
cd nextrep
```
### 2. Setup Firebase  
- Go to [Firebase Console](https://console.firebase.google.com/)  
- Create a project and enable **Authentication** + **Firestore**  
- Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)  
- Place them inside respective platform folders.  

### 3. Setup Environment Variables  
Create a `.env` file in the root directory with:  
```env
YOUTUBE_API_KEY=your_youtube_api_key_here
```
---

### 4. Install Dependencies
```bash
flutter pub get
```
---
### 5. Run the App
```bash
flutter run
```
