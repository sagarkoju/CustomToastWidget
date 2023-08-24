import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isBottomSheetVisible = false;
  late AnimationController _animationController =
      AnimationController(vsync: this);
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _heightAnimation = Tween<double>(begin: 0, end: 50).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void _toggleBottomSheet(
    String text,
    double opacity,
    Alignment alignment, {
    bool error = false,
  }) {
    setState(() {
      _isBottomSheetVisible = true;
      if (_isBottomSheetVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    if (_isBottomSheetVisible) {
      _animationController.forward();
      // Show the bottom sheet
      showModalBottomSheet(
        context: navigatorKey.currentState!.overlay!.context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Align(
            alignment: alignment,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    height: _heightAnimation.value,
                    decoration: BoxDecoration(
                      color: error ? Colors.red : Colors.green,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          error ? Icons.error : Icons.check_circle,
                          color: error ? Colors.white : Colors.black,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Opacity(
                            opacity: opacity,
                            child: Text(
                              text,
                              style: TextStyle(
                                  color: error ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
      // Remove the bottom sheet after a delay
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
        _animationController.reverse(); // Close the bottom sheet
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _toggleBottomSheet(
                  "Hello Hello Hello Hello Hello Hello",
                  0.5,
                  Alignment.topCenter,
                  error: true,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.black87,
                ),
                child: const Text(
                  "Custom Toast Top",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                _toggleBottomSheet(
                  "Test Test Test Test ",
                  1,
                  Alignment.center,
                  error: false,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.black87,
                ),
                child: const Text(
                  "Custom Toast Center",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                _toggleBottomSheet(
                  "Custom Test Custom Test",
                  1,
                  Alignment.bottomCenter,
                  error: false,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.black87,
                ),
                child: const Text(
                  "Custom Toast Down",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void showCustomToast(BuildContext context, String message) {
  //   OverlayEntry overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       top: MediaQuery.of(context).size.height * 0.9,
  //       width: MediaQuery.of(context).size.width,
  //       child: SizedBox(
  //         height: 40,
  //         width: double.infinity,
  //         child: Align(
  //           alignment: Alignment.center,
  //           child: HomeScreen(message: message),
  //         ),
  //       ),
  //     ),
  //   );

  //   Overlay.of(context).insert(overlayEntry);

  //   // Remove the toast after a specific duration
  //   Future.delayed(const Duration(seconds: 2), () {
  //     overlayEntry.remove();
  //   });
  // }
}
