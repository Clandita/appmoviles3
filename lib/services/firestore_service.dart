
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  /////////
  Stream<QuerySnapshot>recetas(){
    return FirebaseFirestore.instance.collection('recetas').snapshots();
  }

  Stream<QuerySnapshot>categorias(){
    return FirebaseFirestore.instance.collection('categoria').snapshots();
  }

  Future<QuerySnapshot>categoria(){
    return FirebaseFirestore.instance.collection('categoria').get();
  }

  Future<void> RecetaAgregar(String nombre, int porciones, String instrucciones, String categoria, DateTime fecha_creacion, String image){
    return FirebaseFirestore.instance.collection('recetas').doc().set({
      'nombre':nombre,
      'porciones':porciones,
      'instrucciones':instrucciones,
      'categoria':categoria,
      'fecha_creacion':fecha_creacion,
      'image':image
    });

  }

  Stream<QuerySnapshot>recetasPorCategoria({required String categoria}){
    return FirebaseFirestore.instance.collection('recetas').where('categoria', isEqualTo: categoria).snapshots();
  }
}