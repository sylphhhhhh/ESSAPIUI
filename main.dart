import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AbsensiApp());
}

// ─── COLORS ──────────────────────────────────────────────────────────────────
class AppColors {
  static const purple = Color(0xFF7C3AED);
  static const purpleDark = Color(0xFF6D28D9);
  static const purpleLight = Color(0xFF8B5CF6);
  static const purpleBg = Color(0xFFEDE9FE);
  static const purpleFaint = Color(0xFFF5F3FF);
  static const amber = Color(0xFFD97706);
  static const amberBg = Color(0xFFFEF3C7);
  static const green = Color(0xFF16A34A);
  static const greenBg = Color(0xFFDCFCE7);
  static const blue = Color(0xFF2563EB);
  static const blueBg = Color(0xFFDBEAFE);
  static const cyan = Color(0xFF0891B2);
  static const cyanBg = Color(0xFFCFFAFE);
  static const red = Color(0xFFDC2626);
  static const redBg = Color(0xFFFEE2E2);
  static const pink = Color(0xFFBE185D);
  static const pinkBg = Color(0xFFFCE7F3);
  static const bg = Color(0xFFF5F4FF);
  static const textDark = Color(0xFF1F2937);
  static const textMid = Color(0xFF6B7280);
  static const textLight = Color(0xFF9CA3AF);
  static const border = Color(0xFFE5E7EB);
  static const divider = Color(0xFFF3F4F6);
  static const inputBg = Color(0xFFF9FAFB);
}

// ─── APP ROOT ─────────────────────────────────────────────────────────────────
class AbsensiApp extends StatelessWidget {
  const AbsensiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi Karyawan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.purple),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

// ─── MAIN SHELL ───────────────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _activeIndex = 0;
  bool _isCheckedIn = false;
  bool _showLeave = false;
  bool _showOvertime = false;
  bool _showOutOffice = false;

  final _pages = const ['home', 'activity', 'absensi', 'notification', 'profile'];

  void _navigate(String page) {
    final idx = _pages.indexOf(page);
    if (idx >= 0) setState(() => _activeIndex = idx);
  }

  Widget _buildPage() {
    switch (_pages[_activeIndex]) {
      case 'home':
        return HomePage(
          onNavigate: _navigate,
          onOpenLeave: () => setState(() => _showLeave = true),
          onOpenOutOffice: () => setState(() => _showOutOffice = true),
          onOpenOvertime: () => setState(() => _showOvertime = true),
          isCheckedIn: _isCheckedIn,
        );
      case 'activity':
        return const ActivityPage();
      case 'absensi':
        return AbsensiPage(
          isCheckedIn: _isCheckedIn,
          onCheckIn: () => setState(() => _isCheckedIn = true),
        );
      case 'notification':
        return const NotificationPage();
      case 'profile':
        return const ProfilePage();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          _buildPage(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomNav(
              activeIndex: _activeIndex,
              onTap: (i) => setState(() => _activeIndex = i),
            ),
          ),
          if (_showLeave)
            LeaveModal(onClose: () => setState(() => _showLeave = false)),
          if (_showOvertime)
            OvertimeModal(onClose: () => setState(() => _showOvertime = false)),
          if (_showOutOffice)
            OutOfficeModal(onClose: () => setState(() => _showOutOffice = false)),
        ],
      ),
    );
  }
}

