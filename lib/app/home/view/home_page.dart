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
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
        borderRadius: kDefaultCircularRadius,
        color: Colors.white,
        border: Border.all(
          width: kSearchBarBorderWidth,
          color: kSearchBarBorderColor,
        ),
      ),
      alignment: Alignment.centerLeft,
      height: kSearchBarHeight,
      child: TextFormField(
        controller: _searchEditingController,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: l10n.search,
          contentPadding: kDefaultPadding,
          hintStyle: const TextStyle(
            color: kTextColor,
          ),
        ),
      ),
    );
  }
}
