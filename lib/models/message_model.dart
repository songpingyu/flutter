import 'package:flutter_chat_ui_starter/models/user_model.dart';

class Messager {
  final User sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;

  Messager({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}

// YOU - current user
final User currentUser =
    User(id: 0, name: 'Current User', imageUrl: 'assets/images/cat1.png');

// USERS
final User greg =
    User(id: 1, name: 'Archangel', imageUrl: 'assets/images/cat2.png');
final User james =
    User(id: 2, name: 'Feqma the demon', imageUrl: 'assets/images/cat3.jpg');
final User john = User(id: 3, name: 'LOGO', imageUrl: 'assets/images/cat4.jpg');
final User olivia =
    User(id: 4, name: 'Sick dev', imageUrl: 'assets/images/cat5.jpg');
final User sam =
    User(id: 5, name: 'Sniper', imageUrl: 'assets/images/cat6.jpg');
final User sophia =
    User(id: 6, name: 'nul', imageUrl: 'assets/images/cat1.png');
final User steven =
    User(id: 7, name: 'Lord', imageUrl: 'assets/images/cat1.png');

// FAVORITE CONTACTS
List<User> favorites = [sam, steven, olivia, john, greg];

// EXAMPLE CHATS ON HOME SCREEN
List<Messager> chats = [
  Messager(
    sender: james,
    time: 'Unknown Timeline',
    text: "I've wait for thousand years...",
    isLiked: false,
    unread: true,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Messager> messages = [];
