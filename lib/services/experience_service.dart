import 'package:hotspot_hosts_flutter_assignment/core/constants/api_constants.dart';
import 'package:hotspot_hosts_flutter_assignment/models/api_response.dart';
import 'package:hotspot_hosts_flutter_assignment/services/api_client.dart';

/// Service for handling experience-related API calls
class ExperienceService {
  final ApiClient _apiClient;

  ExperienceService(this._apiClient);

  /// Fetch all active experiences
  Future<ExperiencesResponse> getExperiences({bool active = true}) async {
    final response = await _apiClient.get(
      ApiConstants.experiencesEndpoint,
      queryParameters: {
        ApiConstants.activeParam: active.toString(),
      },
    );

    return ExperiencesResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
