import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';

abstract class CardShareEcoSystemDataSource {
  Future<List<Map<String, dynamic>>> fetchBrandOffers(List<int> brandIds);

  Future<Map<String, dynamic>> fetchBrandIdsFromGroupId(int gId);

  Future<void> createNewTaskAsUserForAgent(TaskModel task);
}