// ─── BOTTOM NAV ───────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.activeIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.bar_chart_rounded, 'Aktivitas'),
      (Icons.fingerprint, 'Absensi'),
      (Icons.notifications_rounded, 'Notifikasi'),
      (Icons.person_rounded, 'Profil'),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.purple.withOpacity(0.18),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isCenter = i == 2;
              final isActive = activeIndex == i;
              if (isCenter) {
                return GestureDetector(
                  onTap: () => onTap(i),
                  child: Transform.translate(
                    offset: const Offset(0, -14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.purpleLight, AppColors.purpleDark],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.purple.withOpacity(0.45),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(items[i].$1, color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          items[i].$2,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.purple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return GestureDetector(
                onTap: () => onTap(i),
                child: SizedBox(
                  width: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.purpleBg : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          items[i].$1,
                          size: 20,
                          color: isActive ? AppColors.purple : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].$2,
                        style: TextStyle(
                          fontSize: 10,
                          color: isActive ? AppColors.purple : AppColors.textLight,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── PURPLE HEADER ─────────────────────────────────────────────────────────
class _PurpleHeader extends StatelessWidget {
  final Widget child;
  final double bottomPad;

  const _PurpleHeader({required this.child, this.bottomPad = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.purpleDark, AppColors.purpleLight],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPad),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── HOME PAGE ────────────────────────────────────────────────────────────────
class HomePage extends StatelessWidget {
  final void Function(String) onNavigate;
  final VoidCallback onOpenLeave;
  final VoidCallback onOpenOutOffice;
  final VoidCallback onOpenOvertime;
  final bool isCheckedIn;

  const HomePage({
    super.key,
    required this.onNavigate,
    required this.onOpenLeave,
    required this.onOpenOutOffice,
    required this.onOpenOvertime,
    required this.isCheckedIn,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weekdays = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = [
      'Januari','Februari','Maret','April','Mei','Juni',
      'Juli','Agustus','September','Oktober','November','Desember'
    ];
    final dateStr = '${weekdays[today.weekday - 1]}, ${today.day} ${months[today.month - 1]} ${today.year}';

    final quickActions = [
      _QuickAction('absensi', 'Absensi', Icons.fingerprint, AppColors.purpleBg, AppColors.purple),
      _QuickAction('overtime', 'Overtime', Icons.access_time_rounded, AppColors.amberBg, AppColors.amber),
      _QuickAction('outoffice', 'Out of Office', Icons.work_rounded, AppColors.greenBg, AppColors.green),
      _QuickAction('leave', 'Cuti', Icons.beach_access_rounded, AppColors.blueBg, AppColors.blue),
    ];

    final summaryStats = [
      (Icons.login_rounded, 'Jam Masuk', isCheckedIn ? '08:46' : '--:--'),
      (Icons.logout_rounded, 'Jam Keluar', '--:--'),
      (Icons.coffee_rounded, 'Break Time', isCheckedIn ? '00:45' : '--:--'),
      (Icons.access_time_rounded, 'Lembur', '--:--'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header
          _PurpleHeader(
            bottomPad: 80,
            child: Column(
              children: [
                // Top row
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                      ),
                      child: const Center(
                        child: Text('R', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good Morning,', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          Text('Rizky Pratama', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onNavigate('notification'),
                      child: Stack(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: const Icon(Icons.notifications_rounded, color: Colors.white, size: 20),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF87171),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.purpleDark, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Location pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF34D399),
                          boxShadow: [BoxShadow(color: const Color(0xFF34D399).withOpacity(0.5), blurRadius: 8, spreadRadius: 3)],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Front Office', style: TextStyle(color: Colors.white60, fontSize: 11)),
                            Text('Abha Hotel Gading Serpong', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.6), size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Quick Actions Card (overlaps header)
          Transform.translate(
            offset: const Offset(0, -60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: AppColors.purple.withOpacity(0.12), blurRadius: 32, offset: const Offset(0, 8))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: quickActions.map((a) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (a.id == 'absensi') onNavigate('absensi');
                          else if (a.id == 'leave') onOpenLeave();
                          else if (a.id == 'outoffice') onOpenOutOffice();
                          else if (a.id == 'overtime') onOpenOvertime();
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: a.bg,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(a.icon, color: a.color, size: 24),
                            ),
                            const SizedBox(height: 8),
                            Text(a.label, textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11, color: AppColors.textMid, height: 1.3)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Negative margin to pull content up
          Transform.translate(
            offset: const Offset(0, -52),
            child: Column(
              children: [
                // ── Today's Summary
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Today's Summary", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                          Text(dateStr, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 2))],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: summaryStats.map((s) => Expanded(
                                child: Column(
                                  children: [
                                    Icon(s.$1, color: AppColors.purpleLight, size: 16),
                                    const SizedBox(height: 4),
                                    Text(s.$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                                    const SizedBox(height: 2),
                                    Text(s.$3, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                  ],
                                ),
                              )).toList(),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.purpleFaint,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Icon(Icons.location_on_rounded, color: AppColors.purple, size: 14),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Pastikan posisi anda berada di jangkauan area yang ditentukan untuk absensi',
                                      style: TextStyle(fontSize: 11, color: AppColors.purple, height: 1.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Map
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 140,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Map background gradient
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFE8F5E9), Color(0xFFE3F2FD)],
                              ),
                            ),
                          ),
                          // Grid lines
                          CustomPaint(painter: _MapGridPainter()),
                          // Road horizontal
                          Positioned(
                            top: 55, left: 0, right: 0,
                            child: Container(height: 12, color: Colors.white.withOpacity(0.8)),
                          ),
                          // Road vertical
                          Positioned(
                            left: 50, top: 0, bottom: 0,
                            child: Container(width: 8, color: Colors.white.withOpacity(0.8)),
                          ),
                          // Location pin
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.purple,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [BoxShadow(color: AppColors.purple.withOpacity(0.5), blurRadius: 16, offset: const Offset(0, 4))],
                                  ),
                                  child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
                                  ),
                                  child: const Text('Abha Hotel Gading Serpong', style: TextStyle(fontSize: 10, color: AppColors.textDark)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Announcements
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Pengumuman', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                          Row(
                            children: const [
                              Text('Lihat semua', style: TextStyle(fontSize: 12, color: AppColors.purple)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.purple),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _AnnouncementCard(
                        title: 'Briefing Mingguan',
                        desc: 'Briefing mingguan akan dilaksanakan pada Senin, 18 Mei 2026 pukul 09:00 di Aula Utama.',
                        time: '2 jam lalu',
                        color: AppColors.purpleBg,
                        iconColor: AppColors.purple,
                      ),
                      const SizedBox(height: 10),
                      _AnnouncementCard(
                        title: 'Cuti Lebaran',
                        desc: 'Pengajuan cuti Lebaran sudah dibuka. Silakan ajukan melalui menu Cuti.',
                        time: '1 hari lalu',
                        color: AppColors.amberBg,
                        iconColor: AppColors.amber,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Leave Balance
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [AppColors.purple, Color(0xFFA78BFA)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sisa Cuti Tahunan', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text('12', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                                SizedBox(width: 4),
                                Text('hari', style: TextStyle(color: Colors.white, fontSize: 14)),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text('Dari total 15 hari', style: TextStyle(color: Colors.white60, fontSize: 11)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: List.generate(5, (i) => Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Container(
                                  width: 8, height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: i < 3 ? Colors.white.withOpacity(0.4) : Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              )),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: onOpenLeave,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded, color: Colors.white, size: 12),
                                    SizedBox(width: 4),
                                    Text('Ajukan Cuti', style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final String id, label;
  final IconData icon;
  final Color bg, color;
  const _QuickAction(this.id, this.label, this.icon, this.bg, this.color);
}

class _AnnouncementCard extends StatelessWidget {
  final String title, desc, time;
  final Color color, iconColor;
  const _AnnouncementCard({required this.title, required this.desc, required this.time, required this.color, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.campaign_rounded, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                const SizedBox(height: 3),
                Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMid, height: 1.5)),
                const SizedBox(height: 6),
                Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF94A3B8).withOpacity(0.25)
      ..strokeWidth = 0.5;
    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── ABSENSI PAGE ─────────────────────────────────────────────────────────────
class AbsensiPage extends StatefulWidget {
  final bool isCheckedIn;
  final VoidCallback onCheckIn;

  const AbsensiPage({super.key, required this.isCheckedIn, required this.onCheckIn});

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  String? checkInTime;
  String? breakOutTime;
  String? breakInTime;
  String? checkOutTime;

  @override
  void initState() {
    super.initState();
    if (widget.isCheckedIn) checkInTime = '08:46';
  }

  String _now() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    // Week days starting Sunday
    final startOfWeek = today.subtract(Duration(days: today.weekday % 7));
    final weekDays = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
    const dayNames = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

    final steps = [
      _TimelineStep('Check In', checkInTime != null ? 'Abha Hotel Gading Serpong' : 'Belum Check In',
        Icons.login_rounded, checkInTime, checkInTime != null ? 'done' : 'active', AppColors.purple, AppColors.purpleBg),
      _TimelineStep('Break Out', breakOutTime != null ? 'Istirahat dimulai' : 'Menunggu Check In',
        Icons.coffee_rounded, breakOutTime, checkInTime == null ? 'pending' : breakOutTime != null ? 'done' : 'active', AppColors.amber, AppColors.amberBg),
      _TimelineStep('Break In (Return)', breakInTime != null ? 'Kembali bekerja' : 'Menunggu Break Out',
        Icons.coffee_rounded, breakInTime, breakOutTime == null ? 'pending' : breakInTime != null ? 'done' : 'active', AppColors.cyan, AppColors.cyanBg),
      _TimelineStep('Check Out', checkOutTime != null ? 'Pekerjaan selesai' : 'Belum Check Out',
        Icons.logout_rounded, checkOutTime, checkInTime == null ? 'pending' : checkOutTime != null ? 'done' : 'active', AppColors.green, AppColors.greenBg),
    ];

    String? actionLabel; Color? actionBg; Color? actionShadow; VoidCallback? actionFn;
    if (checkInTime == null) {
      actionLabel = 'Check In Sekarang'; actionBg = AppColors.purple; actionShadow = AppColors.purple.withOpacity(0.4);
      actionFn = () { setState(() { checkInTime = _now(); }); widget.onCheckIn(); };
    } else if (breakOutTime == null) {
      actionLabel = 'Mulai Break'; actionBg = AppColors.amber; actionShadow = AppColors.amber.withOpacity(0.4);
      actionFn = () => setState(() => breakOutTime = _now());
    } else if (breakInTime == null) {
      actionLabel = 'Selesai Break'; actionBg = AppColors.cyan; actionShadow = AppColors.cyan.withOpacity(0.4);
      actionFn = () => setState(() => breakInTime = _now());
    } else if (checkOutTime == null) {
      actionLabel = 'Check Out Sekarang'; actionBg = AppColors.green; actionShadow = AppColors.green.withOpacity(0.4);
      actionFn = () => setState(() => checkOutTime = _now());
    }

    final totalWork = checkInTime != null && checkOutTime != null ? '08j 44m' : checkInTime != null ? 'Berlangsung...' : '—';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 110),
      child: Column(
        children: [
          // ── Header
          _PurpleHeader(
            bottomPad: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Absensi', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Week strip
                Row(
                  children: weekDays.asMap().entries.map((entry) {
                    final i = entry.key;
                    final day = entry.value;
                    final isToday = day.day == today.day && day.month == today.month;
                    final isPast = day.isBefore(DateTime(today.year, today.month, today.day));
                    return Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        margin: EdgeInsets.only(right: i < 6 ? 6 : 0),
                        decoration: BoxDecoration(
                          color: isToday ? Colors.white : Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Text(dayNames[day.weekday % 7],
                              style: TextStyle(fontSize: 10, color: isToday ? AppColors.purple : Colors.white70)),
                            const SizedBox(height: 2),
                            Text('${day.day}',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isToday ? AppColors.purple : Colors.white)),
                            const SizedBox(height: 3),
                            Container(
                              width: 6, height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isPast ? const Color(0xFF34D399) : isToday ? AppColors.purple : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // ── Location card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(color: AppColors.purpleFaint, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.location_on_rounded, color: AppColors.purple, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lokasi Absensi', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                        Text('Abha Hotel Gading Serpong', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF34D399),
                          boxShadow: [BoxShadow(color: const Color(0xFF34D399).withOpacity(0.6), blurRadius: 6)],
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text('Terjangkau', style: TextStyle(fontSize: 11, color: Color(0xFF34D399), fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Work summary
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 2))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SummaryItem('Jam Kerja', totalWork),
                  _divider(),
                  _SummaryItem('Check In', checkInTime ?? '--:--'),
                  _divider(),
                  _SummaryItem('Check Out', checkOutTime ?? '--:--'),
                ],
              ),
            ),
          ),

          // ── Timeline
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Timeline Hari Ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    children: steps.asMap().entries.map((entry) {
                      final i = entry.key;
                      final step = entry.value;
                      return _TimelineItem(step: step, isLast: i == steps.length - 1);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // ── Action button
          if (actionLabel != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: GestureDetector(
                onTap: actionFn,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: actionBg,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: actionShadow!, blurRadius: 24, offset: const Offset(0, 8))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.login_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(actionLabel!, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ),

          if (checkOutTime != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.greenBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: AppColors.green, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('Absensi hari ini sudah selesai. Selamat beristirahat!',
                        style: TextStyle(fontSize: 13, color: Color(0xFF166534), fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _divider() => Container(width: 1, height: 32, color: AppColors.divider);

class _SummaryItem extends StatelessWidget {
  final String label, value;
  const _SummaryItem(this.label, this.value);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
      const SizedBox(height: 2),
      Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
    ],
  );
}

class _TimelineStep {
  final String label, sublabel, status;
  final IconData icon;
  final String? time;
  final Color color, bg;
  const _TimelineStep(this.label, this.sublabel, this.icon, this.time, this.status, this.color, this.bg);
}

class _TimelineItem extends StatelessWidget {
  final _TimelineStep step;
  final bool isLast;
  const _TimelineItem({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isDone = step.status == 'done';
    final isActive = step.status == 'active';
    final isPending = step.status == 'pending';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40, height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone || isActive ? step.bg : AppColors.divider,
                border: isActive ? Border.all(color: step.color, width: 2) : null,
              ),
              child: Center(
                child: isDone
                  ? Icon(Icons.check_circle_rounded, color: step.color, size: 20)
                  : Icon(step.icon, color: isPending ? AppColors.textLight : step.color, size: 18),
              ),
            ),
            if (!isLast)
              Container(
                width: 2, height: 36,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isDone ? step.color.withOpacity(0.4) : AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(step.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: isPending ? AppColors.textLight : AppColors.textDark)),
                    if (step.time != null)
                      Text(step.time!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: step.color))
                    else if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: step.bg, borderRadius: BorderRadius.circular(20)),
                        child: Text('Sekarang', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: step.color)),
                      )
                    else
                      const Text('--:--', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(step.sublabel, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── ACTIVITY PAGE ────────────────────────────────────────────────────────────
class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String _activeTab = 'semua';

  final _activities = [
    _Activity(1, 'absensi', 'Check In', 'Abha Hotel Gading Serpong', 'Hari ini, 16 Mei 2026', time: '08:46', status: 'done'),
    _Activity(2, 'absensi', 'Check Out', 'Abha Hotel Gading Serpong', 'Kemarin, 15 Mei 2026', time: '17:30', status: 'done', duration: '8j 44m'),
    _Activity(3, 'overtime', 'Overtime', 'Project deadline Q2', '15 Mei 2026', duration: '2j 30m', status: 'approved'),
    _Activity(4, 'cuti', 'Cuti Tahunan', 'Liburan keluarga', '20–22 Mei 2026', duration: '3 hari', status: 'approved'),
    _Activity(5, 'outoffice', 'Out of Office', 'Meeting klien Jakarta', '14 Mei 2026', duration: '4j', status: 'done'),
    _Activity(6, 'overtime', 'Overtime', 'System maintenance', '12 Mei 2026', duration: '1j 30m', status: 'pending'),
    _Activity(7, 'cuti', 'Cuti Sakit', 'Sakit flu', '10 Mei 2026', duration: '1 hari', status: 'approved'),
    _Activity(8, 'absensi', 'Check In', 'Abha Hotel Gading Serpong', '9 Mei 2026', time: '09:12', status: 'done'),
    _Activity(9, 'outoffice', 'Out of Office', 'Training kantor pusat', '8 Mei 2026', duration: '6j', status: 'rejected'),
  ];

  final _tabs = ['semua', 'absensi', 'overtime', 'outoffice', 'cuti'];
  final _tabLabels = ['Semua', 'Absensi', 'Overtime', 'Out of Office', 'Cuti'];

  @override
  Widget build(BuildContext context) {
    final filtered = _activities.where((a) => _activeTab == 'semua' || a.type == _activeTab).toList();

    return Column(
      children: [
        _PurpleHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Aktivitas', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('Riwayat kehadiran & pengajuan', style: TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
        ),
        // Stats row
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem('22', 'Hadir', AppColors.purple),
              _StatItem('2', 'Cuti', AppColors.blue),
              _StatItem('5', 'Overtime', AppColors.amber),
              _StatItem('0', 'Absen', AppColors.red),
            ],
          ),
        ),
        // Tabs
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _tabs.length,
            itemBuilder: (_, i) {
              final isActive = _activeTab == _tabs[i];
              return GestureDetector(
                onTap: () => setState(() => _activeTab = _tabs[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.purple : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(
                      color: isActive ? AppColors.purple.withOpacity(0.3) : Colors.black.withOpacity(0.06),
                      blurRadius: isActive ? 12 : 4,
                    )],
                  ),
                  child: Text(_tabLabels[i], style: TextStyle(
                    fontSize: 12, fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                    color: isActive ? Colors.white : AppColors.textMid)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _ActivityCard(activity: filtered[i]),
          ),
        ),
      ],
    );
  }
}

class _Activity {
  final int id;
  final String type, title, subtitle, date, status;
  final String? time, duration;
  const _Activity(this.id, this.type, this.title, this.subtitle, this.date, {this.time, this.duration, required this.status});
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatItem(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
    ],
  );
}

class _ActivityCard extends StatelessWidget {
  final _Activity activity;
  const _ActivityCard({required this.activity});

  static const _typeConfig = {
    'absensi': (Icons.login_rounded, AppColors.purpleBg, AppColors.purple),
    'overtime': (Icons.access_time_rounded, AppColors.amberBg, AppColors.amber),
    'outoffice': (Icons.work_rounded, AppColors.greenBg, AppColors.green),
    'cuti': (Icons.beach_access_rounded, AppColors.blueBg, AppColors.blue),
  };
  static const _statusConfig = {
    'approved': ('Disetujui', AppColors.green, AppColors.greenBg),
    'done': ('Selesai', AppColors.purple, AppColors.purpleBg),
    'pending': ('Menunggu', AppColors.amber, AppColors.amberBg),
    'rejected': ('Ditolak', AppColors.red, AppColors.redBg),
  };

  @override
  Widget build(BuildContext context) {
    final tc = _typeConfig[activity.type]!;
    final sc = _statusConfig[activity.status]!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: tc.$2, borderRadius: BorderRadius.circular(14)),
            child: Icon(tc.$1, color: tc.$3, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                        Text(activity.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                      ],
                    )),
                    if (activity.time != null)
                      Text(activity.time!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: tc.$3))
                    else if (activity.duration != null)
                      Text(activity.duration!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMid)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(activity.date, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: sc.$3, borderRadius: BorderRadius.circular(20)),
                      child: Text(sc.$1, style: TextStyle(fontSize: 10, color: sc.$2, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── NOTIFICATION PAGE ────────────────────────────────────────────────────────
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _activeTab = 'semua';
  late Set<int> _readIds;

  final _notifications = [
    _Notif(1, 'absensi', 'Pengingat Absensi', 'Kamu belum melakukan Check Out hari ini. Jangan lupa absen sebelum pulang!', '5 menit lalu', false),
    _Notif(2, 'cuti', 'Cuti Disetujui', 'Pengajuan cuti tahunan kamu pada 20–22 Mei 2026 telah disetujui oleh atasan.', '1 jam lalu', false),
    _Notif(3, 'pengumuman', 'Briefing Mingguan', 'Briefing mingguan akan dilaksanakan Senin, 18 Mei 2026 pukul 09:00 di Aula Utama.', '2 jam lalu', false),
    _Notif(4, 'outoffice', 'Out of Office Ditolak', 'Maaf, pengajuan Out of Office kamu pada 8 Mei 2026 ditolak. Silakan hubungi atasan.', '2 hari lalu', true),
    _Notif(5, 'overtime', 'Overtime Menunggu Persetujuan', 'Pengajuan overtime kamu pada 12 Mei 2026 sedang menunggu persetujuan atasan.', '4 hari lalu', true),
    _Notif(6, 'pengumuman', 'Cuti Lebaran', 'Pengajuan cuti Lebaran sudah dibuka. Silakan ajukan melalui menu Cuti sebelum 25 Mei 2026.', '1 minggu lalu', true, archived: true),
    _Notif(7, 'absensi', 'Rekap Absensi Bulan April', 'Rekap absensi bulan April sudah tersedia. Total hadir: 22 hari dari 23 hari kerja.', '2 minggu lalu', true, archived: true),
  ];

  @override
  void initState() {
    super.initState();
    _readIds = _notifications.where((n) => n.read).map((n) => n.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !_readIds.contains(n.id) && !n.archived).length;
    final filtered = _notifications.where((n) {
      if (_activeTab == 'semua') return !n.archived;
      if (_activeTab == 'belum') return !_readIds.contains(n.id) && !n.archived;
      if (_activeTab == 'dibaca') return _readIds.contains(n.id) && !n.archived;
      if (_activeTab == 'diarsipkan') return n.archived;
      return true;
    }).toList();

    final tabs = [('semua', 'Semua'), ('belum', 'Belum Dibaca'), ('dibaca', 'Dibaca'), ('diarsipkan', 'Diarsipkan')];

    return Column(
      children: [
        _PurpleHeader(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notifikasi', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    unreadCount > 0 ? '$unreadCount notifikasi belum dibaca' : 'Semua sudah dibaca',
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
              if (unreadCount > 0)
                GestureDetector(
                  onTap: () => setState(() => _readIds = _notifications.map((n) => n.id).toSet()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: const Text('Tandai Semua Dibaca', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ),
            ],
          ),
        ),
        // Tabs
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (_, i) {
                final isActive = _activeTab == tabs[i].$1;
                return GestureDetector(
                  onTap: () => setState(() => _activeTab = tabs[i].$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.purple : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(
                        color: isActive ? AppColors.purple.withOpacity(0.3) : Colors.black.withOpacity(0.06),
                        blurRadius: isActive ? 12 : 4,
                      )],
                    ),
                    child: Text(tabs[i].$2, style: TextStyle(
                      fontSize: 12, fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                      color: isActive ? Colors.white : AppColors.textMid)),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.purpleBg),
                      child: const Icon(Icons.notifications_rounded, color: AppColors.purple, size: 28),
                    ),
                    const SizedBox(height: 12),
                    const Text('Tidak ada notifikasi di sini', style: TextStyle(fontSize: 14, color: AppColors.textLight)),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final n = filtered[i];
                  final isUnread = !_readIds.contains(n.id);
                  const typeConfig = {
                    'absensi': (Icons.check_circle_rounded, AppColors.purpleBg, AppColors.purple),
                    'cuti': (Icons.beach_access_rounded, AppColors.blueBg, AppColors.blue),
                    'outoffice': (Icons.work_rounded, AppColors.greenBg, AppColors.green),
                    'pengumuman': (Icons.campaign_rounded, AppColors.amberBg, AppColors.amber),
                    'overtime': (Icons.access_time_rounded, AppColors.pinkBg, AppColors.pink),
                  };
                  final tc = typeConfig[n.type]!;
                  return GestureDetector(
                    onTap: () => setState(() => _readIds.add(n.id)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isUnread ? const Color(0xFFFAFAFE) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isUnread ? AppColors.purple.withOpacity(0.12) : Colors.transparent),
                        boxShadow: [BoxShadow(
                          color: isUnread ? AppColors.purple.withOpacity(0.1) : Colors.black.withOpacity(0.04),
                          blurRadius: 12, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(color: tc.$2, borderRadius: BorderRadius.circular(14)),
                                child: Icon(tc.$1, color: tc.$3, size: 20),
                              ),
                              if (isUnread)
                                Positioned(
                                  top: -3, right: -3,
                                  child: Container(
                                    width: 10, height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.purple,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text(n.title, style: TextStyle(
                                      fontSize: 13, fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600, color: AppColors.textDark))),
                                    Text(n.time, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(n.message, style: const TextStyle(fontSize: 12, color: AppColors.textMid, height: 1.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }
}

class _Notif {
  final int id;
  final String type, title, message, time;
  final bool read, archived;
  const _Notif(this.id, this.type, this.title, this.message, this.time, this.read, {this.archived = false});
}

// ─── PROFILE PAGE ─────────────────────────────────────────────────────────────
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const accountInfo = [
      (Icons.email_rounded, 'Email', 'rizky.pratama@abhahotel.com'),
      (Icons.phone_rounded, 'Telepon', '+62 812-3456-7890'),
      (Icons.business_rounded, 'Departemen', 'Front Office'),
      (Icons.location_on_rounded, 'Lokasi Kantor', 'Abha Hotel Gading Serpong'),
      (Icons.calendar_today_rounded, 'Bergabung', '01 Januari 2023'),
    ];
    const appSettings = [
      (Icons.notifications_rounded, 'Notifikasi', 'Aktif'),
      (Icons.shield_rounded, 'Keamanan & Privasi', ''),
      (Icons.fingerprint, 'Biometrik', 'Aktif'),
      (Icons.help_rounded, 'Bantuan & FAQ', ''),
    ];
    const stats = [
      (Icons.star_rounded, 'Kehadiran', '96%', AppColors.purple),
      (Icons.access_time_rounded, 'Tepat Waktu', '88%', AppColors.green),
      (Icons.timelapse_rounded, 'Lembur', '12j', AppColors.amber),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 110),
      child: Column(
        children: [
          // ── Header
          _PurpleHeader(
            bottomPad: 32,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
                      ),
                      child: const Center(child: Text('R', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700))),
                    ),
                    Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF34D399),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Rizky Pratama', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                const Text('Front Office • Staff', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 6, height: 6,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF34D399))),
                      const SizedBox(width: 6),
                      const Text('ID: EMP-2023-001', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Stats
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: stats.map((s) => Column(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: s.$4.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                    child: Icon(s.$1, color: s.$4, size: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(s.$3, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: s.$4)),
                  const SizedBox(height: 2),
                  Text(s.$2, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                ],
              )).toList(),
            ),
          ),

          // ── Account Info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('INFORMASI AKUN', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textLight, letterSpacing: 0.8)),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    children: accountInfo.asMap().entries.map((entry) {
                      final i = entry.key;
                      final info = entry.value;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(bottom: i < accountInfo.length - 1
                            ? const BorderSide(color: AppColors.divider)
                            : BorderSide.none),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(color: AppColors.purpleBg, borderRadius: BorderRadius.circular(10)),
                              child: Icon(info.$1, color: AppColors.purple, size: 16),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(info.$2, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                                const SizedBox(height: 1),
                                Text(info.$3, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                              ],
                            )),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // ── App Settings
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('PENGATURAN APLIKASI', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textLight, letterSpacing: 0.8)),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    children: appSettings.asMap().entries.map((entry) {
                      final i = entry.key;
                      final s = entry.value;
                      return GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(bottom: i < appSettings.length - 1
                              ? const BorderSide(color: AppColors.divider)
                              : BorderSide.none),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(10)),
                                child: Icon(s.$1, color: AppColors.textMid, size: 16),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(s.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark))),
                              if (s.$3.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.greenBg, borderRadius: BorderRadius.circular(20)),
                                  child: Text(s.$3, style: const TextStyle(fontSize: 11, color: AppColors.green, fontWeight: FontWeight.w600)),
                                )
                              else
                                const Icon(Icons.chevron_right, color: AppColors.textLight, size: 16),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // ── Logout
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GestureDetector(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.redBg, borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppColors.red.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 2))],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: AppColors.red, size: 18),
                    SizedBox(width: 8),
                    Text('Keluar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.red)),
                  ],
                ),
              ),
            ),
          ),

          const Text('Versi Aplikasi 1.0.0', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── LEAVE MODAL ──────────────────────────────────────────────────────────────
class LeaveModal extends StatefulWidget {
  final VoidCallback onClose;
  const LeaveModal({super.key, required this.onClose});

  @override
  State<LeaveModal> createState() => _LeaveModalState();
}

class _LeaveModalState extends State<LeaveModal> {
  bool _success = false;
  String _leaveType = 'tahunan';
  DateTime? _startDate, _endDate;
  final _reasonCtrl = TextEditingController();
  bool _showDropdown = false;

  final _types = [
    ('tahunan', 'Cuti Tahunan', '12 hari tersisa'),
    ('sakit', 'Cuti Sakit', 'Tidak terbatas'),
    ('penting', 'Cuti Penting', '3 hari tersisa'),
    ('melahirkan', 'Cuti Melahirkan', '90 hari'),
  ];

  @override
  Widget build(BuildContext context) {
    return _ModalSheet(
      onClose: widget.onClose,
      child: _success
        ? _SuccessView(
            color: AppColors.greenBg,
            iconColor: AppColors.green,
            message: 'Pengajuan cuti kamu sedang diproses. Kamu akan mendapat notifikasi setelah atasan memberikan keputusan.',
            onClose: widget.onClose,
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ModalHeader(icon: Icons.beach_access_rounded, iconColor: AppColors.blue, iconBg: AppColors.blueBg,
                  title: 'Pengajuan Cuti', subtitle: 'Isi form berikut dengan lengkap', onClose: widget.onClose),
                const SizedBox(height: 20),
                // Balance pills
                Row(
                  children: [
                    _BalancePill('12', 'Tahunan', AppColors.purple, AppColors.purpleBg),
                    const SizedBox(width: 8),
                    _BalancePill('∞', 'Sakit', AppColors.amber, AppColors.amberBg),
                    const SizedBox(width: 8),
                    _BalancePill('3', 'Penting', AppColors.blue, AppColors.blueBg),
                  ],
                ),
                const SizedBox(height: 20),
                // Leave type dropdown
                _FieldLabel('Jenis Cuti'),
                GestureDetector(
                  onTap: () => setState(() => _showDropdown = !_showDropdown),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(_types.firstWhere((t) => t.$1 == _leaveType).$2,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                          Text(_types.firstWhere((t) => t.$1 == _leaveType).$3,
                            style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                        ]),
                        AnimatedRotation(
                          turns: _showDropdown ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showDropdown)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border, width: 1.5),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 8))],
                    ),
                    child: Column(
                      children: _types.map((t) => GestureDetector(
                        onTap: () => setState(() { _leaveType = t.$1; _showDropdown = false; }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          decoration: BoxDecoration(
                            color: _leaveType == t.$1 ? AppColors.purpleFaint : Colors.white,
                            border: Border(bottom: t != _types.last ? const BorderSide(color: AppColors.divider) : BorderSide.none),
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(t.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                            Text(t.$3, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                          ]),
                        ),
                      )).toList(),
                    ),
                  ),
                const SizedBox(height: 14),
                // Date range
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _FieldLabel('Tanggal Mulai'),
                    _DatePickerField(
                      value: _startDate,
                      hint: 'Pilih tanggal',
                      onTap: () async {
                        final d = await showDatePicker(context: context, initialDate: DateTime.now(),
                          firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                        if (d != null) setState(() => _startDate = d);
                      },
                    ),
                  ])),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _FieldLabel('Tanggal Selesai'),
                    _DatePickerField(
                      value: _endDate,
                      hint: 'Pilih tanggal',
                      onTap: () async {
                        final d = await showDatePicker(context: context, initialDate: _startDate ?? DateTime.now(),
                          firstDate: _startDate ?? DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                        if (d != null) setState(() => _endDate = d);
                      },
                    ),
                  ])),
                ]),
                const SizedBox(height: 14),
                _FieldLabel('Alasan / Keterangan'),
                _TextAreaField(controller: _reasonCtrl, hint: 'Tuliskan alasan pengajuan cuti kamu...'),
                const SizedBox(height: 20),
                _SubmitButton(
                  label: 'Kirim Pengajuan',
                  enabled: _startDate != null && _endDate != null && _reasonCtrl.text.isNotEmpty,
                  color: AppColors.purple,
                  onTap: () { if (_startDate != null && _endDate != null && _reasonCtrl.text.isNotEmpty) setState(() => _success = true); },
                ),
              ],
            ),
          ),
    );
  }
}

// ─── OVERTIME MODAL ───────────────────────────────────────────────────────────
class OvertimeModal extends StatefulWidget {
  final VoidCallback onClose;
  const OvertimeModal({super.key, required this.onClose});

  @override
  State<OvertimeModal> createState() => _OvertimeModalState();
}

class _OvertimeModalState extends State<OvertimeModal> {
  bool _success = false;
  DateTime? _date;
  TimeOfDay? _startTime, _endTime;
  final _reasonCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isValid = _date != null && _startTime != null && _endTime != null && _reasonCtrl.text.isNotEmpty;
    return _ModalSheet(
      onClose: widget.onClose,
      child: _success
        ? _SuccessView(
            color: AppColors.amberBg,
            iconColor: AppColors.amber,
            message: 'Pengajuan overtime kamu sedang menunggu persetujuan atasan.',
            onClose: widget.onClose,
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ModalHeader(icon: Icons.access_time_rounded, iconColor: AppColors.amber, iconBg: AppColors.amberBg,
                  title: 'Pengajuan Overtime', subtitle: 'Isi form berikut dengan lengkap', onClose: widget.onClose),
                const SizedBox(height: 20),
                _FieldLabel('Tanggal Overtime'),
                _DatePickerField(
                  value: _date, hint: 'Pilih tanggal',
                  onTap: () async {
                    final d = await showDatePicker(context: context, initialDate: DateTime.now(),
                      firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 30)));
                    if (d != null) setState(() => _date = d);
                  },
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _FieldLabel('Jam Mulai'),
                    _TimePickerField(
                      value: _startTime, hint: '--:--',
                      onTap: () async {
                        final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 17, minute: 0));
                        if (t != null) setState(() => _startTime = t);
                      },
                    ),
                  ])),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _FieldLabel('Jam Selesai'),
                    _TimePickerField(
                      value: _endTime, hint: '--:--',
                      onTap: () async {
                        final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 20, minute: 0));
                        if (t != null) setState(() => _endTime = t);
                      },
                    ),
                  ])),
                ]),
                const SizedBox(height: 14),
                _FieldLabel('Alasan Overtime'),
                _TextAreaField(controller: _reasonCtrl, hint: 'Tuliskan alasan dan pekerjaan yang dikerjakan...'),
                const SizedBox(height: 20),
                _SubmitButton(
                  label: 'Kirim Pengajuan',
                  enabled: isValid,
                  color: AppColors.amber,
                  onTap: () { if (isValid) setState(() => _success = true); },
                ),
              ],
            ),
          ),
    );
  }
}

