# 📱 Maw

**Maw** is a Flutter-based mobile application designed to showcase your software projects — a portfolio app for developers.

---

## 📌 Short Description

Maw helps developers display their projects in a beautiful and structured format — including details like technologies used, team members, features, and challenges. Future versions aim to make it a hub where users can share, review, and engage with others’ projects.

---

## 🎥 Demo

https://github.com/user-attachments/assets/2cfbcd0d-2109-4c2d-8bec-dce7142cdcf8

(00.10 - 00.50 freeze 🙏)

---

## 📖 Overview Current Features

- **Authentication Flow**  
  Secure login and registration system for users.

- **CRUD for Projects**  
  Full project management capabilities, including:
  - Banner customization (image or Lottie)
  - Tech stack list
  - Team member management
  - Features and challenges
  - Testimonials
  - Stats & future plans

---

## 🧱 Tech Stack

- **Flutter** – Cross-platform UI
- **Firebase Auth**  – Authentication
- **Cloud Firestore**  – NoSQL database
- **Firebase Storage**  – Media storage

---

## 🚀 Getting Started

Follow these steps to set up **Maw** on your local machine:

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/maw.git
```

### 2. Navigate into the Project Directory

```bash
cd maw
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Configure Firebase for Android

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Add an Android app with your app's package name
4. Download the `google-services.json` file
5. Place it inside the `android/app/` directory
6. If using `flutterfire_cli`, also run:

```bash
flutterfire configure
```

> This will generate the `firebase_options.dart` file used for initialization.

### 5. Run the App

```bash
flutter run
```

---

## 🌱 Future Enhancements

Here’s what’s coming to Maw in the future:

- 📤 **Project Sharing**
  - Generate sharable links for your portfolio
  - Public and private visibility settings

- ❤️ **Social Features**
  - Like and comment on projects
  - Leave and receive reviews
  - Follow other developers

- 📊 **Analytics and Stats**
  - Track project views, likes, and engagement
  - Developer profile insights

---

Let’s build the ultimate social platform for showcasing software projects!
