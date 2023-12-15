import 'package:flutter/material.dart';
import 'package:travelgo/models/models.dart';
import 'package:travelgo/screens/screens.dart';
import 'package:travelgo/services/services.dart';
import 'package:travelgo/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../services/travels_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final travelsService = Provider.of<TravelsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    if (travelsService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
        title: const Text('Viagens'),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: travelsService.travels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            travelsService.selectedtravel =
                travelsService.travels[index].copy();
            Navigator.pushNamed(context, 'travel');
          },
          child: TravelCard(travel: travelsService.travels[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          travelsService.selectedtravel =
              Travel(
                titulo: '', 
                descricao: '', 
                dataInicio: '', 
                dataFim: '',
                localUrl: '',
              );
          Navigator.pushNamed(context, 'travel');
        },
      ),
    );
  }
}
