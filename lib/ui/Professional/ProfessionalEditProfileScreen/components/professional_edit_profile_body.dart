import 'dart:io';

import 'package:appointmentproject/bloc/ProfessionalBloc/ProfessionalEditProfileBloc/professional_edit_profile_bloc.dart';
import 'package:appointmentproject/model/professional.dart';
import 'package:appointmentproject/ui/Professional/ProfessionalDashboard/professional_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfessionalEditProfileBody extends StatefulWidget {
  @override
  _ProfessionalEditProfileBodyState createState() =>
      _ProfessionalEditProfileBodyState();
}

class _ProfessionalEditProfileBodyState
    extends State<ProfessionalEditProfileBody> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  File _image;
  Professional _professional = Professional.defaultConstructor();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        body: Stack(
          children: [
            BlocListener<ProfessionalEditProfileBloc,
                ProfessionalEditProfileState>(
              listener: (context, state) {
                if (state is ProfessionalProfileUpdatedSuccessfully) {
                  successAlert("Profile updated successfully");
                } else if (state
                    is ProfessionalProfileImageUpdateSuccessfully) {
                  successAlert("Profile Image updated successfully");
                } else if (state is ProfileEditGetProfessionalDataState) {
                  navigateToProfessionalDashboardScreen(
                      context, state.professional);
                }
              },
              child: BlocBuilder<ProfessionalEditProfileBloc,
                  ProfessionalEditProfileState>(
                builder: (context, state) {
                  if (state is ProfessionalEditProfileInitial) {
                    _professional =
                        BlocProvider.of<ProfessionalEditProfileBloc>(context)
                            .professional;
                    _nameController.text = _professional.getName();
                    _contactController.text = _professional.getPhone();
                    _addressController.text = _professional.getAddress();
                    textFieldHandler();

                    return professionalUI();
                  } else if (state is ProfessionalEditProfileLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ProfessionalProfileUpdatedSuccessfully) {
                    _professional = state.professional;
                    _nameController.text = _professional.getName();
                    _contactController.text = _professional.getPhone();
                    _addressController.text = _professional.getAddress();
                    textFieldHandler();
                    return professionalUI();
                  } else if (state
                      is ProfessionalProfileImageUpdateSuccessfully) {
                    _professional = state.professional;
                    _nameController.text = _professional.getName();
                    _contactController.text = _professional.getPhone();
                    _addressController.text = _professional.getAddress();
                    textFieldHandler();
                    return professionalUI();
                  }

                  return Container();
                },
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget professionalUI() {
    return Column(children: [
      professionalProfileLogo(),
      Expanded(child: SingleChildScrollView(child: professionalDetails())),
    ]);
  }

  Widget professionalProfileLogo() {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: deviceHeight * 0.30,
      decoration: BoxDecoration(color: Colors.blue),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    BlocProvider.of<ProfessionalEditProfileBloc>(context)
                        .add(ProfileEditGetProfessionalData());
                  }),
              Text(
                "Professional Profile",
                style: TextStyle(
                    fontSize: deviceWidth < 365 ? 15 : 20, color: Colors.white),
              ),
              IconButton(
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    String nameValidation = nameValidator(_nameController.text);
                    String addressValidation =
                        addressValidator(_addressController.text);
                    bool phoneValidation =
                        phoneValidator(_contactController.text);
                    if (nameValidation != null) {
                      errorDialog(nameValidation);
                    } else if (addressValidation != null) {
                      errorDialog(addressValidation);
                    } else if (!phoneValidation) {
                      errorDialog("Please enter correct phone number");
                    } else {
                      _professional.setName(_nameController.text);
                      _professional.setAddress(_addressController.text);
                      _professional.setPhone(_contactController.text);
                      BlocProvider.of<ProfessionalEditProfileBloc>(context).add(
                          UpdateProfessionalDetailEvent(
                              professional: _professional));
                    }
                  })
            ],
          ),
          SizedBox(
            height: deviceHeight * 0.04,
          ),
          GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: Align(
              alignment: Alignment.topCenter,
              child: _professional.getImage() == null ||
                      _professional.getImage() == ""
                  ? SvgPicture.asset(
                      'assets/icons/camera.svg',
                      width: 50,
                      height: 50,
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(50)),
                        border: new Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      child: ClipOval(
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.fill,
                              placeholder: 'assets/images/logo2.png',
                              image: _professional.getImage())),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget professionalDetails() {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  blurRadius: 6.0, color: Colors.grey, offset: Offset(0.0, 1.0))
            ]),
            height: deviceWidth < 365 ? 80 : 80,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 10, left: 5, right: 0, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    onChanged: (value) {
                      _professional.setName(value);
                    },
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "John Doe",
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  blurRadius: 6.0, color: Colors.grey, offset: Offset(0.0, 1.0))
            ]),
            height: deviceWidth < 365 ? 80 : 80,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 10, left: 5, right: 0, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Contact",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    onChanged: (value) {
                      _professional.setPhone(value);
                    },
                    controller: _contactController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "xxxxxxxxxxx",
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  blurRadius: 6.0, color: Colors.grey, offset: Offset(0.0, 1.0))
            ]),
            height: deviceWidth < 365 ? 80 : 80,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 10, left: 5, right: 0, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Address",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    onChanged: (value) {
                      _professional.setAddress(value);
                    },
                    controller: _addressController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "xyz street",
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.streetAddress,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _imgFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      BlocProvider.of<ProfessionalEditProfileBloc>(context)
          .add(UpdateProfessionalImageEvent(imageFile: _image));
    }
  }

  _imgFromGallery() async {
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _image = File(pickedFile.path);
        BlocProvider.of<ProfessionalEditProfileBloc>(context)
            .add(UpdateProfessionalImageEvent(imageFile: _image));
      }
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == "photo_access_denied") {
          errorDialog("photo access denied");
        } else {
          errorDialog(e.toString());
        }
      } else {
        errorDialog(e.toString());
      }
    }
  }

  void _showPicker(context) {
    try {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == "photo_access_denied") {
          errorDialog("photo access denied");
        } else {
          errorDialog(e.toString());
        }
      } else {
        errorDialog(e.toString());
      }
    }
  }

  successAlert(String message) {
    Alert(
      context: this.context,
      type: AlertType.success,
      title: "",
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(this.context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  errorDialog(String message) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Error",
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  infoDialog(String message) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "",
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  bool phoneValidator(String phone) {
    String pattern =
        r"^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$";
    RegExp regExp = new RegExp(pattern);
    if (regExp.hasMatch(phone)) {
      return true;
    }
    return false;
  }

  String addressValidator(String text) {
    if (text == null || text == "") {
      return "Please enter address";
    } else if (text.length < 5) {
      return "Address charcaters should be more than 5";
    } else
      return null;
  }

  String nameValidator(String text) {
    if (text == null || text == "") {
      return "Please enter name";
    } else if (text.length < 2) {
      return "Name charcaters should be more than 2";
    } else
      return null;
  }

  void navigateToProfessionalDashboardScreen(
      BuildContext context, Professional professional) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ProfessionalDashboard(professional: professional);
    }));
  }

  void textFieldHandler() {
    if (_professional.getName() != null) {
      _nameController.selection =
          TextSelection.collapsed(offset: _professional.getName().length);
    } else {
      _nameController.selection = TextSelection.collapsed(offset: 0);
    }

    if (_professional.getAddress() != null) {
      _addressController.selection =
          TextSelection.collapsed(offset: _professional.getAddress().length);
    } else {
      _addressController.selection = TextSelection.collapsed(offset: 0);
    }

    if (_professional.getPhone() != null) {
      _contactController.selection =
          TextSelection.collapsed(offset: _professional.getPhone().length);
    } else {
      _contactController.selection = TextSelection.collapsed(offset: 0);
    }
  }
}
