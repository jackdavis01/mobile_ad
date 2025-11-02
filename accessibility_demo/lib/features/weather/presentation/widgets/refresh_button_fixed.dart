import 'package:flutter/material.dart';
import 'package:accessibility_demo/core/l10n/l10n_helper.dart';

/// FIXED VERSION: Refresh button widget with CORRECT accessibility support.
/// 
/// This is the DEMONSTRATION version showing proper Semantics implementation
/// that passes all accessibility tests.
/// 
/// Key fixes:
/// - Semantics label matches test expectations exactly
/// - Button state is properly communicated to screen readers
/// - Uses L10nHelper for safe localization access (no ! operator)
/// 
/// Compare this with refresh_button.dart to see the differences!
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
    
    // ✅ FIX: Proper Semantics with explicit label that matches tests
    return Semantics(
      button: true,
      label: isLoading ? l10n.refreshingButton : l10n.refreshButton,
      enabled: !isLoading,
      excludeSemantics: true,
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
          label: ExcludeSemantics(
            child: Text(isLoading ? l10n.refreshingButton : l10n.refreshButton),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
