import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface for network connectivity checking.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation using connectivity_plus package.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  
  const NetworkInfoImpl(this.connectivity);
  
  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.any(
      (r) => r == ConnectivityResult.mobile || r == ConnectivityResult.wifi,
    );
  }
}
