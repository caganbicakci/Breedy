import 'package:breedy/app/bloc/app_bloc.dart';
import 'package:breedy/app/constants/theme_constants.dart';
import 'package:breedy/app/home/bloc/home_bloc.dart';
import 'package:breedy/app/home/widgets/breed_card_view.dart';
import 'package:breedy/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final _searchEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildFloatingActionButton(context, l10n),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          switch (state) {
            case BreedsLoaded():
              return buildGridView(state);
            case BreedsLoadError():
              return Center(child: Text(l10n.errorMessage));
            default:
              return Container();
          }
        },
      ),
    );
  }

  GridView buildGridView(BreedsLoaded state) {
    return GridView.builder(
      padding: kDefaultPadding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: kGridSpacing,
        crossAxisSpacing: kGridSpacing,
        crossAxisCount: kGridAxisCount,
      ),
      itemCount: state.breeds!.length,
      itemBuilder: (_, index) {
        return BreedDetailView(breed: state.breeds![index]);
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
            onTap: () => showSearchDialog(context, state),
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
      builder: (context) => GestureDetector(
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
                    buildSearchField(context),
                  ],
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildSearchField(context),
                  ],
                );
              }
            },
          ),
        ),
      ),
    ).whenComplete(() {
      FocusManager.instance.primaryFocus!.unfocus();
      context.read<HomeBloc>().add(SwipeDialogDown());
    });
  }

  TextFormField buildSearchField(BuildContext context) {
    return TextFormField(
      maxLines: 5,
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
}
