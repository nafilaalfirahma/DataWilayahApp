import 'package:flutter/material.dart';
import 'alamat_service.dart';

void main() {
  runApp(AlamatApp());
}

class AlamatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Wilayah Indonesia'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage('assets/images/indonesia_map.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Selamat Datang!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "Jelajahi informasi wilayah di Indonesia dengan mudah.",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.map, color: Colors.white),
                label: Text("Lihat Data Wilayah",
                    style: TextStyle(fontSize: 18, fontFamily: 'SansSerif')),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProvinsiScreen()),
                  );
                },
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.search, color: Colors.white),
                label: Text("Cari Daerah berdasarkan Keyword",
                    style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.location_on, color: Colors.white),
                label: Text("Cari Kode Pos", style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ZipcodeSearchScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProvinsiScreen extends StatelessWidget {
  final AlamatService alamatService = AlamatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Provinsi'), backgroundColor: Colors.blue),
      body: FutureBuilder<List<dynamic>>(
        future: alamatService.getProvinces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final provinces = snapshot.data!;
            return ListView.builder(
              itemCount: provinces.length,
              itemBuilder: (context, index) {
                final province = provinces[index];
                return ListTile(
                  title: Text(province['text']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            KotaScreen(provinceId: province['id']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class KotaScreen extends StatelessWidget {
  final String provinceId;
  final AlamatService alamatService = AlamatService();

  KotaScreen({required this.provinceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kota/Kabupaten'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: alamatService.getCities(provinceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final cities = snapshot.data!;
            return ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                return ListTile(
                  title: Text(city['text']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            KecamatanScreen(cityId: city['id']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class KecamatanScreen extends StatelessWidget {
  final String cityId;
  final AlamatService alamatService = AlamatService();

  KecamatanScreen({required this.cityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kecamatan'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: alamatService.getDistricts(cityId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final districts = snapshot.data!;
            return ListView.builder(
              itemCount: districts.length,
              itemBuilder: (context, index) {
                final district = districts[index];
                return ListTile(
                  title: Text(district['text']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            KelurahanScreen(districtId: district['id']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class KelurahanScreen extends StatelessWidget {
  final String districtId;
  final AlamatService alamatService = AlamatService();

  KelurahanScreen({required this.districtId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelurahan'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: alamatService.getSubDistricts(districtId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final subDistricts = snapshot.data!;
            return ListView.builder(
              itemCount: subDistricts.length,
              itemBuilder: (context, index) {
                final subDistrict = subDistricts[index];
                return ListTile(
                  title: Text(subDistrict['text']),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AlamatService alamatService = AlamatService();
  List<dynamic> searchResults = [];
  String keyword = '';

  void search() async {
    final results = await alamatService.searchAddress(keyword);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cari Daerah'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Cari Alamat',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                keyword = value;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: search,
              child: Text("Cari"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.grey[20],
                    child: ListTile(
                      title: Text(result['desakel'] ?? ""),
                      subtitle: Text(
                        "${result['kecamatan']}, ${result['kabkota']}, ${result['provinsi']}, ${result['kodepos']}",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZipcodeSearchScreen extends StatefulWidget {
  @override
  _ZipcodeSearchScreenState createState() => _ZipcodeSearchScreenState();
}

class _ZipcodeSearchScreenState extends State<ZipcodeSearchScreen> {
  final AlamatService alamatService = AlamatService();
  List<dynamic> zipCodeResults = [];
  List<dynamic> provinces = [];
  List<dynamic> cities = [];
  List<dynamic> districts = [];
  List<dynamic> subDistricts = [];
  String? selectedProvinceId;
  String? selectedCityId;
  String? selectedDistrictId;
  String? selectedSubDistrictId;

  @override
  void initState() {
    super.initState();
    fetchProvinces();
  }

  void fetchProvinces() async {
    final results = await alamatService.getProvinces();
    setState(() {
      provinces = results;
    });
  }

  void fetchCities(String provinceId) async {
    final results = await alamatService.getCities(provinceId);
    setState(() {
      cities = results;
    });
  }

  void fetchDistricts(String cityId) async {
    final results = await alamatService.getDistricts(cityId);
    setState(() {
      districts = results;
    });
  }

  void fetchSubDistricts(String districtId) async {
    final results = await alamatService.getSubDistricts(districtId);
    setState(() {
      subDistricts = results;
    });
  }

  void searchZipCodes() async {
    if (selectedCityId != null &&
        selectedDistrictId != null &&
        selectedSubDistrictId != null) {
      final results =
          await alamatService.getZipCodes(selectedCityId!, selectedDistrictId!);
      setState(() {
        zipCodeResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Cari Kode Pos'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Pilih Provinsi',
                border: OutlineInputBorder(),
              ),
              items: provinces.map<DropdownMenuItem<String>>((province) {
                return DropdownMenuItem<String>(
                  value: province['id'],
                  child: Text(province['text']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProvinceId = value;
                  selectedCityId = null;
                  selectedDistrictId = null;
                  selectedSubDistrictId = null;
                  cities = [];
                  districts = [];
                  subDistricts = [];
                });
                fetchCities(value!);
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Pilih Kota/Kabupaten',
                border: OutlineInputBorder(),
              ),
              items: cities.map<DropdownMenuItem<String>>((city) {
                return DropdownMenuItem<String>(
                  value: city['id'],
                  child: Text(city['text']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCityId = value;
                  selectedDistrictId = null;
                  selectedSubDistrictId = null;
                  districts = [];
                  subDistricts = [];
                });
                fetchDistricts(value!);
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Pilih Kecamatan',
                border: OutlineInputBorder(),
              ),
              items: districts.map<DropdownMenuItem<String>>((district) {
                return DropdownMenuItem<String>(
                  value: district['id'],
                  child: Text(district['text']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrictId = value;
                  selectedSubDistrictId = null;
                  subDistricts = [];
                });
                fetchSubDistricts(value!);
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Pilih Kelurahan',
                border: OutlineInputBorder(),
              ),
              items: subDistricts.map<DropdownMenuItem<String>>((subDistrict) {
                return DropdownMenuItem<String>(
                  value: subDistrict['id'],
                  child: Text(subDistrict['text']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubDistrictId = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: searchZipCodes,
              child: Text("Cari"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: zipCodeResults.length,
                itemBuilder: (context, index) {
                  final result = zipCodeResults[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(result['kodepos'] ?? "Kode Pos"),
                      subtitle: Text("${result['text']}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