// ─── OUT OF OFFICE MODAL ──────────────────────────────────────────────────────
class OutOfficeModal extends StatefulWidget {
  final VoidCallback onClose;
  const OutOfficeModal({super.key, required this.onClose});

  @override
  State<OutOfficeModal> createState() => _OutOfficeModalState();
}

class _OutOfficeModalState extends State<OutOfficeModal> {
  bool _success = false;
  final _destCtrl = TextEditingController();
  String _purpose = '';
  TimeOfDay? _startTime, _endTime;
  final _notesCtrl = TextEditingController();
  bool _showDropdown = false;

  final _purposes = ['Meeting Klien', 'Kunjungan Lapangan', 'Training / Pelatihan', 'Perjalanan Dinas', 'Lainnya'];

  @override
  Widget build(BuildContext context) {
    final isValid = _destCtrl.text.isNotEmpty && _purpose.isNotEmpty && _startTime != null && _endTime != null;
    return _ModalSheet(
      onClose: widget.onClose,
      child: _success
        ? _SuccessView(
            color: AppColors.greenBg,
            iconColor: AppColors.green,
            message: 'Pengajuan Out of Office kamu sedang diproses. Atasan akan segera memberikan persetujuan.',
            onClose: widget.onClose,
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ModalHeader(icon: Icons.work_rounded, iconColor: AppColors.green, iconBg: AppColors.greenBg,
                  title: 'Out of Office', subtitle: 'Pengajuan keluar area kantor', onClose: widget.onClose),
                const SizedBox(height: 20),
                // Info banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 1),
                        child: Icon(Icons.work_rounded, color: AppColors.green, size: 16)),
                      SizedBox(width: 8),
                      Expanded(child: Text(
                        'Pengajuan Out of Office perlu disetujui atasan sebelum kamu meninggalkan area kantor.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF166534), height: 1.5))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _FieldLabel('Tujuan / Lokasi'),
                _InputField(controller: _destCtrl, hint: 'Contoh: Kantor Pusat Jakarta',
                  icon: Icons.location_on_rounded, onChanged: (_) => setState(() {})),
                const SizedBox(height: 14),
                _FieldLabel('Keperluan'),
                GestureDetector(
                  onTap: () => setState(() => _showDropdown = !_showDropdown),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(_purpose.isEmpty ? 'Pilih keperluan' : _purpose,
                        style: TextStyle(fontSize: 13, color: _purpose.isEmpty ? AppColors.textLight : AppColors.textDark)),
                      AnimatedRotation(
                        turns: _showDropdown ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
                      ),
                    ]),
                  ),
                ),
                if (_showDropdown)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border, width: 1.5),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 8))],
                    ),
                    child: Column(
                      children: _purposes.map((p) => GestureDetector(
                        onTap: () => setState(() { _purpose = p; _showDropdown = false; }),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          decoration: BoxDecoration(
                            color: _purpose == p ? const Color(0xFFF0FDF4) : Colors.white,
                            border: Border(bottom: p != _purposes.last ? const BorderSide(color: AppColors.divider) : BorderSide.none),
                          ),
                          child: Text(p, style: TextStyle(fontSize: 13,
                            color: _purpose == p ? AppColors.green : AppColors.textDark,
                            fontWeight: _purpose == p ? FontWeight.w600 : FontWeight.normal)),
                        ),
                      )).toList(),
                    ),
                  ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _FieldLabel('Waktu Berangkat'),
                    _TimePickerField(
                      value: _startTime, hint: '--:--',
                      onTap: () async {
                        final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
                        if (t != null) setState(() => _startTime = t);
                      },
                    ),
                  ])),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _FieldLabel('Waktu Kembali'),
                    _TimePickerField(
                      value: _endTime, hint: '--:--',
                      onTap: () async {
                        final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 17, minute: 0));
                        if (t != null) setState(() => _endTime = t);
                      },
                    ),
                  ])),
                ]),
                const SizedBox(height: 14),
                Row(children: const [
                  Text('Catatan Tambahan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  SizedBox(width: 4),
                  Text('(opsional)', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                ]),
                const SizedBox(height: 6),
                _TextAreaField(controller: _notesCtrl, hint: 'Catatan tambahan jika diperlukan...', rows: 3),
                const SizedBox(height: 20),
                _SubmitButton(
                  label: 'Kirim Pengajuan',
                  enabled: isValid,
                  color: AppColors.green,
                  onTap: () { if (isValid) setState(() => _success = true); },
                ),
              ],
            ),
          ),
    );
  }
}

