# NextRep – Gym Tracker App  

NextRep is a modern gym/workout tracker app built with **Flutter**, following **Clean Architecture** principles.  
It combines a huge exercise database, smart workout tracking, and seamless cloud/local sync to help you stay on top of your fitness journey.  

---

## Features  

Prioritized by importance:  

1.  **Sign In / Authentication** – Secure login with Firebase Auth & Google Sign-In  
2. **Huge Database** – 2000+ workouts with images, instructions & descriptions  
3. **Clean Architecture** – Scalable, modular project structure with Riverpod & fpdart for error handling  
4. **Firebase + Hive Integration** – Firestore for cloud sync & Hive for local offline storage, with automatic sync on Login, Register and Logout
5. **Dynamic Workout Adjustments** – Smartly adapts Today’s Workout plan  
6. **BMI Calculation & Target Weight** – Personalized stats and goals  
7. **Target Muscle API** – Custom-built API to generate muscles worked by each exercise  
8. **Favourite Workouts** – Save your most-used exercises  
9. **Challenges** – Gamified challenges to push your limits  
10. **Start Workout** – Track sets with reps and weights  
11. **Edit Workouts** – Customize workout plans on the go  
12. **Progress Indicator** *(Coming Soon)* – Visualize your fitness journey  

---

## Demo  

Coming Soon

---

##  Setup Instructions  
Download the [APK](https://github.com/sudhanva-bh/nextrep/releases/tag/v1.0.0) here or

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




