import 'dart:async';
import 'package:appointmentproject/BLoC/SignUpBloc/bloc.dart';
import 'package:appointmentproject/model/client.dart';
import 'package:appointmentproject/repository/client_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './bloc.dart';

class CompleteRegistrationBloc
    extends Bloc<CompleteRegistrationBlocEvent, CompleteRegistrationBlocState> {
  ClientRepository clientRepository;

  @override
  CompleteRegistrationBlocState get initialState =>
      InitialCompleteRegistrationBlocState();

  @override
  Stream<CompleteRegistrationBlocState> mapEventToState(
    CompleteRegistrationBlocEvent event,
  ) async* {
    if (event is CompleteRegistrationButtonPressedEvent) {
      try {
        clientRepository = new ClientRepository(
            name: event.name,
            phone: event.phone,
            country: event.country,
            city: event.city,
            address: event.address,
            dob: Timestamp.fromDate(event.dob),
            need: event.need,
            user: event.user);
        clientRepository.registerClient();
        yield SuccessfulCompleteRegistrationBlocState(user: event.user,client: await getClientData(event.user));
      } catch (Exception) {
        print("user not registered completely " + Exception.toString());
        yield FailureCompleteRegistrationBlocState(
            message: Exception.toString());
      }
    }

    if(event is DatePickerEvent){
      yield DatePickerState(
        name: event.name,
        phone: event.phone,
        country: event.country,
        city:event.city,
        address: event.address,
        dob: event.dob
      );
    }

  }

  Future<Client> getClientData(FirebaseUser user) async {
    return await ClientRepository.defaultConstructor().getClientData(user);
  }

}