// ─── SHARED MODAL WIDGETS ─────────────────────────────────────────────────────
class _ModalSheet extends StatelessWidget {
  final Widget child;
  final VoidCallback onClose;
  const _ModalSheet({required this.child, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(color: Colors.black.withOpacity(0.4)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
                Flexible(child: child),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  final Color color, iconColor;
  final String message;
  final VoidCallback onClose;
  const _SuccessView({required this.color, required this.iconColor, required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            child: Icon(Icons.check_circle_rounded, color: iconColor, size: 36),
          ),
          const SizedBox(height: 16),
          const Text('Pengajuan Terkirim!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.textMid, height: 1.6)),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              decoration: BoxDecoration(
                color: iconColor, borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: iconColor.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 6))],
              ),
              child: const Text('Selesai', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModalHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String title, subtitle;
  final VoidCallback onClose;
  const _ModalHeader({required this.icon, required this.iconColor, required this.iconBg,
    required this.title, required this.subtitle, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Container(width: 38, height: 38,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 18)),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
          ]),
        ]),
        GestureDetector(
          onTap: onClose,
          child: Container(width: 32, height: 32,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.divider),
            child: const Icon(Icons.close, size: 16, color: AppColors.textMid)),
        ),
      ],
    );
  }
}

Widget _FieldLabel(String label) => Padding(
  padding: const EdgeInsets.only(bottom: 6),
  child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
);

