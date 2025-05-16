import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ClasesPage extends StatefulWidget {
  const ClasesPage({super.key});

  @override
  _ClasesPageState createState() => _ClasesPageState();
}

class _ClasesPageState extends State<ClasesPage> {
  late VideoPlayerController _controller;

  final List<Map<String, dynamic>> juegos = const [
    {
      'title': 'Doom Dark Ages',
      'videoUrl': 'assets/videos/doom_video.mp4',
      'color': Color(0xFF8E44AD),
      'categoria': 'Acción',
    },
    {
      'title': 'Grand Theft Auto VI',
      'videoUrl': 'assets/videos/auto_video.mp4',
      'color': Color(0xFF9B59B6),
      'categoria': 'Aventura',
    },
    {
      'title': 'The Last Ronin',
      'videoUrl': 'assets/videos/Ronin_video.mp4',
      'color': Color(0xFF6C3483),
      'categoria': 'Historia',
    },
    {
      'title': 'Red Dead Redemption 2',
      'videoUrl': 'assets/videos/red_dead_video.mp4',
      'color': Color(0xFF7D3C98),
      'categoria': 'Aventura',
    },
    {
      'title': 'Call of Duty',
      'videoUrl': 'assets/videos/cod_video.mp4',
      'color': Color(0xFF512E5F),
      'categoria': 'Shooter',
    },
    {
      'title': 'Black Myth - Wukong',
      'videoUrl': 'assets/videos/black_video.mp4',
      'color': Color(0xFFAF7AC5),
      'categoria': 'Fantasía',
    },
  ];

  String? categoriaSeleccionada;
  final Map<int, bool> _hovering = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playVideo(String videoUrl, String title, Color color) {
    _controller = VideoPlayerController.asset(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                title,
                style: TextStyle(color: color),
              ),
              content: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: VideoPlayer(_controller),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _controller.pause();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ['Todos', 'Acción', 'Aventura', 'Shooter', 'Historia', 'Fantasía'];

    final juegosFiltrados = (categoriaSeleccionada == null || categoriaSeleccionada == 'Todos')
        ? juegos
        : juegos.where((j) => j['categoria'] == categoriaSeleccionada).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos de Juegos'),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF3E5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.videogame_asset, color: Colors.deepPurple, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Explora los mejores trailers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categorias.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = categorias[index];
                    final bool seleccionado = cat == categoriaSeleccionada || (categoriaSeleccionada == null && cat == 'Todos');
                    return ActionChip(
                      backgroundColor: seleccionado
                          ? Colors.deepPurple
                          : Colors.deepPurple.shade100,
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: seleccionado ? Colors.white : Colors.deepPurple,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          categoriaSeleccionada = cat == 'Todos' ? null : cat;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: juegosFiltrados.length,
                  itemBuilder: (context, index) {
                    final juego = juegosFiltrados[index];
                    final isHovering = _hovering[index] ?? false;

                    return MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _hovering[index] = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _hovering[index] = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        transform: isHovering
                            ? (Matrix4.identity()..scale(1.05))
                            : Matrix4.identity(),
                        decoration: BoxDecoration(
                          boxShadow: isHovering
                              ? [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  )
                                ]
                              : [],
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              juego['color'].withOpacity(0.15),
                              juego['color'].withOpacity(0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Card(
                          elevation: 0,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SizedBox(
                            width: 120,
                            height: 140,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                _playVideo(
                                    juego['videoUrl'], juego['title'], juego['color']);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.play_circle_fill_rounded,
                                      color: juego['color'],
                                      size: 50, // Tamaño aumentado
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      juego['title'],
                                      style: const TextStyle(
                                        fontSize: 14, // Tamaño aumentado
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
