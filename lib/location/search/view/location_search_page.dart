import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/location/search/bloc/location_search_bloc.dart';

import 'package:ones_blog/location/search/location_search.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/location_category.dart';
import 'package:ones_blog/utils/size_handler.dart';

class LocationSearchPage extends StatelessWidget {
  const LocationSearchPage({
    super.key,
  });

  static Route<PoppedFromPageArguments> route(
    LocationCategory locationCategory,
  ) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider<LocationSearchBloc>.value(
          value: LocationSearchBloc(
            locationRepository: context.read<LocationRepository>(),
            locationCategory: locationCategory,
          ),
          child: const LocationSearchPage(),
        ),
      );

  @override
  Widget build(BuildContext context) => const LocationSearchView();
}

class LocationSearchView extends StatefulWidget {
  const LocationSearchView({super.key});

  @override
  State createState() => _LocationSearchViewState();
}

class _LocationSearchViewState extends State<LocationSearchView> {
  final TextEditingController _keywordController = TextEditingController();
  late LocationSearchBloc _locationSearchBloc;

  @override
  void initState() {
    super.initState();
    _locationSearchBloc = context.read<LocationSearchBloc>();
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            FixedAppBar(
              homeLeadingIcon: null,
              openMenuIcon: false,
              arguments: PoppedFromPageArguments(
                page: PoppedFromPage.selectLocation,
              ),
            ),
          ],
          body: SingleChildScrollView(
            child: Container(
              color: AppColors.primary,
              width: SizeHandler.screenWidth,
              height: SizeHandler.screenHeight,
              child: Column(
                children: [
                  Container(
                    height: SpaceUnit.quarterBase,
                    width: SizeHandler.screenWidth,
                    color: Colors.white,
                    margin: const EdgeInsets.only(
                      bottom: SpaceUnit.base,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: SpaceUnit.base,
                    ),
                    width: 300,
                    height: SpaceUnit.base * 6,
                    child: TextField(
                      onChanged: (value) => _locationSearchBloc.add(
                        TextChanged(keyword: value),
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(SpaceUnit.base),
                        hintText: l10n.placeholder(
                          _locationSearchBloc.locationCategory
                              .translate(l10n)
                              .toLowerCase(),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: AppColors.muted,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(SpaceUnit.base),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: SpaceUnit.base,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SpaceUnit.doubleBase),
                      color: Colors.white,
                    ),
                    width: 300,
                    height: 500,
                    child: _Content(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSearchBloc, LocationSearchState>(
      builder: (context, state) {
        final l10n = context.l10n;

        if (state is SearchStateLoading) {
          return const Center(
            key: Key('content_loading_indicator'),
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (state is SearchStateError) {
          return Center(
            key: const Key('content_failure_text'),
            child: Text(l10n.listFetchErrorMessage),
          );
        } else if (state is SearchStateSuccess) {
          return _SearchResults(items: state.items);
        }

        return Center(child: Text(l10n.listFetchErrorMessage));
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.items});

  final List<Location> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) => _SearchResultItem(
        item: items[index],
      ),
      separatorBuilder: (BuildContext context, int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: SpaceUnit.base),
        height: SpaceUnit.quarterBase,
        color: AppColors.primary,
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem({required this.item});

  final Location item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        item.name,
        style: AppTextStyle.content,
      ),
      subtitle: Text(item.address),
      onTap: () => Navigator.pop(
        context,
        PoppedFromPageArguments(
          page: PoppedFromPage.selectLocation,
          arguments: {
            'locationId': 8, // TODO: change to real location id.
            'locationName': item.name,
          },
        ),
      ),
    );
  }
}
