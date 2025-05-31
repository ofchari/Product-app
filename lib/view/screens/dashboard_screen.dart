import 'package:flutter/cupertino.dart'; // Import for CupertinoIcons
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/shared_preferences.dart';
import 'details_screen.dart';
import 'login.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Updated list of categories
  final List<String> categories = [
    'Sales',
    'Knitting',
    'Dyeing',
    'Purchase',
    'Yarn',
    'Production',
    'Fabric', // Added Fabric
    'Cutting', // Added Cutting
  ];

  /// Updated icons map
  final Map<String, IconData> categoryIcons = {
    'Sales': CupertinoIcons.chart_bar_alt_fill,
    'Knitting': Icons.cut_outlined,
    'Dyeing': Icons.color_lens_outlined,
    'Purchase': CupertinoIcons.shopping_cart,
    'Yarn': CupertinoIcons.archivebox_fill,
    'Production': CupertinoIcons.settings,
    'Fabric': CupertinoIcons.layers_alt_fill, // Added icon for Fabric
    'Cutting': CupertinoIcons.scissors, // Added icon for Cutting
  };

  // Define subtle gradient colors for cards
  final List<List<Color>> cardGradients = [
    [Colors.blue.shade300, Colors.blue.shade600],
    [Colors.green.shade300, Colors.green.shade600],
    [Colors.orange.shade300, Colors.orange.shade600],
    [Colors.purple.shade300, Colors.purple.shade600],
    [Colors.red.shade300, Colors.red.shade600],
    [Colors.teal.shade300, Colors.teal.shade600],
    [
      Colors.indigo.shade300,
      Colors.indigo.shade600,
    ], // Added gradient for Fabric
    [Colors.pink.shade300, Colors.pink.shade600], // Added gradient for Cutting
  ];

  void _logout() async {
    await SharedPrefsUtil.saveLoginStatus(false);
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false, // Remove all routes below
      );
    }
  }

  void _navigateToDetail(String categoryTitle) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailScreen(categoryTitle: categoryTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2.0, // Add subtle elevation
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined), // Outlined logout icon
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Keep 2 columns
            crossAxisSpacing: 18.w, // Slightly increased spacing
            mainAxisSpacing: 18.h, // Slightly increased spacing
            childAspectRatio:
                1.1, // Adjust aspect ratio for a slightly taller look
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final icon =
                categoryIcons[category] ??
                CupertinoIcons.app_fill; // Default icon
            // Use modulo to cycle through gradients if categories exceed gradients defined
            final gradientColors = cardGradients[index % cardGradients.length];

            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(
                18.r,
              ), // Slightly more rounded corners
              child: InkWell(
                onTap: () => _navigateToDetail(category),
                borderRadius: BorderRadius.circular(18.r),
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 45.sp, color: Colors.white),
                      SizedBox(height: 12.h),
                      Text(
                        category,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 17.sp, // Slightly larger font
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 2.0,
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
