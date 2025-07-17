# Wavlo 💬🤟

AI-powered Chat App that bridges communication gaps between Deaf, Mute, and hearing users through speech, text, and sign language translation.

Wavlo empowers seamless communication for everyone — integrating voice-to-text, text-to-speech, and real-time sign language recognition to create an inclusive messaging experience for all 🌍


# 💡 What is Wavlo?

Wavlo is an accessibility-first chat app that goes beyond typical messaging:

🎤 Convert voice messages into text — making conversations accessible for the hearing-impaired
🔈 Transform text into speech — helping users with speech or reading difficulties
🎥 Record sign language videos — Wavlo translates them into written messages using AI
💬 Chat just like WhatsApp — private, fast, and mobile-friendly

# 🤟 Real-Time Sign Language to Text
This is one of Wavlo’s most innovative features. The app uses your device’s camera and real-time AI recognition to convert sign language gestures into written text — live, as the user signs each letter or word.

How it Works:
📷 The user opens the camera inside the app and starts signing using hand gestures.

🧠 The AI model processes each gesture in real-time, detecting letters as they are signed.

📝 As each gesture is recognized, the corresponding character appears instantly on the screen like live typing.

✍️ The user continues signing until their message is complete.

📩 Once done, they tap Send and the message is delivered through the chat like a normal text.

Example Flow:
The user signs: H – E – L – L – O

The screen displays: "Hello"

Tap Send, and the message is sent in the chat.

This real-time recognition system allows for fast, fluid communication without the need to record full videos — making Wavlo a powerful and inclusive tool for the Deaf and Mute community.

# 📸 Screens
<img width="1920" height="1080" alt="Untitled design" src="https://github.com/user-attachments/assets/fd9f0211-8d8a-4538-9be8-12165b7ad85d" />


# 🧠 the AI Model
Wavlo’s real-time sign language feature is powered by a custom-trained AI model that recognizes hand gestures from a live camera feed and converts them instantly into text.

Model Highlights:
Dataset: Thousands of labeled sign images (A–Z) captured in varied environments for better accuracy.

Architecture: Lightweight CNN optimized for mobile and real-time inference.

How it Works: Each video frame is processed live to detect gestures and display matching text on screen — letter by letter.

Performance: Runs smoothly on mobile devices with low latency for a natural signing experience.

🔗 View the Model on GitHub:

https://github.com/mu-3mar/Sign-Language-Recognition.git

## 🛠️ Installation

To clone and run the Flutter app locally:

```bash
# Clone the repository
git clone https://github.com/Maisheta/Wavlo.git
cd Wavlo

# Get Flutter packages
flutter pub get

# Run the app
flutter run


