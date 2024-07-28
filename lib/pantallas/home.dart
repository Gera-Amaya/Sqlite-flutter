import 'package:flutter/material.dart';
import '../db/database.dart';
import '../planetas/planetas.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Planetas>? planetario;

  @override
  void initState() {
    super.initState();
    abrirDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema Solar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddPlanetaDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (planetario == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueGrey,
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: planetario!.length,
                    itemBuilder: (context, index) {
                      final planeta = planetario![index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.blur_circular_rounded),
                          title: Text("Nombre: ${planeta.nombre}"),
                          subtitle: Text("Distancia al Sol: ${planeta.distanciaSol} km\nRadio: ${planeta.radio} km"),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditPlanetaDialog(planeta);
                            },
                          ),
                          onLongPress: () {
                            _showDeleteConfirmDialog(planeta.id!);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Mantén presionado el planeta para eliminar.',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void abrirDB() async {
    await query();
  }

  Future<void> agregar(Planetas planeta) async {
    await DB.insertar(planeta);
    await query();
  }

  Future<void> query() async {
    planetario = await DB.consulta();
    setState(() {});
  }

  Future<void> actualizar(Planetas planeta) async {
    await DB.actualizar(planeta);
    await query();
  }

  Future<void> borrar(int id) async {
    await DB.borrar(id);
    await query();
  }

  void _showAddPlanetaDialog() {
    final nombreController = TextEditingController();
    final distanciaSolController = TextEditingController();
    final radioController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Planeta'),
          content: Column(
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: distanciaSolController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Distancia al Sol'),
              ),
              TextField(
                controller: radioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Radio'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final planeta = Planetas(
                  null,
                  nombreController.text,
                  double.tryParse(distanciaSolController.text) ?? 0,
                  double.tryParse(radioController.text) ?? 0,
                );
                agregar(planeta);
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditPlanetaDialog(Planetas planeta) {
    final nombreController = TextEditingController(text: planeta.nombre);
    final distanciaSolController = TextEditingController(text: planeta.distanciaSol.toString());
    final radioController = TextEditingController(text: planeta.radio.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Planeta'),
          content: Column(
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: distanciaSolController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Distancia al Sol'),
              ),
              TextField(
                controller: radioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Radio'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedPlaneta = Planetas(
                  planeta.id,
                  nombreController.text,
                  double.tryParse(distanciaSolController.text) ?? 0,
                  double.tryParse(radioController.text) ?? 0,
                );
                actualizar(updatedPlaneta);
                Navigator.of(context).pop();
              },
              child: const Text('Actualizar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Planeta'),
          content: Text(
            '¿Estás seguro de que quieres eliminar este planeta?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                borrar(id);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
