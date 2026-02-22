import 'package:flutter/material.dart';
import 'package:jbre_app/features/shared/shared.dart';

class PlantsScreen extends StatelessWidget {
  const PlantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Plants'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      body: const _PlantsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo planta'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _PlantsView extends StatelessWidget {
  const _PlantsView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Eres genial!'));
  }
}
