import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:travelgo/models/travel.dart';
import 'package:http/http.dart' as http;

class TravelsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-60b53-default-rtdb.firebaseio.com';
  final List<Travel> travels = [];
  bool isLoading = true;
  bool isSaving = false;
  late Travel selectedtravel;
  File? newPictureFile;
  final storage = const FlutterSecureStorage();

  TravelsService() {
    loadTravels();
  }
  //* <List<Travel>>
  Future<List<Travel>> loadTravels() async {
    isLoading = true;
    notifyListeners();
    final Uri url = Uri.https(_baseUrl, 'travels.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);
    final Map<String, dynamic> travelsMap = json.decode(resp.body);
    travelsMap.forEach((key, value) {
      final tempTravel = Travel.fromJson(value);
      tempTravel.id = key;
      travels.add(tempTravel);
    });
    
    isLoading = false;
    notifyListeners();
    return travels; 
  }

  Future saveOrCreateTravel(Travel travel) async {
    isSaving = true;
    notifyListeners();
    if (travel.id == null) {      
      await createTravel(travel);
    } else {      
      await updateTravel(travel);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> updateTravel(Travel travel) async {    
    final Uri url = Uri.https(_baseUrl, 'travels/${travel.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp =
        await http.put(url, body: travel.toRawJson()); 
    final decodedData = resp.body;
    
    final index = travels.indexWhere((element) => element.id == travel.id);
    travels[index] = travel;
    return travel.id!;
  }

  Future<String> createTravel(Travel travel) async {    
    final Uri url = Uri.https(_baseUrl, 'travels.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp =
        await http.post(url, body: travel.toRawJson()); 
    final decodedData = json.decode(resp.body);
    
    travel.id = decodedData['titulo'];
    travels.add(travel);
    return travel.id!;
  }

  void updateSelectedTravelImage(String path) {
    selectedtravel.localUrl = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dmf6vr5fq/image/upload?upload_preset=wdvccozz');
    final imageUploadRequest =
        http.MultipartRequest('POST', url); 
    final file = await http.MultipartFile.fromPath(
        'file', newPictureFile!.path); 
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {      
      return null;
    }
    newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
