import 'package:appmoviles3/pages/receta_agregar.dart';
import 'package:appmoviles3/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class RecetasPage extends StatefulWidget {
  final String categoria;
  const RecetasPage({required this.categoria});

  @override
  State<RecetasPage> createState() => _RecetasPageState();
}

class _RecetasPageState extends State<RecetasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: Text("Recetas de ${widget.categoria}",style:TextStyle(color: Colors.white)),
      ),
      body: Center(
          child:StreamBuilder(stream:FirestoreService().recetasPorCategoria( categoria: widget.categoria) ,
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
                  title: Center(child: Text(receta['nombre'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                  subtitle: Column(
                    children: [
                      Image.network(
                        receta['image'],
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Categoria: ${receta['categoria']}'),
                          
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Porciones: ${receta['porciones']} Personas'),
                          
                        ],
                      ),
                      Divider(),
                      Row(children: [Text('Preparación:', style: TextStyle(fontWeight: FontWeight.bold),)],),
                      Row(
                        children: [
                        Flexible(
                          child: Text('${receta['instrucciones']} ', overflow: TextOverflow.fade,)

                        ) ]),
                      Container(
                        child: ElevatedButton(
                          onPressed: (){

                          },
                          child:Text('Ver Receta')),
                      )                     
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