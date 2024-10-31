// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCcjbOwCcO9xXY9SW9WOF451jnrKBfvyrg",
  authDomain: "farmlink-8f61b.firebaseapp.com",
  projectId: "farmlink-8f61b",
  storageBucket: "farmlink-8f61b.appspot.com",
  messagingSenderId: "626142691260",
  appId: "1:626142691260:web:646108e02f5c12d41eb5b9",
  measurementId: "G-ZTM4X89DJW"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);