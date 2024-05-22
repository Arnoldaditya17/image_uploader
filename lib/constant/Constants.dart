class Constants {
  static getUri(String endpoint) {
    return Uri(
      scheme: 'http',
      host: '192.168.8.171',
      port: 8081,
      path: endpoint,
    );
  }
}
