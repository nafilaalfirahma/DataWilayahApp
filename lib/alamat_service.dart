import 'dart:convert';
import 'package:http/http.dart' as http;

class AlamatService {
  final String baseUrl = "https://alamat.thecloudalert.com/api";

  Future<List<dynamic>> getProvinces() async {
    final response = await http.get(Uri.parse('$baseUrl/provinsi/get/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result'];
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<List<dynamic>> getCities(String provinceId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/kabkota/get/?d_provinsi_id=$provinceId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result'];
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<List<dynamic>> getDistricts(String cityId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/kecamatan/get/?d_kabkota_id=$cityId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result'];
    } else {
      throw Exception('Failed to load districts');
    }
  }

  Future<List<dynamic>> getSubDistricts(String districtId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/kelurahan/get/?d_kecamatan_id=$districtId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result'];
    } else {
      throw Exception('Failed to load sub-districts');
    }
  }

  Future<List<dynamic>> searchAddress(String keyword) async {
    final response =
        await http.get(Uri.parse('$baseUrl/cari/index/?keyword=$keyword'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result'];
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<List<dynamic>> getZipCodes(String cityId, String districtId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/kodepos/get/?d_kabkota_id=$cityId&d_kecamatan_id=$districtId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result'];
    } else {
      throw Exception('Failed to load zip codes');
    }
  }
}
