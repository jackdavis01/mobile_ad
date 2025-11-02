import 'package:flutter/material.dart';
import 'package:accessibility_demo/core/l10n/l10n_helper.dart';

/// Refresh button widget with accessibility support.
/// 
/// Uses L10nHelper for safe localization access (no ! operator).
class RefreshButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  
  const RefreshButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = L10nHelper.of(context); // Safe access, no ! operator
    
    return Semantics(
      button: true,
      label: isLoading ? l10n.refreshingButton : l10n.refreshButton,
      enabled: !isLoading,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.refresh),
          label: Text(isLoading ? l10n.refreshingButton : l10n.refreshButton),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
