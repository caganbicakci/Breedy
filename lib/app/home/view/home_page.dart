import 'package:breedy/app/bloc/app_bloc.dart';
import 'package:breedy/app/home/bloc/home_bloc.dart';
import 'package:breedy/app/home/widgets/custom_card_view.dart';
import 'package:breedy/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

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
      appBar: buildAppBar(l10n),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildFloatingActionButton(context),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is BreedsLoaded) {
            Logger().i(state);
            return buildGridView(state);
          } else if (state is BreedsLoadError) {
            Logger().e("Error");
            return Container(
              child: Text('Error!!'),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  AppBar buildAppBar(AppLocalizations l10n) {
    return AppBar(
      title: Text(l10n.appName),
      centerTitle: true,
    );
  }

  GridView buildGridView(BreedsLoaded state) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        crossAxisCount: 2,
      ),
      itemCount: state.breeds!.length,
      itemBuilder: (_, index) {
        return CustomCardView(breed: state.breeds![index]);
      },
    );
  }

  Container buildFloatingActionButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(width: 2, color: Colors.black12),
      ),
      alignment: Alignment.centerLeft,
      height: 55,
      child: TextFormField(
        controller: _searchEditingController,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Search',
          contentPadding: EdgeInsets.all(16),
          hintStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
