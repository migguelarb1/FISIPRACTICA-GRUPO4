import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/core/utils/session_manager.dart';
import 'package:flutter_app/features/shared/services/mensajes_services.dart';
import 'package:flutter_app/features/student/screens/chat/chat_estudiante_screen.dart';
import 'package:flutter_app/features/student/services/chat_services.dart';
import 'package:flutter_app/features/student/widgets/chat_bot_header.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final logger = Logger();

enum ConnectionStatus { connecting, connected, disconnected, error }

enum MessageStatus { sending, sent, error }

class ChatBotScreen extends StatefulWidget {
  final String company;
  final String chatId;
  final String jobId;
  final Map<String, dynamic> recruiter;

  const ChatBotScreen({
    required this.company,
    required this.chatId,
    required this.jobId,
    required this.recruiter,
    super.key,
  });

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chatOptions = [
    {
      'id': '1',
      'text': '¿Cuál es el proceso de selección?',
      'response': '''El proceso de selección consta de las siguientes etapas:
1. Evaluación de CV
2. Pruebas psicotécnicas
3. Entrevista con RRHH
4. Entrevista técnica
5. Entrevista final''',
    },
    {
      'id': '2',
      'text': '¿Cuáles son los requisitos para postular?',
      'response': '''Los requisitos principales son:
- Ser estudiante universitario de últimos ciclos o egresado
- Promedio ponderado mínimo de 14
- Disponibilidad para realizar prácticas a tiempo completo
- Nivel intermedio de inglés''',
    },
    {
      'id': '3',
      'text': 'Comunicarme con un reclutador',
      'isAction': true,
    },
  ];

