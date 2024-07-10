import 'package:appmoviles3/pages/recetas.dart';
import 'package:appmoviles3/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formatofecha=DateFormat('dd-MM-yyyy ');
  final formatohora=DateFormat('HH:mm');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbd2cc),
        centerTitle: true,
        title: Text("Recetas de la abuela"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Categorías de recetas",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirestoreService().categorias(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.separated(
                    separatorBuilder: (_, __) => Divider(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var categoria = snapshot.data!.docs[index];
                    
                      return ListTile(
                        title: Center(
                          child: Text(
                            categoria['nombre'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Column(
                          children: [
                            Image.network(
                              categoria['image'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Calorias promedio: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(' ${categoria['calorias']}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Última modificación:',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(
                                  formatofecha.format(categoria['ultima modificacion'].toDate())),
                                  Text(
                                  'a las: '+formatohora.format(categoria['ultima modificacion'].toDate())+'hrs'),
                                
                              ],
                              
                            ),
                            Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecetasPage(
                                        categoria: categoria['nombre'],
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Ir a recetas de ${categoria['nombre']}',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
