import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/services/firestore_service.dart';
import 'package:nileshapp/models/chat_model.dart';
import 'package:nileshapp/models/user_model.dart';
import 'package:nileshapp/Chat/chat_screen.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatRoomModel> _chatRooms = [];
  List<ChatRoomModel> _filteredChatRooms = [];
  Map<String, UserModel> _userCache = {};
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      if (_isSearching) {
        _filteredChatRooms = _chatRooms.where((chatRoom) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final currentUser = authProvider.userModel;
          if (currentUser == null) return false;
          
          final otherParticipantId = chatRoom.participants.firstWhere(
            (id) => id != currentUser.id,
            orElse: () => '',
          );
          
          final otherUser = _userCache[otherParticipantId];
          if (otherUser == null) return false;
          
          return otherUser.name.toLowerCase().contains(query) ||
                 (chatRoom.lastMessage?.toLowerCase().contains(query) ?? false);
        }).toList();
      } else {
        _filteredChatRooms = List.from(_chatRooms);
      }
    });
  }

  Future<void> _loadChatRooms() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.userModel;
      
      if (currentUser == null) return;

      _chatRooms = await FirestoreService.instance.getUserChatRooms(currentUser.id);
      
      // Sort chat rooms by last message time (newest first - WhatsApp style)
      _chatRooms.sort((a, b) {
        if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
        if (a.lastMessageTime == null) return 1;
        if (b.lastMessageTime == null) return -1;
        return b.lastMessageTime!.compareTo(a.lastMessageTime!);
      });
      
      // Load user data for each chat room
      for (final chatRoom in _chatRooms) {
        for (final participantId in chatRoom.participants) {
          if (participantId != currentUser.id && !_userCache.containsKey(participantId)) {
            final user = await FirestoreService.instance.getUser(participantId);
            if (user != null) {
              _userCache[participantId] = user;
            }
          }
        }
      }

      // Initialize filtered list
      _filteredChatRooms = List.from(_chatRooms);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        backgroundColor: kDarkBackground,
        elevation: 0,
        title: _isSearching 
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: TextStyle(color: kTextSecondary),
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : const Text(
                'Messages',
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              if (_isSearching) {
                _searchController.clear();
                setState(() {
                  _isSearching = false;
                });
              } else {
                setState(() {
                  _isSearching = true;
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.6),
                radius: 1.5,
                colors: [
                  Color(0xFF1E1436),
                  kDarkBackground,
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: kPrimaryPurple,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadChatRooms,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredChatRooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              color: kTextSecondary,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              _isSearching ? 'No results found' : 'No conversations yet',
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isSearching 
                  ? 'Try searching with different keywords'
                  : 'Start chatting with freelancers or clients',
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadChatRooms,
      color: kPrimaryPurple,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredChatRooms.length,
        itemBuilder: (context, index) {
          return _buildChatRoomCard(_filteredChatRooms[index]);
        },
      ),
    );
  }

  Widget _buildChatRoomCard(ChatRoomModel chatRoom) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.userModel;
    
    if (currentUser == null) return const SizedBox.shrink();

    // Find the other participant
    final otherParticipantId = chatRoom.participants.firstWhere(
      (id) => id != currentUser.id,
    );
    
    final otherUser = _userCache[otherParticipantId];
    if (otherUser == null) return const SizedBox.shrink();

    final unreadCount = chatRoom.unreadCounts[currentUser.id] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: unreadCount > 0 ? kCardColor.withOpacity(0.8) : kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unreadCount > 0 
              ? kPrimaryPurple.withOpacity(0.4) 
              : kPrimaryPurple.withOpacity(0.1),
          width: unreadCount > 0 ? 1.5 : 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: unreadCount > 0 
                ? kPrimaryPurple.withOpacity(0.2)
                : kPrimaryPurple.withOpacity(0.05),
            blurRadius: unreadCount > 0 ? 15 : 8,
            spreadRadius: unreadCount > 0 ? 2 : 1,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: kAccentTeal,
              backgroundImage: otherUser.profileImageUrl != null
                  ? NetworkImage(otherUser.profileImageUrl!)
                  : null,
              child: otherUser.profileImageUrl == null
                  ? Text(
                      otherUser.name.isNotEmpty ? otherUser.name[0].toUpperCase() : 'U',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    )
                  : null,
            ),
            if (unreadCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: kAccentPink,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          otherUser.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              chatRoom.lastMessage ?? 'No messages yet',
              style: TextStyle(
                color: unreadCount > 0 ? Colors.white.withOpacity(0.9) : kTextSecondary,
                fontSize: 14,
                fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (chatRoom.lastMessageTime != null) ...[
                  Text(
                    _formatTime(chatRoom.lastMessageTime!),
                    style: TextStyle(
                      color: unreadCount > 0 
                          ? kAccentTeal 
                          : kTextSecondary.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: otherUser.role == UserRole.freelancer 
                        ? kAccentTeal.withOpacity(0.2)
                        : kPrimaryPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    otherUser.role == UserRole.freelancer ? 'Freelancer' : 'Client',
                    style: TextStyle(
                      color: otherUser.role == UserRole.freelancer 
                          ? kAccentTeal
                          : kPrimaryPurple,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                otherUserId: otherUser.id,
                otherUserName: otherUser.name,
                otherUserImageUrl: otherUser.profileImageUrl,
              ),
            ),
          ).then((_) {
            // Refresh chat rooms when returning
            _loadChatRooms();
          });
        },
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    // WhatsApp-style time formatting
    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
