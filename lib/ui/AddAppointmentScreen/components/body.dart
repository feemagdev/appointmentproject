


import 'package:appointmentproject/BLoC/AddAppointmentBloc/add_appointment_bloc.dart';
import 'package:appointmentproject/BLoC/AddAppointmentBloc/add_appointment_event.dart';
import 'package:appointmentproject/BLoC/AddAppointmentBloc/add_appointment_state.dart';
import 'package:appointmentproject/model/client.dart';
import 'package:appointmentproject/model/service.dart';
import 'package:appointmentproject/model/sub_services.dart';
import 'package:appointmentproject/ui/AddAppointmentScreen/components/backgound.dart';
import 'package:appointmentproject/ui/AddAppointmentScreen/components/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:appointmentproject/ui/AddAppointmentScreen/components/sub_services_ui.dart';

class Body extends StatelessWidget {
  final List<Service> servicesList;
  double height;
  double width;
  AddAppointmentBloc addAppointmentBloc;


  Body({@required this.servicesList,});

  @override
  Widget build(BuildContext context) {
    addAppointmentBloc = BlocProvider.of<AddAppointmentBloc>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    print(width);
    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          SizedBox(
            height: 60,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Add Appointment",
                style: TextStyle(
                  fontSize: height * 0.035,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "select a service",
                  style: TextStyle(
                    fontSize: height * 0.022,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          serviceListBuilder(context),
          SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "select a sub service",
              style: TextStyle(
                fontSize: height * 0.022,
                color: Colors.white,
              ),
            ),
          ),
          BlocListener<AddAppointmentBloc,AddAppointmentState>(
            listener:(context,state){
              if(state is TapOnServiceState){
                subServiceListBuilder(context,state.subServicesList);
              }
            },
            child: BlocBuilder<AddAppointmentBloc,AddAppointmentState>(
              builder: (context,state){
                if(state is TapOnServiceState){
                  return subServiceListBuilder(context,state.subServicesList);
                }
                return Container();
              },
            ),),



        ],
      ),
    );
  }


  Widget serviceListBuilder(BuildContext context){
    return Container(
      height: height * 0.14,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: servicesList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Services(
            svgSrc: servicesList[index].image,
            title: servicesList[index].name,
            onTap: () {
              addAppointmentBloc.add(TapOnServiceEvent(serviceID: servicesList[index].name));
            },
          ),
        ),
      ),
    );
  }
  Widget subServiceListBuilder(BuildContext context,List<SubServices> list){
    return Container(
      height: height * 0.14,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SubServicesUI(title:list[index].name,svgSrc:list[index].image),
        ),
      ),
    );
  }


}
