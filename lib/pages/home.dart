import 'package:appmoviles3/pages/receta_agregar.dart';
import 'package:appmoviles3/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: Text("Recetas De La Abuela",style:TextStyle(color: Colors.white)),
      ),
      body: Center(
          child:StreamBuilder(stream:FirestoreService().recetas() ,
           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData||snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else{
              return ListView.separated( 
                separatorBuilder:(_,__)=>Divider(), 
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                var receta=snapshot.data!.docs[index];
                return ListTile(
                  leading: Icon(Icons.egg),
                  title: Text(receta['nombre']),
                  subtitle: Row(
                    children: [
                      Text('categoria: ${receta['categoria']}'),
                      
                    ],
                  ),
                );
              },);
            }
           })
      ),
      floatingActionButton:FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          MaterialPageRoute route=MaterialPageRoute(builder: (context)=>RecetaAgregarPage());
          Navigator.push(context, route);

      }),
    );
  }
}