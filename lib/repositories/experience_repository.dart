import 'package:hotspot_hosts_flutter_assignment/core/utils/exceptions.dart';
import 'package:hotspot_hosts_flutter_assignment/core/utils/result.dart';
import 'package:hotspot_hosts_flutter_assignment/models/experience.dart';
import 'package:hotspot_hosts_flutter_assignment/services/experience_service.dart';

/// Repository for managing experience data
class ExperienceRepository {
  final ExperienceService _experienceService;

  ExperienceRepository(this._experienceService);

  Future<Result<List<Experience>>> getExperiences() async {
    try {
      final response = await _experienceService.getExperiences(active: true);
      return Success(response.data.experiences);
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      return Error(exception.message, exception);
    }
  }
}
