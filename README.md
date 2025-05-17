# 📱 Maw

**Maw** is a Flutter-based mobile application designed to showcase your software projects — a portfolio app for developers.

---

## 📌 Short Description

Maw helps developers display their projects in a beautiful and structured format — including details like technologies used, team members, features, and challenges. It serves as a hub where users can share, review, and engage with others' projects.

---

## 📖 Current Features

- **Authentication Flow**  
  Secure login and registration system with profile management.

- **CRUD for Projects**  
  Full project management capabilities, including:
  - Banner customization (image or Lottie)
  - Tech stack list
  - Team member management
  - Features and challenges documentation
  - Testimonials
  - Project statistics & future plans
  
- **Project Showcase**
  - Beautiful, animated UI for project visualization
  - Carousel image display
  - Expandable sections for detailed information
 
- **Social Features**
  - Connect with other developers
  - Send and accept connection requests
  - View other users' portfolios
  - Build your professional network

- **Push Notifications**
  - Real-time notifications for connection activities
  - Get notified when someone sends you a connection request
  - Receive notifications when someone accepts your request
  - Inbox system to manage all your notifications
  
- **Cache Management**
  - Efficient caching of project images
  - Automatic cache cleanup
  - Manual cache management options

- **Seeding Functionality**
  - Database seeding for demonstration and testing
  - Sample project templates

---

## 🧱 Tech Stack

- **Flutter** – Cross-platform UI framework
- **Riverpod** – State management
- **Firebase Auth** – Authentication
- **Cloud Firestore** – NoSQL database
- **Firebase Storage** – Media storage
- **Firebase Cloud Messaging** – Push notifications
- **Firebase Cloud Functions** – Backend for notifications
- **Awesome Notifications** – Local notification handling
- **Lottie** – Animation integration
- **SQFLite** – Local cache database

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

Here's what's coming to Maw in the future:

- 🔍 **Search Functionality**
  - Search for projects by name, technology, or category
  - Advanced filtering options for precise results
  - Discover trending projects and developers

- 👥 **Enhanced Social Features**
  - Activity feed to track network updates
  - Group discussions about projects
  - Collaborative project showcases

- ⭐ **Engagement System**
  - Star projects you like
  - Leave meaningful reviews and feedback
  - Rate projects based on multiple criteria
  - Showcase project popularity metrics

- 🔔 **Advanced Notifications**
  - Project engagement notifications
  - Weekly digests of network activity
  - Trending project alerts

---

## 🐈‍⬛ Cat

Meow maw.

---

Let's build the ultimate social platform for showcasing software projects!
