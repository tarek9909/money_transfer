import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// Global scaffold messenger key to safely show toasts across routes,
/// bottom sheets, and dialogs without establishing invalid InheritedWidget dependencies.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Standard luxury floating toast/snackbar feedback for ONYX mobile app.
abstract final class AppToast {
  static void success(BuildContext? context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.emeraldLight,
    );
  }

  static void error(BuildContext? context, String message) {
    final cleanMsg = message.replaceFirst('Exception: ', '').trim();
    _show(
      context,
      message: cleanMsg.isEmpty ? 'An error occurred' : cleanMsg,
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.crimsonLight,
    );
  }

  static void info(BuildContext? context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info_outline_rounded,
      iconColor: AppColors.indigoLight,
    );
  }

  static void _show(
    BuildContext? context, {
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    final messenger = rootScaffoldMessengerKey.currentState ??
        (context != null && context.mounted
            ? ScaffoldMessenger.maybeOf(context)
            : null);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: AppColors.midnight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.slateDark),
        ),
        elevation: 8,
        duration: const Duration(milliseconds: 2500),
        content: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