  List<Map<String, dynamic>> messages = [];
  String chatId = '';
  String event = 'message';
  Map<String, dynamic> user = {};
  bool isLoading = true;
  bool isSending = false;
  bool isTyping = false;
  late IO.Socket socket;
  bool socketInitialized = false;
  ConnectionStatus connectionStatus = ConnectionStatus.disconnected;
  bool isReconnecting = false;
  int reconnectAttempts = 0;
  Timer? reconnectTimer;
  // Agregar variable para trackear el usuario actual
  String? currentUserId;
  static const int maxReconnectAttempts = 5;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (currentUserId != null) {
      _checkAndReconnectSocket();
    }
  }

  final _sessionManager = SessionManager();
  Future<void> _checkAndReconnectSocket() async {
    try {
      final userData = await _sessionManager.getUser();
      if (!mounted) return;

      // Si el usuario cambió, reinicializar el chat
      if (currentUserId != userData['sub'].toString()) {
        _disconnectSocket();
        setState(() {
          currentUserId = userData['sub'].toString();
          messages = [];
          isLoading = true;
        });
        await _initializeChat();
      }
    } catch (e) {
      logger.e('Error al verificar usuario: $e');
      setState(() => isLoading = false);
      _showErrorSnackBar('Error al verificar el usuario');
    }
  }

  void _disconnectSocket() {
    try {
      if (socketInitialized) {
        // Marcar como no inicializado primero para evitar setState() en listeners
        socketInitialized = false;

        // Remover todos los listeners
        socket.off(event);
        socket.offAny();
        socket.clearListeners();

        if (socket.connected) {
          socket.disconnect();
        }
        socket.dispose();
      }
    } catch (e) {
      logger.e('Error al desconectar socket: $e');
    }
  }

  Future<void> _initializeChat() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      connectionStatus = ConnectionStatus.connecting;
    });

    try {
      // Obtener información del usuario
      final userData = await _sessionManager.getUser();
      if (!mounted) return;
      setState(() {
        user = userData;
        chatId = widget.chatId;
      });
      // Inicializar socket
      await _initializeSocket();
      // Cargar mensajes históricos
      await _fetchMensajes();
      setState(() {
        currentUserId = userData['sub'].toString();
        user = userData;
        messages.add({
          'mensaje': '''¡Hola! Soy el asistente virtual de FISIPRACTICA 👋

Estoy aquí para ayudarte con información sobre el proceso de selección en ${widget.company}. 

¿En qué puedo ayudarte hoy?''',
          'fecha': DateTime.now().toIso8601String(),
          'is_me': false,
          'showOptions': true,
        });
      });
    } catch (e) {
      logger.e('Error al inicializar el chat: $e');
      if (mounted) {
        _showErrorSnackBar('Error al cargar el chat');
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _fetchMensajes() async {
    if (!mounted) return;

    try {
      final fetchedMensajes =
          await MensajesServices.getMensajes(int.parse(chatId));

      if (!mounted) return;

      setState(() {
        // Ordenar mensajes por fecha, más antiguos primero
        /* final sortedMessages =
            fetchedMensajes; /* 
          ..sort((a, b) =>
              DateTime.parse(a['fecha']).compareTo(DateTime.parse(b['fecha']))); */

        // Filtrar mensajes duplicados y mantener orden cronológico
        messages = [
          ...sortedMessages.where((msg) => !messages.any((existingMsg) =>
              existingMsg['id']?.toString() == msg['id']?.toString())),
          messages.first, */
        messages =
            fetchedMensajes; // Mensaje de bienvenida al final para reverse: true
        //];
      });

      // Scroll al último mensaje
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      logger.e('Error al obtener mensajes: $e');
      if (mounted) {
        _showErrorSnackBar('Error al cargar los mensajes');
      }
    }
  }

  Future<void> _initializeSocket() async {
    try {
      setState(() => connectionStatus = ConnectionStatus.connecting);

      socket = IO.io(
        '${dotenv.env['API_DOMAIN']}',
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': true,
          'query': {
            'from': currentUserId,
            'chat_id': chatId,
            'job_id': widget.jobId,
            'company': widget.company,
          },
          'forceNew': true,
        },
      );

      socketInitialized = true;
      _setupSocketListeners();
    } catch (e) {
      logger.e('Error al inicializar socket: $e');
      if (mounted) {
        setState(() => connectionStatus = ConnectionStatus.error);
        _showErrorSnackBar('Error al inicializar la conexión');
      }
    }
  }

  void _setupSocketListeners() {
    socket.onConnect((_) {
      if (!mounted || !socketInitialized) return;
      setState(() {
        connectionStatus = ConnectionStatus.connected;
        isReconnecting = false;
        reconnectAttempts = 0;
      });
      logger.i('Socket conectado para usuario: $currentUserId');
    });

    socket.onDisconnect((_) {
      if (!mounted || !socketInitialized) return;
      setState(() {
        connectionStatus = ConnectionStatus.disconnected;
        isTyping = false;
        if (!isReconnecting && reconnectAttempts < maxReconnectAttempts) {
          _handleReconnect();
        }
      });
      logger.w('Socket desconectado para usuario: $currentUserId');
    });

    socket.onConnectError((error) {
      logger.e('Error de conexión socket para usuario $currentUserId: $error');
      if (!mounted) return;
      setState(() {
        connectionStatus = ConnectionStatus.error;
        if (!isReconnecting && reconnectAttempts < maxReconnectAttempts) {
          _handleReconnect();
        }
      });
      _showErrorSnackBar('Error de conexión');
    });

    socket.on('typing', (_) {
      if (!mounted) return;
      setState(() => isTyping = true);
    });

    socket.on('stop_typing', (_) {
      if (!mounted) return;
      setState(() => isTyping = false);
    });

    socket.on(event, (data) {
      if (!mounted || !socketInitialized) return;
      setState(() {
        isTyping = false;
        // Agregar al final para reverse: true
        messages.insert(0, {
          'mensaje': data,
          'fecha': DateTime.now().toIso8601String(),
          'is_me': false,
          'showOptions': true,
        });
      });
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    reconnectTimer?.cancel();
    _disconnectSocket();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleReconnect() {
    if (!mounted || !socketInitialized) return;

    setState(() {
      isReconnecting = true;
      reconnectAttempts++;
    });

    reconnectTimer?.cancel();
    reconnectTimer = Timer(const Duration(seconds: 3), () async {
      if (!mounted || !socketInitialized) return;
      if (connectionStatus != ConnectionStatus.connected) {
        await _initializeSocket();
      }
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty || !mounted || !socketInitialized) return;

    setState(() => isSending = true);

    try {
      final newMessage = {
        'from': currentUserId,
        'chat_id': chatId,
        'job_id': widget.jobId,
        'company': widget.company,
        'mensaje': message,
        'fecha': DateTime.now().toIso8601String(),
        'is_me': true,
      };

      final messageWithStatus = Map<String, dynamic>.from(newMessage)
        ..['status'] = MessageStatus.sending;

      setState(() {
        // Agregar al final para reverse: true
        messages.insert(0, messageWithStatus);
        _controller.clear();
        isTyping = true;
      });

      socket.emit('message', newMessage);

      if (!mounted || !socketInitialized) return;
      setState(() {
        messageWithStatus['status'] = MessageStatus.sent;
        isSending = false;
      });
      _scrollToBottom();
    } catch (e) {
      logger.e('Error al enviar mensaje: $e');
      if (!mounted || !socketInitialized) return;
      setState(() {
        messages.last['status'] = MessageStatus.error;
        isSending = false;
        isTyping = false;
      });
      _showErrorSnackBar('Error al enviar el mensaje');
    } finally {
      if (mounted) setState(() => isSending = false);
    }
  }

  String _findBotResponse(String message) {
    // Convertir mensaje a minúsculas para mejor comparación
    message = message.toLowerCase();

    // Buscar coincidencias en las opciones predefinidas
    for (var option in _chatOptions) {
      if (message.contains(option['text'].toLowerCase()) &&
          !option['isAction']) {
        return option['response'];
      }
    }

    // Palabras clave específicas
    if (message.contains('requisito') || message.contains('postular')) {
      return _chatOptions[1]['response'];
    }
    if (message.contains('proceso') ||
        message.contains('selección') ||
        message.contains('etapa')) {
      return _chatOptions[0]['response'];
    }
    if (message.contains('reclutador') ||
        message.contains('humanos') ||
        message.contains('rrhh')) {
      return '''¿Deseas hablar con un reclutador? 
Puedes hacer clic en el botón "Comunicarme con un reclutador" que aparece debajo.''';
    }

    // Respuesta por defecto
    return '''Lo siento, no he podido entender tu pregunta. 
¿Podrías reformularla o seleccionar una de las opciones disponibles?''';
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted || !socketInitialized) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _goToChat(BuildContext context) async {
    if (socket.connected) {
      socket.disconnect();
    }
    final userData = await _sessionManager.getUser();
    final chat = await ChatServices().createChat(
        int.parse(userData['sub']),
        int.parse(widget.jobId),
        widget.recruiter['user']['id'] != null
            ? int.parse(widget.recruiter['user']['id'])
            : null);
    if (chat.isEmpty) {
      _showErrorSnackBar('Error al crear el chat');
      return;
    }
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatEstudianteScreen(
          recruiterId: widget.recruiter['user']['id'],
          jobId: widget.jobId,
          recruiterName:
              '${widget.recruiter['user']['first_name']} ${widget.recruiter['user']['last_name']}',
          chatId: chat['id'].toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: ChatBotHeader(
          company: widget.company,
          connectionStatus: connectionStatus,
        ),
      ),
      body: Column(
        children: [
          _buildConnectionStatus(),
          Expanded(
            child: GroupedListView<dynamic, String>(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              reverse: true,
              order: GroupedListOrder.ASC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              elements: messages,
              groupBy: (element) {
                DateTime date = DateTime.parse(element['fecha']).toLocal();
                return "${date.year}/${date.month}/${date.day}";
              },
              groupHeaderBuilder: (element) => SizedBox(
                height: 50,
                child: Center(
                  child: Card(
                    color: Colors.blue[900],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat('d MMM y')
                            .format(DateTime.parse(element['fecha']).toLocal()),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              itemBuilder: (context, element) {
                return Column(
                  children: [
                    _buildMessage(element),
                    if (!element['is_me'] && messages.first == element)
                      _buildOptions(),
                    if (isTyping && messages.first == element)
                      _buildTypingIndicator(),
                  ],
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    if (connectionStatus == ConnectionStatus.connected) {
      return const SizedBox.shrink();
    }

    Color backgroundColor;
    String message;

    switch (connectionStatus) {
      case ConnectionStatus.connecting:
        backgroundColor = Colors.orange;
        message = 'Conectando...';
        break;
      case ConnectionStatus.disconnected:
        backgroundColor = Colors.red;
        message = 'Desconectado - Intentando reconectar...';
        break;
      case ConnectionStatus.error:
        backgroundColor = Colors.red;
        message = 'Error de conexión';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: backgroundColor,
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    return Align(
      alignment:
          message['is_me'] ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: message['is_me'] ? Colors.blue[100] : Colors.green[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: message['is_me']
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message['mensaje'] as String,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm')
                      .format(DateTime.parse(message['fecha']).toLocal()),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (message['is_me']) ...[
                  const SizedBox(width: 4),
                  _buildMessageStatus(message['status']),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageStatus(MessageStatus? status) {
    switch (status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      case MessageStatus.sent:
        return const Icon(
          Icons.check,
          size: 16,
          color: Colors.green,
        );
      case MessageStatus.error:
        return const Icon(
          Icons.error_outline,
          size: 16,
          color: Colors.red,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _chatOptions.map((option) {
          final bool isAction = option['isAction'] ?? false;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ElevatedButton(
              onPressed: isAction
                  ? () => _goToChat(context)
                  : () => _sendMessage(option['text']),
              style: ElevatedButton.styleFrom(
                backgroundColor: isAction ? Colors.blue[900] : Colors.white,
                foregroundColor: isAction ? Colors.white : Colors.black87,
                side: BorderSide(color: Colors.blue[900]!),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                option['text'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Escribe tu pregunta...",
                border: const OutlineInputBorder(),
                enabled: connectionStatus == ConnectionStatus.connected &&
                    !isSending,
              ),
              onSubmitted: (text) {
                if (text.isNotEmpty &&
                    connectionStatus == ConnectionStatus.connected) {
                  _sendMessage(text);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          isSending
              ? const SizedBox(
                  width: 40,
                  height: 40,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: connectionStatus == ConnectionStatus.connected
                      ? () {
                          if (_controller.text.isNotEmpty) {
                            _sendMessage(_controller.text);
                          }
                        }
                      : null,
                ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(1),
            _buildDot(2),
            _buildDot(3),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 * index),
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: Colors.green[300]?.withOpacity(value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
