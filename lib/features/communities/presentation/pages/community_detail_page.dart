import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livria_user/common/theme/app_colors.dart';
import 'package:livria_user/features/communities/infrastructure/datasource/community_remote_datasource.dart';
import '../../../auth/infrastructure/model/user_model.dart';
import '../../domain/entities/community.dart';
import '../../domain/entities/post.dart';
import '../../../auth/infrastructure/datasource/auth_local_datasource.dart';
import '../../../auth/infrastructure/datasource/auth_remote_datasource.dart';
import '../../domain/repositories/community_repository.dart';
import '../../domain/repositories/community_repository_impl.dart';
import '../../infrastructure/datasource/post_remote_datasource.dart';
import '../../domain/repositories/post_repository_impl.dart';
import '../widgets/_community_header.dart';
import '../widgets/_post_form.dart';
import '../widgets/_post_list.dart';

String _getCommunityTypeLabel(int type) {
   switch (type) {
    case 1: return 'LITERATURE';
    case 2: return 'NON-FICTION';
    case 3: return 'FICTION';
    case 4: return 'MANGAS & COMICS';
    case 5: return 'JUVENILE';
    case 6: return 'CHILDREN';
    case 7: return 'EBOOKS & AUDIOBOOKS';
    default: return 'GENERAL';
   }
}

class CommunityDetailPage extends StatefulWidget {
   final Community community;
   final AuthLocalDataSource authLocalDataSource;
   final AuthRemoteDataSource authRemoteDataSource;
   final PostRemoteDataSource postRemoteDataSource;
   final CommunityRemoteDataSource communityRemoteDataSource;

   const CommunityDetailPage({
    super.key,
    required this.community,
    required this.authLocalDataSource,
    required this.authRemoteDataSource,
    required this.postRemoteDataSource,
    required this.communityRemoteDataSource,
   });
   @override
   State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
   String? _username;
   String? _userIconUrl;
   bool _isUserLoading = true;
   final TextEditingController _contentController = TextEditingController();
   bool _isPosting = false;
   File? _selectedImageFile;
   final ImagePicker _picker = ImagePicker();
   List<Post> _posts = [];
   bool _isLoadingPosts = true;
   late final PostRepositoryImpl _postRepository;

   late final CommunityRepository _communityRepository;
   int? _currentUserId;
   bool _isJoined = false;
   bool _isTogglingJoin = false;

