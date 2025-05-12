part of 'db_controller_impl.dart';

abstract class DbController {
  Future<void> addNotification(bool isUser, CustomNotification notification, ToastificationType type);

  Future<List<String>> fetchAllUsers();

  Stream<List<types.Message>> fetchMessagesStream(String roomId);

  Stream<List<Conversation>> fetchConversationsStream();

  //Future<void> addUser(UserModel user);
}