import 'package:cloud_firestore/cloud_firestore.dart';

class firestore{


  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(String note)  {
    return notes.add({'note': note, 'timestamp': DateTime.now()});
  }

  Stream<QuerySnapshot> getnote(){
    return notes.orderBy('timestamp', descending: true).snapshots();

  }

  Future<void> update(String id, String newedit){
    return notes.doc(id).update({'note':newedit,'timestamp':Timestamp.now()});
  }

  Future<void> delete(String id){
    return notes.doc(id).delete();
  }






































}