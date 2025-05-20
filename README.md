# 📱 Maw

**Maw** is a Flutter-based mobile application designed to showcase your software projects — a portfolio app for developers.

---

## 📌 Short Description

Maw helps developers display their projects in a beautiful and structured format — including details like technologies used, team members, features, and challenges. It serves as a hub where users can share, review, and engage with others' projects.

---

## 📷 Screenshots for this Update
1. User 1 is in homescreen, goes to searchbar, types User 2 (@fluter), and opens his profile page. Then he sends a connection request using the button on the top right.
<img src="https://github.com/user-attachments/assets/fdb20931-9fc2-4bdf-a117-3117a938dfa7" width="200"/>
<img src="https://github.com/user-attachments/assets/e04e3d38-defb-4754-acda-0c0fc5411a19" width="200"/>
<img src="https://github.com/user-attachments/assets/934dd446-4a29-48f7-ab54-799b44c0df5d" width="200"/>
<img src="https://github.com/user-attachments/assets/ac6e5ae3-a876-4497-9ae9-45cd43f98a6d" width="200"/>

2. User 2 (@fluter) get notification of connection request from User 1 (@cota). When he tap the notification, it opens the account inbox. in there User 1 (@fluter) Accept the connection request from User 1 (@cota). Another way to open the inbox is from the Inbox Icon on homescreen, at the searchbar.
<img src="https://github.com/user-attachments/assets/dce551bb-9171-4783-841d-34468e1ac167" width="200"/>
<img src="https://github.com/user-attachments/assets/97865f49-c5d9-458a-b600-910f1e1aa980" width="200"/>
<img src="https://github.com/user-attachments/assets/e4e764ea-d371-4f05-8b85-4660cfb1004a" width="200"/>
<img src="https://github.com/user-attachments/assets/94d1d9c6-ee6c-4440-82b2-f688c7e7ccd4" width="200"/>

3. After User 2 (@fluter) accepts the connection, User 1 (@cota) receives a notification that the connection request has been accepted.
<img src="https://github.com/user-attachments/assets/9fa759b6-0b26-45c1-89f4-89d698392c9f" width="200"/>
<img src="https://github.com/user-attachments/assets/570e5e98-49f2-478f-8337-933c493ca78f" width="200"/>

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