class _DatePickerField extends StatelessWidget {
  final DateTime? value;
  final String hint;
  final VoidCallback onTap;
  const _DatePickerField({required this.value, required this.hint, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = value == null ? hint : '${value!.day.toString().padLeft(2,'0')}/${value!.month.toString().padLeft(2,'0')}/${value!.year}';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.inputBg, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(children: [
          const Icon(Icons.calendar_today_rounded, color: AppColors.textLight, size: 16),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 13, color: value == null ? AppColors.textLight : AppColors.textDark)),
        ]),
      ),
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final TimeOfDay? value;
  final String hint;
  final VoidCallback onTap;
  const _TimePickerField({required this.value, required this.hint, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = value == null ? hint : '${value!.hour.toString().padLeft(2,'0')}:${value!.minute.toString().padLeft(2,'0')}';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.inputBg, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(children: [
          const Icon(Icons.access_time_rounded, color: AppColors.textLight, size: 14),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 13, color: value == null ? AppColors.textLight : AppColors.textDark)),
        ]),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  const _InputField({required this.controller, required this.hint, this.icon, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.textLight, size: 16) : null,
        filled: true,
        fillColor: AppColors.inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.purple, width: 1.5)),
      ),
      style: const TextStyle(fontSize: 13, color: AppColors.textDark),
    );
  }
}

class _TextAreaField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int rows;
  const _TextAreaField({required this.controller, required this.hint, this.rows = 4});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: rows,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
        filled: true,
        fillColor: AppColors.inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.purple, width: 1.5)),
      ),
      style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.5),
    );
  }
}

class _BalancePill extends StatelessWidget {
  final String value, label;
  final Color color, bg;
  const _BalancePill(this.value, this.label, this.color, this.bg);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
    child: Column(children: [
      Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
      Text(label, style: TextStyle(fontSize: 10, color: color.withOpacity(0.8))),
    ]),
  );
}

class _SubmitButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final Color color;
  final VoidCallback onTap;
  const _SubmitButton({required this.label, required this.enabled, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: enabled ? color : AppColors.border,
          borderRadius: BorderRadius.circular(16),
          boxShadow: enabled ? [BoxShadow(color: color.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 6))] : null,
        ),
        child: Text(label, textAlign: TextAlign.center,
          style: TextStyle(color: enabled ? Colors.white : AppColors.textLight, fontSize: 14, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
