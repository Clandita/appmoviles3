import 'package:appmoviles3/pages/recetas.dart';
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
        bottom: PreferredSize(
          
          preferredSize: Size.fromHeight(30),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('¿Qué Receta estás búscando?', style: TextStyle(fontSize: 20),),
                ),
              ],
            ))),
      ),
    
      body: Center(
          child:StreamBuilder(stream:FirestoreService().categorias() ,
           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData||snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else{
              return ListView.separated( 
                separatorBuilder:(_,__)=>Divider(), 
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                var categoria=snapshot.data!.docs[index];
                return ListTile(

                  title: Center(child: Text(categoria['nombre'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
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
                          Text('Calorias promedio: ${categoria['calorias']}'),
                          
                          
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Última modificación:')//${categoria['ultima modificacion']}'),
                          
                          
                        ],
                      ),
                      Container(child: ElevatedButton(
                        onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:(context)=> RecetasPage(categoria: categoria['nombre']), ));
                    }
                  , child: Text('Ir a recetas de ${categoria['nombre']}')),),

                    ],
                  ),
                );
              },);
            }
           })
      ),
    );
  }
}