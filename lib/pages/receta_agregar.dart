import 'package:appmoviles3/services/firestore_service.dart';
import 'package:flutter/material.dart';
class RecetaAgregarPage extends StatefulWidget {
  const RecetaAgregarPage({super.key});

  @override
  State<RecetaAgregarPage> createState() => _RecetaAgregarPageState();
}

class _RecetaAgregarPageState extends State<RecetaAgregarPage> {
  TextEditingController nombreCtrl=TextEditingController();
  TextEditingController porcionesCtrl=TextEditingController();
  TextEditingController instruccionesCtrl=TextEditingController();
  TextEditingController fecha_creacionCtrl=TextEditingController();
  TextEditingController categoriaCtrl=TextEditingController();

  final formKey=GlobalKey<FormState>();
  DateTime fecha_creacion=DateTime.now();
  String categoria='';
  String? categoriaseleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xfffbd2cc),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreCtrl,
                decoration: InputDecoration(
                  label: Text("Nombre")
                ),validator: (nombre){
                  if(nombre!.isEmpty){
                    return 'indique el nombre de receta';
                  }
                  if(nombre.length<3){
                    return 'El nombre debe tener más de 3 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0,),
              TextFormField(
                controller: porcionesCtrl,
                keyboardType: TextInputType.number, 
                decoration: InputDecoration(
                  label: Text("Porciones")
                ),validator: (porciones){
                  if(porciones!.isEmpty){
                    return 'indique porciones de receta';
                  }
                  if(int.tryParse(porciones)==null){
                    return 'la porción debe ser un número';
                  }
                  if(int.parse(porciones) < 1){
                    return 'la porción debe ser mayor a 1';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: instruccionesCtrl,
                decoration: InputDecoration(
                  label: Text("Instrucciones")
                ),validator: (instrucciones){
                  if(instrucciones!.isEmpty){
                    return 'indique instrucciones de receta';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              FutureBuilder(
                future: FirestoreService().categoria(),
                builder:(context,AsyncSnapshot snapshot){
                  if(!snapshot.hasData || snapshot.connectionState==ConnectionState.waiting){
                    return Text("cargando categorias...");
                  }else{
                    var categoria=snapshot.data!.docs;
                    categoriaseleccionada=categoria[0]['nombre'];
                    return DropdownButtonFormField<String>(
                      value: categoriaseleccionada,
                      decoration: InputDecoration(labelText: 'Categoria'),
                      items: categoria.map<DropdownMenuItem<String>>((categoria){
                        return DropdownMenuItem<String>(
                          child: Text(categoria['nombre']),
                          value: categoria['nombre'],);
                      }).toList(),
                      onChanged: (categoriaseleccionada){
                        setState(() {
                          this.categoria=categoriaseleccionada!;
                        });
                      },
                      );
                  }
                },
        
                ),
              Container(
                child: ElevatedButton(
                  onPressed: (){
                    if(formKey.currentState!.validate()){
                      FirestoreService().RecetaAgregar(
                        nombreCtrl.text.trim(),
                        int.parse(porcionesCtrl.text.trim()),
                        instruccionesCtrl.text.trim(),
                        this.categoria,
                        this.fecha_creacion,
                        'https://cdn-icons-png.flaticon.com/512/2088/2088090.png');
                      
                      Navigator.pop(context);
                    }
                  }, 
                  child: Text("agregar")),
              ),
              SizedBox(height: 16.0),
              Container(
                child: Row(
                  children: [
                    Text("fecha de creación: ",style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(fecha_creacion.day.toString()+'/'+fecha_creacion.month.toString()+'/'+fecha_creacion.year.toString()),
                    Spacer(),
                  
                  ],),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}