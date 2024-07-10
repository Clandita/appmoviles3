import 'package:appmoviles3/main.dart';
import 'package:appmoviles3/pages/recetas.dart';
import 'package:appmoviles3/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formatofecha=DateFormat('dd-MM-yyyy ');
  final formatohora=DateFormat('HH:mm');
  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
        (Route<dynamic> route) => false, 
      );
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
  Future<void> _confirmSignOut(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cerrar sesión"),
          content: Text("¿Está seguro que desea cerrar sesión?"),
          actions: [
            TextButton(
              child: Text("Volver"),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: Text("Cerrar"),
              onPressed: () {
                _signOut(); 
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbd2cc),
        centerTitle: true,
        title: Text("Recetas de la abuela"),
        actions: [
          GestureDetector(
            onTap: () {
              _confirmSignOut(context); 
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  user?.photoURL ?? 'https://picsum.photos/200',
                ),
              ),
            ),
          ),
        ],
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
