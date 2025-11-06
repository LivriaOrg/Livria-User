class Env {
  static const apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://livriagod.azurewebsites.net',
  );
}
