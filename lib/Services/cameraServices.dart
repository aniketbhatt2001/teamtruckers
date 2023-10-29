import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../Utils/Constatnts.dart';

final vehicleImgUrlProvider = StateProvider<String?>((ref) => null);
final rcFrontImgUrlProvider = StateProvider<String?>((ref) => null);
final rcbackImgUrlProvider = StateProvider<String?>((ref) => null);
final permit1ImgUrlProvider = StateProvider<String?>((ref) => null);
final permit2ImgUrlProvider = StateProvider<String?>((ref) => null);
final licenseFrontProvider = StateProvider<String?>((ref) => null);
final licenseBackProvider = StateProvider<String?>((ref) => null);
final idProvider = StateProvider<String?>((ref) => null);
final identificationFile1 = StateProvider<String?>((ref) => null);
final identificationFile2 = StateProvider<String?>((ref) => null);
final vehicleInsurance = StateProvider<String?>((ref) => null);
final profileProvider = StateProvider<String?>((ref) => null);

Future<XFile?> openCamera() async {
  XFile? pickedImage =
      await ImagePicker().pickImage(source: ImageSource.camera);
  return pickedImage;
}

Future<XFile?> openGallery() async {
  XFile? pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  return pickedImage;
}

Future getImagePath(String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(vehicleImgUrlProvider.notifier).state =
        data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }
    print(ref.read(vehicleImgUrlProvider.notifier).state);
    return data;
  } else {
    print('failed');
    return null;
  }

  // if (data['status'] == 200) {

  // } else {
  //   return "";
}

Future getRcFrontImagePath(String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(rcFrontImgUrlProvider.notifier).state =
        data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }
    print(ref.read(rcFrontImgUrlProvider.notifier).state);
    return data;
  } else {
    print('failed');
    return null;
  }
}

Future getProfileUrl(String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(profileProvider.notifier).state =
        data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }
    print(ref.read(profileProvider.notifier).state);
    return data;
  } else {
    print('failed');
    return null;
  }
}

Future getRcBackImagePath(String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(rcbackImgUrlProvider.notifier).state =
        data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }
    print(ref.read(rcFrontImgUrlProvider.notifier).state);
    return data;
  } else {
    print('failed');
    return null;
  }
}

Future getPermit1ImagePath(String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(permit1ImgUrlProvider.notifier).state =
        data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }
    print(ref.read(rcFrontImgUrlProvider.notifier).state);
    return data;
  } else {
    print('failed');
    return null;
  }
}

Future getPermit2ImagePath(String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(permit2ImgUrlProvider.notifier).state =
        data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }
    print(ref.read(rcFrontImgUrlProvider.notifier).state);
    return data;
  } else {
    print('failed');
    return null;
  }
}

Future getLicenseFrontImgUrl(
    String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(licenseFrontProvider.notifier).state =
        data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }
    print(ref.read(licenseFrontProvider.notifier).state);
    return data;
  } else {
    print('failed');
    return null;
  }
}

Future getLicenseBackImgUrl(
    String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(licenseBackProvider.notifier).state =
        data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }

    return data;
  } else {
    return null;
  }
}

Future getId(String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(idProvider.notifier).state = data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }

    return data;
  } else {
    return null;
  }
}

Future getIdentificatinFile1(
    String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(identificationFile1.notifier).state =
        data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }

    return data;
  } else {
    return null;
  }
}

Future getIddentificatinFile2(
    String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(identificationFile2.notifier).state =
        data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }

    return data;
  } else {
    return null;
  }
}

Future getVehicleInsurance(String folderName, XFile file, WidgetRef ref) async {
  String url = "$baseUrl/app/image_upload";

  http.MultipartRequest request = http.MultipartRequest(
    "POST",
    Uri.parse(url),
  )
    ..fields['device_type'] = 'MOB'
    ..fields['folder_name'] = folderName;

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
  ));

  //print(request.);

  var response = await request.send();

  var responsed = await http.Response.fromStream(response);

  //print(responsed.body);
  if (responsed.statusCode == 200) {
    dynamic data = jsonDecode(responsed.body);

    ref.read(vehicleInsurance.notifier).state =
        data['response'][0]['path_with_url'];
    // if (data['status'] == 200) {
    // return data['response'][0]['path'];
    // } else {
    //   return "";
    // }

    return data;
  } else {
    return null;
  }
}

Future<String> showimgOption(BuildContext context) async {
  String option = "";
  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Choose"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              option = "camera";
              Navigator.pop(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.photo_camera,
                  color: Colors.blue,
                  size: 35,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("CAMERA")
              ],
            ),
          ),
          InkWell(
            onTap: () {
              option = "image";
              Navigator.pop(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Icon(
                  Icons.photo,
                  color: Colors.blue,
                  size: 35,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text("PHOTOS")
              ],
            ),
          )
        ],
      ),
    ),
  );

  return option;
}
