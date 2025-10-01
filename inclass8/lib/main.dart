import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fading Text Animation',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: FadingTextAnimation(),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  bool _isDayMode = true;
  Color _textColor = Colors.black;
  bool _showFrame = false;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void toggleTheme() {
    setState(() {
      _isDayMode = !_isDayMode;
    });
  }

  void changeTextColor(Color color) {
    setState(() {
      _textColor = color;
    });
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _textColor,
              onColorChanged: changeTextColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDayMode ? ThemeData.light() : ThemeData.dark(),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Fading Text Animation'),
            backgroundColor: _isDayMode ? Colors.blue : Colors.deepPurple,
            actions: [
              IconButton(
                icon: Icon(_isDayMode ? Icons.wb_sunny : Icons.nightlight),
                onPressed: toggleTheme,
                tooltip: 'Toggle Day/Night Mode',
              ),
              IconButton(
                icon: const Icon(Icons.palette),
                onPressed: _showColorPicker,
                tooltip: 'Change Text Color',
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.text_fields), text: 'Screen 1'),
                Tab(icon: Icon(Icons.animation), text: 'Screen 2'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Screen 1 - Basic Fading Animation
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: toggleVisibility,
                      child: AnimatedOpacity(
                        opacity: _isVisible ? 1.0 : 0.0,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        child: Text(
                          'Hello, Flutter!',
                          style: TextStyle(
                            fontSize: 24,
                            color: _textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Image with frame toggle
                    Column(
                      children: [
                        Container(
                          decoration: _showFrame
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                )
                              : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(_showFrame ? 16 : 0),
                            child: Image.network(
                              'https://picsum.photos/200/200',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Show Frame'),
                            const SizedBox(width: 10),
                            Switch(
                              value: _showFrame,
                              onChanged: (bool value) {
                                setState(() {
                                  _showFrame = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Screen 2 - Advanced Fading Animation
              SecondScreen(textColor: _textColor),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: toggleVisibility,
            child: const Icon(Icons.play_arrow),
            backgroundColor: _isDayMode ? Colors.blue : Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final Color textColor;

  const SecondScreen({Key? key, required this.textColor}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    // Start animation automatically
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _animation,
            child: Text(
              'Advanced Fade!',
              style: TextStyle(
                fontSize: 28,
                color: widget.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ScaleTransition(
            scale: _animation,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.flutter_dash,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          RotationTransition(
            turns: _animation,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}