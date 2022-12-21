import 'package:inst_client/data/services/database.dart';
import 'package:inst_client/domain/models/user.dart';

class DataService {
  Future cuUser(User user) async {
    await DB.instance.createUpdate(user);
  }
}
