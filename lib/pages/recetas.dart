import 'package:appmoviles3/pages/receta_agregar.dart';
import 'package:appmoviles3/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class RecetasPage extends StatefulWidget {
  final String categoria;
  
  const RecetasPage({required this.categoria});

  @override
  
  State<RecetasPage> createState() => _RecetasPageState();
  
}

class _RecetasPageState extends State<RecetasPage> {
  final formatofecha=DateFormat('dd-MM-yyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbd2cc),
        centerTitle: true,
        title: Text("Recetas de ${widget.categoria}"),
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
                          Text('Categoria: ', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('${receta['categoria']}')
                          
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Porciones:', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(' ${receta['porciones']} Personas')
                          
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Fecha creación:', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(formatofecha.format(receta['fecha creacion'].toDate()))
                          
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: (){
                            mostrarReceta(context, receta);
                          },
                          child:Text('Ver Receta')),
                      )                     
                    ],
                  ),
                  onLongPress:() {confirmarBorrar(context, receta, receta.id);}
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

  void mostrarReceta(BuildContext context, receta){
    showBottomSheet(
      context: context,
      builder: (context){
        return SizedBox(
          height: 350,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xfffbd2cc),
              border: Border.all(color:Color(0xffde817c), width: 2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)
              )
          ),
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: OutlinedButton(
                      child: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                      ),
                      ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text('${receta['nombre']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), overflow: TextOverflow.fade,))
                  ],
                ),
              Divider(color: Colors.black,),
              Row(
                children: [
                  Text('Preparación:', style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              Row(
                children: [
                  Flexible(child: Text('${receta['instrucciones']}', overflow: TextOverflow.fade,))
                ],
                )
            ],
          ),
        ) ,
        )
        
        );
      }
      );
  }
  
  void confirmarBorrar(BuildContext context, receta, recetaid){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Eliminar receta'),
          content: Text('¿Estás seguro que deseas eliminar ${receta['nombre']}?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: (){
                Navigator.of(context).pop();
              } ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: (){
                FirestoreService().recetaBorrar(recetaid);
                Navigator.of(context).pop();
              })
          ],
        );
      }
      );
  }



}