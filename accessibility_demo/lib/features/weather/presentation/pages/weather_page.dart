import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:accessibility_demo/core/l10n/l10n_helper.dart';
import 'package:accessibility_demo/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:accessibility_demo/features/weather/presentation/bloc/weather_event.dart';
import 'package:accessibility_demo/features/weather/presentation/bloc/weather_state.dart';
import 'package:accessibility_demo/features/weather/presentation/widgets/refresh_button.dart';
import 'package:accessibility_demo/features/weather/presentation/widgets/weather_info_card.dart';

/// Main weather page.
/// 
/// Displays weather information with BLoC state management.
/// Uses L10nHelper for safe localization access (no ! operator).
class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = L10nHelper.of(context); // Safe access, no ! operator
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherInitial) {
            // Initial state - trigger load immediately
            context.read<WeatherBloc>().add(const GetWeatherEvent());
            return _buildLoadingView(context);
          } else if (state is WeatherLoading) {
            // Loading state
            return _buildLoadingView(context);
          } else if (state is WeatherLoaded) {
            // Success state
            return _buildLoadedView(context, state);
          } else if (state is WeatherError) {
            // Error state
            return _buildErrorView(context, state);
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
  
  /// Build loading view.
  Widget _buildLoadingView(BuildContext context) {
    final l10n = L10nHelper.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Semantics(
            label: l10n.refreshingButton,
            child: Text(l10n.refreshingButton),
          ),
        ],
      ),
    );
  }
  
  /// Build loaded view with weather data.
  Widget _buildLoadedView(BuildContext context, WeatherLoaded state) {
    final l10n = L10nHelper.of(context);
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Cache jelzés (ha cache-ből van) - KÁRTYA ELŐTT!
          if (state.isCached)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.orange.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.orange.shade900,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.cachedDataLabel,
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          
          // Időjárás kártya
          WeatherInfoCard(
            weather: state.weather,
            isCached: false, // Ne jelenítse meg kétszer!
          ),
          
          const SizedBox(height: 16),
          
          // Frissítés gomb
          RefreshButton(
            onPressed: () {
              context.read<WeatherBloc>().add(const GetWeatherEvent());
            },
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  /// Build error view.
  Widget _buildErrorView(BuildContext context, WeatherError state) {
    final l10n = L10nHelper.of(context);
    
    // Parse error message (format: "errorKey" or "errorKey:details")
    final parts = state.message.split(':');
    final errorKey = parts[0];
    final errorDetails = parts.length > 1 ? parts[1] : '';
    
    String errorMessage;
    switch (errorKey) {
      case 'errorServerFailure':
        errorMessage = l10n.errorServerFailure(errorDetails);
        break;
      case 'errorNetworkFailure':
        errorMessage = l10n.errorNetworkFailure;
        break;
      case 'errorCacheFailure':
        errorMessage = l10n.errorCacheFailure;
        break;
      default:
        errorMessage = state.message;
    }
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: '${l10n.errorTitle}: $errorMessage',
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.errorTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            RefreshButton(
              onPressed: () {
                context.read<WeatherBloc>().add(const GetWeatherEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}
