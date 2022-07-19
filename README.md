# screensite

Sanctions Screening App

Purpose:
- Provide sanctions screening via UI: results ranked by match score (0.95-100%)

Intended features:
- Screen an entity (person/item or organisation) against all open sanctions lists.
- Look at up-to-date sanctions lists in one location.

This repo is only the front-end of the app and it is built with Flutter backed by Firebase Firestore. (Another repository will be created to define server functions, which will serve as a back-end of the application).

## Flutter

If you are new to Flutter, these resources will get you started:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Remember, in the context of this project we are using Flutter for Web only!

## Riverpod

For all state management (data binding and interactivity) we will be using https://riverpod.dev/

If you are new to it, please have a read through the website and the tutorial here: [Flutter State Management with Riverpod: The Essential Guide](https://codewithandrea.com/articles/flutter-state-management-riverpod/)

## Firebase Firestore

The support for Firestore was added using this guide:
https://firebase.google.com/docs/flutter/setup?platform=web
