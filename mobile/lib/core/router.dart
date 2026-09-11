import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/accounts/accounts_page.dart';
import '../features/auth/login_page.dart';
import '../features/auth/register_page.dart';
import '../features/home/home_page.dart';
import '../features/transactions/add_entry_page.dart';
import '../features/transactions/transactions_page.dart';
import '../features/static_expenses/static_expenses_page.dart';
import '../features/transfers/transfer_page.dart';
import '../features/transfers/transfer_history_page.dart';
import '../features/settings/settings_page.dart';
import 'providers.dart';
import 'theme.dart';
import 'widgets/floating_nav_dock.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loggedIn = auth.valueOrNull != null;
      final isAuth =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      if (auth.isLoading) {
        return isAuth ? null : '/login';
      }
      if (!loggedIn && !isAuth) return '/login';
      if (loggedIn && isAuth) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomePage()),
          GoRoute(
            path: '/transactions',
            builder: (_, __) => const TransactionsPage(),
          ),
          GoRoute(path: '/accounts', builder: (_, __) => const AccountsPage()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
        ],
      ),
      GoRoute(
        path: '/add',
        builder: (_, state) => AddEntryPage(
          type: state.uri.queryParameters['type'] ?? 'DYNAMIC_SPENDING',
          transactionId: state.uri.queryParameters['transactionId'],
          initialAmount: state.uri.queryParameters['amount'],
          initialDescription: state.uri.queryParameters['description'],
        ),
      ),
      GoRoute(
        path: '/static-expenses',
        builder: (_, __) => const StaticExpensesPage(),
      ),
      GoRoute(path: '/transfer', builder: (_, __) => const TransferPage()),
      GoRoute(
        path: '/transfers',
        builder: (_, __) => const TransferHistoryPage(),
      ),
    ],
  );
});

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = location.startsWith('/transactions')
        ? 1
        : location.startsWith('/accounts')
        ? 2
        : location.startsWith('/settings')
        ? 3
        : 0;

    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: FloatingNavDock(
              selectedIndex: index,
              onDestinationSelected: (value) {
                final paths = ['/', '/transactions', '/accounts', '/settings'];
                context.go(paths[value]);
              },
              onAddPressed: () => _showAddMenu(context),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddMenu(BuildContext hostContext) {
    showModalBottomSheet<void>(
      context: hostContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: AppShadows.floating,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppGradients.luxuryDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: AppColors.mint,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Action',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.midnight,
                          ),
                        ),
                        Text(
                          'What would you like to record?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Consumer(
                  builder: (context, ref, _) {
                    final presets = ref.watch(presetsProvider);
                    if (presets.isEmpty) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('⚡', style: TextStyle(fontSize: 13)),
                              const SizedBox(width: 6),
                              Text(
                                'QUICK ITEM PRESETS',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: presets.map((preset) {
                                final isIncome = preset.type.contains('INCOME');
                                final color =
                                    isIncome ? AppColors.emerald : AppColors.crimson;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ActionChip(
                                    avatar: Text(
                                      preset.icon ?? (isIncome ? '💰' : '🏷️'),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    label: Text(
                                      '${preset.title} · \$${preset.amount.toStringAsFixed(2)}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.midnight,
                                      ),
                                    ),
                                    backgroundColor: AppColors.background,
                                    side: BorderSide(
                                      color: color.withValues(alpha: 0.25),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    onPressed: () {
                                      Navigator.of(sheetContext).pop();
                                      final encodedDesc =
                                          Uri.encodeComponent(preset.title);
                                      final encodedAmt =
                                          preset.amount.toStringAsFixed(2);
                                      hostContext.push(
                                        '/add?type=${preset.type}&amount=$encodedAmt&description=$encodedDesc',
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const Divider(height: 20),
                        ],
                      ),
                    );
                  },
                ),
                _quickActionTile(
                  sheetContext,
                  title: 'Record Expense',
                  subtitle: 'Daily spending, shopping, food & groceries',
                  icon: Icons.shopping_bag_outlined,
                  color: AppColors.crimson,
                  bgColor: AppColors.crimsonSoft,
                  onTap: () => hostContext.push('/add?type=DYNAMIC_SPENDING'),
                ),
                _quickActionTile(
                  sheetContext,
                  title: 'Add Income',
                  subtitle: 'Salary, freelance earnings, deposits',
                  icon: Icons.trending_up_rounded,
                  color: AppColors.emerald,
                  bgColor: AppColors.mintSoft,
                  onTap: () => hostContext.push('/add?type=MAIN_INCOME'),
                ),
                _quickActionTile(
                  sheetContext,
                  title: 'Transfer Between Wallets',
                  subtitle: 'Move funds between cash & digital accounts',
                  icon: Icons.swap_horiz_rounded,
                  color: AppColors.indigo,
                  bgColor: AppColors.indigoSoft,
                  onTap: () => hostContext.push('/transfer'),
                ),
                _quickActionTile(
                  sheetContext,
                  title: 'Recurring Bills',
                  subtitle: 'Rent, subscriptions, utilities tracker',
                  icon: Icons.event_repeat_rounded,
                  color: AppColors.amber,
                  bgColor: AppColors.amberSoft,
                  onTap: () => hostContext.push('/static-expenses'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickActionTile(
    BuildContext sheetContext, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.of(sheetContext).pop();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.midnight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
