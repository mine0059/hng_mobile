# 🏪 Store Management App (Flutter + SQLite)

A simple yet powerful **Store Management App** built with Flutter.  
This project demonstrates full **CRUD operations (Create, Read, Update, Delete)** using the **Sqflite package**, local image storage, and modern Material UI design principles.

---

## 📱 Features

✅ Add new products with image, name, description, price, and quantity.  
✅ Edit and update product details in a sleek modal bottom sheet.  
✅ Delete products easily.
✅ Persist data locally using **SQLite (sqflite package)**.  
✅ Curved image thumbnails for each product in the list.  
✅ Pull-to-refresh and responsive UI.  
✅ Edge-to-edge design that adapts to gesture navigation (modern Android).  

---

## 🧩 Tech Stack

| Technology | Purpose |
|-------------|----------|
| **Flutter** | App framework |
| **Dart** | Programming language |
| **Sqflite** | Local database for product storage |
| **Path Provider** | Accessing device storage |
| **Image Picker / File Picker** | Selecting product images |
| **Material 3 UI** | Clean, modern design |

---

## 🧠 Architecture Overview

The app uses a modular approach with the following key components:

| File | Description |
|------|--------------|
| `product_list_screen.dart` | Displays all products and allows edit/delete actions |
| `add_product_screen.dart` | Form screen for adding new products |
| `sql_helper.dart` | Handles SQLite database creation, queries, and CRUD methods |
| `main.dart` | Initializes SQLite and sets up system UI + app entry point |

---

## ⚙️ Setup Instructions

### 1️⃣ Clone this repository
```bash
git clone https://github.com/mine0059/hng_mobile.git
cd hng_mobile
### 2️⃣ Install dependencies
flutter pub get
### 3️⃣ Run the app
flutter run

📦 Release APK
You can directly download and test the app using the link below 👇
https://drive.google.com/file/d/1iQ_RWJoHHNGVg2royw1QhkjCSPBXbZlB/view?usp=sharing

🎥 Demo Video
Watch the demo of the app in action here:
https://drive.google.com/file/d/1rMXhpumKJnoPHp5DbgohBxbUqYLYZ8WG/view?usp=sharing

💾 GitHub Repository
https://github.com/mine0059/hng_mobile

🧑‍💻 Developer
Name: Oghenemine Emmanuel
Email: oghenemineemma@gmail.com
GitHub: @mine0059

🪶 License

This project is open-source and available under the MIT License

