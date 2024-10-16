import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:test_printer/ip/widgets/imagestorebytes.dart';
import 'dart:io';
import 'package:test_printer/ip/widgets/printer.dart';

class PrintWithIp extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final int total;
  const PrintWithIp({super.key, required this.data, required this.total});

  @override
  State<PrintWithIp> createState() => _PrintWithIpState();
}

class _PrintWithIpState extends State<PrintWithIp> {
  final f = NumberFormat("\$###,###.00", "en_US");
  ScreenshotController screenshotController = ScreenshotController();
  String dir = Directory.current.path;
  void testPrint(String printerIp, Uint8List theImageThatComes) async {
    if (printerIp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("please enter printer ip")),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("we are connecting to printer $printerIp")),
      );
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      final printer = NetworkPrinter(paper, profile);
      final PosPrintResult res = await printer.connect(printerIp, port: 9100);
      if (res == PosPrintResult.success) {
        await testReceipt(printer, theImageThatComes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.msg)),
        );
        await Future.delayed(const Duration(seconds: 3), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('printer disconnected')),
          );
          printer.disconnect();
        });
      }else if (res == PosPrintResult.timeout){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.msg)),
        );
      }
    }
  }

  TextEditingController printerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter printer ip'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: printerController,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 1.0,
                        ),
                      ),
                      hintText: "printer ip"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Screenshot(
                  controller: screenshotController,
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: widget.data.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    widget.data[index]['title'].toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${widget.data[index]['price']} x ${widget.data[index]['qty']}",
                                  ),
                                  trailing: Text(
                                    "${widget.data[index]['price'] * widget.data[index]['qty']} EG",
                                  ),
                                );
                              },
                            ),
                            const Text(
                              '------------------------------------------------------',
                              style: TextStyle(color: Colors.black),
                              maxLines: 1,
                            ),
                            Text(
                              "Total: ${f.format(widget.total)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: TextButton.icon(
                    onPressed: () {
                      screenshotController
                          .capture(delay: const Duration(milliseconds: 10))
                          .then((capturedImage) async {
                        theImageThatComesFromThePrinter = capturedImage!;
                        setState(() {
                          theImageThatComesFromThePrinter = capturedImage;
                          testPrint(printerController.text,
                              theImageThatComesFromThePrinter);
                        });
                      }).catchError((onError) {
                        if (kDebugMode) {
                          print(onError);
                        }
                      });
                    },
                    icon: const Icon(Icons.print),
                    label: const Text('Print Now'),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
