import 'package:flutter/material.dart';
import 'package:flutter_codigo5_sqflite_qr/db/db_admin.dart';
import 'package:flutter_codigo5_sqflite_qr/models/license_model.dart';
import 'package:flutter_codigo5_sqflite_qr/pages/scanner_qr_page.dart';
import 'package:flutter_codigo5_sqflite_qr/ui/general/colors.dart';
import 'package:flutter_codigo5_sqflite_qr/ui/widgets/item_list_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LicenseModel> licenses = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    licenses = await DBAdmin.db.getLicenses2();
    setState(() {});
  }

  showDetail(LicenseModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Detalle del carnet",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                children: [
                  Text(
                    "Nombres:",
                    style: TextStyle(
                      color: kFontPrimaryColor.withOpacity(0.7,),
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    model.name,
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Text(
                    "Nro. DNI:",
                    style: TextStyle(
                      color: kFontPrimaryColor.withOpacity(0.7,),
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    model.dni
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Text(
                    "Código QR:",
                    style: TextStyle(
                      color: kFontPrimaryColor.withOpacity(0.7,),
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: (){
                  final Uri _url = Uri.parse(model.url);
                  launchUrl(_url);
                },
                child: SizedBox(
                  height: 160,
                  width: 160,
                  child: QrImage(
                    data: model.url,
                    version: QrVersions.auto,
                    size: 100.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kFontPrimaryColor),
        title: const Text(
          "VacunApp Storage",
          style: TextStyle(
            color: kFontPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mis carnets registrados",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                licenses.isNotEmpty
                    ? Expanded(
                        child: RefreshIndicator(
                          strokeWidth: 2,
                          color: kBrandPrimaryColor,
                          onRefresh: () async {
                            getData();
                          },
                          child: ListView.builder(
                            // physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: licenses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ItemListWidget(
                                // name: licenses[index].name,
                                // dni: licenses[index].dni,
                                // url: licenses[index].url,
                                // licenseModel: licenses[index],
                                licenseModel: licenses[index],
                                onPressed: () {
                                  showDetail(licenses[index]);
                                },
                              );
                            },
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            Image.asset(
                              'assets/images/box.png',
                              height: 100,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "Aún no tienes carnets registrados.",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: kFontPrimaryColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 52.0,
              width: double.infinity,
              margin: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ScannerQRPage()));
                },
                style: ElevatedButton.styleFrom(
                  primary: kBrandPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
                label: const Text(
                  "Escaner QR",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                icon: SvgPicture.asset(
                  'assets/icons/bx-qr-scan.svg',
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
