import 'package:flutter/material.dart';
import 'package:flutter_app/core/constants/constants.dart';
import 'package:flutter_app/core/utils/session_manager.dart';
import 'package:flutter_app/features/shared/services/mensajes_services.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';
import 'package:flutter_app/features/student/screens/chat/chat_estudiante_screen.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ChatEstudianteListScreen extends StatefulWidget {
  const ChatEstudianteListScreen({super.key});

  @override
  State<ChatEstudianteListScreen> createState() =>
      _ChatEstudianteListScreenState();
}

class _ChatEstudianteListScreenState extends State<ChatEstudianteListScreen> {
  List<Map<String, dynamic>> chats = [];
  List<Map<String, dynamic>> filteredChats = [];
  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? user;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Obtener información del usuario actual
      user = await SessionManager().getUser();

      if (user == null) {
        throw Exception('Usuario no encontrado');
      }

      // Obtener chats del reclutador
      // Por ahora usamos valores de ejemplo, pero deberías obtenerlos del contexto
      final userId = user!['sub'];

      final fetchedChats = await MensajesServices.getChats(
        userId: userId.toString(),
        type: 'Estudiante',
      );

      // Enriquecer los chats con información adicional
      for (var chat in fetchedChats) {
        try {
          final messages = await MensajesServices.getMensajes(chat['id']);
          if (messages.isNotEmpty) {
            final lastMessage = messages.last;
            chat['lastMessage'] = lastMessage['mensaje'];
            chat['lastMessageTime'] = lastMessage['fecha'];
            chat['unreadCount'] = messages.where((msg) => !msg['is_me']).length;
          }
        } catch (e) {
          logger
              .w('Error al obtener último mensaje del chat ${chat['id']}: $e');
        }
      }

      if (mounted) {
        setState(() {
          chats = fetchedChats;
          _filterChats();
          isLoading = false;
        });
      }
    } catch (e) {
      logger.e('Error al cargar chats: $e');
      if (mounted) {
        setState(() {
          errorMessage = 'Error al cargar los chats';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshChats() async {
    await _loadChats();
  }

  void _filterChats() {
    setState(() {
      if (searchQuery.isEmpty) {
        filteredChats = List.from(chats);
      } else {
        filteredChats = chats.where((chat) {
          final studentName = chat['student']['name']?.toLowerCase() ?? '';
          final jobTitle =
              chat['job_id']; /* ']['title']?.toLowerCase() ?? ''; */
          final lastMessage = chat['lastMessage']?.toLowerCase() ?? '';
          final query = searchQuery.toLowerCase();

          return studentName.contains(query) ||
              jobTitle.contains(query) ||
              lastMessage.contains(query);
        }).toList();
      }

      // Ordenar por último mensaje más reciente
      filteredChats.sort((a, b) {
        final timeA = a['lastMessageTime'] as String?;
        final timeB = b['lastMessageTime'] as String?;

        if (timeA == null && timeB == null) return 0;
        if (timeA == null) return 1;
        if (timeB == null) return -1;

        return DateTime.parse(timeB).compareTo(DateTime.parse(timeA));
      });
    });
  }

  void _onSearchChanged(String query) {
    searchQuery = query;
    _filterChats();
  }

  void _navigateToChat(Map<String, dynamic> chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatEstudianteScreen(
          recruiterId: chat['recruiter']['id'].toString(),
          jobId: chat['job_id'].toString() /* ']['id'].toString() */,
          recruiterName:
              '${chat['recruiter']['first_name']} ${chat['recruiter']['last_name']}',
          recruiterAvatar: chat['recruiter']['photo'],
          chatId: chat['id'].toString(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: const Header(isHome: true),
      ),
      body: Column(
        children: [
          // Título de la sección
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Mis Conversaciones',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Barra de búsqueda
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Buscar conversaciones...',
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.primary),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  color: AppColors.primary),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Indicador de cantidad de chats
          if (!isLoading && chats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                searchQuery.isEmpty
                    ? '${chats.length} conversación${chats.length == 1 ? '' : 'es'}'
                    : '${filteredChats.length} de ${chats.length} conversaciones',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Contenido principal
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "chatListRefresh",
        onPressed: _refreshChats,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando conversaciones...',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshChats,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes conversaciones aún',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Las conversaciones aparecerán aquí cuando los\nestudiantes se contacten contigo',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (filteredChats.isEmpty && searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron conversaciones',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta con otros términos de búsqueda',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshChats,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredChats.length,
        itemBuilder: (context, index) {
          final chat = filteredChats[index];
          return _buildChatItem(chat);
        },
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    final recruiter = chat['recruiter'];
    final job = chat['job_id'];
    final lastMessage = chat['lastMessage'] as String?;
    final lastMessageTime = chat['lastMessageTime'] as String?;
    final unreadCount = chat['unreadCount'] as int? ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToChat(chat),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar del estudiante con indicador de estado
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.secondary,
                    backgroundImage: recruiter?['photo'] != null
                        ? NetworkImage(recruiter['photo'])
                        : null,
                    child: recruiter?['photo'] == null
                        ? Icon(
                            Icons.person,
                            size: 30,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                  // Indicador de estado en línea
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // Información del chat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila superior: nombre y hora
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nombre del estudiante
                        Expanded(
                          child: Text(
                            '${recruiter['first_name']} ${recruiter['last_name']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Hora del último mensaje
                        if (lastMessageTime != null)
                          Text(
                            _formatTime(lastMessageTime),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Información del trabajo
                    Text(
                      job.toString() /* ['title'] ?? 'Oferta de trabajo' */,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Último mensaje o estado
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage ?? 'No hay mensajes aún',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontStyle: lastMessage == null
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),

                        // Contador de mensajes no leídos
                        if (unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Flecha indicadora
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (messageDate == today) {
        // Hoy: mostrar solo la hora
        return DateFormat('HH:mm').format(dateTime);
      } else if (messageDate == today.subtract(const Duration(days: 1))) {
        // Ayer
        return 'Ayer';
      } else if (now.difference(messageDate).inDays < 7) {
        // Esta semana: mostrar día de la semana
        return DateFormat('EEE').format(dateTime);
      } else {
        // Más de una semana: mostrar fecha
        return DateFormat('dd/MM').format(dateTime);
      }
    } catch (e) {
      return '';
    }
  }
}
