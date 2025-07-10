import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/core/utils/session_manager.dart';
import 'package:flutter_app/features/recruiter/services/chat_header.dart';
import 'package:flutter_app/features/shared/services/mensajes_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final logger = Logger();

enum ConnectionStatus { connecting, connected, disconnected, error }

enum MessageStatus { sending, sent, error }

class ChatReclutadorScreen extends StatefulWidget {
  final String studentId;
  final String jobId;
  final String studentName;
  final String? studentAvatar;
  final String chatId;

  const ChatReclutadorScreen(
      {required this.studentId,
      required this.jobId,
      required this.studentName,
      required this.chatId,
      this.studentAvatar,
      super.key});

  @override
  State<ChatReclutadorScreen> createState() => _ChatReclutadorScreenState();
}

class _ChatReclutadorScreenState extends State<ChatReclutadorScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];
  Map<String, dynamic> user = {};

  bool isLoading = true;
  bool isSending = false;
  bool isReconnecting = false;
  int reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;

  late IO.Socket socket;
  bool socketInitialized = false;
  ConnectionStatus connectionStatus = ConnectionStatus.disconnected;

  String event = 'recruiter-message';
  String chatId = '';
  Timer? reconnectTimer;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      setState(() {
        isLoading = true;
        connectionStatus = ConnectionStatus.connecting;
      });

      // Obtener información del usuario actual
      final userData = await SessionManager().getUser();
      if (!mounted) return;

      setState(() {
        user = userData;
        chatId = widget.chatId;
      });

      // Inicializar socket después de tener la información necesaria
      await _initializeSocket();

      // Cargar mensajes históricos
      await _fetchMensajes();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      logger.e('Error al inicializar el chat: $e');
      if (!mounted) return;
      setState(() {
        connectionStatus = ConnectionStatus.error;
        isLoading = false;
      });
      _showErrorSnackBar('Error al cargar el chat');
    }
  }

  Future<void> _fetchMensajes() async {
    try {
      final fetchedMensajes =
          await MensajesServices.getMensajes(int.parse(chatId));
      if (!mounted) return;

      setState(() {
        // Ordenar mensajes por fecha, más antiguos primero
        messages =
                fetchedMensajes /* 
          ..sort((a, b) =>
              DateTime.parse(a['fecha']).compareTo(DateTime.parse(b['fecha']))) */
            ;
      });

      // Scroll al último mensaje
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      logger.e('Error al obtener mensajes: $e');
      if (!mounted) return;
      _showErrorSnackBar('Error al cargar los mensajes');
    }
  }

  Future<void> _initializeSocket() async {
    _disposeSocket(); // Limpiar socket existente si hay

    socket = IO.io(
      '${dotenv.env['API_DOMAIN']}',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'reconnection': true,
        'reconnectionDelay': 1000,
        'reconnectionDelayMax': 5000,
        'reconnectionAttempts': maxReconnectAttempts,
        'query': {
          'from': user['sub'],
          'to': widget.studentId,
          'chat_id': chatId,
          'job_id': widget.jobId,
        },
      },
    );

    socketInitialized = true;
    _setupSocketListeners();

    // Esperar a que se conecte o falle
    try {
      await _waitForConnection();
    } catch (e) {
      logger.e('Error al conectar el socket: $e');
      if (!mounted) return;
      setState(() => connectionStatus = ConnectionStatus.error);
      _showErrorSnackBar('Error al establecer la conexión');
    }
  }

  Future<void> _waitForConnection() {
    return Future.delayed(const Duration(seconds: 5), () {
      if (connectionStatus != ConnectionStatus.connected) {
        throw Exception('Timeout al conectar el socket');
      }
    });
  }

  void _setupSocketListeners() {
    socket.onConnect((_) {
      if (!mounted || !socketInitialized) return;
      setState(() {
        connectionStatus = ConnectionStatus.connected;
        isReconnecting = false;
        reconnectAttempts = 0;
      });
      logger.i('Socket conectado');
    });

    socket.onDisconnect((_) {
      if (!mounted || !socketInitialized) return;
      setState(() {
        connectionStatus = ConnectionStatus.disconnected;
        if (!isReconnecting && reconnectAttempts < maxReconnectAttempts) {
          _handleReconnect();
        }
      });
      logger.w('Socket desconectado');
    });

    socket.onConnectError((error) {
      logger.e('Error de conexión: $error');
      if (!mounted || !socketInitialized) return;
      setState(() {
        connectionStatus = ConnectionStatus.error;
        if (!isReconnecting && reconnectAttempts < maxReconnectAttempts) {
          _handleReconnect();
        }
      });
    });

    socket.on(event, (data) {
      if (!mounted || !socketInitialized) return;
      final receivedMessage = {
        'mensaje': data,
        'fecha': DateTime.now().toIso8601String(),
        'is_me': false,
      };
      setState(() {
        // Agregar al final para reverse: true
        messages.insert(0, receivedMessage);
      });
      _scrollToBottom();
    });

    socket.onError((error) {
      logger.e('Error general del socket: $error');
      if (!mounted || !socketInitialized) return;
      _showErrorSnackBar('Error en la conexión');
    });
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
        'from': user['sub'],
        'to': widget.studentId,
        'chat_id': chatId,
        'job_id': widget.jobId,
        'mensaje': message,
        'fecha': DateTime.now().toIso8601String(),
        'is_me': true,
      };

      setState(() {
        // Agregar al final para reverse: true
        messages.insert(0, newMessage);
        _controller.clear();
      });

      socket.emit(event, newMessage);

      // Simular delay para mostrar el estado de envío
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted || !socketInitialized) return;
      setState(() {
        newMessage['status'] = MessageStatus.sent;
        isSending = false;
      });

      _scrollToBottom();
    } catch (e) {
      logger.e('Error al enviar mensaje: $e');
      if (!mounted || !socketInitialized) return;
      setState(() {
        messages.last['status'] = MessageStatus.error;
        isSending = false;
      });
      _showErrorSnackBar('Error al enviar el mensaje');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && mounted) {
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _disposeSocket() {
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
      logger.e('Error al desconectar el socket: $e');
    }
  }

  @override
  void dispose() {
    reconnectTimer?.cancel();
    _disposeSocket();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted &&
        socketInitialized &&
        connectionStatus == ConnectionStatus.disconnected) {
      _handleReconnect();
    }
  }

  @override
  void deactivate() {
    _disposeSocket();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando chat...'),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: ChatHeader(
          studentAvatar: widget.studentAvatar,
          studentName: widget.studentName,
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
                return Align(
                  alignment: element['is_me']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      color: element['is_me']
                          ? Colors.blue[100]
                          : Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: element['is_me']
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          element['mensaje'] as String,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('HH:mm').format(
                                  DateTime.parse(element['fecha']).toLocal()),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (element['is_me']) ...[
                              const SizedBox(width: 4),
                              _buildMessageStatus(element['status']),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
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

  Widget _buildConnectionStatus() {
    if (connectionStatus == ConnectionStatus.connected && !isReconnecting) {
      return const SizedBox.shrink();
    }

    Color backgroundColor;
    String message;
    Widget? icon;

    switch (connectionStatus) {
      case ConnectionStatus.connecting:
        backgroundColor = Colors.orange;
        message = 'Conectando...';
        icon = const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
        break;
      case ConnectionStatus.disconnected:
        backgroundColor = Colors.red;
        message = isReconnecting
            ? 'Intentando reconectar... (Intento ${reconnectAttempts}/$maxReconnectAttempts)'
            : 'Desconectado';
        icon = isReconnecting
            ? const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.wifi_off, size: 16, color: Colors.white);
        break;
      case ConnectionStatus.error:
        backgroundColor = Colors.red;
        message = 'Error de conexión';
        icon = const Icon(Icons.error_outline, size: 16, color: Colors.white);
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
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
                hintText: connectionStatus == ConnectionStatus.connected
                    ? "Escribe un mensaje..."
                    : "Esperando conexión...",
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
}
