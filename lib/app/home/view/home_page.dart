import 'package:breedy/app/bloc/app_bloc.dart';
import 'package:breedy/app/constants/theme_constants.dart';
import 'package:breedy/app/home/bloc/home_bloc.dart';
import 'package:breedy/app/home/widgets/breed_card_view.dart';
import 'package:breedy/domain/models/breed.dart';
import 'package:breedy/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => const HomeView();
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchEditingController = TextEditingController();
  final _scaffoldKey = GlobalKey();
  // late NavigatorState navigator;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildFloatingActionButton(context, l10n),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          switch (state) {
            case BreedsLoaded():
              return buildGridView(state.breeds!);
            case BreedsLoadError():
              return Center(child: Text(l10n.errorMessage));
            default:
              return Container();
          }
        },
      ),
    );
  }

  BlocBuilder<HomeBloc, HomeState> buildGridView(List<Breed> breedList) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is BreedSearchSubmitted) {
          return buildBreedGreedView(state.breedSearchResult);
        }
        if (state is BreedSearchNotFound) {
          return buildBreedNotFoundView();
        } else {
          return buildBreedGreedView(breedList);
        }
      },
    );
  }

  GridView buildBreedGreedView(List<Breed> breedList) {
    return GridView.builder(
      padding: kDefaultPadding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: kGridSpacing,
        crossAxisSpacing: kGridSpacing,
        crossAxisCount: kGridAxisCount,
      ),
      itemCount: breedList.length,
      itemBuilder: (_, index) {
        return BreedDetailView(breed: breedList[index]);
      },
    );
  }

  Container buildFloatingActionButton(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Container(
      margin: kHorizontalMargin,
      decoration: BoxDecoration(
        borderRadius: kPrimaryBorderRadiusAll,
        color: Colors.white,
        border: Border.all(
          width: kSearchBarBorderWidth,
          color: kSearchBarBorderColor,
        ),
      ),
      alignment: Alignment.centerLeft,
      height: kSearchBarHeight,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return TextFormField(
            canRequestFocus: false,
            controller: _searchEditingController,
            onTap: () => showSearchDialog(_scaffoldKey.currentContext!, state),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: context.l10n.search,
              contentPadding: kDefaultPadding,
              hintStyle: const TextStyle(
                color: kTextColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> showSearchDialog(BuildContext context, HomeState state) {
    return showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: kBorderRadiusTopCorners,
      ),
      backgroundColor: kBackgroundColor,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      context: context,
      builder: (context) => Builder(
        builder: (dialogContext) {
          return GestureDetector(
            onVerticalDragUpdate: (dragDetail) {
              final dragDistance = dragDetail.primaryDelta ?? 0;
              if (dragDistance < 0) {
                context.read<HomeBloc>().add(SwipeDialogUp());
              } else {
                context.read<HomeBloc>().add(SwipeDialogDown());
              }
            },
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is SearchDialogLarge) {
                    return Column(
                      children: [
                        buildSearchField(dialogContext),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildSearchField(dialogContext),
                        const SizedBox(height: kDefaultSizedBoxHeight),
                      ],
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    ).whenComplete(() {
      FocusManager.instance.primaryFocus!.unfocus();
      context.read<HomeBloc>().add(SwipeDialogDown());
      context
          .read<HomeBloc>()
          .add(BreedSearchEvent(_searchEditingController.text));
    });
  }

  TextFormField buildSearchField(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: (_) => Navigator.of(context).pop(),
      autofocus: true,
      controller: _searchEditingController,
      style:
          Theme.of(context).textTheme.bodyMedium!.copyWith(color: kTextColor),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: context.l10n.search,
        contentPadding: kDefaultPadding,
        hintStyle: const TextStyle(
          color: kTextColor,
        ),
      ),
    );
  }

  Center buildBreedNotFoundView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.l10n.noResult,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: kErrorPageItemMargin),
          Text(
            context.l10n.tryAnotherWord,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45,
                ),
          ),
        ],
      ),
    );
  }
}
