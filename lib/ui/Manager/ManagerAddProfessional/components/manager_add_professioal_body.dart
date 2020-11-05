import 'package:appointmentproject/bloc/ManagerBloc/ManagerAddProfessionalBloc/manager_add_professional_bloc.dart';
import 'package:appointmentproject/model/manager.dart';
import 'package:appointmentproject/ui/Manager/ManagerDashboard/manager_dashboard_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MnagaerAddProfessionalBody extends StatefulWidget {
  @override
  _MnagaerAddProfessionalBodyState createState() =>
      _MnagaerAddProfessionalBodyState();
}

class _MnagaerAddProfessionalBodyState
    extends State<MnagaerAddProfessionalBody> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Manager _manager =
        BlocProvider.of<ManagerAddProfessionalBloc>(context).manager;

    return Scaffold(
        appBar: AppBar(
          title: Text("Add Professional"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: [
                BlocListener<ManagerAddProfessionalBloc,
                    ManagerAddProfessionalState>(
                  listener: (context, state) {
                    if (state is ManagerAddedProfessionalSuccessfullyState) {
                      navigateToDashboard(_manager, context);
                    } else if (state
                        is ProfessionalNotRegisteredSuccessfullyState) {
                      showAlertDialog(state.errorMessage);
                    }
                  },
                  child: BlocBuilder<ManagerAddProfessionalBloc,
                      ManagerAddProfessionalState>(
                    builder: (context, state) {
                      if (state is ManagerAddProfessionalInitial) {
                        return _professionalForm(context, _manager);
                      } else if (state
                          is ProfessionalNotRegisteredSuccessfullyState) {
                        return _professionalForm(context, _manager);
                      }
                      return _professionalForm(context, _manager);
                    },
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Widget _professionalForm(context, manager) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: deviceWidth < 365 ? 60 : 70,
            child: TextFormField(
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter email';
                } else if (!EmailValidator.validate(value)) {
                  return "Please enter correct email";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: deviceWidth < 365 ? 60 : 70,
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter name';
                } else if (value.length <= 2) {
                  return "Name should be greater than 2 characters";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: deviceWidth < 365 ? 60 : 70,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter phone';
                } else if (!phoneValidator(value)) {
                  return "Please enter correct phone number";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: deviceWidth < 365 ? 60 : 70,
            child: TextFormField(
              controller: addressController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.streetAddress,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter address';
                } else if (value.length < 5) {
                  return "Please enter correct address";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: deviceWidth < 365 ? 60 : 70,
            child: TextFormField(
              controller: cityController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter city name';
                } else if (value.length < 3) {
                  return "Please enter correct city name";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: deviceWidth < 365 ? 60 : 70,
            child: TextFormField(
              controller: countryController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: "Country",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter city name';
                } else if (value.length < 3) {
                  return "Please enter correct country name";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: deviceWidth < 365 ? 60 : 70,
            child: TextFormField(
              controller: experienceController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: "Experience (years)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your experience';
                } else if (int.parse(value) > 50) {
                  return "experience cannot be greater than 50";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            width: deviceWidth * 0.50,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print("validated");
                  BlocProvider.of<ManagerAddProfessionalBloc>(context).add(
                      ManagerAddProfessionalButtonPressedEvent(
                          email: emailController.text,
                          name: nameController.text,
                          phone: phoneController.text,
                          address: addressController.text,
                          city: cityController.text,
                          country: countryController.text));
                }
              },
              child: Text('Add new customer'),
            ),
          )
        ],
      ),
    );
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

  void showAlertDialog(String desc) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "",
      desc: desc,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  void navigateToDashboard(Manager manager, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ManagerDashboardScreen(manager: manager);
    }));
  }
}