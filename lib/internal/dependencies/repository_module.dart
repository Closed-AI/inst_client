import 'package:inst_client/data/repository/api_data_repository.dart';
import 'package:inst_client/domain/repository/api_repository.dart';
import 'package:inst_client/internal/dependencies/api_module.dart';

class RepositoryModule {
  static ApiRepository? _apiRepository;
  static ApiRepository apiRepository() {
    return _apiRepository ??
        ApiDataRepository(
          ApiModule.auth(),
        );
  }
}
