///////////////////// Base URL /////////////////////
const String baseUrl = 'https://wowme.dotapps.net/api/v1';

class ApiRoutes {
  // Auth
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';

  static const String callLogs = '$baseUrl/call-log';
}
