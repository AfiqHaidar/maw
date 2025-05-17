// lib/data/enums/connection_status.dart
enum ConnectionIdentifier {
  pending,
  connected,
  blocked;

  String get name {
    switch (this) {
      case ConnectionIdentifier.pending:
        return 'pending';
      case ConnectionIdentifier.connected:
        return 'connected';
      case ConnectionIdentifier.blocked:
        return 'blocked';
    }
  }

  static ConnectionIdentifier fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return ConnectionIdentifier.pending;
      case 'connected':
        return ConnectionIdentifier.connected;
      case 'blocked':
        return ConnectionIdentifier.blocked;
      default:
        throw Exception('Invalid ConnectionIdentifier: $status');
    }
  }
}
