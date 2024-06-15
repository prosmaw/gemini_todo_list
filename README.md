# todo_list

A Flutter To-Do list app that integrates the Gemini API to allow users to add tasks using natural language and gain insights through an integrated chat.

## Features

  - **Login/Logup:** User authentication using Firebase Auth 
  - **Board management:** Create, update, delete boards, invite other users to  boards (using Firestore)
  - **Task management:** Add tasks, update, delete tasks on boards, assign task to board members (using Firestore)
  - **Notification schedule:** Notifications are schedule for task due date using Firebase Cloud Functions,
      Cloud Task, and Firebase Cloud. Notifications are sent to task assignees on due date and when invited on a board.
  - **Add tasks using natural language:** Create a new task by simple input using natural language
  - **Gemini chat based insights:** Possibility to get insights, recommendations, summaries about tasks through a chat interface

## Screenshots
<p align="center">
  <img src="https://github.com/prosmaw/gemini_todo_list/blob/main/assets/images/home_page1.png" alt="Screenshot 1" width="250"/>
  <img src="https://github.com/prosmaw/gemini_todo_list/blob/main/assets/images/home_board.png" alt="Screenshot 2" width="250"/>
  <img src="https://github.com/prosmaw/gemini_todo_list/blob/main/assets/images/gen_input.png" alt="Screenshot 3" width="250"/>
</p>
<p align="center">
  <img src="https://github.com/prosmaw/gemini_todo_list/blob/main/assets/images/chat1.png" alt="Screenshot 4" width="250"/>
  <img src="https://github.com/prosmaw/gemini_todo_list/blob/main/assets/images/chat2.png" alt="Screenshot 5" width="250"/>
  <img src="https://github.com/prosmaw/gemini_todo_list/blob/main/assets/images/chat3.png" alt="Screenshot 6" width="250"/>
</p>
<p align="center">
  <img src="https://github.com/prosmaw/gemini_todo_list/blob/main/assets/images/notif_page.png" alt="Screenshot 7" width="250"/>
  <img src="https://github.com/prosmaw/gemini_todo_list/blob/main/assets/images/task_details.png" alt="Screenshot 8" width="250"/>
  <img src="https://github.com/prosmaw/gemini_todo_list/blob/main/assets/images/task_creation.png" alt="Screenshot 9" width="250"/>
</p>

## Video

  https://github.com/prosmaw/gemini_todo_list/assets/81015893/49bc7efb-6e74-4c60-9bd6-68546b1d1d7e
  
 Note: Quality of the video was reduced to be uploaded here check assets/video for a better quality
## Getting Started

### Installing

* Clone the repo on your machine
* Ensure you have Flutter installed on your system. If not, follow the instructions on the official Flutter website: https://flutter.dev/docs/get-started/install
* Run ```flutter pub get``` to install the dependecies
* Initialize firebase in the project. Follow instructions here: https://firebase.google.com/docs/flutter/setup?platform=android
* Activate Firebase auth, Firestore in the firebase project to be able to login, store and get data
* Create .env file at the root and add your Gemini API keys.
* Activate Cloud Messaging, Firebase Cloud Function to try notifications
* Run the application using ```flutter run```

  **Cloud function usage in the project**
  - Functions are already provided in the ```functions/index.js``` 
  - Run ```firebase init functions``` and follow instructions to initialize and the cloud function localy in you project. For more instructions: https://firebase.google.com/docs/functions/get-started?gen=2nd
  - Run ```firebase deploy --only functions``` to deploy the functions on Google Cloud
  - Follow instructions here to add cloud Task to your cloud Project (your Firebase project in Google Cloud): https://cloud.google.com/tasks/docs/add-task-queue
  - Follow instructions here to add the app.yaml and necessary informations needed to use Cloud Task in the index.js file: https://cloud.google.com/tasks/docs/tutorial-gcf  


## Authors

Contributors names and contact info

 Yao Prosper Amebe  
 [@prosperamebe](https://www.linkedin.com/in/prosper-amebe/)

## License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details

## Acknowledgments

Inspiration, code snippets, etc.
* [Design](https://dribbble.com/shots/20166390--29-Mobile-App-Concept)

