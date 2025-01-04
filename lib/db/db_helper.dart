import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suplier_api/model/barang.dart';
import 'package:suplier_api/model/category.dart';
import 'package:suplier_api/model/history_stok.dart';
import 'package:suplier_api/model/supplier.dart';

class FirebaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference historyStokCollection =
      FirebaseFirestore.instance.collection('history_stok');
  final CollectionReference suppliersCollection =
      FirebaseFirestore.instance.collection('suppliers');

  // Add item to Firestore
  Future<void> addItem(Barang item) async {
    try {
      await itemsCollection.doc(item.id.toString()).set(item.toMap());
    } catch (e) {
      throw Exception("Failed to add item: $e");
    }
  }

  // Get all items
  Future<List<Barang>> getItems() async {
    try {
      QuerySnapshot snapshot = await itemsCollection.get();
      return snapshot.docs
          .map((doc) => Barang.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch suppliers: $e");
    }
  }

  // Get item by ID
  Future<Barang?> getItemById(String id) async {
    try {
      DocumentSnapshot doc = await itemsCollection.doc(id).get();
      if (doc.exists) {
        return Barang.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to fetch item: $e");
    }
  }

  Future<int> getLastItemId() async {
    try {
      // Query Firestore to get the document with the highest ID
      final querySnapshot = await _firestore
          .collection('items')
          .orderBy('id', descending: true) // Sort by 'id' in descending order
          .limit(1) // Limit to the first result
          .get();

      // Check if any document exists
      if (querySnapshot.docs.isNotEmpty) {
        final lastItem = querySnapshot.docs.first.data();
        return lastItem['id'] as int; // Return the highest 'id'
      }
      return 0; // If no items exist, return 0
    } catch (e) {
      print('Error fetching last item ID: $e');
      return 0; // Handle errors gracefully
    }
  }

  // Delete item by ID
  Future<void> deleteItem(String id) async {
    try {
      await itemsCollection.doc(id).delete();
    } catch (e) {
      throw Exception("Failed to delete item: $e");
    }
  }

  // Update item in Firestore
  Future<void> updateItem(Barang item) async {
    try {
      await itemsCollection.doc(item.id.toString()).update(item.toMap());
    } catch (e) {
      throw Exception("Failed to update item: $e");
    }
  }

  // Delete supplier by ID
  Future<void> deleteSupplier(String id) async {
    try {
      await suppliersCollection.doc(id).delete();
    } catch (e) {
      throw Exception("Failed to delete item: $e");
    }
  }

  // Add category
  Future<void> addCategory(Category category) async {
    try {
      await categoriesCollection
          .doc(category.id.toString())
          .set(category.toMap());
    } catch (e) {
      throw Exception("Failed to add category: $e");
    }
  }

  // Get all categories
  Future<List<Category>> getCategories() async {
    try {
      QuerySnapshot snapshot = await categoriesCollection.get();
      return snapshot.docs
          .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch categories: $e");
    }
  }

  // Method to get the last category ID
  Future<int> getLastCategoryId() async {
    try {
      final querySnapshot = await _firestore
          .collection('categories')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['id'] as int;
      }
      return 0; // Return 0 if no categories exist
    } catch (e) {
      print('Error fetching last category ID: $e');
      return 0;
    }
  }

  // Update item stock
  Future<void> updateStock(String itemId, int stock) async {
    try {
      await itemsCollection.doc(itemId).update({'stock': stock});
    } catch (e) {
      throw Exception("Failed to update stock: $e");
    }
  }

  // Add history stok
  Future<void> addHistoryStok(HistoryStok historyStok) async {
    try {
      await historyStokCollection.add(historyStok.toMap());
    } catch (e) {
      throw Exception("Failed to add history stok: $e");
    }
  }

  // Get history stok by item ID
  Future<List<HistoryStok>> getHistoryStokByItemId(int itemId) async {
    try {
      QuerySnapshot snapshot =
          await historyStokCollection.where('item_id', isEqualTo: itemId).get();
      return snapshot.docs
          .map((doc) => HistoryStok.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch history stok: $e");
    }
  }

  // Get all history stok
  Future<List<HistoryStok>> getAllHistoryStok() async {
    try {
      QuerySnapshot snapshot = await historyStokCollection.get();
      return snapshot.docs
          .map((doc) => HistoryStok.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch all history stok: $e");
    }
  }

  // Add item to Firestore
  Future<void> addSuppliers(Supplier supplier) async {
    try {
      await suppliersCollection
          .doc(supplier.id.toString())
          .set(supplier.toMap());
    } catch (e) {
      throw Exception("Failed to add item: $e");
    }
  }

  Future<List<Supplier>> getSuppliers() async {
    try {
      QuerySnapshot snapshot = await suppliersCollection.get();
      return snapshot.docs
          .map((doc) => Supplier.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch suppliers: $e");
    }
  }

  // Get the last item ID
  Future<int> getLastSupplierId() async {
    try {
      // Query Firestore to get the document with the highest ID
      final querySnapshot = await _firestore
          .collection('suppliers')
          .orderBy('id', descending: true) // Sort by 'id' in descending order
          .limit(1) // Limit to the first result
          .get();

      // Check if any document exists
      if (querySnapshot.docs.isNotEmpty) {
        final lastSupplier = querySnapshot.docs.first.data();
        return lastSupplier['id'] as int; // Return the highest 'id'
      }
      return 0; // If no items exist, return 0
    } catch (e) {
      print('Error fetching last item ID: $e');
      return 0; // Handle errors gracefully
    }
  }

  // Get Supplier by ID
  Future<Supplier?> getSupplierById(String id) async {
    try {
      DocumentSnapshot doc = await suppliersCollection.doc(id).get();
      if (doc.exists) {
        return Supplier.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to fetch item: $e");
    }
  }
}
