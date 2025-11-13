import 'package:flutter/material.dart';
import 'package:livria_user/common/theme/app_colors.dart';
import 'package:livria_user/common/utils/app_icons.dart';
import '../../application/services/community_service.dart';
import '../../domain/entities/community.dart';
import '../../infrastructure/repositories/community_repository_api.dart';
import '../../infrastructure/datasource/community_remote_datasource.dart';
import '../../presentation/widgets/community_card.dart';


class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  final TextEditingController _searchController = TextEditingController();

  final CommunityRemoteDataSource _dataSource = CommunityRemoteDataSource();

  late final CommunityRepositoryApi _repository = CommunityRepositoryApi(dataSource: _dataSource);

  late final CommunityService _communityService = CommunityService(_repository);

  List<Community> _filteredCommunities = [];
  bool _isLoading = true;
  String? _hasError;

  @override
  void initState() {
    super.initState();
    _fetchCommunities();
  }

  Future<void> _fetchCommunities({String query = ''}) async {
    if (_hasError == null || !_isLoading) {
      setState(() {
        _isLoading = true;
        _hasError = null;
      });
    }

    try {
      final results = await _communityService.findCommunities(query);

      setState(() {
        _filteredCommunities = results;
        _isLoading = false;
        _hasError = null;
      });
    } catch (e) {
      print('Error al cargar comunidades: $e');
      setState(() {
        _hasError = 'The communities could not be loaded. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _performSearch(String query) {
    _fetchCommunities(query: query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              _buildHeader(context),

              const SizedBox(height: 20),

              _buildSearchBar(context),

              const SizedBox(height: 24),

              Expanded(
                child: _buildCommunityGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Título "COMMUNITIES"
        Text(
          'COMMUNITIES',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: AppColors.darkBlue,
            fontSize: 30,
          ),
        ),

        // Botón "CREATE +" estilizado
        OutlinedButton.icon(
          onPressed: () {
            print('Navegar a la pantalla de Creación de Comunidad');
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            side: const BorderSide(color: AppColors.primaryOrange, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.white,
          ),
          icon: const Icon(
            AppIcons.post,
            size: 16,
            color: AppColors.primaryOrange,
          ),
          label: Text(
            'CREATE +',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 14,
              color: AppColors.primaryOrange,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    const double containerBorderRadius = 10.0;
    const double borderThickness = 1.5;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(containerBorderRadius),
        border: Border.all(color: AppColors.accentGold, width: borderThickness),
      ),
      child: Row(
        children: [
          // Campo de texto de búsqueda
          Expanded(
            child: TextField(
              controller: _searchController,
              onSubmitted: _performSearch,
              textInputAction: TextInputAction.search,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Enter a title to search',
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.accentGold,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),

          // Separador visual de 1.5px (el grosor del borde)
          Container(width: borderThickness, color: AppColors.accentGold),

          // Botón de búsqueda (Ícono de lupa)
          GestureDetector(
            onTap: () => _performSearch(_searchController.text),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(containerBorderRadius),
                bottomRight: Radius.circular(containerBorderRadius),
              ),
              child: Container(
                width: 50,
                height: 50 - (borderThickness * 2),
                color: AppColors.primaryOrange,
                child: const Icon(
                  AppIcons.search,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityGrid() {
    // 1. Estado de Carga (Muestra un indicador de progreso)
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange));
    }

    // 2. Estado de Error (Muestra mensaje y botón de reintento)
    if (_hasError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_hasError!, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.errorRed)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchCommunities, // Intentar recargar
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryOrange),
              child: const Text('Retry', style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      );
    }

    // 3. Resultados Vacíos (No hay comunidades o la búsqueda no encontró nada)
    if (_filteredCommunities.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isEmpty
              ? 'No available.'
              : 'No matches for "${_searchController.text}"',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    // 4. Grid View de 3 columnas (Datos cargados)
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredCommunities.length,
      itemBuilder: (context, index) {
        // Usa la entidad Community
        return CommunityCard(
          community: _filteredCommunities[index],
        );
      },
    );
  }
}