   @override
   void initState() {
    super.initState();
    _communityRepository = CommunityRepositoryImpl(widget.communityRemoteDataSource);
    _postRepository = PostRepositoryImpl(widget.postRemoteDataSource);
    _loadUserProfile();
    _fetchPosts();
    _checkUserJoinedStatus();
   }
   @override
   void dispose() {
    _contentController.dispose();
    super.dispose();
   }
   Future<void> _handleGalleryPick() async {
    try {
     final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
     );
     if (pickedFile != null) {
      if (mounted) {
       setState(() {
        _selectedImageFile = File(pickedFile.path);
       });
       _showSnackbar('Image selected: ${pickedFile.name}', color: AppColors.softTeal);
      }
     } else {
      _showSnackbar('No image selected.', color: AppColors.secondaryYellow);
     }
    } catch (e) {
     print('Error al seleccionar imagen: $e');
     _showSnackbar('Failed to access gallery.', color: Colors.red);
    }
   }
   Future<void> _removeSelectedImage() async {
    if (mounted) {
     setState(() {
      _selectedImageFile = null;
     });
    }
    _showSnackbar('Image removed.', color: AppColors.softTeal);
   }
   Future<void> _fetchPosts() async {
    if (mounted) {
     setState(() {
      _isLoadingPosts = true;
     });
    }
    try {
     final fetchedPosts = await _postRepository.fetchPostsByCommunityId(widget.community.id, 0, 20);
     if (mounted) {
      setState(() {
       _posts = fetchedPosts;
       _isLoadingPosts = false;
      });
     }
    } catch (e) {
     print('Error al cargar posts: $e');
     if (mounted) {
      setState(() {
       _isLoadingPosts = false;
      });
     }
     _showSnackbar('Failed to load posts: $e', color: Colors.red);
    }
   }

   Future<void> _loadUserProfile() async {
    try {
     final userId = await widget.authLocalDataSource.getUserId();
     final token = await widget.authLocalDataSource.getToken();
     if (userId != null && token != null) {
      final UserModel user = await widget.authRemoteDataSource.getUserProfile(userId, token);
      if (mounted) {
       setState(() {
        _username = user.username;
        _userIconUrl = user.icon;
        _isUserLoading = false;
       });
      }
     } else {
      if (mounted) {
       setState(() {
        _isUserLoading = false;
       });
      }
     }
    } catch (e) {
     print('Error al cargar perfil de usuario: $e');
     if (mounted) {
      setState(() {
       _isUserLoading = false;
      });
     }
     _showSnackbar('The user profile could not be loaded. Please try again.', color: Colors.red);
    }
   }
   Future<void> _handlePostCreation() async {
    final content = _contentController.text.trim();
    if (_username == null) {
     _showSnackbar('Error: The username could not be retrieved. Please try logging in again.', color: Colors.red);
     return;
    }
    if (content.isEmpty && _selectedImageFile == null) {
     _showSnackbar('The post cannot be empty. Enter content or select an image.', color: AppColors.secondaryYellow);
     return;
    }
    if (mounted) {
     setState(() {
      _isPosting = true;
     });
    }
    try {
     final String? imageUrlForApi = _selectedImageFile != null
       ? 'LOCAL_FILE_PATH_PLACEHOLDER: ${_selectedImageFile!.path}'
       : null;
     final newPost = await _postRepository.createPost(
      communityId: widget.community.id,
      username: _username!,
      content: content,
      img: imageUrlForApi,
     );
     _contentController.clear();
     _showSnackbar('Post successfully published!', color: AppColors.primaryOrange);
     if (mounted) {
      setState(() {
       _selectedImageFile = null;
       _posts.insert(0, newPost);
      });
     }
    } catch (e) {
     _showSnackbar('Error publishing post: ${e.toString()}', color: Colors.red);
     print('Excepción al crear post: $e');
    } finally {
     if (mounted) {
      setState(() {
       _isPosting = false;
      });
     }
    }
   }
   void _showSnackbar(String message, {required Color color}) {
    String cleanMessage = message.replaceFirst('Exception: ', '');
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
      content: Text(cleanMessage),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
     ),
    );
   }

   void _handleJoinPressed() async {
    if (_currentUserId == null) {
     _showSnackbar('User ID not available. Please try logging in again.', color: Colors.red);
     return;
    }
    if (_isTogglingJoin) return;

    setState(() {
     _isTogglingJoin = true;
    });

    try {
     if (_isJoined) {
      // Lógica de LEAVE
      await _communityRepository.leaveCommunity(
       userClientId: _currentUserId!,
       communityId: widget.community.id,
      );
      if (mounted) {
       setState(() {
        _isJoined = false;
       });
       _showSnackbar('You have left the community ${widget.community.name}.',
           color: AppColors.secondaryYellow);
      }
     } else {
      // Lógica de JOIN
      await _communityRepository.joinCommunity(
       userClientId: _currentUserId!,
       communityId: widget.community.id,
      );
      if (mounted) {
       setState(() {
        _isJoined = true;
       });
       _showSnackbar('You have successfully joined the community ${widget.community.name}!',
           color: AppColors.primaryOrange);
      }
     }
    } catch (e) {
     _showSnackbar('Operation failed: ${e.toString()}', color: Colors.red);
    } finally {
     if (mounted) {
      setState(() {
       _isTogglingJoin = false;
      });
     }
    }
   }

   @override
   Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: AppColors.white,
     appBar: AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: Text(widget.community.name, style: const TextStyle(color: AppColors.darkBlue)),
      iconTheme: const IconThemeData(color: AppColors.darkBlue),
     ),
     body: SingleChildScrollView(
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        CommunityHeader(
         community: widget.community,
         getCommunityTypeLabel: _getCommunityTypeLabel,
         onJoinPressed: _isTogglingJoin ? () {} : _handleJoinPressed,
  isJoined: _isJoined,
        ),
        const SizedBox(height: 16),
        PostForm(
         isUserLoading: _isUserLoading,
         username: _username,
         isPosting: _isPosting,
         contentController: _contentController,
         selectedImageFile: _selectedImageFile,
         onGalleryPick: _handleGalleryPick,
         onRemoveImage: _removeSelectedImage,
         onPost: _handlePostCreation,
         onCameraPressed: () => _showSnackbar('Camera not implemented.', color: AppColors.softTeal),
         showSnackbar: _showSnackbar,
        ),
        const SizedBox(height: 24),
        Padding(
         padding: const EdgeInsets.symmetric(horizontal: 16.0),
         child: Text(
          'Recent Posts',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
           color: AppColors.darkBlue,
           fontWeight: FontWeight.bold,
          ),
         ),
        ),
        const SizedBox(height: 12),
        PostList(
         isLoadingPosts: _isLoadingPosts,
         posts: _posts,
         currentUsername: _username,
         currentUserIconUrl: _userIconUrl,
        ),
       ],
      ),
     ),
    );
   }

   Future<void> _checkUserJoinedStatus() async {
    if (_currentUserId == null) {
     await _loadUserProfile();
    }

    if (_currentUserId == null) return;

    try {
     final isMember = await _communityRepository.checkUserJoined(
      userId: _currentUserId!,
      communityId: widget.community.id,
     );
     if (mounted) {
      setState(() {
       _isJoined = isMember;
      });
     }
    } catch (e) {
     print('Error al verificar unión a comunidad: $e');
     _showSnackbar('Failed to check membership status: $e', color: Colors.red);
    }
   }
}