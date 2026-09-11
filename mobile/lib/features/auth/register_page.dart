import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/luxury_card.dart';
import '../../core/widgets/onyx_logo.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  String currency = 'USD';
  bool obscurePassword = true;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/login'),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const OnyxLogo(
                    size: 48,
                    showText: true,
                    subtitle: 'Private Financial Ledger',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Create Account',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.midnight,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Set up your private financial ledger in seconds.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  LuxuryCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: name,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Your full name',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Email address',
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: password,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password (10+ characters)',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => obscurePassword = !obscurePassword,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: currency,
                          decoration: const InputDecoration(
                            labelText: 'Primary currency',
                            prefixIcon: Icon(Icons.language_rounded),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'USD',
                              child: Text('USD · US Dollar'),
                            ),
                            DropdownMenuItem(
                              value: 'EUR',
                              child: Text('EUR · Euro'),
                            ),
                            DropdownMenuItem(
                              value: 'GBP',
                              child: Text('GBP · British Pound'),
                            ),
                            DropdownMenuItem(
                              value: 'LBP',
                              child: Text('LBP · Lebanese Pound'),
                            ),
                            DropdownMenuItem(
                              value: 'AED',
                              child: Text('AED · UAE Dirham'),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => currency = value ?? 'USD'),
                        ),
                        if (auth.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Text(
                              auth.error.toString(),
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.crimson,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.midnight,
                            minimumSize: const Size.fromHeight(54),
                            elevation: 4,
                            shadowColor:
                                AppColors.midnight.withValues(alpha: 0.3),
                          ),
                          onPressed: auth.isLoading ? null : _register,
                          child: auth.isLoading
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Create My Space',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      'Already have an account? Sign in',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.midnight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    await ref
        .read(authProvider.notifier)
        .register(name.text.trim(), email.text.trim(), password.text, currency);
  }
}
